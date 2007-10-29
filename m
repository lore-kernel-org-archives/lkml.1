Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbXJ2SYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbXJ2SYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXJ2SYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:24:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27514 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbXJ2SYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:24:35 -0400
Date: Mon, 29 Oct 2007 11:20:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com
Subject: [PATCH] rtc: m48t59 fix section mismatch warning
Message-Id: <20071029112004.de52d9db.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Change the name of this data to use a name (suffix) that is whitelisted
by MODPOST so that the section warning is fixed (not generated).

WARNING: vmlinux.o(.data+0x1b140): Section mismatch: reference to .init.text:m48t59_rtc_probe (between 'm48t59_rtc_platdrv' and 'm48t59_nvram_attr')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/rtc/rtc-m48t59.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc1-git4.orig/drivers/rtc/rtc-m48t59.c
+++ linux-2.6.24-rc1-git4/drivers/rtc/rtc-m48t59.c
@@ -464,7 +464,7 @@ static int __devexit m48t59_rtc_remove(s
 	return 0;
 }
 
-static struct platform_driver m48t59_rtc_platdrv = {
+static struct platform_driver m48t59_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-m48t59",
 		.owner	= THIS_MODULE,
@@ -475,12 +475,12 @@ static struct platform_driver m48t59_rtc
 
 static int __init m48t59_rtc_init(void)
 {
-	return platform_driver_register(&m48t59_rtc_platdrv);
+	return platform_driver_register(&m48t59_rtc_driver);
 }
 
 static void __exit m48t59_rtc_exit(void)
 {
-	platform_driver_unregister(&m48t59_rtc_platdrv);
+	platform_driver_unregister(&m48t59_rtc_driver);
 }
 
 module_init(m48t59_rtc_init);
