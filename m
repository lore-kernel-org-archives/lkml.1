Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbXIYG0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbXIYG0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXIYG0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:26:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31394 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXIYG0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:26:06 -0400
Date: Mon, 24 Sep 2007 23:25:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, adaplas@gmail.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH/RFC] video gfx: merge kconfig menus
Message-Id: <20070924232536.b1123359.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some reason that we don't put all video gfx config in one
place?  Is the split just historical, based on subdirectory locations,
or is there a bigger reason for it?

[to apply cleanly, this patch depends on a patch that was sent
to linux-fbdev-devel, which is subscribers-only, so I didn't cc: lkml
on it:  http://marc.info/?l=linux-fbdev-devel&m=119070044232621&w=2]

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Move AGP and DRM menus into the video graphics support menu.
  They use 'menuconfig' so that they can all be disabled with
  one selection.
Make the console menu use 'menuconfig' so that it can all be
  disabled with one selection.
Make the frame buffer menu use 'menuconfig' so that it can all be
  disabled with one selection.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/Kconfig     |    4 ----
 drivers/char/agp/Kconfig |    2 +-
 drivers/char/drm/Kconfig |    2 +-
 drivers/video/Kconfig    |   11 +++++++----
 4 files changed, 9 insertions(+), 10 deletions(-)

--- linux-2.6.23-rc8.orig/drivers/char/Kconfig
+++ linux-2.6.23-rc8/drivers/char/Kconfig
@@ -896,10 +896,6 @@ config GPIO_TB0219
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
-source "drivers/char/agp/Kconfig"
-
-source "drivers/char/drm/Kconfig"
-
 source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
--- linux-2.6.23-rc8.orig/drivers/video/Kconfig
+++ linux-2.6.23-rc8/drivers/video/Kconfig
@@ -5,8 +5,9 @@
 menu "Graphics support"
 	depends on HAS_IOMEM
 
-source "drivers/video/backlight/Kconfig"
-source "drivers/video/display/Kconfig"
+source "drivers/char/agp/Kconfig"
+
+source "drivers/char/drm/Kconfig"
 
 config VGASTATE
        tristate
@@ -19,7 +20,7 @@ config VIDEO_OUTPUT_CONTROL
 	  This framework adds support for low-level control of the video 
 	  output switch.
 
-config FB
+menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
 	  The frame buffer device provides an abstraction for the graphics
@@ -1860,6 +1861,9 @@ if ARCH_OMAP
 	source "drivers/video/omap/Kconfig"
 endif
 
+source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
+
 if VT
 	source "drivers/video/console/Kconfig"
 endif
@@ -1869,4 +1873,3 @@ if FB || SGI_NEWPORT_CONSOLE
 endif
 
 endmenu
-
--- linux-2.6.23-rc8.orig/drivers/char/agp/Kconfig
+++ linux-2.6.23-rc8/drivers/char/agp/Kconfig
@@ -1,4 +1,4 @@
-config AGP
+menuconfig AGP
 	tristate "/dev/agpgart (AGP Support)"
 	depends on ALPHA || IA64 || PARISC || PPC || X86
 	depends on PCI
--- linux-2.6.23-rc8.orig/drivers/char/drm/Kconfig
+++ linux-2.6.23-rc8/drivers/char/drm/Kconfig
@@ -4,7 +4,7 @@
 # This driver provides support for the
 # Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
 #
-config DRM
+menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG
 	help
