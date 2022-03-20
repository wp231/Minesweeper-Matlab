function Minesweeper(Bomb, Map)
%判定傳入參數
switch nargin
    case 0
        Bomb = 65;
        Map = [22, 18];
    case 1
        Map = [22, 18];
end

windows = figure( ...
    "Name","Minesweeper", ...
    "ToolBar","none", ...
    "NumberTitle","off", ...
    "Color",[1,1,1], ...
    "WindowButtonDownFcn",@BDF, ...
    "WindowButtonMotionFcn",@BMF, ...
    "WindowButtonUpFcn",@BUF);

map_axes = axes(windows,...
    "Position",[0.05,0.05,0.85,0.9],...
    "XLim",[0,Map(1)], ...
    "YLim",[0,Map(2)], ...
    "XGrid","off", ...
    "YGrid","off",...
    "XTick",1:Map(1), ...
    "YTick",1:Map(2),...
    "XTickLabel",[],...
    "YTickLabel",[],...
    "DataAspectRatio",[1,1,1],...
    "XColor",[1,1,1], ...
    "YColor",[1,1,1], ...
    "Color",[1,1,1]);

bomb_num_text = uicontrol(windows, ...
    "Style","text", ...
    "String",num2str(Bomb),...
    "BackgroundColor",[1,1,1],...
    "Units","normalized", ...
    "Position",[0.925,0.85,0.05,0.1], ...
    "FontSize",18, ...
    "FontWeight","bold");

uicontrol(windows,...
    "Units","normalized",...
    "Position",[0.91,0.05,0.08,0.05],...
    "Style","pushbutton",...
    "String","Auto",...
    "Callback",@CB);

hold on

for i = Map(1)+1:-1:1
    for j = Map(2)+1:-1:1
        map_color(i,j) = patch(map_axes,[i-1,i,i,i-1], ...
            [j-1,j-1,j,j],[0.8,0.8,0.8],"EdgeColor",[0.7,0.7,0.7]);

        map_img(i,j) = image(map_axes,[i-0.9,i-0.1],[j-0.9,j-0.1],[]);
    end
end

flag_img = zeros(9,9,3,'uint8');
flag_img(:,:,1) = [204 204 204 204 204 204 204 204 204;
    204 0 0 0 0 0 0 0 204;
    204 204 0 0 0 0 0 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 204 204 255 204 204 204 204;
    204 204 255 255 255 204 204 204 204;
    204 204 204 255 255 204 204 204 204;
    204 204 204 204 255 204 204 204 204;
    204 204 204 204 204 204 204 204 204];
flag_img(:,:,2) = [204 204 204 204 204 204 204 204 204;
    204 0 0 0 0 0 0 0 204;
    204 204 0 0 0 0 0 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 0 0 0 204 204 204 204;
    204 204 204 0 0 204 204 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 204 204 204 204 204 204 204];
flag_img(:,:,3) = [204 204 204 204 204 204 204 204 204;
    204 0 0 0 0 0 0 0 204;
    204 204 0 0 0 0 0 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 0 0 0 204 204 204 204;
    204 204 204 0 0 204 204 204 204;
    204 204 204 204 0 204 204 204 204;
    204 204 204 204 204 204 204 204 204];

bomb_img_red = zeros(15,15,3,'uint8');
bomb_img_red(:,:,1) = [
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 0 0 0 0 0 0 0 0 0 0 0 0 0 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
bomb_img_red([9,10],[6,7],[2,3]) = 255;

bomb_img_while = zeros(15,15,3,'uint8');
bomb_img_while(:,:,1) = [
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 0 0 0 0 0 0 0 0 0 0 0 0 0 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
bomb_img_while(:,:,2) = [
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 0 0 0 0 0 0 0 0 0 0 0 0 0 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
bomb_img_while(:,:,3) = [
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 255 255 0 0 0 0 0 0 0 0 0 255 255 255;
    255 0 0 0 0 0 0 0 0 0 0 0 0 0 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 0 0 255 255 0 0 0 0 0 255 255 255;
    255 255 255 255 0 0 0 0 0 0 0 255 255 255 255;
    255 255 255 0 255 0 0 0 0 0 255 0 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 0 255 255 255 255 255 255 255;
    255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];


num_color = uint8([0,0,225;2,129,2;253,7,7;20,20,158;...
    128,1,1;0,128,128;10,10,10;128,128,128]);


flag_count = Bomb;
down_point = [0, 0];
motion_point = [1, 1];
up_point = [0, 0];
a = 0;
b = 0;
map_data = zeros(Map);
map_open = zeros(Map,"logical");
flag_map = zeros(Map,"logical");
click_type = "";
game_over = 0;

    %生成地圖
    function CreateMap()
        create_bomb = randperm(Map(1)*Map(2),Bomb);     %隨機函數生成炸彈
        bomb_map = zeros(Map);
        bomb_map(create_bomb) = 1;                      %炸彈地圖

        %捲積計算相加創建數字地圖
        map_data = conv2(bomb_map,[1,1,1;1,0,1;1,1,1],"same");
        map_data(create_bomb) = -1;                     %將炸彈位置設-1
    end

    %以x,y為中心擴張
    function [a,b] = ExtendGrid(x,y)
        a = [x-1,x-1,x-1,x,x,x,x+1,x+1,x+1];
        b = [y-1,y,y+1,y-1,y,y+1,y-1,y,y+1];

        %查找出界並刪除
        er = find(a < 1 | a > Map(1) | b < 1 | b > Map(2));
        a(er) = [];
        b(er) = [];
    end

    %連結起來的 0 創建地圖形式列表
    function C = FindContinuousZero(x,y)
        C = zeros(Map,'logical');
        C_ = zeros(Map,'logical');
        C(x,y) = 1;
        while ~all(C==C_,"all")
            [aa,bb] = find(C & map_data == 0 & C_ == 0);
            C_ = C;
            for ii = [aa,bb].'
                [ar,br] = ExtendGrid(ii(1),ii(2));
                C(ar,br) = 1;
            end
        end
    end

    function TextPrint(x,y)
        text(map_axes,x-0.7,y-0.5,num2str(map_data(x,y)), ...
                "FontWeight","bold","Color",num_color(map_data(x,y),:));
    end

    function OpenZero(x,y)
        C = FindContinuousZero(x,y);
        [xx,yy] = find(C);

        %開啟 0 的格子
        for ii = [xx,yy].'
            %如果有立旗移除
            if flag_map(ii(1),ii(2)) == 1
                ClearFlag(ii(1),ii(2));
            end

            map_color(ii(1),ii(2)).FaceColor = [1,1,1];
            map_open(ii(1),ii(2)) = 1;

            %如果數字顯示
            if map_data(ii(1),ii(2)) > 0
                TextPrint(ii(1),ii(2));
            end
        end
    end

    function OpenMap(x,y)
        if map_open(x,y) == 1 || flag_map(x,y) == 1
            return;
        end

        map_open(x,y) = 1;

        %開啟數字
        if map_data(x,y) > 0
            map_color(x,y).FaceColor = [1,1,1];
            TextPrint(x,y);
        %開啟炸彈
        elseif map_data(x,y) == -1
            map_color(x,y).FaceColor = [1,0,0];
            map_img(x,y).CData = bomb_img_red;
            game_over = 1;
        %開啟0
        else
            OpenZero(x,y)
        end
        IsWin();
    end

    function ClearFlag(x,y)
        map_img(x,y).CData = [];
        flag_map(x,y) = 0;
        flag_count = flag_count + 1;
        bomb_num_text.String = num2str(flag_count);
    end

    function CreateFlag(x,y)
        map_img(x,y).CData = flag_img;
        flag_map(x,y) = 1;
        flag_count = flag_count - 1;
        bomb_num_text.String = num2str(flag_count);
    end

    function ChangeFlag(x,y)
        if map_open(x,y) == 1
            return
        end

        if flag_map(x,y) == 1
            ClearFlag(x,y);
        %避免插旗超過數量
        elseif flag_count >= 1
            CreateFlag(x,y);
        end
    end

    function GameOver(iswin)
        if iswin
            %贏的視窗
            Endbuttom = questdlg('You Win !','YouWin',...
                'Restart','Close','Restart');
        else
            %輸的視窗
            Endbuttom = questdlg('You Lose.','YouLose',...
                'Restart','Close','Restart');
        end
        if strcmp(Endbuttom,'Restart')
            close; clear;
            Minesweeper;
        elseif strcmp(Endbuttom,'Close')
            close; clear;
        end
   end

    %判定輸贏
    function IsWin()
        if game_over
            %顯示所有炸彈
            [aa,bb]=find(map_data==-1);
            for ii = [aa,bb].'
                if map_open(ii(1),ii(2)) == 0
                    map_img(ii(1),ii(2)).CData = bomb_img_while;
                end
            end
            GameOver(false);
            return;
        elseif all(map_data == -1 | map_open,"all")
            GameOver(true);
        end
    end

    function BDF(~,~)
        IsWin();
        point = map_axes.CurrentPoint;
        down_point = [floor(point(1,1)) + 1, floor(point(1,2)) + 1];
        click_type = windows.SelectionType;
        %岀界判定
        if down_point(1) < 1 || down_point(1) > Map(1) ...
                || down_point(2) < 1 || down_point(2) > Map(2)
            return;
        end
        
        %九宮格顯示顏色(做為快翻使用)
        if map_open(down_point(1),down_point(2)) == 1 && ...
                map_data(down_point(1),down_point(2)) > 0

            [a,b] = ExtendGrid(down_point(1),down_point(2));

            for ii = [a;b]
                if map_open(ii(1),ii(2)) == 0 && flag_map(ii(1),ii(2)) == 0
                    map_color(ii(1),ii(2)).FaceColor = [0.5,0.5,0.5];
                end
            end
        end
    end

    function BMF(~,~)

        %通過格子是否開起來判定原始顏色
        if map_open(motion_point(1),motion_point(2))
            map_color(motion_point(1),motion_point(2)).FaceColor = [1,1,1];
        else
            map_color(motion_point(1),motion_point(2)).FaceColor = ...
                [0.8,0.8,0.8];
        end

        %獲取位子
        point = map_axes.CurrentPoint;
        motion_point = [floor(point(1,1)) + 1, floor(point(1,2)) + 1];

        % X判定出界校正
        if motion_point(1) < 1
            motion_point(1) = 1;
        elseif motion_point(1) > Map(1)
            motion_point(1) = Map(1);
        end
        % Y判定出界校正
        if motion_point(2) < 1
            motion_point(2) = 1;
        elseif motion_point(2) > Map(2)
            motion_point(2) = Map(2);
        end

        map_color(motion_point(1),motion_point(2)).FaceColor = [0.9,0.9,0.9];
    end

    function BUF(~,~)
        IsWin();
        point = map_axes.CurrentPoint;
        up_point = [floor(point(1,1)) + 1, floor(point(1,2)) + 1];

        %恢復九宮格變色
        if a~= 0
            for ii = [a;b]
                if map_open(ii(1),ii(2)) == 0 && flag_map(ii(1),ii(2)) == 0
                    map_color(ii(1),ii(2)).FaceColor = [0.8,0.8,0.8];
                end
            end
        end

        %意外判定
        if up_point(1) < 1 || up_point(1) > Map(1) ...
                || up_point(2) < 1 || up_point(2) > Map(2) ...
                || up_point(1) ~= down_point(1) ...
                || up_point(2) ~= down_point(2)
            a = 0;
            b = 0;
            return;
        end

        %判定是否可以快翻
        if a ~= 0
            flag_sum = 0;
            for ii = [a;b]
                flag_sum = flag_map(ii(1),ii(2)) + flag_sum;
            end
            if map_data(up_point(1),up_point(2)) == flag_sum
                for ii = [a;b]
                    OpenMap(ii(1),ii(2));
                end
            end
            a = 0;
            b = 0;
            IsWin()
            return;
        end
        
        %立旗幟
        if click_type == "alt"
            ChangeFlag(up_point(1),up_point(2));
            return;
        end

        %開啟格子
        if click_type == "normal"
            OpenMap(up_point(1),up_point(2));
            return;
        end            
    end

%紀錄不需要考慮數字格子
dont_care = zeros(Map,"logical");

    function CB(~,~)
        TrivialAnalysis();
    end

    %用九宮格分析炸彈和可開啟格子
    function TrivialAnalysis()
        C = zeros(Map,"logical");


        while ~all(C==map_open,"all")
            C = map_open;

            [x,y] = find(map_data > 0 & map_open == 1 & dont_care == 0);
            for ii = [x,y].'
                AutoFlag(ii(1),ii(2));
            end
            [x,y] = find(map_data > 0 & map_open == 1 & dont_care == 0);
            for ii = [x,y].'
                AutoClearGrid(ii(1),ii(2));
            end
        end
    end

    %判定九宮格未開格子數與數字相同，自動立旗
    function AutoFlag(x,y)
        sum = 0;
        [aa,bb] = ExtendGrid(x,y);
        %九宮格內未開格子數
        for ii = [aa;bb]
            sum = ~map_open(ii(1),ii(2)) + sum;
        end
        %自動立旗
        if sum == map_data(x,y)
            dont_care(x,y) = 1;
            for ii = [aa;bb]
                if map_open(ii(1),ii(2)) == 0 && flag_map(ii(1),ii(2)) == 0
                    CreateFlag(ii(1),ii(2));
                      pause(0.1);
                end
            end
        end
    end

    %判定九宮格旗子數數字相同，自動點開
    function AutoClearGrid(x,y)
        sum = 0;
        [aa,bb] = ExtendGrid(x,y);
        %九宮格內累加旗子數
        for ii = [aa;bb]
            sum = sum + flag_map(ii(1),ii(2));
        end
        %自動開啟九宮格
        if sum == map_data(x,y)
            dont_care(x,y) = 1;
            for ii = [aa;bb]
                OpenMap(ii(1),ii(2));
            end
              pause(0.1);
        end
    end
% 
% extend_map = zeros(Map,"logical");
% 
%     function EnumerateAll()
%         [x,y] = find(map_data > 0 & map_open == 1 & dont_care == 0);
%         for ii = [x,y].'
%             ExtentAndFill(ii(1),ii(2));
%         end
% 
%         len = length(extend_map);
%         for ii = 1:2^len
%             try_num = dec2bin(ii,len);
%             try_map = zeros(Map,"logical");
%             for iii = try_num
%                 try_map()
%             end
%         end
%     end
% 
%     function ExtentAndFill(x,y)
%         [aa,bb] = ExtendGrid(x,y);
%         for ii = [aa;bb]
%             if map_open(ii(1),ii(2)) == 0 && flag_map(ii(1),ii(2)) == 0
%                 extend_map(ii(1),ii(2)) = 1;
%             end
%         end
%     end

CreateMap();
end