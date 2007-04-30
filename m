Return-Path: <linux-kernel-owner+w=401wt.eu-S1161659AbXD3LiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161659AbXD3LiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161543AbXD3LiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:38:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43236 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161657AbXD3LiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:38:03 -0400
Date: Mon, 30 Apr 2007 13:35:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Karsten Keil <kkeil@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai.germaschewski@gmx.de>,
       isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/36] Use menuconfig objects II - ISDN
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301333340.29151@yvahk01.tjqt.qr>
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

In this patch, CONFIG_ISDN is also changed from a tristate to bool,
since no Makefile uses obj-$(CONFIG_ISDN) that could possibly
produce a module out of CONFIG_ISDN. So CONFIG_ISDN=y and
CONFIG_ISDN=m would do the same, in which case only allowing yes/no
seems 'nicer' to me. The submodules in the ISDN menu can still be
built as modules, as usual.

CAUTION: Everyone who has CONFIG_ISDN set to 'm' will get it set to 
'n'(!), so either everyone (including defconfig maintainers) should keep 
an eye open, or I need to come up with a patch that changes kconfig to 
just downgrade m->y in such cases.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/Kconfig |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/isdn/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/isdn/Kconfig
@@ -2,10 +2,8 @@
 # ISDN device configuration
 #
 
-menu "ISDN subsystem"
-
-config ISDN
-	tristate "ISDN support"
+menuconfig ISDN
+	bool "ISDN support"
 	depends on NET
 	---help---
 	  ISDN ("Integrated Services Digital Networks", called RNIS in France)
@@ -20,12 +18,11 @@ config ISDN
 
 	  Select this option if you want your kernel to support ISDN.
 
+if ISDN
 
-menu "Old ISDN4Linux"
-	depends on NET && ISDN
-
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux subsystem"
+	depends on NET
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
@@ -46,14 +43,11 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-endmenu
-
 comment "CAPI subsystem"
-	depends on NET && ISDN
+	depends on NET
 
 config ISDN_CAPI
 	tristate "CAPI2.0 support"
-	depends on ISDN
 	help
 	  This provides the CAPI (Common ISDN Application Programming
 	  Interface, a standard making it easy for programs to access ISDN
@@ -64,5 +58,4 @@ source "drivers/isdn/capi/Kconfig"
 
 source "drivers/isdn/hardware/Kconfig"
 
-endmenu
-
+endif # ISDN
