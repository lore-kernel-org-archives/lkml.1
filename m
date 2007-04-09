Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXDIVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXDIVnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965982AbXDIV36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:29:58 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:31938 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXDIV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:29:44 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/14] ARM: OMAP: Sync board specific files with linux-omap
Date: Mon,  9 Apr 2007 17:28:32 -0400
Message-Id: <1176154157419-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761541501423-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs omap board specific files with linux-omap tree.

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
 arch/arm/mach-omap1/board-voiceblue.c |    2 +-
 10 files changed, 380 insertions(+), 176 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/board-ams-delta.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-ams-delta.c	2007-04-09 16:40:19.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-ams-delta.c	2007-04-09 16:40:23.000000000 -0400
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
-
-	KEY(1, 0, KEY_DELETE),	/* Delete	*/
-	KEY(2, 2, KEY_PLAY),	/* Play	  */
-	KEY(0, 1, KEY_PAGEUP),	/* Up	*/
-	KEY(3, 1, KEY_PAGEDOWN),	/* Down	  */
-	KEY(0, 2, KEY_EMAIL),	/* ReadEmail */
-	KEY(1, 2, KEY_STOP),	/* Stop	  */
+	KEY(3, 2, KEY_CONNECT),		/* Internet  */
+	KEY(2, 1, KEY_SHOP),		/* Services  */
+	KEY(1, 1, KEY_PHONE),		/* VoiceMail */
+
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
-
-	KEY(4, 7, KEY_CAMERA),	/* Photo	 */
-
-	KEY(4, 0, KEY_F2),	/* Home	  */
-	KEY(4, 1, KEY_F3),	/* Office	*/
-	KEY(4, 2, KEY_F4),	/* Mobile	*/
-	KEY(7, 7, KEY_F5),	/* SMS		*/
-	KEY(5, 7, KEY_F6),	/* Email	 */
+	KEY(5, 3, KEY_KPDOT),		/* # key     */
+	KEY(2, 7, KEY_NUMLOCK),		/* Mute      */
+	KEY(1, 7, KEY_KPMINUS),		/* Recall    */
+	KEY(1, 6, KEY_KPPLUS),		/* Redial    */
+	KEY(6, 7, KEY_KPSLASH),		/* Handsfree */
+	KEY(0, 6, KEY_ENTER),		/* Video     */
+
+	KEY(4, 7, KEY_CAMERA),		/* Photo     */
+
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
@@ -158,6 +158,10 @@ static struct map_desc ams_delta_io_desc
 	}
 };
 
+static struct omap_lcd_config ams_delta_lcd_config __initdata = {
+	.ctrl_name	= "internal",
+};
+
 static struct omap_uart_config ams_delta_uart_config __initdata = {
 	.enabled_uarts = 1,
 };
@@ -169,6 +173,7 @@ static struct omap_usb_config ams_delta_
 };
 
 static struct omap_board_config_kernel ams_delta_config[] = {
+	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 	{ OMAP_TAG_UART,	&ams_delta_uart_config },
 	{ OMAP_TAG_USB,		&ams_delta_usb_config },
 };
@@ -199,6 +204,11 @@ static struct platform_device ams_delta_
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
@@ -206,6 +216,7 @@ static struct platform_device ams_delta_
 
 static struct platform_device *ams_delta_devices[] __initdata = {
 	&ams_delta_kp_device,
+	&ams_delta_lcd_device,
 	&ams_delta_led_device,
 };
 
Index: linux-2.6/arch/arm/mach-omap1/board-h2.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-h2.c	2007-04-09 16:38:11.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-h2.c	2007-04-09 16:40:23.000000000 -0400
@@ -139,6 +139,66 @@ static struct platform_device h2_nor_dev
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
@@ -218,11 +278,15 @@ static struct resource h2_irda_resources
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
@@ -270,6 +334,7 @@ static struct platform_device h2_mcbsp1_
 
 static struct platform_device *h2_devices[] __initdata = {
 	&h2_nor_device,
+	//&h2_nand_device,
 	&h2_smc91x_device,
 	&h2_irda_device,
 	&h2_kp_device,
@@ -333,6 +398,13 @@ static struct omap_board_config_kernel h
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
 
Index: linux-2.6/arch/arm/mach-omap1/board-h3.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-h3.c	2007-04-09 16:39:05.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-h3.c	2007-04-09 16:40:23.000000000 -0400
@@ -44,6 +44,8 @@
 #include <asm/arch/keypad.h>
 #include <asm/arch/dma.h>
 #include <asm/arch/common.h>
+#include <asm/arch/mcbsp.h>
+#include <asm/arch/omap-alsa.h>
 
 extern int omap_gpio_init(void);
 
@@ -349,11 +351,14 @@ static struct resource h3_irda_resources
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
@@ -364,6 +369,41 @@ static struct platform_device h3_lcd_dev
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
@@ -372,6 +412,7 @@ static struct platform_device *devices[]
 	&h3_irda_device,
 	&h3_kp_device,
 	&h3_lcd_device,
+	&h3_mcbsp1_device,
 };
 
 static struct omap_usb_config h3_usb_config __initdata = {
Index: linux-2.6/arch/arm/mach-omap1/board-nokia770.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-nokia770.c	2007-04-09 16:38:11.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-nokia770.c	2007-04-09 16:40:23.000000000 -0400
@@ -34,6 +34,8 @@
 #include <asm/arch/aic23.h>
 #include <asm/arch/gpio.h>
 
+#include "../plat-omap/dsp/dsp_common.h"
+
 static void __init omap_nokia770_init_irq(void)
 {
 	/* On Nokia 770, the SleepX signal is masked with an
@@ -91,7 +93,7 @@ static struct platform_device nokia770_k
 };
 
 static struct platform_device *nokia770_devices[] __initdata = {
-        &nokia770_kp_device,
+	&nokia770_kp_device,
 };
 
 static struct ads7846_platform_data nokia770_ads7846_platform_data __initdata = {
@@ -105,7 +107,7 @@ static struct ads7846_platform_data noki
 
 static struct spi_board_info nokia770_spi_board_info[] __initdata = {
 	[0] = {
-		.modalias		= "lcd_mipid",
+		.modalias       = "lcd_mipid",
 		.bus_num        = 2,
 		.chip_select    = 3,
 		.max_speed_hz   = 12000000,
@@ -153,6 +155,7 @@ static struct omap_board_config_kernel n
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
@@ -197,7 +200,7 @@ static void codec_delayed_power_down(str
 {
 	down(&audio_pwr_sem);
 	if (audio_pwr_state == -1)
-		tlv320aic23_power_down();
+		aic23_power_down();
 	clk_disable(dspxor_ck);
 	up(&audio_pwr_sem);
 }
@@ -213,7 +216,8 @@ static void nokia770_audio_pwr_down(void
 	schedule_delayed_work(&codec_power_down_work, HZ / 20);	/* 50ms */
 }
 
-void nokia770_audio_pwr_up_request(int stage)
+static int
+nokia770_audio_pwr_up_request(struct dsp_kfunc_device *kdev, int stage)
 {
 	down(&audio_pwr_sem);
 	if (audio_pwr_state == -1)
@@ -221,9 +225,11 @@ void nokia770_audio_pwr_up_request(int s
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
@@ -239,7 +245,38 @@ void nokia770_audio_pwr_down_request(int
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
@@ -251,9 +288,7 @@ static void __init omap_nokia770_init(vo
 	omap_board_config = nokia770_config;
 	omap_board_config_size = ARRAY_SIZE(nokia770_config);
 	omap_serial_init();
-	omap_dsp_audio_pwr_up_request = nokia770_audio_pwr_up_request;
-	omap_dsp_audio_pwr_down_request = nokia770_audio_pwr_down_request;
-	dspxor_ck = clk_get(0, "dspxor_ck");
+	omap_dsp_init();
 }
 
 static void __init omap_nokia770_map_io(void)
Index: linux-2.6/arch/arm/mach-omap1/board-osk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-osk.c	2007-04-09 16:39:09.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-osk.c	2007-04-09 16:40:23.000000000 -0400
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
Index: linux-2.6/arch/arm/mach-omap1/board-palmte.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-palmte.c	2007-04-09 16:40:21.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-palmte.c	2007-04-09 16:40:23.000000000 -0400
@@ -321,116 +321,6 @@ static struct tsc2102_config palmte_tsc2
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
@@ -449,17 +339,6 @@ static struct spi_board_info palmte_spi_
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
@@ -539,8 +418,6 @@ static void __init omap_palmte_init(void
 
 	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
 
-	spi_register_board_info(palmte_spi_info, ARRAY_SIZE(palmte_spi_info));
-
 	omap_serial_init();
 	palmte_gpio_setup();
 }
Index: linux-2.6/arch/arm/mach-omap1/board-palmtt.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-palmtt.c	2007-04-09 16:40:22.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-palmtt.c	2007-04-09 16:40:23.000000000 -0400
@@ -314,8 +314,8 @@ static struct omap_uart_config palmtt_ua
 };
 
 static struct omap_board_config_kernel palmtt_config[] = {
-	{ OMAP_TAG_USB,	&palmtt_usb_config	},
-	{ OMAP_TAG_LCD,	&palmtt_lcd_config	},
+	{ OMAP_TAG_USB,		&palmtt_usb_config	},
+	{ OMAP_TAG_LCD,		&palmtt_lcd_config	},
 	{ OMAP_TAG_UART,	&palmtt_uart_config	},
 };
 
Index: linux-2.6/arch/arm/mach-omap1/board-voiceblue.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-voiceblue.c	2007-04-09 16:38:11.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-voiceblue.c	2007-04-09 16:40:23.000000000 -0400
@@ -235,7 +235,7 @@ static struct notifier_block panic_block
 static int __init voiceblue_setup(void)
 {
 	/* Setup panic notifier */
-	notifier_chain_register(&panic_notifier_list, &panic_block);
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 
 	return 0;
 }
