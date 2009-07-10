Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZGJNRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZGJNRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZGJNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:17:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57626 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580AbZGJNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:17:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] rtc: Convert WM8350 RTC driver to dev_pm_ops
Date: Fri, 10 Jul 2009 14:16:59 +0100
Message-Id: <1247231819-30431-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/rtc/rtc-wm8350.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index c91edc5..b70702b 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -350,8 +350,9 @@ static const struct rtc_class_ops wm8350_rtc_ops = {
 };
 
 #ifdef CONFIG_PM
-static int wm8350_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int wm8350_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct wm8350 *wm8350 = dev_get_drvdata(&pdev->dev);
 	int ret = 0;
 	u16 reg;
@@ -369,8 +370,9 @@ static int wm8350_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return ret;
 }
 
-static int wm8350_rtc_resume(struct platform_device *pdev)
+static int wm8350_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct wm8350 *wm8350 = dev_get_drvdata(&pdev->dev);
 	int ret;
 
@@ -483,13 +485,17 @@ static int __devexit wm8350_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct dev_pm_ops wm8350_rtc_pm_ops = {
+	.suspend = wm8350_rtc_suspend,
+	.resume = wm8350_rtc_resume,
+};
+
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
 	.remove = __devexit_p(wm8350_rtc_remove),
-	.suspend = wm8350_rtc_suspend,
-	.resume = wm8350_rtc_resume,
 	.driver = {
 		.name = "wm8350-rtc",
+		.pm = &wm8350_rtc_pm_ops,
 	},
 };
 
-- 
1.6.3.3

