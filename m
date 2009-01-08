Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZAHMEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZAHMEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZAHMEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:04:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33602 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756709AbZAHME3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:04:29 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.29] [WATCHDOG] wm8350: Fix section annotations
Date: Thu,  8 Jan 2009 12:04:27 +0000
Message-Id: <1231416267-3026-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and remove functions were incorrectly annotated, with the
misannotation of the remove function causing build failures when built
in.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/watchdog/wm8350_wdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 2bc0d4d..a2d2e8e 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -279,7 +279,7 @@ static struct miscdevice wm8350_wdt_miscdev = {
 	.fops = &wm8350_wdt_fops,
 };
 
-static int wm8350_wdt_probe(struct platform_device *pdev)
+static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 
@@ -296,7 +296,7 @@ static int wm8350_wdt_probe(struct platform_device *pdev)
 	return misc_register(&wm8350_wdt_miscdev);
 }
 
-static int __exit wm8350_wdt_remove(struct platform_device *pdev)
+static int __devexit wm8350_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&wm8350_wdt_miscdev);
 
@@ -305,7 +305,7 @@ static int __exit wm8350_wdt_remove(struct platform_device *pdev)
 
 static struct platform_driver wm8350_wdt_driver = {
 	.probe = wm8350_wdt_probe,
-	.remove = wm8350_wdt_remove,
+	.remove = __devexit_p(wm8350_wdt_remove),
 	.driver = {
 		.name = "wm8350-wdt",
 	},
-- 
1.5.6.5

