Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXE3Ti4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXE3Ti4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbXE3Tir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:38:47 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54242 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbXE3Tiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:38:46 -0400
Date: Wed, 30 May 2007 21:37:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/06] Use menuconfig objects 4 - ISDN part 1/6 (CONFIG_ISDN)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302136410.11140@yvahk01.tjqt.qr>
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
 drivers/isdn/Kconfig                |   13 ++++---------
 drivers/isdn/hardware/Kconfig       |    2 +-
 drivers/isdn/hardware/avm/Kconfig   |    2 +-
 drivers/isdn/hardware/eicon/Kconfig |    2 +-
 drivers/isdn/i4l/Kconfig            |    7 +++----
 5 files changed, 10 insertions(+), 16 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
@@ -2,12 +2,10 @@
 # ISDN device configuration
 #
 
-menu "ISDN subsystem"
-	depends on !S390
-
-config ISDN
+menuconfig ISDN
 	tristate "ISDN support"
 	depends on NET
+	depends on !S390
 	---help---
 	  ISDN ("Integrated Services Digital Networks", called RNIS in France)
 	  is a special type of fully digital telephone service; it's mostly
@@ -21,9 +19,9 @@ config ISDN
 
 	  Select this option if you want your kernel to support ISDN.
 
+if ISDN
 
 menu "Old ISDN4Linux"
-	depends on NET && ISDN
 
 config ISDN_I4L
 	tristate "Old ISDN4Linux (obsolete)"
@@ -49,11 +47,9 @@ endif
 endmenu
 
 comment "CAPI subsystem"
-	depends on NET && ISDN
 
 config ISDN_CAPI
 	tristate "CAPI2.0 support"
-	depends on ISDN
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN
@@ -64,5 +60,4 @@ source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
-endmenu
-
+endif # ISDN
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/Kconfig
@@ -2,7 +2,7 @@
 # ISDN hardware drivers
 #
 comment "CAPI hardware drivers"
-	depends on NET && ISDN && ISDN_CAPI
+	depends on ISDN_CAPI
 
 source "drivers/isdn/hardware/avm/Kconfig"
 
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/avm/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Active AVM cards"
-	depends on NET && ISDN && ISDN_CAPI!=n
+	depends on ISDN_CAPI!=n
 
 config CAPI_AVM
 	bool "Support AVM cards"
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/eicon/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Active Eicon DIVA Server cards"
-	depends on NET && ISDN && ISDN_CAPI!=n
+	depends on ISDN_CAPI!=n
 
 config CAPI_EICON
 	bool "Support Eicon cards"
Index: linux-2.6.22-rc3-git1/drivers/isdn/i4l/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/i4l/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/i4l/Kconfig
@@ -86,7 +86,6 @@ config ISDN_X25
 
 
 menu "ISDN feature submodules"
-	depends on ISDN
 
 config ISDN_DRV_LOOP
 	tristate "isdnloop support"
@@ -100,7 +99,7 @@ config ISDN_DRV_LOOP
 
 config ISDN_DIVERSION
 	tristate "Support isdn diversion services"
-	depends on ISDN && ISDN_I4L
+	depends on ISDN_I4L
 	help
 	  This option allows you to use some supplementary diversion
 	  services in conjunction with the HiSax driver on an EURO/DSS1
@@ -120,13 +119,13 @@ config ISDN_DIVERSION
 endmenu
 
 comment "ISDN4Linux hardware drivers"
-	depends on NET && ISDN && ISDN_I4L
+	depends on ISDN_I4L
 
 source "drivers/isdn/hisax/Kconfig"
 
 
 menu "Active cards"
-	depends on NET && ISDN && ISDN_I4L!=n
+	depends on ISDN_I4L!=n
 
 source "drivers/isdn/icn/Kconfig"
 
