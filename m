Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbXE3Tjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbXE3Tjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXE3TjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:39:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54527 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbXE3TjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:39:21 -0400
Date: Wed, 30 May 2007 21:38:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/06] Use menuconfig objects 4 - ISDN part 2/6 (CONFIG_ISDN_I4L)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/Kconfig         |    6 +-----
 drivers/isdn/act2000/Kconfig |    2 +-
 drivers/isdn/gigaset/Kconfig |    2 --
 drivers/isdn/hisax/Kconfig   |    1 -
 drivers/isdn/i4l/Kconfig     |    3 ---
 drivers/isdn/icn/Kconfig     |    2 +-
 drivers/isdn/pcbit/Kconfig   |    2 +-
 drivers/isdn/sc/Kconfig      |    2 +-
 8 files changed, 5 insertions(+), 15 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
@@ -21,9 +21,7 @@ menuconfig ISDN
 
 if ISDN
 
-menu "Old ISDN4Linux"
-
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (obsolete)"
 	---help---
 	  This driver allows you to use an ISDN-card for networking
@@ -44,8 +42,6 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-endmenu
-
 comment "CAPI subsystem"
 
 config ISDN_CAPI
Index: linux-2.6.22-rc3-git1/drivers/isdn/act2000/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/act2000/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/act2000/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_ACT2000
 	tristate "IBM Active 2000 support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  Say Y here if you have an IBM Active 2000 ISDN card. In order to use
 	  this card, additional firmware is necessary, which has to be loaded
Index: linux-2.6.22-rc3-git1/drivers/isdn/gigaset/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/gigaset/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/gigaset/Kconfig
@@ -1,9 +1,7 @@
 menu "Siemens Gigaset"
-	depends on ISDN_I4L
 
 config ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
-	depends on ISDN_I4L
 	select CRC_CCITT
 	select BITREVERSE
 	help
Index: linux-2.6.22-rc3-git1/drivers/isdn/hisax/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hisax/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hisax/Kconfig
@@ -1,6 +1,5 @@
 
 menu "Passive cards"
-	depends on ISDN_I4L
 
 config ISDN_DRV_HISAX
 	tristate "HiSax SiemensChipSet driver support"
Index: linux-2.6.22-rc3-git1/drivers/isdn/i4l/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/i4l/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/i4l/Kconfig
@@ -99,7 +99,6 @@ config ISDN_DRV_LOOP
 
 config ISDN_DIVERSION
 	tristate "Support isdn diversion services"
-	depends on ISDN_I4L
 	help
 	  This option allows you to use some supplementary diversion
 	  services in conjunction with the HiSax driver on an EURO/DSS1
@@ -119,13 +118,11 @@ config ISDN_DIVERSION
 endmenu
 
 comment "ISDN4Linux hardware drivers"
-	depends on ISDN_I4L
 
 source "drivers/isdn/hisax/Kconfig"
 
 
 menu "Active cards"
-	depends on ISDN_I4L!=n
 
 source "drivers/isdn/icn/Kconfig"
 
Index: linux-2.6.22-rc3-git1/drivers/isdn/icn/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/icn/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/icn/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_ICN
 	tristate "ICN 2B and 4B support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  This enables support for two kinds of ISDN-cards made by a German
 	  company called ICN.  2B is the standard version for a single ISDN
Index: linux-2.6.22-rc3-git1/drivers/isdn/pcbit/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/pcbit/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/pcbit/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_PCBIT
 	tristate "PCBIT-D support"
-	depends on ISDN_I4L && ISA && (BROKEN || X86)
+	depends on ISA && (BROKEN || X86)
 	help
 	  This enables support for the PCBIT ISDN-card.  This card is
 	  manufactured in Portugal by Octal.  For running this card,
Index: linux-2.6.22-rc3-git1/drivers/isdn/sc/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/sc/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/sc/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISDN_DRV_SC
 	tristate "Spellcaster support"
-	depends on ISDN_I4L && ISA
+	depends on ISA
 	help
 	  This enables support for the Spellcaster BRI ISDN boards.  This
 	  driver currently builds only in a modularized version.
