Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZGUN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZGUN5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGUN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:57:53 -0400
Received: from compulab.site5.com ([67.18.134.219]:39982 "EHLO compulab.co.il"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZGUN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:57:52 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] drivers/video/backlight: switch to dev_pm_ops
Date: Tue, 21 Jul 2009 16:57:47 +0300
Message-Id: <1248184667-22226-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.0.6
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/da903x_bl.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 93bb434..386ecd2 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -153,35 +153,35 @@ static int da903x_backlight_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int da903x_backlight_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+static int da903x_backlight_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	return da903x_backlight_set(bl, 0);
 }
 
-static int da903x_backlight_resume(struct platform_device *pdev)
+static int da903x_backlight_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define da903x_backlight_suspend	NULL
-#define da903x_backlight_resume		NULL
-#endif
+
+static struct dev_pm_ops da903x_backlight_pm_ops = {
+	.suspend	= da903x_backlight_suspend,
+	.resume		= da903x_backlight_resume,
+};
 
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &da903x_backlight_pm_ops,
 	},
 	.probe		= da903x_backlight_probe,
 	.remove		= da903x_backlight_remove,
-	.suspend	= da903x_backlight_suspend,
-	.resume		= da903x_backlight_resume,
 };
 
 static int __init da903x_backlight_init(void)
-- 
1.6.0.6

