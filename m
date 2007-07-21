Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbXGUS4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbXGUS4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXGUS4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:56:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51180 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbXGUS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:56:35 -0400
Date: Sat, 21 Jul 2007 20:56:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: akpm@linux-foundation.org
cc: Eric.Moore@lsil.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use menuconfig objects - Fusion
In-Reply-To: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
References: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 16:17, akpm@linux-foundation.org wrote:
>The patch titled
>     Use menuconfig objects II - fusion
>has been removed from the -mm tree.  Its filename was
>     use-menuconfig-objects-ii-fusion.patch
>
>This patch was dropped because it broke

Here is an updated version.

Thanks,
	Jan
===


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/message/fusion/Kconfig |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: linux-2.6.23/drivers/message/fusion/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/message/fusion/Kconfig
+++ linux-2.6.23/drivers/message/fusion/Kconfig
@@ -1,15 +1,19 @@
 
-menu "Fusion MPT device support"
+menuconfig FUSION
+	bool "Fusion MPT device support"
 	depends on PCI
+	---help---
+	Say Y here to get to see options for Fusion Message
+	Passing Technology (MPT) drivers.
+	This option alone does not add any kernel code.
+
+	If you say N, all options in this submenu will be skipped and disabled.
 
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
@@ -24,7 +28,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -41,7 +44,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -55,7 +57,6 @@ config FUSION_SAS
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
-	depends on FUSION
 	default "128"
 	range 16 128
 	help
@@ -101,4 +102,4 @@ config FUSION_LAN
 
 	  If unsure whether you really want or need this, say N.
 
-endmenu
+endif # FUSION
