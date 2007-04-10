Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXDJVTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXDJVTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXDJVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:19:50 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48972 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbXDJVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:19:48 -0400
Date: Tue, 10 Apr 2007 23:18:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 14/30] Use menuconfig objects - MD
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102317230.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/md/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/md/Kconfig
+++ linux-2.6.21-rc5/drivers/md/Kconfig
@@ -2,19 +2,17 @@
 # Block device driver configuration
 #
 
-if BLOCK
-
-menu "Multi-device support (RAID and LVM)"
-
-config MD
+menuconfig MD
 	bool "Multiple devices driver support (RAID and LVM)"
+	depends on BLOCK
 	help
 	  Support multiple physical spindles through a single logical device.
 	  Required for RAID and logical volume management.
 
+if MD
+
 config BLK_DEV_MD
 	tristate "RAID support"
-	depends on MD
 	---help---
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one
@@ -189,7 +187,6 @@ config MD_FAULTY
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
-	depends on MD
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
@@ -262,6 +259,4 @@ config DM_MULTIPATH_EMC
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
-endmenu
-
-endif
+endif # MD
#<EOF>
