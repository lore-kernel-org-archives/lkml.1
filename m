Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbXDDSKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbXDDSKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXDDSKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:10:01 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37705 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDDSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:54 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 40/90] ARM: OMAP: Sync board specific files with linux-omap
Date: Wed,  4 Apr 2007 14:05:19 -0400
Message-Id: <11757100781275-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100752021-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs omap board specific files with linux-omap.

Patch consists mostly of driver updates done in linux-omap
tree for drivers not yet in mainline kernel.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |   59 +++++++-----
 arch/arm/mach-omap1/board-h2.c        |   79 ++++++++++++++
 arch/arm/mach-omap1/board-h3.c        |   41 ++++++++
 arch/arm/mach-omap1/board-nokia770.c  |   53 ++++++++--
 arch/arm/mach-omap1/board-osk.c       |    1 +
 arch/arm/mach-omap1/board-palmte.c    |  123 ----------------------
 arch/arm/mach-omap1/board-palmtt.c    |    4 +-
 arch/arm/mach-omap1/board-palmz71.c   |   14 ++--
 arch/arm/mach-omap1/board-voiceblue.c |    2 +-
 arch/arm/mach-omap2/board-h4.c        |  180 +++++++++++++++++++++++++++++++--
 10 files changed, 380 insertions(+), 176 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index fa2da74..c73ca61 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -34,20 +34,20 @@ static u8 ams_delta_latch1_reg;
 static u16 ams_delta_latch2_reg;
 
 static int ams_delta_keymap[] = {
-	KEY(0, 0, KEY_F1),	/* Advert	*/
+	KEY(0, 0, KEY_F1),		/* Advert    */
 
-	KEY(3, 0, KEY_COFFEE),	/* Games	 */
+	KEY(3, 0, KEY_COFFEE),		/* Games     */
 	KEY(2, 0, KEY_QUESTION),	/* Directory */
-	KEY(3, 2, KEY_CONNECT),	/* Internet  */
-	KEY(2, 1, KEY_SHOP),	/* Services  */
-	KEY(1, 1, KEY_PHONE),	/* VoiceMail */
+	KEY(3, 2, KEY_CONNECT),		/* Internet  */
+	KEY(2, 1, KEY_SHOP),		/* Services  */
+	KEY(1, 1, KEY_PHONE),		/* VoiceMail */
 
-	KEY(1, 0, KEY_DELETE),	/* Delete	*/
-	KEY(2, 2, KEY_PLAY),	/* Play	  */
-	KEY(0, 1, KEY_PAGEUP),	/* Up	*/
-	KEY(3, 1, KEY_PAGEDOWN),	/* Down	  */
-	KEY(0, 2, KEY_EMAIL),	/* ReadEmail */
-	KEY(1, 2, KEY_STOP),	/* Stop	  */
+	KEY(1, 0, KEY_DELETE),		/* Delete    */
+	KEY(2, 2, KEY_PLAY),		/* Play      */
+	KEY(0, 1, KEY_PAGEUP),		/* Up        */
+	KEY(3, 1, KEY_PAGEDOWN),	/* Down      */
+	KEY(0, 2, KEY_EMAIL),		/* ReadEmail */
+	KEY(1, 2, KEY_STOP),		/* Stop      */
 
 	/* Numeric keypad portion */
 	KEY(7, 0, KEY_KP1),
@@ -61,20 +61,20 @@ static int ams_delta_keymap[] = {
 	KEY(5, 2, KEY_KP9),
 	KEY(6, 3, KEY_KP0),
 	KEY(7, 3, KEY_KPASTERISK),
-	KEY(5, 3, KEY_KPDOT),	/* # key	 */
-	KEY(2, 7, KEY_NUMLOCK),	/* Mute	  */
-	KEY(1, 7, KEY_KPMINUS),	/* Recall	*/
-	KEY(1, 6, KEY_KPPLUS),	/* Redial	*/
-	KEY(6, 7, KEY_KPSLASH),	/* Handsfree */
-	KEY(0, 6, KEY_ENTER),	/* Video	 */
+	KEY(5, 3, KEY_KPDOT),		/* # key     */
+	KEY(2, 7, KEY_NUMLOCK),		/* Mute      */
+	KEY(1, 7, KEY_KPMINUS),		/* Recall    */
+	KEY(1, 6, KEY_KPPLUS),		/* Redial    */
+	KEY(6, 7, KEY_KPSLASH),		/* Handsfree */
+	KEY(0, 6, KEY_ENTER),		/* Video     */
 
-	KEY(4, 7, KEY_CAMERA),	/* Photo	 */
+	KEY(4, 7, KEY_CAMERA),		/* Photo     */
 
-	KEY(4, 0, KEY_F2),	/* Home	  */
-	KEY(4, 1, KEY_F3),	/* Office	*/
-	KEY(4, 2, KEY_F4),	/* Mobile	*/
-	KEY(7, 7, KEY_F5),	/* SMS		*/
-	KEY(5, 7, KEY_F6),	/* Email	 */
+	KEY(4, 0, KEY_F2),		/* Home      */
+	KEY(4, 1, KEY_F3),		/* Office    */
+	KEY(4, 2, KEY_F4),		/* Mobile    */
+	KEY(7, 7, KEY_F5),		/* SMS       */
+	KEY(5, 7, KEY_F6),		/* Email     */
 
 	/* QWERTY portion of keypad */
 	KEY(4, 3, KEY_Q),
@@ -107,7 +107,7 @@ static int ams_delta_keymap[] = {
 	KEY(3, 6, KEY_M),
 	KEY(2, 6, KEY_SPACE),
 
-	KEY(0, 7, KEY_LEFTSHIFT),	/* Vol up	*/
+	KEY(0, 7, KEY_LEFTSHIFT),	/* Vol up    */
 	KEY(3, 7, KEY_LEFTCTRL),	/* Vol down  */
 
 	0
@@ -158,6 +158,10 @@ static struct map_desc ams_delta_io_desc[] __initdata = {
 	}
 };
 
+static struct omap_lcd_config ams_delta_lcd_config __initdata = {
+	.ctrl_name	= "internal",
+};
+
 static struct omap_uart_config ams_delta_uart_config __initdata = {
 	.enabled_uarts = 1,
 };
@@ -169,6 +173,7 @@ static struct omap_usb_config ams_delta_usb_config __initdata = {
 };
 
 static struct omap_board_config_kernel ams_delta_config[] = {
+	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 	{ OMAP_TAG_UART,	&ams_delta_uart_config },
 	{ OMAP_TAG_USB,		&ams_delta_usb_config },
 };
@@ -199,6 +204,11 @@ static struct platform_device ams_delta_kp_device = {
 	.resource	= ams_delta_kp_resources,
 };
 
+static struct platform_device ams_delta_lcd_device = {
+	.name	= "lcd_ams_delta",
+	.id	= -1,
+};
+
 static struct platform_device ams_delta_led_device = {
 	.name	= "ams-delta-led",
 	.id	= -1
@@ -206,6 +216,7 @@ static struct platform_device ams_delta_led_device = {
 
 static struct platform_device *ams_delta_devices[] __initdata = {
 	&ams_delta_kp_device,
+	&ams_delta_lcd_device,
 	&ams_delta_led_device,
 };
 
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index ad51939..d97ff63 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -139,6 +139,66 @@ static struct platform_device h2_nor_device = {
 	.resource	= &h2_nor_resource,
 };
 
+#if 0	/* REVISIT: Enable when nand_platform_data is applied */
+
+static struct mtd_partition h2_nand_partitions[] = {
+#if 0
+	/* REVISIT:  enable these partitions if you make NAND BOOT
+	 * work on your H2 (rev C or newer); published versions of
+	 * x-load only support P2 and H3.
+	 */
+	{
+		.name		= "xloader",
+		.offset		= 0,
+		.size		= 64 * 1024,
+		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
+	},
+	{
+		.name		= "bootloader",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 256 * 1024,
+		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
+	},
+	{
+		.name		= "params",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 192 * 1024,
+	},
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 2 * SZ_1M,
+	},
+#endif
+	{
+		.name		= "filesystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= MTDPART_OFS_APPEND,
+	},
+};
+
+/* dip switches control NAND chip access:  8 bit, 16 bit, or neither */
+static struct nand_platform_data h2_nand_data = {
+	.options	= NAND_SAMSUNG_LP_OPTIONS,
+	.parts		= h2_nand_partitions,
+	.nr_parts	= ARRAY_SIZE(h2_nand_partitions),
+};
+
+static struct resource h2_nand_resource = {
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device h2_nand_device = {
+	.name		= "omapnand",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &h2_nand_data,
+	},
+	.num_resources	= 1,
+	.resource	= &h2_nand_resource,
+};
+#endif
+
 static struct resource h2_smc91x_resources[] = {
 	[0] = {
 		.start	= OMAP1610_ETHR_START,		/* Physical */
@@ -218,11 +278,15 @@ static struct resource h2_irda_resources[] = {
 		.flags	= IORESOURCE_IRQ,
 	},
 };
+
+static u64 irda_dmamask = 0xffffffff;
+
 static struct platform_device h2_irda_device = {
 	.name		= "omapirda",
 	.id		= 0,
 	.dev		= {
 		.platform_data	= &h2_irda_data,
+		.dma_mask	= &irda_dmamask,
 	},
 	.num_resources	= ARRAY_SIZE(h2_irda_resources),
 	.resource	= h2_irda_resources,
@@ -270,6 +334,7 @@ static struct platform_device h2_mcbsp1_device = {
 
 static struct platform_device *h2_devices[] __initdata = {
 	&h2_nor_device,
+	//&h2_nand_device,
 	&h2_smc91x_device,
 	&h2_irda_device,
 	&h2_kp_device,
@@ -333,6 +398,13 @@ static struct omap_board_config_kernel h2_config[] = {
 	{ OMAP_TAG_LCD,		&h2_lcd_config },
 };
 
+#define H2_NAND_RB_GPIO_PIN	62
+
+static int h2_nand_dev_ready(struct nand_platform_data *data)
+{
+	return omap_get_gpio_datain(H2_NAND_RB_GPIO_PIN);
+}
+
 static void __init h2_init(void)
 {
 	/* Here we assume the NOR boot config:  NOR on CS3 (possibly swapped
@@ -347,6 +419,13 @@ static void __init h2_init(void)
 	h2_nor_resource.end = h2_nor_resource.start = omap_cs3_phys();
 	h2_nor_resource.end += SZ_32M - 1;
 
+#if 0	/* REVISIT: Enable when nand_platform_data is applied */
+	h2_nand_resource.end = h2_nand_resource.start = OMAP_CS2B_PHYS;
+	h2_nand_resource.end += SZ_4K - 1;
+	if (!(omap_request_gpio(H2_NAND_RB_GPIO_PIN)))
+		h2_nand_data.dev_ready = h2_nand_dev_ready;
+#endif
+
 	omap_cfg_reg(L3_1610_FLASH_CS2B_OE);
 	omap_cfg_reg(M8_1610_FLASH_CS2B_WE);
 
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 7b260b7..1ce0ec3 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -44,6 +44,8 @@
 #include <asm/arch/keypad.h>
 #include <asm/arch/dma.h>
 #include <asm/arch/common.h>
+#include <asm/arch/mcbsp.h>
+#include <asm/arch/omap-alsa.h>
 
 extern int omap_gpio_init(void);
 
@@ -349,11 +351,14 @@ static struct resource h3_irda_resources[] = {
 	},
 };
 
+static u64 irda_dmamask = 0xffffffff;
+
 static struct platform_device h3_irda_device = {
 	.name		= "omapirda",
 	.id		= 0,
 	.dev		= {
 		.platform_data	= &h3_irda_data,
+		.dma_mask	= &irda_dmamask,
 	},
 	.num_resources	= ARRAY_SIZE(h3_irda_resources),
 	.resource	= h3_irda_resources,
@@ -364,6 +369,41 @@ static struct platform_device h3_lcd_device = {
 	.id		= -1,
 };
 
+static struct omap_mcbsp_reg_cfg mcbsp_regs = {
+	.spcr2 = FREE | FRST | GRST | XRST | XINTM(3),
+	.spcr1 = RINTM(3) | RRST,
+	.rcr2  = RPHASE | RFRLEN2(OMAP_MCBSP_WORD_8) |
+                RWDLEN2(OMAP_MCBSP_WORD_16) | RDATDLY(1),
+	.rcr1  = RFRLEN1(OMAP_MCBSP_WORD_8) | RWDLEN1(OMAP_MCBSP_WORD_16),
+	.xcr2  = XPHASE | XFRLEN2(OMAP_MCBSP_WORD_8) |
+                XWDLEN2(OMAP_MCBSP_WORD_16) | XDATDLY(1) | XFIG,
+	.xcr1  = XFRLEN1(OMAP_MCBSP_WORD_8) | XWDLEN1(OMAP_MCBSP_WORD_16),
+	.srgr1 = FWID(15),
+	.srgr2 = GSYNC | CLKSP | FSGM | FPER(31),
+
+	.pcr0  = CLKRM | SCLKME | FSXP | FSRP | CLKXP | CLKRP,
+	//.pcr0 = CLKXP | CLKRP,        /* mcbsp: slave */
+};
+
+static struct omap_alsa_codec_config alsa_config = {
+	.name                   = "H3 TSC2101",
+	.mcbsp_regs_alsa        = &mcbsp_regs,
+	.codec_configure_dev    = NULL, // tsc2101_configure,
+	.codec_set_samplerate   = NULL, // tsc2101_set_samplerate,
+	.codec_clock_setup      = NULL, // tsc2101_clock_setup,
+	.codec_clock_on         = NULL, // tsc2101_clock_on,
+	.codec_clock_off        = NULL, // tsc2101_clock_off,
+	.get_default_samplerate = NULL, // tsc2101_get_default_samplerate,
+};
+
+static struct platform_device h3_mcbsp1_device = {
+	.name	= "omap_alsa_mcbsp",
+	.id	= 1,
+	.dev = {
+		.platform_data	= &alsa_config,
+	},
+};
+
 static struct platform_device *devices[] __initdata = {
 	&nor_device,
 	&nand_device,
@@ -372,6 +412,7 @@ static struct platform_device *devices[] __initdata = {
 	&h3_irda_device,
 	&h3_kp_device,
 	&h3_lcd_device,
+	&h3_mcbsp1_device,
 };
 
 static struct omap_usb_config h3_usb_config __initdata = {
diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 70014f7..8ea0cef 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -34,6 +34,8 @@
 #include <asm/arch/aic23.h>
 #include <asm/arch/gpio.h>
 
+#include "../plat-omap/dsp/dsp_common.h"
+
 static void __init omap_nokia770_init_irq(void)
 {
 	/* On Nokia 770, the SleepX signal is masked with an
@@ -91,7 +93,7 @@ static struct platform_device nokia770_kp_device = {
 };
 
 static struct platform_device *nokia770_devices[] __initdata = {
-        &nokia770_kp_device,
+	&nokia770_kp_device,
 };
 
 static struct ads7846_platform_data nokia770_ads7846_platform_data __initdata = {
@@ -105,7 +107,7 @@ static struct ads7846_platform_data nokia770_ads7846_platform_data __initdata =
 
 static struct spi_board_info nokia770_spi_board_info[] __initdata = {
 	[0] = {
-		.modalias		= "lcd_mipid",
+		.modalias       = "lcd_mipid",
 		.bus_num        = 2,
 		.chip_select    = 3,
 		.max_speed_hz   = 12000000,
@@ -153,6 +155,7 @@ static struct omap_board_config_kernel nokia770_config[] = {
 	{ OMAP_TAG_MMC,		&nokia770_mmc_config },
 };
 
+#if	defined(CONFIG_OMAP_DSP)
 /*
  * audio power control
  */
@@ -183,7 +186,7 @@ static void nokia770_audio_pwr_up(void)
 	clk_enable(dspxor_ck);
 
 	/* Turn on codec */
-	tlv320aic23_power_up();
+	aic23_power_up();
 
 	if (omap_get_gpio_datain(HEADPHONE_GPIO))
 		/* HP not connected, turn on amplifier */
@@ -197,7 +200,7 @@ static void codec_delayed_power_down(struct work_struct *work)
 {
 	down(&audio_pwr_sem);
 	if (audio_pwr_state == -1)
-		tlv320aic23_power_down();
+		aic23_power_down();
 	clk_disable(dspxor_ck);
 	up(&audio_pwr_sem);
 }
@@ -213,7 +216,8 @@ static void nokia770_audio_pwr_down(void)
 	schedule_delayed_work(&codec_power_down_work, HZ / 20);	/* 50ms */
 }
 
-void nokia770_audio_pwr_up_request(int stage)
+static int
+nokia770_audio_pwr_up_request(struct dsp_kfunc_device *kdev, int stage)
 {
 	down(&audio_pwr_sem);
 	if (audio_pwr_state == -1)
@@ -221,9 +225,11 @@ void nokia770_audio_pwr_up_request(int stage)
 	/* force audio_pwr_state = 0, even if it was 1. */
 	audio_pwr_state = 0;
 	up(&audio_pwr_sem);
+	return 0;
 }
 
-void nokia770_audio_pwr_down_request(int stage)
+static int
+nokia770_audio_pwr_down_request(struct dsp_kfunc_device *kdev, int stage)
 {
 	down(&audio_pwr_sem);
 	switch (stage) {
@@ -239,7 +245,38 @@ void nokia770_audio_pwr_down_request(int stage)
 		break;
 	}
 	up(&audio_pwr_sem);
+	return 0;
+}
+
+static struct dsp_kfunc_device nokia770_audio_device = {
+	.name	 = "audio",
+	.type	 = DSP_KFUNC_DEV_TYPE_AUDIO,
+	.enable  = nokia770_audio_pwr_up_request,
+	.disable = nokia770_audio_pwr_down_request,
+};
+
+static __init int omap_dsp_init(void)
+{
+	int ret;
+
+	dspxor_ck = clk_get(0, "dspxor_ck");
+	if (IS_ERR(dspxor_ck)) {
+		printk(KERN_ERR "couldn't acquire dspxor_ck\n");
+		return PTR_ERR(dspxor_ck);
+	}
+
+	ret = dsp_kfunc_device_register(&nokia770_audio_device);
+	if (ret) {
+		printk(KERN_ERR
+		       "KFUNC device registration faild: %s\n",
+		       nokia770_audio_device.name);
+		goto out;
+	}
+	return 0;
+ out:
+	return ret;
 }
+#endif	/* CONFIG_OMAP_DSP */
 
 static void __init omap_nokia770_init(void)
 {
@@ -251,9 +288,7 @@ static void __init omap_nokia770_init(void)
 	omap_board_config = nokia770_config;
 	omap_board_config_size = ARRAY_SIZE(nokia770_config);
 	omap_serial_init();
-	omap_dsp_audio_pwr_up_request = nokia770_audio_pwr_up_request;
-	omap_dsp_audio_pwr_down_request = nokia770_audio_pwr_down_request;
-	dspxor_ck = clk_get(0, "dspxor_ck");
+	omap_dsp_init();
 }
 
 static void __init omap_nokia770_map_io(void)
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 7d0cf7a..253c539 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 4c5b443..c23e8b6 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -321,116 +321,6 @@ static struct tsc2102_config palmte_tsc2102_config = {
 	.alsa_config	= &palmte_alsa_config,
 };
 
-static struct omap_mcbsp_reg_cfg palmte_mcbsp1_regs = {
-	.spcr2	= FRST | GRST | XRST | XINTM(3),
-	.xcr2	= XDATDLY(1) | XFIG,
-	.xcr1	= XWDLEN1(OMAP_MCBSP_WORD_32),
-	.pcr0	= SCLKME | FSXP | CLKXP,
-};
-
-static struct omap_alsa_codec_config palmte_alsa_config = {
-	.name			= "TSC2102 audio",
-	.mcbsp_regs_alsa	= &palmte_mcbsp1_regs,
-	.codec_configure_dev	= NULL,	/* tsc2102_configure, */
-	.codec_set_samplerate	= NULL,	/* tsc2102_set_samplerate, */
-	.codec_clock_setup	= NULL,	/* tsc2102_clock_setup, */
-	.codec_clock_on		= NULL,	/* tsc2102_clock_on, */
-	.codec_clock_off	= NULL,	/* tsc2102_clock_off, */
-	.get_default_samplerate	= NULL,	/* tsc2102_get_default_samplerate, */
-};
-
-#ifdef CONFIG_APM
-/*
- * Values measured in 10 minute intervals averaged over 10 samples.
- * May differ slightly from device to device but should be accurate
- * enough to give basic idea of battery life left and trigger
- * potential alerts.
- */
-static const int palmte_battery_sample[] = {
-	2194, 2157, 2138, 2120,
-	2104, 2089, 2075, 2061,
-	2048, 2038, 2026, 2016,
-	2008, 1998, 1989, 1980,
-	1970, 1958, 1945, 1928,
-	1910, 1888, 1860, 1827,
-	1791, 1751, 1709, 1656,
-};
-
-#define INTERVAL		10
-#define BATTERY_HIGH_TRESHOLD	66
-#define BATTERY_LOW_TRESHOLD	33
-
-static void palmte_get_power_status(struct apm_power_info *info, int *battery)
-{
-	int charging, batt, hi, lo, mid;
-
-	charging = !omap_get_gpio_datain(PALMTE_DC_GPIO);
-	batt = battery[0];
-	if (charging)
-		batt -= 60;
-
-	hi = ARRAY_SIZE(palmte_battery_sample);
-	lo = 0;
-
-	info->battery_flag = 0;
-	info->units = APM_UNITS_MINS;
-
-	if (batt > palmte_battery_sample[lo]) {
-		info->battery_life = 100;
-		info->time = INTERVAL * ARRAY_SIZE(palmte_battery_sample);
-	} else if (batt <= palmte_battery_sample[hi - 1]) {
-		info->battery_life = 0;
-		info->time = 0;
-	} else {
-		while (hi > lo + 1) {
-			mid = (hi + lo) >> 2;
-			if (batt <= palmte_battery_sample[mid])
-				lo = mid;
-			else
-				hi = mid;
-		}
-
-		mid = palmte_battery_sample[lo] - palmte_battery_sample[hi];
-		hi = palmte_battery_sample[lo] - batt;
-		info->battery_life = 100 - (100 * lo + 100 * hi / mid) /
-			ARRAY_SIZE(palmte_battery_sample);
-		info->time = INTERVAL * (ARRAY_SIZE(palmte_battery_sample) -
-				lo) - INTERVAL * hi / mid;
-	}
-
-	if (charging) {
-		info->ac_line_status = APM_AC_ONLINE;
-		info->battery_status = APM_BATTERY_STATUS_CHARGING;
-		info->battery_flag |= APM_BATTERY_FLAG_CHARGING;
-	} else {
-		info->ac_line_status = APM_AC_OFFLINE;
-		if (info->battery_life > BATTERY_HIGH_TRESHOLD)
-			info->battery_status = APM_BATTERY_STATUS_HIGH;
-		else if (info->battery_life > BATTERY_LOW_TRESHOLD)
-			info->battery_status = APM_BATTERY_STATUS_LOW;
-		else
-			info->battery_status = APM_BATTERY_STATUS_CRITICAL;
-	}
-
-	if (info->battery_life > BATTERY_HIGH_TRESHOLD)
-		info->battery_flag |= APM_BATTERY_FLAG_HIGH;
-	else if (info->battery_life > BATTERY_LOW_TRESHOLD)
-		info->battery_flag |= APM_BATTERY_FLAG_LOW;
-	else
-		info->battery_flag |= APM_BATTERY_FLAG_CRITICAL;
-}
-#else
-#define palmte_get_power_status	NULL
-#endif
-
-static struct tsc2102_config palmte_tsc2102_config = {
-	.use_internal	= 0,
-	.monitor	= TSC_BAT1 | TSC_AUX | TSC_TEMP,
-	.temp_at25c	= { 2200, 2615 },
-	.apm_report	= palmte_get_power_status,
-	.alsa_config	= &palmte_alsa_config,
-};
-
 static struct omap_board_config_kernel palmte_config[] = {
 	{ OMAP_TAG_USB,		&palmte_usb_config },
 	{ OMAP_TAG_MMC,		&palmte_mmc_config },
@@ -449,17 +339,6 @@ static struct spi_board_info palmte_spi_info[] __initdata = {
 	},
 };
 
-static struct spi_board_info palmte_spi_info[] __initdata = {
-	{
-		.modalias	= "tsc2102",
-		.bus_num	= 2,	/* uWire (officially) */
-		.chip_select	= 0,	/* As opposed to 3 */
-		.irq		= OMAP_GPIO_IRQ(PALMTE_PINTDAV_GPIO),
-		.platform_data	= &palmte_tsc2102_config,
-		.max_speed_hz	= 8000000,
-	},
-};
-
 /* Periodically check for changes on important input pins */
 struct timer_list palmte_pin_timer;
 int prev_power, prev_headphones;
@@ -539,8 +418,6 @@ static void __init omap_palmte_init(void)
 
 	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
 
-	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
-
 	omap_serial_init();
 	palmte_gpio_setup();
 }
diff --git a/arch/arm/mach-omap1/board-palmtt.c b/arch/arm/mach-omap1/board-palmtt.c
index 3c9a41a..e47010f 100644
--- a/arch/arm/mach-omap1/board-palmtt.c
+++ b/arch/arm/mach-omap1/board-palmtt.c
@@ -314,8 +314,8 @@ static struct omap_uart_config palmtt_uart_config __initdata = {
 };
 
 static struct omap_board_config_kernel palmtt_config[] = {
-	{ OMAP_TAG_USB,	&palmtt_usb_config	},
-	{ OMAP_TAG_LCD,	&palmtt_lcd_config	},
+	{ OMAP_TAG_USB,		&palmtt_usb_config	},
+	{ OMAP_TAG_LCD,		&palmtt_lcd_config	},
 	{ OMAP_TAG_UART,	&palmtt_uart_config	},
 };
 
diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 54abbaa..b1ef1be 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -199,12 +199,12 @@ static struct omap_mcbsp_reg_cfg mcbsp_regs = {
 static struct omap_alsa_codec_config alsa_config = {
 	.name			= "PalmZ71 AIC23",
 	.mcbsp_regs_alsa	= &mcbsp_regs,
-	.codec_configure_dev	= NULL,	// aic23_configure,
-	.codec_set_samplerate	= NULL,	// aic23_set_samplerate,
-	.codec_clock_setup	= NULL,	// aic23_clock_setup,
-	.codec_clock_on		= NULL,	// aic23_clock_on,
-	.codec_clock_off	= NULL,	// aic23_clock_off,
-	.get_default_samplerate	= NULL,	// aic23_get_default_samplerate,
+	.codec_configure_dev	= NULL,		// aic23_configure,
+	.codec_set_samplerate	= NULL,		// aic23_set_samplerate,
+	.codec_clock_setup	= NULL,		// aic23_clock_setup,
+	.codec_clock_on		= NULL,		// aic23_clock_on,
+	.codec_clock_off	= NULL,		// aic23_clock_off,
+	.get_default_samplerate	= NULL,		// aic23_get_default_samplerate,
 };
 
 static struct platform_device palmz71_mcbsp1_device = {
@@ -346,7 +346,7 @@ palmz71_gpio_setup(int early)
 				palmz71_powercable, SA_SAMPLE_RANDOM,
 				"palmz71-cable", 0))
 			printk(KERN_ERR
-					"IRQ request for power cable failed!\n");
+			       "IRQ request for power cable failed!\n");
 		palmz71_powercable(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO), 0, 0);
 	}
 }
diff --git a/arch/arm/mach-omap1/board-voiceblue.c b/arch/arm/mach-omap1/board-voiceblue.c
index 447a586..214dd19 100644
--- a/arch/arm/mach-omap1/board-voiceblue.c
+++ b/arch/arm/mach-omap1/board-voiceblue.c
@@ -235,7 +235,7 @@ static struct notifier_block panic_block = {
 static int __init voiceblue_setup(void)
 {
 	/* Setup panic notifier */
-	notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index b1cebdd..100aea4 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -19,6 +19,8 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
+#include <linux/err.h>
+#include <linux/clk.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -36,10 +38,14 @@
 #include <asm/arch/keypad.h>
 #include <asm/arch/menelaus.h>
 #include <asm/arch/dma.h>
+#include <asm/arch/gpmc.h>
 #include "prcm-regs.h"
 
 #include <asm/io.h>
 
+#define H4_FLASH_CS	0
+#define H4_SMC91X_CS	1
+
 static unsigned int row_gpios[6] = { 88, 89, 124, 11, 6, 96 };
 static unsigned int col_gpios[7] = { 90, 91, 100, 36, 12, 97, 98 };
 
@@ -116,8 +122,6 @@ static struct flash_platform_data h4_flash_data = {
 };
 
 static struct resource h4_flash_resource = {
-	.start		= H4_CS0_BASE,
-	.end		= H4_CS0_BASE + SZ_64M - 1,
 	.flags		= IORESOURCE_MEM,
 };
 
@@ -133,6 +137,7 @@ static struct platform_device h4_flash_device = {
 
 /* Select between the IrDA and aGPS module
  */
+#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
 static int h4_select_irda(struct device *dev, int state)
 {
 	unsigned char expa;
@@ -192,6 +197,10 @@ static int h4_transceiver_mode(struct device *dev, int mode)
 
 	return 0;
 }
+#else
+static int h4_select_irda(struct device *dev, int state) { return 0; }
+static int h4_transceiver_mode(struct device *dev, int mode) { return 0; }
+#endif
 
 static struct omap_irda_config h4_irda_data = {
 	.transceiver_cap	= IR_SIRMODE | IR_MIRMODE | IR_FIRMODE,
@@ -253,16 +262,80 @@ static struct platform_device *h4_devices[] __initdata = {
 	&h4_lcd_device,
 };
 
+/* 2420 Sysboot setup (2430 is different) */
+static u32 get_sysboot_value(void)
+{
+	return (omap_readl(OMAP242X_CONTROL_STATUS) & 0xFFF);
+}
+
+/* FIXME: This function should be moved to some other file, gpmc.c? */
+
+/* H4-2420's always used muxed mode, H4-2422's always use non-muxed
+ *
+ * Note: OMAP-GIT doesn't correctly do is_cpu_omap2422 and is_cpu_omap2423
+ *  correctly.  The macro needs to look at production_id not just hawkeye.
+ */
+static u32 is_gpmc_muxed(void)
+{
+	u32 mux;
+	mux = get_sysboot_value();
+	if ((mux & 0xF) == 0xd)
+		return 1;	/* NAND config (could be either) */
+	if (mux & 0x2)		/* if mux'ed */
+		return 1;
+	else
+		return 0;
+}
+
 static inline void __init h4_init_debug(void)
 {
+	int eth_cs;
+	unsigned long cs_mem_base;
+	unsigned int muxed, rate;
+	struct clk *l3ck;
+
+	eth_cs	= H4_SMC91X_CS;
+
+	l3ck = clk_get(NULL, "core_l3_ck");
+	if (IS_ERR(l3ck))
+		rate = 100000000;
+	else
+		rate = clk_get_rate(l3ck);
+
+	if (is_gpmc_muxed())
+		muxed = 0x200;
+	else
+		muxed = 0;
+
 	/* Make sure CS1 timings are correct */
-	GPMC_CONFIG1_1 = 0x00011200;
-	GPMC_CONFIG2_1 = 0x001f1f01;
-	GPMC_CONFIG3_1 = 0x00080803;
-	GPMC_CONFIG4_1 = 0x1c091c09;
-	GPMC_CONFIG5_1 = 0x041f1f1f;
-	GPMC_CONFIG6_1 = 0x000004c4;
-	GPMC_CONFIG7_1 = 0x00000f40 | (0x08000000 >> 24);
+	gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG1,
+			  0x00011000 | muxed);
+
+	if (rate >= 160000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f01);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080803);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1c0b1c0a);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else if (rate >= 130000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else {/* rate = 100000000 */
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x031A1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000003C2);
+	}
+
+	if (gpmc_cs_request(eth_cs, SZ_16M, &cs_mem_base) < 0) {
+		printk(KERN_ERR "Failed to request GPMC mem for smc91x\n");
+		return;
+	}
+
 	udelay(100);
 
 	omap_cfg_reg(M15_24XX_GPIO92);
@@ -270,11 +343,24 @@ static inline void __init h4_init_debug(void)
 		gpmc_cs_free(eth_cs);
 }
 
+static void __init h4_init_flash(void)
+{
+	unsigned long base;
+
+	if (gpmc_cs_request(H4_FLASH_CS, SZ_64M, &base) < 0) {
+		printk("Can't request GPMC CS for flash\n");
+		return;
+	}
+	h4_flash_resource.start	= base;
+	h4_flash_resource.end	= base + SZ_64M - 1;
+}
+
 static void __init omap_h4_init_irq(void)
 {
 	omap2_init_common_hw();
 	omap_init_irq();
 	omap_gpio_init();
+	h4_init_flash();
 }
 
 static struct omap_uart_config h4_uart_config __initdata = {
@@ -336,9 +422,75 @@ static struct omap_board_config_kernel h4_config[] = {
 	{ OMAP_TAG_UART,	&h4_uart_config },
 	{ OMAP_TAG_MMC,		&h4_mmc_config },
 	{ OMAP_TAG_LCD,		&h4_lcd_config },
-	{ OMAP_TAG_USB,	&h4_usb_config },
+	{ OMAP_TAG_USB,		&h4_usb_config },
 };
 
+#ifdef	CONFIG_MACH_OMAP_H4_TUSB
+
+#include <linux/usb/musb.h>
+
+static struct musb_hdrc_platform_data tusb_data = {
+	.mode		= MUSB_OTG,
+	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
+
+	/* 1.8V supplied by Menelaus, other voltages supplied by VBAT;
+	 * so no switching.
+	 */
+};
+
+static void __init tusb_evm_setup(void)
+{
+	static char	announce[] __initdata =
+				KERN_INFO "TUSB 6010 EVM\n";
+	int		irq;
+	unsigned	dmachan = 0;
+
+	/* There are at least 32 different combinations of boards that
+	 * are loosely called "H4", with a 2420 ... different OMAP chip
+	 * revisions (with pin mux changes for DMAREQ, GPMC errata, etc),
+	 * modifications of the CPU board, mainboard, EVM, TUSB etc.
+	 * Plus omap2422, omap2423, etc.
+	 *
+	 * So you might need to tweak this setup to make the TUSB EVM
+	 * behave on your particular setup ...
+	 */
+
+	/* Already set up:  GPMC AD[0..15], CLK, nOE, nWE, nADV_ALE */
+	omap_cfg_reg(E2_GPMC_NCS2);
+	omap_cfg_reg(L2_GPMC_NCS7);
+	omap_cfg_reg(M1_GPMC_WAIT2);
+
+	switch ((system_rev >> 8) & 0x0f) {
+	case 0:		/* ES 1.0 */
+	case 1:		/* ES 2.0 */
+		/* Assume early board revision without optional ES2.0
+		 * rework to swap J15 & AA10 so DMAREQ0 works
+		 */
+		omap_cfg_reg(AA10_242X_GPIO13);
+		irq = 13;
+		// omap_cfg_reg(J15_24XX_DMAREQ0);
+		break;
+	default:
+		/* Later Menelaus boards can support all 6 DMA request
+		 * lines, at the price of boot flash A23-A26.
+		 */
+		omap_cfg_reg(J15_24XX_GPIO99);
+		irq = 99;
+		omap_cfg_reg(AA10_242X_DMAREQ0);
+		omap_cfg_reg(AA6_242X_DMAREQ1);
+		dmachan = (1 << 1) | (1 << 0);
+		break;
+	}
+
+	if (tusb6010_setup_interface(&tusb_data,
+			TUSB6010_REFCLK_24, /* waitpin */ 2,
+			/* async cs */ 2, /* sync cs */ 7,
+			irq, dmachan) == 0)
+		printk(announce);
+}
+
+#endif
+
 static void __init omap_h4_init(void)
 {
 	/*
@@ -371,6 +523,14 @@ static void __init omap_h4_init(void)
 	omap_board_config = h4_config;
 	omap_board_config_size = ARRAY_SIZE(h4_config);
 	omap_serial_init();
+
+	/* smc91x, debug leds, ps/2, extra uarts */
+	h4_init_debug();
+
+#ifdef	CONFIG_MACH_OMAP_H4_TUSB
+	tusb_evm_setup();
+#endif
+
 }
 
 static void __init omap_h4_map_io(void)
-- 
1.4.4.2

