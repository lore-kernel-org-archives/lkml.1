Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZIXL63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZIXL63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZIXL60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:58:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17994 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZIXL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:57:25 -0400
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 18/19] OMAP: SDP: Enable DSS2 for OMAP3 SDP board
Date: Thu, 24 Sep 2009 14:56:23 +0300
Message-Id: <1253793384-31158-19-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1253793384-31158-18-git-send-email-tomi.valkeinen@nokia.com>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-2-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-3-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-4-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-5-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-6-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-7-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-8-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-9-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-10-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-11-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-12-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-13-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-14-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-15-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-16-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-17-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-18-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 24 Sep 2009 11:56:52.0342 (UTC) FILETIME=[1AE34960:01CA3D0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/configs/omap_3430sdp_defconfig |   29 +++++-
 arch/arm/mach-omap2/board-3430sdp.c     |  167 ++++++++++++++++++++++++++++---
 2 files changed, 177 insertions(+), 19 deletions(-)

diff --git a/arch/arm/configs/omap_3430sdp_defconfig b/arch/arm/configs/omap_3430sdp_defconfig
index 8a4a7e2..59e26e4 100644
--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -1336,10 +1336,33 @@ CONFIG_FB_CFB_IMAGEBLIT=y
 #
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
-CONFIG_FB_OMAP=y
-# CONFIG_FB_OMAP_LCDC_EXTERNAL is not set
+# CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
+# CONFIG_FB_BROADSHEET is not set
+# CONFIG_FB_OMAP_LCD_VGA is not set
 # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
-CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
+CONFIG_OMAP2_VRAM=y
+CONFIG_OMAP2_VRFB=y
+CONFIG_OMAP2_DSS=y
+CONFIG_OMAP2_VRAM_SIZE=4
+CONFIG_OMAP2_DSS_DEBUG_SUPPORT=y
+# CONFIG_OMAP2_DSS_RFBI is not set
+CONFIG_OMAP2_DSS_VENC=y
+# CONFIG_OMAP2_DSS_SDI is not set
+# CONFIG_OMAP2_DSS_DSI is not set
+# CONFIG_OMAP2_DSS_FAKE_VSYNC is not set
+CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=0
+CONFIG_FB_OMAP2=y
+CONFIG_FB_OMAP2_DEBUG_SUPPORT=y
+# CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE is not set
+CONFIG_FB_OMAP2_NUM_FBS=3
+
+#
+# OMAP2/3 Display Device Drivers
+#
+CONFIG_PANEL_GENERIC=y
+# CONFIG_PANEL_SAMSUNG_LTE430WQ_F0C is not set
+CONFIG_PANEL_SHARP_LS037V7DW01=y
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index bd57ec7..f5af39a 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -36,6 +36,7 @@
 #include <mach/common.h>
 #include <mach/dma.h>
 #include <mach/gpmc.h>
+#include <mach/display.h>
 
 #include <mach/control.h>
 #include <mach/keypad.h>
@@ -148,31 +149,152 @@ static struct spi_board_info sdp3430_spi_board_info[] __initdata = {
 	},
 };
 
-static struct platform_device sdp3430_lcd_device = {
-	.name		= "sdp2430_lcd",
-	.id		= -1,
+
+#define SDP3430_LCD_PANEL_BACKLIGHT_GPIO	8
+#define SDP3430_LCD_PANEL_ENABLE_GPIO		5
+
+static unsigned backlight_gpio;
+static unsigned enable_gpio;
+static int lcd_enabled;
+static int dvi_enabled;
+
+static void __init sdp3430_display_init(void)
+{
+	int r;
+
+	enable_gpio    = SDP3430_LCD_PANEL_ENABLE_GPIO;
+	backlight_gpio = SDP3430_LCD_PANEL_BACKLIGHT_GPIO;
+
+	r = gpio_request(enable_gpio, "LCD reset");
+	if (r) {
+		printk(KERN_ERR "failed to get LCD reset GPIO\n");
+		goto err0;
+	}
+
+	r = gpio_request(backlight_gpio, "LCD Backlight");
+	if (r) {
+		printk(KERN_ERR "failed to get LCD backlight GPIO\n");
+		goto err1;
+	}
+
+	gpio_direction_output(enable_gpio, 0);
+	gpio_direction_output(backlight_gpio, 0);
+
+	return;
+err1:
+	gpio_free(enable_gpio);
+err0:
+	return;
+}
+
+static int sdp3430_panel_enable_lcd(struct omap_dss_device *dssdev)
+{
+	if (dvi_enabled) {
+		printk(KERN_ERR "cannot enable LCD, DVI is enabled\n");
+		return -EINVAL;
+	}
+
+	gpio_direction_output(enable_gpio, 1);
+	gpio_direction_output(backlight_gpio, 1);
+
+	lcd_enabled = 1;
+
+	return 0;
+}
+
+static void sdp3430_panel_disable_lcd(struct omap_dss_device *dssdev)
+{
+	lcd_enabled = 0;
+
+	gpio_direction_output(enable_gpio, 0);
+	gpio_direction_output(backlight_gpio, 0);
+}
+
+static int sdp3430_panel_enable_dvi(struct omap_dss_device *dssdev)
+{
+	if (lcd_enabled) {
+		printk(KERN_ERR "cannot enable DVI, LCD is enabled\n");
+		return -EINVAL;
+	}
+
+	dvi_enabled = 1;
+
+	return 0;
+}
+
+static void sdp3430_panel_disable_dvi(struct omap_dss_device *dssdev)
+{
+	dvi_enabled = 0;
+}
+
+static int sdp3430_panel_enable_tv(struct omap_dss_device *dssdev)
+{
+	return 0;
+}
+
+static void sdp3430_panel_disable_tv(struct omap_dss_device *dssdev)
+{
+}
+
+
+static struct omap_dss_device sdp3430_lcd_device = {
+	.name			= "lcd",
+	.driver_name		= "sharp_ls_panel",
+	.type			= OMAP_DISPLAY_TYPE_DPI,
+	.phy.dpi.data_lines	= 16,
+	.platform_enable	= sdp3430_panel_enable_lcd,
+	.platform_disable	= sdp3430_panel_disable_lcd,
 };
 
-static struct regulator_consumer_supply sdp3430_vdac_supply = {
-	.supply		= "vdac",
-	.dev		= &sdp3430_lcd_device.dev,
+static struct omap_dss_device sdp3430_dvi_device = {
+	.name			= "dvi",
+	.driver_name		= "generic_panel",
+	.type			= OMAP_DISPLAY_TYPE_DPI,
+	.phy.dpi.data_lines	= 24,
+	.platform_enable	= sdp3430_panel_enable_dvi,
+	.platform_disable	= sdp3430_panel_disable_dvi,
 };
 
-static struct regulator_consumer_supply sdp3430_vdvi_supply = {
-	.supply		= "vdvi",
-	.dev		= &sdp3430_lcd_device.dev,
+static struct omap_dss_device sdp3430_tv_device = {
+	.name			= "tv",
+	.driver_name		= "venc",
+	.type			= OMAP_DISPLAY_TYPE_VENC,
+	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
+	.platform_enable	= sdp3430_panel_enable_tv,
+	.platform_disable	= sdp3430_panel_disable_tv,
 };
 
-static struct platform_device *sdp3430_devices[] __initdata = {
+
+static struct omap_dss_device *sdp3430_dss_devices[] = {
 	&sdp3430_lcd_device,
+	&sdp3430_dvi_device,
+	&sdp3430_tv_device,
 };
 
-static struct omap_lcd_config sdp3430_lcd_config __initdata = {
-	.ctrl_name	= "internal",
+static struct omap_dss_board_info sdp3430_dss_data = {
+	.num_devices	= ARRAY_SIZE(sdp3430_dss_devices),
+	.devices	= sdp3430_dss_devices,
+	.default_device	= &sdp3430_lcd_device,
+};
+
+static struct platform_device sdp3430_dss_device = {
+	.name		= "omapdss",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &sdp3430_dss_data,
+	},
+};
+
+static struct regulator_consumer_supply sdp3430_vdda_dac_supply = {
+	.supply		= "vdda_dac",
+	.dev		= &sdp3430_dss_device.dev,
+};
+
+static struct platform_device *sdp3430_devices[] __initdata = {
+	&sdp3430_dss_device,
 };
 
 static struct omap_board_config_kernel sdp3430_config[] __initdata = {
-	{ OMAP_TAG_LCD,		&sdp3430_lcd_config },
 };
 
 static void __init omap_3430sdp_init_irq(void)
@@ -388,22 +510,34 @@ static struct regulator_init_data sdp3430_vdac = {
 					| REGULATOR_CHANGE_STATUS,
 	},
 	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &sdp3430_vdac_supply,
+	.consumer_supplies	= &sdp3430_vdda_dac_supply,
 };
 
 /* VPLL2 for digital video outputs */
+static struct regulator_consumer_supply sdp3430_vpll2_supplies[] = {
+	{
+		.supply		= "vdvi",
+		.dev		= &sdp3430_lcd_device.dev,
+	},
+	{
+		.supply		= "vdds_dsi",
+		.dev		= &sdp3430_dss_device.dev,
+	}
+};
+
 static struct regulator_init_data sdp3430_vpll2 = {
 	.constraints = {
 		.name			= "VDVI",
 		.min_uV			= 1800000,
 		.max_uV			= 1800000,
+		.apply_uV		= true,
 		.valid_modes_mask	= REGULATOR_MODE_NORMAL
 					| REGULATOR_MODE_STANDBY,
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
-	.num_consumer_supplies	= 1,
-	.consumer_supplies	= &sdp3430_vdvi_supply,
+	.num_consumer_supplies	= ARRAY_SIZE(sdp3430_vpll2_supplies),
+	.consumer_supplies	= sdp3430_vpll2_supplies,
 };
 
 static struct twl4030_platform_data sdp3430_twldata = {
@@ -495,6 +629,7 @@ static void __init omap_3430sdp_init(void)
 	omap_serial_init();
 	usb_musb_init();
 	board_smc91x_init();
+	sdp3430_display_init();
 	enable_board_wakeup_source();
 }
 
-- 
1.6.4

