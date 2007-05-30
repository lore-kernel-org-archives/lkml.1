Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXE3TnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXE3TnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXE3TnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:43:12 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56136 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXE3TnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:43:11 -0400
Date: Wed, 30 May 2007 21:41:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mac@melware.de
Subject: [PATCH 06/06] Use menuconfig objects 4 - ISDN part 6/6 (CONFIG_CAPI_EICON)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302140430.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/hardware/eicon/Kconfig |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/eicon/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
@@ -2,51 +2,50 @@
 # ISDN DIVAS Eicon driver
 #
 
-menu "Active Eicon DIVA Server cards"
-
-config CAPI_EICON
-	bool "Support Eicon cards"
+menuconfig CAPI_EICON
+	bool "Active Eicon DIVA Server cards"
 	help
 	  Enable support for Eicon Networks active ISDN cards.
 
+if CAPI_EICON
+
 config ISDN_DIVAS
 	tristate "Support Eicon DIVA Server cards"
-	depends on CAPI_EICON && PROC_FS && PCI
+	depends on PROC_FS && PCI
 	help
 	  Say Y here if you have an Eicon Networks DIVA Server PCI ISDN card.
 	  In order to use this card, additional firmware is necessary, which
 	  has to be downloaded into the card using the divactrl utility.
 
+if ISDN_DIVAS
+
 config ISDN_DIVAS_BRIPCI
 	bool "DIVA Server BRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server BRI-PCI.
 
 config ISDN_DIVAS_PRIPCI
 	bool "DIVA Server PRI/PCI support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for DIVA Server PRI-PCI.
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
-	depends on ISDN_DIVAS
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
 
 config ISDN_DIVAS_USERIDI
 	tristate "DIVA User-IDI interface support"
-	depends on ISDN_DIVAS
 	help
 	  Enable support for user-mode IDI interface.
 
 config ISDN_DIVAS_MAINT
 	tristate "DIVA Maint driver support"
-	depends on ISDN_DIVAS && m
+	depends on m
 	help
 	  Enable Divas Maintenance driver.
 
-endmenu
+endif # ISDN_DIVAS
 
+endif # CAPI_EICON
