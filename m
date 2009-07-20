Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZGTSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZGTSva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZGTSv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:51:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZGTSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bqIgRbD44a8ShCLdtlePjq+WCUXsqxezzE3v+qn0VLDvvFpiegf14B77r4tHaOUadm
         paDU16Heodfrktc/4BmBYHU1dBqEBHXAMfHd5SO4WQmTVbiOzAA7IxBwcZUmWyrkAfZI
         P5NuIUrwBRgVsfKnnHnyfkx3Cvuv8Gw4FucaY=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [PATCH] au1xmmc: dev_pm_ops conversion
Date: Mon, 20 Jul 2009 20:51:21 +0200
Message-Id: <1248115882-20221-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
Run-tested on Au1200.

 drivers/mmc/host/au1xmmc.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index d3f5561..70509c9 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1131,13 +1131,12 @@ static int __devexit au1xmmc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int au1xmmc_suspend(struct device *dev)
 {
-	struct au1xmmc_host *host = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host = dev_get_drvdata(dev);
 	int ret;
 
-	ret = mmc_suspend_host(host->mmc, state);
+	ret = mmc_suspend_host(host->mmc, PMSG_SUSPEND);
 	if (ret)
 		return ret;
 
@@ -1150,27 +1149,27 @@ static int au1xmmc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int au1xmmc_resume(struct platform_device *pdev)
+static int au1xmmc_resume(struct device *dev)
 {
-	struct au1xmmc_host *host = platform_get_drvdata(pdev);
+	struct au1xmmc_host *host = dev_get_drvdata(dev);
 
 	au1xmmc_reset_controller(host);
 
 	return mmc_resume_host(host->mmc);
 }
-#else
-#define au1xmmc_suspend NULL
-#define au1xmmc_resume NULL
-#endif
+
+static struct dev_pm_ops au1xmmc_pmops = {
+	.resume		= au1xmmc_resume,
+	.suspend	= au1xmmc_suspend,
+};
 
 static struct platform_driver au1xmmc_driver = {
 	.probe         = au1xmmc_probe,
 	.remove        = au1xmmc_remove,
-	.suspend       = au1xmmc_suspend,
-	.resume        = au1xmmc_resume,
 	.driver        = {
 		.name  = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.pm    = &au1xmmc_pmops,
 	},
 };
 
-- 
1.6.3.3

