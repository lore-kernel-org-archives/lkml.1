Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYBQMXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYBQMXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYBQMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:22:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38317 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 02/27] rtc: silence section mismatch warning in rtc-test
Date: Sun, 17 Feb 2008 13:22:39 +0100
Message-Id: <1203250984-11285-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.data+0x253e28): Section mismatch in reference from the variable test_drv to the function .devexit.text:test_remove()

Fix by renaming the platfrom_driver variable from *_drv to *_driver
so modpost ignore the reference to an __devexit section.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-test.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 254c9fc..bc93002 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -147,7 +147,7 @@ static int __devexit test_remove(struct platform_device *plat_dev)
 	return 0;
 }
 
-static struct platform_driver test_drv = {
+static struct platform_driver test_driver = {
 	.probe	= test_probe,
 	.remove = __devexit_p(test_remove),
 	.driver = {
@@ -160,7 +160,7 @@ static int __init test_init(void)
 {
 	int err;
 
-	if ((err = platform_driver_register(&test_drv)))
+	if ((err = platform_driver_register(&test_driver)))
 		return err;
 
 	if ((test0 = platform_device_alloc("rtc-test", 0)) == NULL) {
@@ -191,7 +191,7 @@ exit_free_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 	return err;
 }
 
@@ -199,7 +199,7 @@ static void __exit test_exit(void)
 {
 	platform_device_unregister(test0);
 	platform_device_unregister(test1);
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 }
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
-- 
1.5.4.rc3.14.g44397

