Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYGTQOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYGTQOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYGTQOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:14:20 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58966 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbYGTQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:14:20 -0400
Subject: RTC: rtc-s3c: add __devexit and __devinit markers
Message-Id: <20080720161418.186584460@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: a.zummo@towertech.it, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-s3c24xx-rtc-devattr.patch
Date: Sun, 20 Jul 2008 17:14:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the relevant __devinit and __devexit attributes to
the rtc-s3c driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/rtc/rtc-s3c.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/rtc/rtc-s3c.c	2008-07-20 17:08:20.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/rtc/rtc-s3c.c	2008-07-20 17:09:00.000000000 +0100
@@ -383,7 +383,7 @@ static void s3c_rtc_enable(struct platfo
 	}
 }
 
-static int s3c_rtc_remove(struct platform_device *dev)
+static int __devexit s3c_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
@@ -400,7 +400,7 @@ static int s3c_rtc_remove(struct platfor
 	return 0;
 }
 
-static int s3c_rtc_probe(struct platform_device *pdev)
+static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
@@ -513,7 +513,7 @@ static int s3c_rtc_resume(struct platfor
 
 static struct platform_driver s3c2410_rtcdrv = {
 	.probe		= s3c_rtc_probe,
-	.remove		= s3c_rtc_remove,
+	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
 	.resume		= s3c_rtc_resume,
 	.driver		= {

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
