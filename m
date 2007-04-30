Return-Path: <linux-kernel-owner+w=401wt.eu-S1161499AbXD3Lku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161499AbXD3Lku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161540AbXD3Lkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:40:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45353 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161499AbXD3LkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:40:21 -0400
Date: Mon, 30 Apr 2007 13:38:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org
Subject: [PATCH 16/36] Use menuconfig objects II - MD
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301337570.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/md/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/md/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/md/Kconfig
@@ -2,20 +2,18 @@
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
 	select ASYNC_TX_DMA
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
@@ -190,7 +188,6 @@ config MD_FAULTY
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
-	depends on MD
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
@@ -272,6 +269,4 @@ config DM_DELAY
 
 	If unsure, say N.
 
-endmenu
-
-endif
+endif # MD
