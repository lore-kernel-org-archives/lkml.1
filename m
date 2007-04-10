Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXDJVkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXDJVkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXDJVkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:40:01 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:56491 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXDJVj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:39:59 -0400
Date: Tue, 10 Apr 2007 23:39:08 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Orphaned driver - the list for it 
	<linux-parport@lists.infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 25/30] Use menuconfig objects - parport
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102337530.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/parport/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/parport/Kconfig
+++ linux-2.6.21-rc5/drivers/parport/Kconfig
@@ -5,9 +5,7 @@
 # Parport configuration.
 #
 
-menu "Parallel port support"
-
-config PARPORT
+menuconfig PARPORT
 	tristate "Parallel port support"
 	---help---
 	  If you want to use devices connected to your machine's parallel port
@@ -32,9 +30,11 @@ config PARPORT
 
 	  If unsure, say Y.
 
+if PARPORT
+
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on PARPORT && (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
+	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
@@ -84,7 +84,7 @@ config PARPORT_PC_PCMCIA
 
 config PARPORT_IP32
 	tristate "SGI IP32 builtin port (EXPERIMENTAL)"
-	depends on SGI_IP32 && PARPORT && EXPERIMENTAL
+	depends on SGI_IP32 && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port on
@@ -93,7 +93,7 @@ config PARPORT_IP32
 
 config PARPORT_AMIGA
 	tristate "Amiga builtin port"
-	depends on AMIGA && PARPORT
+	depends on AMIGA
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -102,7 +102,7 @@ config PARPORT_AMIGA
 
 config PARPORT_MFC3
 	tristate "Multiface III parallel port"
-	depends on ZORRO && PARPORT
+	depends on ZORRO
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need parallel port support for the MFC3 card.
@@ -111,7 +111,7 @@ config PARPORT_MFC3
 
 config PARPORT_ATARI
 	tristate "Atari hardware"
-	depends on ATARI && PARPORT
+	depends on ATARI
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -121,12 +121,11 @@ config PARPORT_ATARI
 config PARPORT_GSC
 	tristate
 	default GSC
-	depends on PARPORT
 	select PARPORT_NOT_PC
 
 config PARPORT_SUNBPP
 	tristate "Sparc hardware (EXPERIMENTAL)"
-	depends on SBUS && PARPORT && EXPERIMENTAL
+	depends on SBUS && EXPERIMENTAL
 	select PARPORT_NOT_PC
 	help
 	  This driver provides support for the bidirectional parallel port
@@ -135,7 +134,6 @@ config PARPORT_SUNBPP
 
 config PARPORT_AX88796
 	tristate "AX88796 Parallel Port"
-	depends on PARPORT
 	select PARPORT_NOT_PC
 	help
 	  Say Y here if you need support for the parallel port hardware on
@@ -147,7 +145,6 @@ config PARPORT_AX88796
 
 config PARPORT_1284
 	bool "IEEE 1284 transfer modes"
-	depends on PARPORT
 	help
 	  If you have a printer that supports status readback or device ID, or
 	  want to use a device that uses enhanced parallel port transfer modes
@@ -158,5 +155,4 @@ config PARPORT_1284
 config PARPORT_NOT_PC
 	bool
 
-endmenu
-
+endif # PARPORT
#<EOF>
