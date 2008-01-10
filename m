Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYAJQA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYAJQA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYAJQAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:00:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42260 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756136AbYAJQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:00:50 -0500
Date: Thu, 10 Jan 2008 16:00:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: Re: [PATCH 6/6] Build system and MAINTAINERS entry for WM97xx
	touchscreen drivers
Message-ID: <20080110160047.GA811@rakim.wolfsonmicro.main>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Dmitry Torokhov <dtor@mail.ru>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-6-git-send-email-broonie@opensource.wolfsonmicro.com> <20080110154118.GC15361@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110154118.GC15361@uranus.ravnborg.org>
X-Cookie: McDonald's -- Because you're worth it.
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 04:41:18PM +0100, Sam Ravnborg wrote:
> On Thu, Jan 10, 2008 at 11:51:10AM +0000, Mark Brown wrote:

> > +wm97xx-ts-objs := wm97xx-core.o

> Use 
> wm97xx-ts-y := wm97xx-core.o

> > +wm97xx-ts-objs += wm9713.o
> > +endif

> So this becomes:
> wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713) += wm9713.o

> Same for the other two assignments.

Ah, that's much nicer - thanks!  I've made this change in our git tree:

>From 550829a5933d4cf4f667530cdd275faf800d2188 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Nov 2007 22:36:50 +0000
Subject: [PATCH] Build system and MAINTAINERS entry for WM97xx touchscreen drivers

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
---
 MAINTAINERS                        |    9 ++++++
 drivers/input/touchscreen/Kconfig  |   52 ++++++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/Makefile |    7 +++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b4f611c..62131fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4196,6 +4196,15 @@ L:	linux-wireless@vger.kernel.org
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
index fa8442b..89fa468 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -160,6 +160,58 @@ config TOUCHSCREEN_TOUCHRIGHT
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
+config TOUCHSCREEN_WM97XX_PXA
+	tristate "WM97xx PXA accelerated touch"
+	depends on TOUCHSCREEN_WM97XX && ARCH_PXA
+	help
+	  Say Y here for support for streaming mode with WM97xx touchscreens
+	  on systems with PXA2xx series processors.
+
+	  If unsure, say N
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pxa-wm97xx
+
 config TOUCHSCREEN_TOUCHWIN
 	tristate "Touchwin serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 35d4097..ade9dc1 100644
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
+obj-$(CONFIG_TOUCHSCREEN_WM97XX_PXA)	+= pxa-wm97xx.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)  += wm9705.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)  += wm9712.o
+wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)  += wm9713.o
-- 
1.5.3.8
