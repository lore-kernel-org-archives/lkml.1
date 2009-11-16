Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZKPSea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZKPSea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZKPSe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:34:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53972 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZKPSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:34:26 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RA5o1EfHuK05SV4aRDJLS
Date: Mon, 16 Nov 2009 10:34:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       ext Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-ID: <20091116183425.GN3684@atomide.com>
References: <20091116160402.deb0cc82.sfr@canb.auug.org.au>
 <1258366001.2384.25.camel@tubuntu.research.nokia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <1258366001.2384.25.camel@tubuntu.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tomi Valkeinen <tomi.valkeinen@nokia.com> [091116 02:06]:
> On Mon, 2009-11-16 at 06:04 +0100, ext Stephen Rothwell wrote:
> > Hi Tomi,
> > 
> > Today's linux-next merge of the omap_dss2 tree got a conflict in
> > arch/arm/configs/omap_3430sdp_defconfig between the omap tree and the
> > omap_dss2 tree.
> > 
> > I just used the version from the omap tree as I can't figure out anything
> > better, sorry.
> 
> Tony, 
> 
> These patches in omap tree seem to cause the conflicts. Are they stable,
> ie. can I cherry pick them to my for-next tree, and put my patches on
> top of them?

Well all the board-*.c patches are still getting shuffled around
this week a bit.. But we can resolve it with the following two changes.
 
> b30dcf5f37023d591caee80c233bf33706bc5a21
> omap3: 3430sdp: Enable Linux Regulator framework

This we should keep as it is, but the commit ID may still change.
 
> fc89f86e06c11b8828ce1d6c669f724877546c03
> ARM: OMAP3: Fix 3430SDP defconfig

I've cut out the CONFIG_FB related sections of this patch in
omap for-next branch, see below.

Tomi, please update your patch by leaving out the now unnecessary
TWL4030 and regulator sections. See also the updated version of
your patch attached.

And please also use the static commit id I gave earlier, the other
patches can still change a bit.

Regards,

Tony

--QKdGvSO+nmPlgiQ/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="sdp3430-defconfig-nofb.patch"

I've left out the CONFIG_FB related parts of
"ARM: OMAP3: Fix 3430SDP defconfig" and renamed
it to "ARM: OMAP3: Update 3430SDP defconfig".

--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -940,11 +940,9 @@ CONFIG_TWL4030_CORE=y
 # Graphics support
 #
 # CONFIG_VGASTATE is not set
-# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 CONFIG_FB=y
 # CONFIG_FIRMWARE_EDID is not set
 # CONFIG_FB_DDC is not set
-# CONFIG_FB_BOOT_VESA_SUPPORT is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
@@ -965,13 +963,8 @@ CONFIG_FB_CFB_IMAGEBLIT=y
 #
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
-# CONFIG_FB_METRONOME is not set
-# CONFIG_FB_MB862XX is not set
-# CONFIG_FB_BROADSHEET is not set
 CONFIG_FB_OMAP=y
-# CONFIG_FB_OMAP_LCD_VGA is not set
 # CONFIG_FB_OMAP_LCDC_EXTERNAL is not set
-# CONFIG_FB_OMAP_LCD_MIPID is not set
 # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
 CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
@@ -979,7 +972,11 @@ CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
 #
 # Display device support
 #
-# CONFIG_DISPLAY_SUPPORT is not set
+CONFIG_DISPLAY_SUPPORT=y
+
+#
+# Display hardware drivers
+#
 
 #
 # Console display driver support

--QKdGvSO+nmPlgiQ/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="tomi-3430sdp-v2.patch"

>From 5fdd839b3fcf292c52fd68b76a6b254436c86c3e Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Wed, 5 Aug 2009 16:07:26 +0300
Subject: [PATCH] OMAP: SDP: Enable DSS2 for OMAP3 SDP board

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/configs/omap_3430sdp_defconfig b/arch/arm/configs/omap_3430sdp_defconfig
index 8a4a7e2..730ada3 100644
--- a/arch/arm/configs/omap_3430sdp_defconfig
+++ b/arch/arm/configs/omap_3430sdp_defconfig
@@ -1336,10 +1338,33 @@ CONFIG_FB_CFB_IMAGEBLIT=y
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
index a2abac9..b697d50 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -37,6 +37,7 @@
 #include <plat/common.h>
 #include <plat/dma.h>
 #include <plat/gpmc.h>
+#include <plat/display.h>
 
 #include <plat/control.h>
 #include <plat/gpmc-smc91x.h>
@@ -152,31 +153,152 @@ static struct spi_board_info sdp3430_spi_board_info[] __initdata = {
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
@@ -392,22 +514,34 @@ static struct regulator_init_data sdp3430_vdac = {
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
@@ -499,6 +633,7 @@ static void __init omap_3430sdp_init(void)
 	omap_serial_init();
 	usb_musb_init();
 	board_smc91x_init();
+	sdp3430_display_init();
 	enable_board_wakeup_source();
 }
 

--QKdGvSO+nmPlgiQ/--
