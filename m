Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXDJVPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXDJVPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDJVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:15:06 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:47166 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbXDJVPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:15:02 -0400
Date: Tue, 10 Apr 2007 23:14:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/30] Use menuconfig objects - IDE
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102313500.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/ide/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/ide/Kconfig
+++ linux-2.6.21-rc5/drivers/ide/Kconfig
@@ -4,12 +4,9 @@
 # Andre Hedrick <andre@linux-ide.org>
 #
 
-if BLOCK
-
-menu "ATA/ATAPI/MFM/RLL support"
-
-config IDE
+menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
+	depends on BLOCK
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
 	  storage units such as ATA/(E)IDE and ATAPI units. The most common
@@ -1081,8 +1078,4 @@ config BLK_DEV_HD_ONLY
 config BLK_DEV_HD
 	def_bool BLK_DEV_HD_IDE || BLK_DEV_HD_ONLY
 
-endif
-
-endmenu
-
-endif
+endif # IDE
#<EOF>
