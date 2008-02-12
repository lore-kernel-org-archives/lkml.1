Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYBLKWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYBLKWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbYBLKVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:21:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48429 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760529AbYBLKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:21:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: [PATCH 6/6] Build system and MAINTAINERS entry for WM97xx touchscreen drivers
Date: Tue, 12 Feb 2008 10:21:45 +0000
Message-Id: <1202811705-2303-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202811705-2303-5-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080212101738.GB21039@rakim.wolfsonmicro.main>
 <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1202811705-2303-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1202811705-2303-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1202811705-2303-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1202811705-2303-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
---
 MAINTAINERS                        |    9 ++++++
 drivers/input/touchscreen/Kconfig  |   52 ++++++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/Makefile |    7 +++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2340cfb..4ad793f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4204,6 +4204,15 @@ L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
 
+WM97XX TOUCHSCREEN DRIVERS
+P:	Mark Brown
+M:	broonie@opensource.wolfsonmicro.com
+P:	Liam Girdwood
+M:	liam.girdwood@wolfsonmicro.com
+L:	linux-input@vger.kernel.org
+T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
+S:	Supported
+
 X.25 NETWORK LAYER
 P:	Henner Eisen
 M:	eis@baty.hanse.de
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 90e8e92..0be05a2 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -158,6 +158,58 @@ config TOUCHSCREEN_TOUCHRIGHT
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchright.
 
+config TOUCHSCREEN_WM97XX
+	tristate "Support for WM97xx AC97 touchscreen controllers"
+	depends on AC97_BUS
+
+config TOUCHSCREEN_WM9705
+	bool "WM9705 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9705 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9705.
+
+config TOUCHSCREEN_WM9712
+	bool "WM9712 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9712 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9712.
+
+config TOUCHSCREEN_WM9713
+	bool "WM9713 Touchscreen interface support"
+	depends on TOUCHSCREEN_WM97XX
+	help
+	  Say Y here if you have a Wolfson Microelectronics WM9713 touchscreen
+	  controller connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wm9713.
+
+config TOUCHSCREEN_WM97XX_MAINSTONE
+	tristate "WM97xx Mainstone accelerated touch"
+	depends on TOUCHSCREEN_WM97XX && ARCH_PXA
+	help
+	  Say Y here for support for streaming mode with WM97xx touchscreens
+	  on Mainstone systems.
+
+	  If unsure, say N
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mainstone-wm97xx
+
 config TOUCHSCREEN_TOUCHWIN
 	tristate "Touchwin serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 35d4097..d38156e 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -4,6 +4,8 @@
 
 # Each configuration option enables a list of files.
 
+wm97xx-ts-y := wm97xx-core.o
+
 obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
@@ -19,3 +21,8 @@ obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
 obj-$(CONFIG_TOUCHSCREEN_UCB1400)	+= ucb1400_ts.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX)	+= wm97xx-ts.o
+obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)  += wm9705.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)  += wm9712.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)  += wm9713.o
-- 
1.5.4

