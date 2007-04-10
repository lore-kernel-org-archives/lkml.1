Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXDJVMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXDJVMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXDJVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:12:10 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:46068 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbXDJVMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:12:06 -0400
Date: Tue, 10 Apr 2007 23:10:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Moore <Eric.Moore@lsi.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org
Subject: [PATCH 09/30] Use menuconfig objects - fusion
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102308440.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/message/fusion/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/message/fusion/Kconfig
+++ linux-2.6.21-rc5/drivers/message/fusion/Kconfig
@@ -1,14 +1,13 @@
 
-menu "Fusion MPT device support"
+menuconfig FUSION
+	bool "Fusion MPT device support"
+	default y
 
-config FUSION
-	bool
-	default n
+if FUSION
 
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -23,7 +22,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -40,7 +38,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -54,7 +51,6 @@ config FUSION_SAS
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
-	depends on FUSION
 	default "128"
 	range 16 128
 	help
@@ -100,4 +96,4 @@ config FUSION_LAN
 
 	  If unsure whether you really want or need this, say N.
 
-endmenu
+endif # FUSION
#<EOF>
