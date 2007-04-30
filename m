Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXD3MbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXD3MbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbXD3MbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:31:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41727 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbXD3MbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:31:12 -0400
Date: Mon, 30 Apr 2007 14:30:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 35/36] Use menuconfig objects II - DVB
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>
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

Also remove one indirection (CONFIG_DVB) that does not seem to
be really used inside the kernel.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/media/Makefile             |    2 +-
 drivers/media/dvb/Kconfig          |   19 -------------------
 drivers/media/dvb/dvb-core/Kconfig |   16 +++++++++++++---
 3 files changed, 14 insertions(+), 23 deletions(-)

Index: linux-2.6.21-mm_20070428/drivers/media/Makefile
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/Makefile
+++ linux-2.6.21-mm_20070428/drivers/media/Makefile
@@ -5,4 +5,4 @@
 obj-y := common/
 obj-$(CONFIG_VIDEO_DEV) += video/
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB)       += dvb/
+obj-$(CONFIG_DVB_CORE)  += dvb/
Index: linux-2.6.21-mm_20070428/drivers/media/dvb/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/dvb/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/dvb/Kconfig
@@ -2,23 +2,6 @@
 # Multimedia device configuration
 #
 
-menu "Digital Video Broadcasting Devices"
-
-config DVB
-	bool "DVB For Linux"
-	depends on NET && INET
-	---help---
-	  Support Digital Video Broadcasting hardware.  Enable this if you
-	  own a DVB adapter and want to use it or if you compile Linux for
-	  a digital SetTopBox.
-
-	  API specs and user tools are available from <http://www.linuxtv.org/>.
-
-	  Please report problems regarding this driver to the LinuxDVB
-	  mailing list.
-
-	  If unsure say N.
-
 source "drivers/media/dvb/dvb-core/Kconfig"
 
 comment "Supported SAA7146 based PCI Adapters"
@@ -47,5 +30,3 @@ source "drivers/media/dvb/pluto2/Kconfig
 comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
-
-endmenu
Index: linux-2.6.21-mm_20070428/drivers/media/dvb/dvb-core/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/dvb/dvb-core/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/dvb/dvb-core/Kconfig
@@ -1,12 +1,22 @@
-config DVB_CORE
-	tristate "DVB Core Support"
-	depends on DVB
+menuconfig DVB_CORE
+	tristate "DVB for Linux"
+	depends on NET && INET
 	select CRC32
 	help
+	  Support Digital Video Broadcasting hardware.  Enable this if you
+	  own a DVB adapter and want to use it or if you compile Linux for
+	  a digital SetTopBox.
+
 	  DVB core utility functions for device handling, software fallbacks etc.
 	  Say Y when you have a DVB card and want to use it. Say Y if your want
 	  to build your drivers outside the kernel, but need the DVB core. All
 	  in-kernel drivers will select this automatically if needed.
+
+	  API specs and user tools are available from <http://www.linuxtv.org/>.
+
+	  Please report problems regarding this driver to the LinuxDVB
+	  mailing list.
+
 	  If unsure say N.
 
 config DVB_CORE_ATTACH
