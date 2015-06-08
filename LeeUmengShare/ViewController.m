//
//  ViewController.m
//  LeeUmengShare
//
//  Created by Keanu Reeves on 15-6-5.
//  Copyright (c) 2015年 yuanjilee. All rights reserved.
//



#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ksize.width-100)/2.0, 200, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [UMSocialData openLog:YES];
}

- (void)buttonClick
{
    //检查SSO授权是否过期
    [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    NSArray *snsNames = [NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToTencent,UMShareToSina,UMShareToSms, nil];
    
    //参数
    
    NSString *shareText = @"umengShareTest";
    UIImage *shareImage = [UIImage imageNamed:@"Share.jpg"];
    
    //统一设置标题
    [UMSocialData defaultData].extConfig.title = @"testTitle";
    //分平台设置标题,朋友圈只显示标题
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"朋友圈Title";
    
    //url 当前仅发现必须分平台设置，appDelegate里已设置过，但此处优先级更高
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"www.baidu.com";
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:umeng_appkey shareText:shareText shareImage:shareImage shareToSnsNames:snsNames delegate:self];
    
    
}

//判断分享平台，定制分享内容
- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToSms]) {
        socialData.shareImage = nil;
    } else if ([platformName isEqualToString:UMShareToSina]) {
        //微博分享没有标题，url跳转事件
        socialData.shareText = @"新浪微博分享内容,url => www.baidu.com";
    }
    
}

//分享回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
