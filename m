Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZBCQzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZBCQzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZBCQyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:54:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57224 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZBCQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:54:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 3 Feb 2009 17:54:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: dv1394: move deprecation message from module init
 to file open
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.27c6433221173763@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many Linux installations, the dv1394 driver will be auto-loaded
whenever an AV/C device (e.g. camcorder or audio device) is plugged in.
An irritating message would then appear in the kernel log.

Defer this message to until a dv1394 character device file is actually
used by a program.  Also include the program name in the message and
update the message slightly.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/ieee1394/dv1394.c
===================================================================
--- linux.orig/drivers/ieee1394/dv1394.c
+++ linux/drivers/ieee1394/dv1394.c
@@ -1823,6 +1823,10 @@ static int dv1394_open(struct inode *ino
 
 #endif
 
+	printk(KERN_INFO "%s: NOTE, the dv1394 interface is unsupported "
+	       "and will not be available in the new firewire driver stack. "
+	       "Try libraw1394 based programs instead.\n", current->comm);
+
 	return 0;
 }
 
@@ -2567,10 +2571,6 @@ static int __init dv1394_init_module(voi
 {
 	int ret;
 
-	printk(KERN_WARNING
-	       "NOTE: The dv1394 driver is unsupported and may be removed in a "
-	       "future Linux release. Use raw1394 instead.\n");
-
 	cdev_init(&dv1394_cdev, &dv1394_fops);
 	dv1394_cdev.owner = THIS_MODULE;
 	ret = cdev_add(&dv1394_cdev, IEEE1394_DV1394_DEV, 16);

-- 
Stefan Richter
-=====-==--= --=- ---==
http://arcgraph.de/sr/

