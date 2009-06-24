Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbZFXLjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbZFXLjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZFXLgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52709 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbZFXLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:39 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 08/20] omapfb: Add support for the OMAP3 Beagle DVI output
Date: Wed, 24 Jun 2009 14:33:33 +0300
Message-Id: <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:05.0144 (UTC) FILETIME=[F57EF980:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Koen Kooi <koen@openembedded.org>

The default resolution is 1024x768@24bit

This version addresses the comments from Felipe Balbi adn Arun Edarath

Fixed-by: Felipe Contreras <felipe.contreras@gmail.com>
Fixed-by: Steve Sakoman <steve@sakoman.com>
Fixed-by: Jarkko Nikula <jarkko.nikula@gmail.com>
Fixed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Koen Kooi <koen@openembedded.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 arch/arm/configs/omap3_beagle_defconfig |   47 +++++++++++-
 drivers/video/omap/Makefile             |    1 +
 drivers/video/omap/lcd_omap3beagle.c    |  130 +++++++++++++++++++++++++++++++
 3 files changed, 177 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/omap/lcd_omap3beagle.c

diff --git a/arch/arm/configs/omap3_beagle_defconfig b/arch/arm/configs/omap3_beagle_defconfig
index 4c6fb7e..c4726f0 100644
--- a/arch/arm/configs/omap3_beagle_defconfig
+++ b/arch/arm/configs/omap3_beagle_defconfig
@@ -769,7 +769,33 @@ CONFIG_DAB=y
 #
 # CONFIG_VGASTATE is not set
 # CONFIG_VIDEO_OUTPUT_CONTROL is not set
-# CONFIG_FB is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_FOREIGN_ENDIAN is not set
+# CONFIG_FB_SYS_FOPS is not set
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_VIRTUAL is not set
+CONFIG_FB_OMAP=y
+# CONFIG_FB_OMAP_LCDC_EXTERNAL is not set
+# CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
+CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -782,6 +808,25 @@ CONFIG_DAB=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+# CONFIG_FONT_6x11 is not set
+# CONFIG_FONT_7x14 is not set
+# CONFIG_FONT_PEARL_8x8 is not set
+# CONFIG_FONT_ACORN_8x8 is not set
+# CONFIG_FONT_MINI_4x6 is not set
+# CONFIG_FONT_SUN8x16 is not set
+# CONFIG_FONT_SUN12x22 is not set
+# CONFIG_FONT_10x18 is not set
+# CONFIG_LOGO is not set
+
+#
+# Sound
+#
 # CONFIG_SOUND is not set
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB_SUPPORT=y
diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index 4345157..9ff1815 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -31,6 +31,7 @@ objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_MACH_OMAP_3430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_omap2evm.o
 objs-y$(CONFIG_MACH_OMAP3EVM) += lcd_omap3evm.o
+objs-y$(CONFIG_MACH_OMAP3_BEAGLE) += lcd_omap3beagle.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
 
 omapfb-objs := $(objs-yy)
diff --git a/drivers/video/omap/lcd_omap3beagle.c b/drivers/video/omap/lcd_omap3beagle.c
new file mode 100644
index 0000000..4011910
--- /dev/null
+++ b/drivers/video/omap/lcd_omap3beagle.c
@@ -0,0 +1,130 @@
+/*
+ * LCD panel support for the TI OMAP3 Beagle board
+ *
+ * Author: Koen Kooi <koen@openembedded.org>
+ *
+ * Derived from drivers/video/omap/lcd-omap3evm.c
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
+#include <linux/gpio.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+#include <asm/mach-types.h>
+
+#define LCD_PANEL_ENABLE_GPIO       170
+
+static int omap3beagle_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	gpio_request(LCD_PANEL_ENABLE_GPIO, "LCD enable");
+	return 0;
+}
+
+static void omap3beagle_panel_cleanup(struct lcd_panel *panel)
+{
+	gpio_free(LCD_PANEL_ENABLE_GPIO);
+}
+
+static int omap3beagle_panel_enable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_PANEL_ENABLE_GPIO, 1);
+	return 0;
+}
+
+static void omap3beagle_panel_disable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_PANEL_ENABLE_GPIO, 0);
+}
+
+static unsigned long omap3beagle_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel omap3beagle_panel = {
+	.name		= "omap3beagle",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.bpp		= 16,
+	.data_lines	= 24,
+	.x_res		= 1024,
+	.y_res		= 768,
+	.hsw		= 3,		/* hsync_len (4) - 1 */
+	.hfp		= 3,		/* right_margin (4) - 1 */
+	.hbp		= 39,		/* left_margin (40) - 1 */
+	.vsw		= 1,		/* vsync_len (2) - 1 */
+	.vfp		= 2,		/* lower_margin */
+	.vbp		= 7,		/* upper_margin (8) - 1 */
+
+	.pixel_clock	= 64000,
+
+	.init		= omap3beagle_panel_init,
+	.cleanup	= omap3beagle_panel_cleanup,
+	.enable		= omap3beagle_panel_enable,
+	.disable	= omap3beagle_panel_disable,
+	.get_caps	= omap3beagle_panel_get_caps,
+};
+
+static int omap3beagle_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&omap3beagle_panel);
+	return 0;
+}
+
+static int omap3beagle_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int omap3beagle_panel_suspend(struct platform_device *pdev,
+				   pm_message_t mesg)
+{
+	return 0;
+}
+
+static int omap3beagle_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver omap3beagle_panel_driver = {
+	.probe		= omap3beagle_panel_probe,
+	.remove		= omap3beagle_panel_remove,
+	.suspend	= omap3beagle_panel_suspend,
+	.resume		= omap3beagle_panel_resume,
+	.driver		= {
+		.name	= "omap3beagle_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init omap3beagle_panel_drv_init(void)
+{
+	return platform_driver_register(&omap3beagle_panel_driver);
+}
+
+static void __exit omap3beagle_panel_drv_exit(void)
+{
+	platform_driver_unregister(&omap3beagle_panel_driver);
+}
+
+module_init(omap3beagle_panel_drv_init);
+module_exit(omap3beagle_panel_drv_exit);
-- 
1.6.3.2

