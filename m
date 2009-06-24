Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZFXLgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZFXLgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZFXLgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:10 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58132 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFXLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:08 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 01/20] omapfb: Add support for the Apollon LCD
Date: Wed, 24 Jun 2009 14:33:26 +0300
Message-Id: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:35:50.0857 (UTC) FILETIME=[ECFAF390:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/Makefile      |    2 +
 drivers/video/omap/lcd_apollon.c |  138 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/omap/lcd_apollon.c

diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index ed13889..d053498 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -24,5 +24,7 @@ objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
 objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
 objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
 
+objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
+
 omapfb-objs := $(objs-yy)
 
diff --git a/drivers/video/omap/lcd_apollon.c b/drivers/video/omap/lcd_apollon.c
new file mode 100644
index 0000000..626ae3a
--- /dev/null
+++ b/drivers/video/omap/lcd_apollon.c
@@ -0,0 +1,138 @@
+/*
+ * LCD panel support for the Samsung OMAP2 Apollon board
+ *
+ * Copyright (C) 2005,2006 Samsung Electronics
+ * Author: Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * Derived from drivers/video/omap/lcd-h4.c
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
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <mach/gpio.h>
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+
+/* #define USE_35INCH_LCD 1 */
+
+static int apollon_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	/* configure LCD PWR_EN */
+	omap_cfg_reg(M21_242X_GPIO11);
+	return 0;
+}
+
+static void apollon_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int apollon_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void apollon_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long apollon_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel apollon_panel = {
+	.name		= "apollon",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			  OMAP_LCDC_INV_HSYNC,
+
+	.bpp		= 16,
+	.data_lines	= 18,
+#ifdef USE_35INCH_LCD
+	.x_res		= 240,
+	.y_res		= 320,
+	.hsw		= 2,
+	.hfp		= 3,
+	.hbp		= 9,
+	.vsw		= 4,
+	.vfp		= 3,
+	.vbp		= 5,
+#else
+	.x_res		= 480,
+	.y_res		= 272,
+	.hsw		= 41,
+	.hfp		= 2,
+	.hbp		= 2,
+	.vsw		= 10,
+	.vfp		= 2,
+	.vbp		= 2,
+#endif
+	.pixel_clock	= 6250,
+
+	.init		= apollon_panel_init,
+	.cleanup	= apollon_panel_cleanup,
+	.enable		= apollon_panel_enable,
+	.disable	= apollon_panel_disable,
+	.get_caps	= apollon_panel_get_caps,
+};
+
+static int apollon_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&apollon_panel);
+	return 0;
+}
+
+static int apollon_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int apollon_panel_suspend(struct platform_device *pdev,
+				  pm_message_t mesg)
+{
+	return 0;
+}
+
+static int apollon_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver apollon_panel_driver = {
+	.probe		= apollon_panel_probe,
+	.remove		= apollon_panel_remove,
+	.suspend	= apollon_panel_suspend,
+	.resume		= apollon_panel_resume,
+	.driver		= {
+		.name	= "apollon_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init apollon_panel_drv_init(void)
+{
+	return platform_driver_register(&apollon_panel_driver);
+}
+
+static void __exit apollon_panel_drv_exit(void)
+{
+	platform_driver_unregister(&apollon_panel_driver);
+}
+
+module_init(apollon_panel_drv_init);
+module_exit(apollon_panel_drv_exit);
-- 
1.6.3.2

