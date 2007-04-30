Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbXD3LWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbXD3LWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030892AbXD3LWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:22:39 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50259 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbXD3LWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:22:37 -0400
Date: Mon, 30 Apr 2007 13:22:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/36] Use menuconfig objects II - block devices
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301321450.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/block/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/block/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/block/Kconfig
@@ -2,9 +2,12 @@
 # Block device driver configuration
 #
 
-if BLOCK
+menuconfig BLK_DEV
+	bool "Block devices"
+	depends on BLOCK
+	default y
 
-menu "Block devices"
+if BLK_DEV
 
 config BLK_DEV_FD
 	tristate "Normal floppy disk support"
@@ -453,6 +456,4 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
-endmenu
-
-endif
+endif # BLK_DEV
