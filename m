Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbXDJVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbXDJVo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXDJVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:44:57 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58325 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbXDJVoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:44:22 -0400
Date: Tue, 10 Apr 2007 23:42:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jaroslav Kysela <perex@suse.cz>, Adam Belay <ambx1@neo.rr.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 28/30] Use menuconfig objects - PNP
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102341200.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/pnp/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pnp/Kconfig
+++ linux-2.6.21-rc5/drivers/pnp/Kconfig
@@ -2,9 +2,7 @@
 # Plug and Play configuration
 #
 
-menu "Plug and Play support"
-
-config PNP
+menuconfig PNP
 	bool "Plug and Play support"
 	depends on ISA || ACPI
 	---help---
@@ -21,15 +19,15 @@ config PNP
 
 	  If unsure, say Y.
 
+if PNP
+
 config PNP_DEBUG
 	bool "PnP Debug Messages"
-	depends on PNP
 	help
 	  Say Y if you want the Plug and Play Layer to print debug messages.
 	  This is useful if you are developing a PnP driver or troubleshooting.
 
 comment "Protocols"
-	depends on PNP
 
 source "drivers/pnp/isapnp/Kconfig"
 
@@ -37,5 +35,4 @@ source "drivers/pnp/pnpbios/Kconfig"
 
 source "drivers/pnp/pnpacpi/Kconfig"
 
-endmenu
-
+endif # PNP
Index: linux-2.6.21-rc5/drivers/pnp/isapnp/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pnp/isapnp/Kconfig
+++ linux-2.6.21-rc5/drivers/pnp/isapnp/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISAPNP
 	bool "ISA Plug and Play support"
-	depends on PNP && ISA
+	depends on ISA
 	help
 	  Say Y here if you would like support for ISA Plug and Play devices.
 	  Some information is in <file:Documentation/isapnp.txt>.
Index: linux-2.6.21-rc5/drivers/pnp/pnpbios/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pnp/pnpbios/Kconfig
+++ linux-2.6.21-rc5/drivers/pnp/pnpbios/Kconfig
@@ -3,7 +3,7 @@
 #
 config PNPBIOS
 	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on PNP && ISA && X86 && EXPERIMENTAL
+	depends on ISA && X86 && EXPERIMENTAL
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
#<EOF>
