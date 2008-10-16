Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYJPPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYJPPsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYJPPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:48:38 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59187 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYJPPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lhDc/0YYoqr9v6V6hbTCGti4RdEFJg/RAq5wCsXD4a4pECxLjh7A1e5dLFBkWpo9FL
         dGME065q0x9XwnshXE3rPbOYzlYL/UYIxxin/7gyJc8Tp3LtpDTdMrOsrXrG2IsQkgDJ
         2EImzCzxSRF8aXSUeTeHTjac2drMlcfUbE5sI=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] rtc-s3c: Fix section mismatch warnings
Date: Thu, 16 Oct 2008 18:48:30 +0300
Message-Id: <1224172110-24905-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081016171554.1ed8dd0f@i1501.lan.towertech.it>
References: <20081016171554.1ed8dd0f@i1501.lan.towertech.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warnings was appeared when compile rtc-s3c.c because
platform_driver structure s3c2410_rtcdrv has wrong name.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/rtc/rtc-s3c.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index e7d19b6..9a92ee1 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -507,7 +507,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 #define s3c_rtc_resume  NULL
 #endif
 
-static struct platform_driver s3c2410_rtcdrv = {
+static struct platform_driver s3c2410_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
@@ -523,12 +523,12 @@ static char __initdata banner[] = "S3C24XX RTC, (c) 2004,2006 Simtec Electronics
 static int __init s3c_rtc_init(void)
 {
 	printk(banner);
-	return platform_driver_register(&s3c2410_rtcdrv);
+	return platform_driver_register(&s3c2410_rtc_driver);
 }
 
 static void __exit s3c_rtc_exit(void)
 {
-	platform_driver_unregister(&s3c2410_rtcdrv);
+	platform_driver_unregister(&s3c2410_rtc_driver);
 }
 
 module_init(s3c_rtc_init);
-- 
1.5.6.5

