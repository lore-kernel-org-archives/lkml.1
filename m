Return-Path: <linux-kernel-owner+w=401wt.eu-S1031538AbXD3L5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031538AbXD3L5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031525AbXD3L5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:57:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60979 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031514AbXD3L5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:57:04 -0400
Date: Mon, 30 Apr 2007 13:56:17 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Antonino Daplas <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 33/36] Use menuconfig objects II - video/logo
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301355430.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/video/logo/Kconfig |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/video/logo/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/video/logo/Kconfig
@@ -2,73 +2,69 @@
 # Logo configuration
 #
 
-menu "Logo configuration"
-
-config LOGO
+menuconfig LOGO
 	bool "Bootup logo"
 	depends on FB || SGI_NEWPORT_CONSOLE
 	help
 	  Enable and select frame buffer bootup logos.
 
+if LOGO
+
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_LINUX_VGA16
 	bool "Standard 16-color Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_LINUX_CLUT224
 	bool "Standard 224-color Linux logo"
-	depends on LOGO
 	default y
 
 config LOGO_DEC_CLUT224
 	bool "224-color Digital Equipment Corporation Linux logo"
-	depends on LOGO && (MACH_DECSTATION || ALPHA)
+	depends on MACH_DECSTATION || ALPHA
 	default y
 
 config LOGO_MAC_CLUT224
 	bool "224-color Macintosh Linux logo"
-	depends on LOGO && MAC
+	depends on MAC
 	default y
 
 config LOGO_PARISC_CLUT224
 	bool "224-color PA-RISC Linux logo"
-	depends on LOGO && PARISC
+	depends on PARISC
 	default y
 
 config LOGO_SGI_CLUT224
 	bool "224-color SGI Linux logo"
-	depends on LOGO && (SGI_IP22 || SGI_IP27 || SGI_IP32 || X86_VISWS)
+	depends on SGI_IP22 || SGI_IP27 || SGI_IP32 || X86_VISWS
 	default y
 
 config LOGO_SUN_CLUT224
 	bool "224-color Sun Linux logo"
-	depends on LOGO && SPARC
+	depends on SPARC
 	default y
 
 config LOGO_SUPERH_MONO
 	bool "Black and white SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_SUPERH_VGA16
 	bool "16-color SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_SUPERH_CLUT224
 	bool "224-color SuperH Linux logo"
-	depends on LOGO && SUPERH
+	depends on SUPERH
 	default y
 
 config LOGO_M32R_CLUT224
 	bool "224-color M32R Linux logo"
-	depends on LOGO && M32R
+	depends on M32R
 	default y
 
-endmenu
-
+endif # LOGO
