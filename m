Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbZFXLit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbZFXLit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFXLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52691 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbZFXLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:34 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 06/20] omapfb: Add support for the 3430SDP LCD
Date: Wed, 24 Jun 2009 14:33:31 +0300
Message-Id: <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:01.0810 (UTC) FILETIME=[F3823F20:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@mvista.com>

The 3430SDP uses the same panel as the 2430SDP.  The main difference
are in the GPIO lines used for panel enable and backlight, and the
VAUX register/commands sent to the TWL4030 power subsystem.

Also, some misc. whitespace cleanups.

Fixed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kevin Hilman <khilman@mvsita.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 arch/arm/configs/omap_3430sdp_defconfig |   39 +++++++++++++++++++++++++++++-
 drivers/video/omap/Makefile             |    2 +
 drivers/video/omap/lcd_2430sdp.c        |   12 ++++++---
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/arm/configs/omap_3430sdp_defconfig b/arch/arm/configs/omap_3430sdp_defconfig
index 8fb918d..73e0128 100644
--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -1313,8 +1313,33 @@ CONFIG_DVB_ISL6421=m
 # Graphics support
 #
 # CONFIG_VGASTATE is not set
-# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
@@ -1331,6 +1356,16 @@ CONFIG_DISPLAY_SUPPORT=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+CONFIG_LOGO=y
+CONFIG_LOGO_LINUX_MONO=y
+CONFIG_LOGO_LINUX_VGA16=y
+CONFIG_LOGO_LINUX_CLUT224=y
 CONFIG_SOUND=y
 CONFIG_SOUND_OSS_CORE=y
 CONFIG_SND=y
diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index c2475e3..96d2d43 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -8,6 +8,7 @@ objs-yy := omapfb_main.o
 
 objs-y$(CONFIG_ARCH_OMAP1) += lcdc.o
 objs-y$(CONFIG_ARCH_OMAP2) += dispc.o
+objs-y$(CONFIG_ARCH_OMAP3) += dispc.o
 
 objs-$(CONFIG_ARCH_OMAP1)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += sossi.o
 objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += rfbi.o
@@ -27,6 +28,7 @@ objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
 
 objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
 objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd_2430sdp.o
+objs-y$(CONFIG_MACH_OMAP_3430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_omap2evm.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
 
diff --git a/drivers/video/omap/lcd_2430sdp.c b/drivers/video/omap/lcd_2430sdp.c
index 284cfce..393712b 100644
--- a/drivers/video/omap/lcd_2430sdp.c
+++ b/drivers/video/omap/lcd_2430sdp.c
@@ -39,13 +39,17 @@
 static unsigned backlight_gpio;
 static unsigned enable_gpio;
 
-#define LCD_PANEL_BACKLIGHT_GPIO	91
-#define LCD_PANEL_ENABLE_GPIO		154
 #define LCD_PIXCLOCK_MAX		5400 /* freq 5.4 MHz */
 #define PM_RECEIVER             TWL4030_MODULE_PM_RECEIVER
 #define ENABLE_VAUX2_DEDICATED  0x09
 #define ENABLE_VAUX2_DEV_GRP    0x20
+#define ENABLE_VAUX3_DEDICATED	0x03
+#define ENABLE_VAUX3_DEV_GRP	0x20
 
+#define ENABLE_VPLL2_DEDICATED          0x05
+#define ENABLE_VPLL2_DEV_GRP            0xE0
+#define TWL4030_VPLL2_DEV_GRP           0x33
+#define TWL4030_VPLL2_DEDICATED         0x36
 
 #define t2_out(c, r, v) twl4030_i2c_write_u8(c, r, v)
 
@@ -146,7 +150,7 @@ struct lcd_panel sdp2430_panel = {
 
 	.init		= sdp2430_panel_init,
 	.cleanup	= sdp2430_panel_cleanup,
-	.enable	= sdp2430_panel_enable,
+	.enable		= sdp2430_panel_enable,
 	.disable	= sdp2430_panel_disable,
 	.get_caps	= sdp2430_panel_get_caps,
 };
@@ -176,7 +180,7 @@ static int sdp2430_panel_resume(struct platform_device *pdev)
 struct platform_driver sdp2430_panel_driver = {
 	.probe		= sdp2430_panel_probe,
 	.remove		= sdp2430_panel_remove,
-	.suspend		= sdp2430_panel_suspend,
+	.suspend	= sdp2430_panel_suspend,
 	.resume		= sdp2430_panel_resume,
 	.driver		= {
 		.name	= "sdp2430_lcd",
-- 
1.6.3.2

