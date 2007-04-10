Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXDJVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXDJVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXDJVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:38:29 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:55884 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbXDJVi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:38:27 -0400
Date: Tue, 10 Apr 2007 23:37:42 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?UTF-8?Q?Eberhard_M=C3=B6nkeberg?= <emoenke@gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 24/30] Use menuconfig objects - oldcd
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102336550.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/cdrom/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/cdrom/Kconfig
+++ linux-2.6.21-rc5/drivers/cdrom/Kconfig
@@ -2,11 +2,9 @@
 # CDROM driver configuration
 #
 
-menu "Old CD-ROM drivers (not SCSI, not IDE)"
+menuconfig CD_NO_IDESCSI
+	bool "Old CD-ROM drivers (not SCSI, not IDE)"
 	depends on ISA && BLOCK
-
-config CD_NO_IDESCSI
-	bool "Support non-SCSI/IDE/ATAPI CDROM drives"
 	---help---
 	  If you have a CD-ROM drive that is neither SCSI nor IDE/ATAPI, say Y
 	  here, otherwise N. Read the CD-ROM-HOWTO, available from
@@ -31,9 +29,10 @@ config CD_NO_IDESCSI
 	  answer will get "defaulted" for you if you enable any of the Linux
 	  CD-ROM drivers).
 
+if CD_NO_IDESCSI
+
 config AZTCD
 	tristate "Aztech/Orchid/Okano/Wearnes/TXC/CyDROM  CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is your driver if you have an Aztech CDA268-01A, Orchid
 	  CD-3110, Okano or Wearnes CDD110, Conrad TXC, or CyCD-ROM CR520 or
@@ -51,7 +50,6 @@ config AZTCD
 
 config GSCD
 	tristate "Goldstar R420 CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  If this is your CD-ROM drive, say Y here.  As described in the file
 	  <file:Documentation/cdrom/gscd>, you might have to change a setting
@@ -67,7 +65,7 @@ config GSCD
 
 config SBPCD
 	tristate "Matsushita/Panasonic/Creative, Longshine, TEAC CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  This driver supports most of the drives which use the Panasonic or
 	  Sound Blaster interface.  Please read the file
@@ -105,7 +103,6 @@ config SBPCD
 
 config MCDX
 	tristate "Mitsumi CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  Use this driver if you want to be able to use your Mitsumi LU-005,
 	  FX-001 or FX-001D CD-ROM drive.
@@ -121,7 +118,6 @@ config MCDX
 
 config OPTCD
 	tristate "Optics Storage DOLPHIN 8000AT CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is the driver for the 'DOLPHIN' drive with a 34-pin Sony
 	  compatible interface. It also works with the Lasermate CR328A. If
@@ -138,7 +134,7 @@ config OPTCD
 
 config CM206
 	tristate "Philips/LMS CM206 CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  If you have a Philips/LMS CD-ROM drive cm206 in combination with a
 	  cm260 host adapter card, say Y here. Please also read the file
@@ -153,7 +149,6 @@ config CM206
 
 config SJCD
 	tristate "Sanyo CDR-H94A CDROM support"
-	depends on CD_NO_IDESCSI
 	help
 	  If this is your CD-ROM drive, say Y here and read the file
 	  <file:Documentation/cdrom/sjcd>. You should then also say Y or M to
@@ -165,7 +160,6 @@ config SJCD
 
 config ISP16_CDI
 	tristate "ISP16/MAD16/Mozart soft configurable cdrom interface support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  These are sound cards with built-in cdrom interfaces using the OPTi
 	  82C928 or 82C929 chips. Say Y here to have them detected and
@@ -178,7 +172,7 @@ config ISP16_CDI
 
 config CDU31A
 	tristate "Sony CDU31A/CDU33A CDROM support"
-	depends on CD_NO_IDESCSI && BROKEN_ON_SMP
+	depends on BROKEN_ON_SMP
 	---help---
 	  These CD-ROM drives have a spring-pop-out caddyless drawer, and a
 	  rectangular green LED centered beneath it.  NOTE: these CD-ROM
@@ -198,7 +192,6 @@ config CDU31A
 
 config CDU535
 	tristate "Sony CDU535 CDROM support"
-	depends on CD_NO_IDESCSI
 	---help---
 	  This is the driver for the older Sony CDU-535 and CDU-531 CD-ROM
 	  drives. Please read the file <file:Documentation/cdrom/sonycd535>.
@@ -210,4 +203,4 @@ config CDU535
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonycd535.
 
-endmenu
+endif # CD_NO_IDESCSI
#<EOF>
