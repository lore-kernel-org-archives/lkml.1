Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbXKJQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbXKJQ0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXKJQ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:26:31 -0500
Received: from ns.penguin.cz ([212.47.7.226]:47660 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbXKJQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:26:30 -0500
X-Greylist: delayed 2112 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 11:26:30 EST
Subject: [PATCH] drivers/video/s1d13xxxfb.c as module with dbg
From: Stanislav Brabec <utx@penguin.cz>
To: linux-kernel@vger.kernel.org
Cc: Thibaut VARENE <varenet@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 16:51:15 +0100
Message-Id: <1194709875.4486.8.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Attached patch fixes two compilation problems of s1d13xxxfb.c:
- Fixes outdated dbg() message to fix compilation error with debugging enabled.
- Do not read kernel command line options when compiled as module.

Signed-off-by: Stanislav Brabec <utx@penguin.cz>

--- linux-2.6.23/drivers/video/s1d13xxxfb.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/video/s1d13xxxfb.c	2007-11-02 16:48:34.000000000 +0100
@@ -540,7 +540,7 @@
 	int ret = 0;
 	u8 revision;
 
-	dbg("probe called: device is %p\n", dev);
+	dbg("probe called: device is %p\n", pdev);
 
 	printk(KERN_INFO "Epson S1D13XXX FB Driver\n");
 
@@ -753,8 +753,11 @@
 static int __init
 s1d13xxxfb_init(void)
 {
+
+#ifndef MODULE
 	if (fb_get_options("s1d13xxxfb", NULL))
 		return -ENODEV;
+#endif
 
 	return platform_driver_register(&s1d13xxxfb_driver);
 }


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

