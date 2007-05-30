Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXE3Tl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXE3Tl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbXE3TlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:41:12 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55348 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbXE3TlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:41:10 -0400
Date: Wed, 30 May 2007 21:40:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/06] Use menuconfig objects 4 - ISDN part 4/6 (CONFIG_ISDN_CAPI)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302139280.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Transform "depends on" into a simpler if-endif block style dependency.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/Kconfig                |    4 ++++
 drivers/isdn/capi/Kconfig           |    7 ++-----
 drivers/isdn/hardware/Kconfig       |    1 -
 drivers/isdn/hardware/avm/Kconfig   |   13 ++++++-------
 drivers/isdn/hardware/eicon/Kconfig |    3 +--
 5 files changed, 13 insertions(+), 15 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
@@ -52,8 +52,12 @@ config ISDN_CAPI
 	  hardware, see <http://www.capi.org/>.  This is needed for AVM's set
 	  of active ISDN controllers like B1, T1, M1.
 
+if ISDN_CAPI
+
 source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
+endif # ISDN_CAPI
+
 endif # ISDN
Index: linux-2.6.22-rc3-git1/drivers/isdn/capi/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/capi/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/capi/Kconfig
@@ -3,7 +3,6 @@
 #
 config ISDN_DRV_AVMB1_VERBOSE_REASON
 	bool "Verbose reason code reporting"
-	depends on ISDN_CAPI
 	default y
 	help
 	  If you say Y here, the CAPI drivers will give verbose reasons for
@@ -12,7 +11,6 @@ config ISDN_DRV_AVMB1_VERBOSE_REASON
 
 config CAPI_TRACE
 	bool "CAPI trace support"
-	depends on ISDN_CAPI
 	default y
 	help
 	  If you say Y here, the kernelcapi driver can make verbose traces
@@ -23,7 +21,7 @@ config CAPI_TRACE
 
 config ISDN_CAPI_MIDDLEWARE
 	bool "CAPI2.0 Middleware support (EXPERIMENTAL)"
-	depends on ISDN_CAPI && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
@@ -33,7 +31,6 @@ config ISDN_CAPI_MIDDLEWARE
 
 config ISDN_CAPI_CAPI20
 	tristate "CAPI2.0 /dev/capi support"
-	depends on ISDN_CAPI
 	help
 	  This option will provide the CAPI 2.0 interface to userspace
 	  applications via /dev/capi20. Applications should use the
@@ -56,7 +53,7 @@ config ISDN_CAPI_CAPIFS
 
 config ISDN_CAPI_CAPIDRV
 	tristate "CAPI2.0 capidrv interface support"
-	depends on ISDN_CAPI && ISDN_I4L
+	depends on ISDN_I4L
 	help
 	  This option provides the glue code to hook up CAPI driven cards to
 	  the legacy isdn4linux link layer.  If you have a card which is
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/Kconfig
@@ -2,7 +2,6 @@
 # ISDN hardware drivers
 #
 comment "CAPI hardware drivers"
-	depends on ISDN_CAPI
 
 source "drivers/isdn/hardware/avm/Kconfig"
 
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/avm/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
@@ -3,7 +3,6 @@
 #
 
 menu "Active AVM cards"
-	depends on ISDN_CAPI!=n
 
 config CAPI_AVM
 	bool "Support AVM cards"
@@ -12,13 +11,13 @@ config CAPI_AVM
 
 config ISDN_DRV_AVMB1_B1ISA
 	tristate "AVM B1 ISA support"
-	depends on CAPI_AVM && ISDN_CAPI && ISA
+	depends on CAPI_AVM && ISA
 	help
 	  Enable support for the ISA version of the AVM B1 card.
 
 config ISDN_DRV_AVMB1_B1PCI
 	tristate "AVM B1 PCI support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the PCI version of the AVM B1 card.
 
@@ -30,14 +29,14 @@ config ISDN_DRV_AVMB1_B1PCIV4
 
 config ISDN_DRV_AVMB1_T1ISA
 	tristate "AVM T1/T1-B ISA support"
-	depends on CAPI_AVM && ISDN_CAPI && ISA
+	depends on CAPI_AVM && ISA
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_B1PCMCIA
 	tristate "AVM B1/M1/M2 PCMCIA support"
-	depends on CAPI_AVM && ISDN_CAPI
+	depends on CAPI_AVM
 	help
 	  Enable support for the PCMCIA version of the AVM B1 card.
 
@@ -50,14 +49,14 @@ config ISDN_DRV_AVMB1_AVM_CS
 
 config ISDN_DRV_AVMB1_T1PCI
 	tristate "AVM T1/T1-B PCI support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_C4
 	tristate "AVM C4/C2 support"
-	depends on CAPI_AVM && ISDN_CAPI && PCI
+	depends on CAPI_AVM && PCI
 	help
 	  Enable support for the AVM C4/C2 PCI cards.
 	  These cards handle 4/2 BRI ISDN lines (8/4 channels).
Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/eicon/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/eicon/Kconfig
@@ -3,7 +3,6 @@
 #
 
 menu "Active Eicon DIVA Server cards"
-	depends on ISDN_CAPI!=n
 
 config CAPI_EICON
 	bool "Support Eicon cards"
@@ -32,7 +31,7 @@ config ISDN_DIVAS_PRIPCI
 
 config ISDN_DIVAS_DIVACAPI
 	tristate "DIVA CAPI2.0 interface support"
-	depends on ISDN_DIVAS && ISDN_CAPI
+	depends on ISDN_DIVAS
 	help
 	  You need this to provide the CAPI interface
 	  for DIVA Server cards.
