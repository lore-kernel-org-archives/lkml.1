Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZFXLhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZFXLhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZFXLgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52523 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZFXLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:17 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 09/20] omapfb: Add support for the Gumstix Overo LCD
Date: Wed, 24 Jun 2009 14:33:34 +0300
Message-Id: <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:04.0675 (UTC) FILETIME=[F5376930:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Sakoman <steve@sakoman.com>

Signed-off-by: Steve Sakoman <steve@sakoman.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/Kconfig     |   21 +++++
 drivers/video/omap/Makefile    |    1 +
 drivers/video/omap/lcd_overo.c |  179 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/omap/lcd_overo.c

diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index 574453f..eb05e09 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -7,6 +7,27 @@ config FB_OMAP
 	help
           Frame buffer driver for OMAP based boards.
 
+choice
+	depends on FB_OMAP && MACH_OVERO
+	prompt "Screen resolution"
+	default FB_OMAP_079M3R
+	help
+	  Selected desired screen resolution
+
+config FB_OMAP_031M3R
+	boolean "640 x 480 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_048M3R
+	boolean "800 x 600 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_079M3R
+	boolean "1024 x 768 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_092M9R
+	boolean "1280 x 720 @ 60 Hz Reduced blanking"
+
+endchoice
+
 config FB_OMAP_LCD_MIPID
 	bool "MIPI DBI-C/DCS compatible LCD support"
 	depends on FB_OMAP && SPI_MASTER
diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index 9ff1815..0d2996a 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -33,6 +33,7 @@ objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_omap2evm.o
 objs-y$(CONFIG_MACH_OMAP3EVM) += lcd_omap3evm.o
 objs-y$(CONFIG_MACH_OMAP3_BEAGLE) += lcd_omap3beagle.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
+objs-y$(CONFIG_MACH_OVERO) += lcd_overo.o
 
 omapfb-objs := $(objs-yy)
 
diff --git a/drivers/video/omap/lcd_overo.c b/drivers/video/omap/lcd_overo.c
new file mode 100644
index 0000000..2bc5c92
--- /dev/null
+++ b/drivers/video/omap/lcd_overo.c
@@ -0,0 +1,179 @@
+/*
+ * LCD panel support for the Gumstix Overo
+ *
+ * Author: Steve Sakoman <steve@sakoman.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/gpio.h>
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+#include <asm/mach-types.h>
+
+#define LCD_ENABLE       144
+
+static int overo_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	if ((gpio_request(LCD_ENABLE, "LCD_ENABLE") == 0) &&
+	    (gpio_direction_output(LCD_ENABLE, 1) == 0))
+		gpio_export(LCD_ENABLE, 0);
+	else
+		printk(KERN_ERR "could not obtain gpio for LCD_ENABLE\n");
+
+	return 0;
+}
+
+static void overo_panel_cleanup(struct lcd_panel *panel)
+{
+	gpio_free(LCD_ENABLE);
+}
+
+static int overo_panel_enable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_ENABLE, 1);
+	return 0;
+}
+
+static void overo_panel_disable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_ENABLE, 0);
+}
+
+static unsigned long overo_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel overo_panel = {
+	.name		= "overo",
+	.config		= OMAP_LCDC_PANEL_TFT,
+	.bpp		= 16,
+	.data_lines	= 24,
+
+#if defined CONFIG_FB_OMAP_031M3R
+
+	/* 640 x 480 @ 60 Hz  Reduced blanking VESA CVT 0.31M3-R */
+	.x_res		= 640,
+	.y_res		= 480,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 7,
+	.pixel_clock	= 23500,
+
+#elif defined CONFIG_FB_OMAP_048M3R
+
+	/* 800 x 600 @ 60 Hz  Reduced blanking VESA CVT 0.48M3-R */
+	.x_res		= 800,
+	.y_res		= 600,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 11,
+	.pixel_clock	= 35500,
+
+#elif defined CONFIG_FB_OMAP_079M3R
+
+	/* 1024 x 768 @ 60 Hz  Reduced blanking VESA CVT 0.79M3-R */
+	.x_res		= 1024,
+	.y_res		= 768,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 15,
+	.pixel_clock	= 56000,
+
+#elif defined CONFIG_FB_OMAP_092M9R
+
+	/* 1280 x 720 @ 60 Hz  Reduced blanking VESA CVT 0.92M9-R */
+	.x_res		= 1280,
+	.y_res		= 720,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 5,
+	.vbp		= 13,
+	.pixel_clock	= 64000,
+
+#else
+
+	/* use 640 x 480 if no config option */
+	/* 640 x 480 @ 60 Hz  Reduced blanking VESA CVT 0.31M3-R */
+	.x_res		= 640,
+	.y_res		= 480,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 7,
+	.pixel_clock	= 23500,
+
+#endif
+
+	.init		= overo_panel_init,
+	.cleanup	= overo_panel_cleanup,
+	.enable		= overo_panel_enable,
+	.disable	= overo_panel_disable,
+	.get_caps	= overo_panel_get_caps,
+};
+
+static int overo_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&overo_panel);
+	return 0;
+}
+
+static int overo_panel_remove(struct platform_device *pdev)
+{
+	/* omapfb does not have unregister_panel */
+	return 0;
+}
+
+static struct platform_driver overo_panel_driver = {
+	.probe		= overo_panel_probe,
+	.remove		= overo_panel_remove,
+	.driver		= {
+		.name	= "overo_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init overo_panel_drv_init(void)
+{
+	return platform_driver_register(&overo_panel_driver);
+}
+
+static void __exit overo_panel_drv_exit(void)
+{
+	platform_driver_unregister(&overo_panel_driver);
+}
+
+module_init(overo_panel_drv_init);
+module_exit(overo_panel_drv_exit);
-- 
1.6.3.2

