Return-Path: <linux-kernel-owner+w=401wt.eu-S1030988AbXD3LZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988AbXD3LZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030994AbXD3LZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:25:54 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54901 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030988AbXD3LZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:25:53 -0400
Date: Mon, 30 Apr 2007 13:24:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Doug Thompson <norsk5@xmission.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH 05/36] Use menuconfig objects II - EDAC
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301323080.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/edac/Kconfig |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/edac/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/edac/Kconfig
@@ -6,10 +6,8 @@
 # $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
 #
 
-menu 'EDAC - error detection and reporting (RAS) (EXPERIMENTAL)'
-
-config EDAC
-	tristate "EDAC core system error reporting (EXPERIMENTAL)"
+menuconfig EDAC
+	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on X86 && EXPERIMENTAL
 	help
 	  EDAC is designed to report errors in the core system.
@@ -29,13 +27,12 @@ config EDAC
 	  There is also a mailing list for the EDAC project, which can
 	  be found via the sourceforge page.
 
+if EDAC
 
 comment "Reporting subsystems"
-	depends on EDAC
 
 config EDAC_DEBUG
 	bool "Debugging"
-	depends on EDAC
 	help
 	  This turns on debugging information for the entire EDAC
 	  sub-system. You can insert module with "debug_level=x", current
@@ -44,7 +41,6 @@ config EDAC_DEBUG
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
-	depends on EDAC
 	default y
 	help
 	  Some systems are able to detect and correct errors in main
@@ -99,15 +95,13 @@ config EDAC_R82600
 
 choice
 	prompt "Error detecting method"
-	depends on EDAC
 	default EDAC_POLL
 
 config EDAC_POLL
 	bool "Poll for errors"
-	depends on EDAC
 	help
 	  Poll the chipset periodically to detect errors.
 
 endchoice
 
-endmenu
+endif # EDAC
