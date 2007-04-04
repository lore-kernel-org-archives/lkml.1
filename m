Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXDDSec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXDDSec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXDDSIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:44 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36929 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXDDSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:30 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 30/90] ARM: OMAP: Palm Zire71 minor fixes
Date: Wed,  4 Apr 2007 14:05:09 -0400
Message-Id: <117571004562-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100423982-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l34IZRZJ025658

From: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>

This patch makes minor changes in palmz71 board file (formating changes) and
renames one GPIO (PALMZ71_PINTDAV_GPIO to PALMZ71_PENIRQ_GPIO) in
board-palmz71.h and board-palmz71.c .

Signed-off-by: Marek Vašut <marek.vasut@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmz71.c       |   29 ++++++++++++++---------------
 include/asm-arm/arch-omap/board-palmz71.h |    2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 5d73e8c..786142b 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -192,8 +192,7 @@ static struct omap_mcbsp_reg_cfg mcbsp_regs = {
 	.xcr1	= XFRLEN1(OMAP_MCBSP_WORD_8) | XWDLEN1(OMAP_MCBSP_WORD_16),
 	.srgr1	= FWID(DEFAULT_BITPERSAMPLE - 1),
 	.srgr2	= GSYNC | CLKSP | FSGM | FPER(DEFAULT_BITPERSAMPLE * 2 - 1),
-	/*.pcr0	= FSXM | FSRM | CLKXM | CLKRM | CLKXP | CLKRP, *//* mcbsp: master */
-	.pcr0 = CLKXP | CLKRP,	/* mcbsp: slave */
+	.pcr0	= CLKXP | CLKRP,	/* mcbsp: slave */
 };
 
 static struct omap_alsa_codec_config alsa_config = {
@@ -240,7 +239,7 @@ static struct platform_device *devices[] __initdata = {
 static int
 palmz71_get_pendown_state(void)
 {
-	return !omap_get_gpio_datain(6);
+	return !omap_get_gpio_datain(PALMZ71_PENIRQ_GPIO);
 }
 
 static const struct ads7846_platform_data palmz71_ts_info = {
@@ -251,16 +250,16 @@ static const struct ads7846_platform_data palmz71_ts_info = {
 	.get_pendown_state	= palmz71_get_pendown_state,
 };
 
-static struct spi_board_info __initdata palmz71_boardinfo[] = {
-{
+static struct spi_board_info __initdata palmz71_boardinfo[] = { {
 	/* MicroWire (bus 2) CS0 has an ads7846e */
 	.modalias	= "ads7846",
 	.platform_data	= &palmz71_ts_info,
-	.irq		= OMAP_GPIO_IRQ(6),
-	.max_speed_hz	= 120000 /* max sample rate at 3V */
-				* 26 /* command + data + overhead */,
+	.irq		= OMAP_GPIO_IRQ(PALMZ71_PENIRQ_GPIO),
+	.max_speed_hz	= 120000	/* max sample rate at 3V */
+				* 26	/* command + data + overhead */,
 	.bus_num	= 2,
 	.chip_select	= 0,
+	}
 } };
 
 static struct omap_usb_config palmz71_usb_config __initdata = {
@@ -288,10 +287,10 @@ static struct omap_uart_config palmz71_uart_config __initdata = {
 };
 
 static struct omap_board_config_kernel palmz71_config[] = {
-	{OMAP_TAG_USB, &palmz71_usb_config},
-	{OMAP_TAG_MMC, &palmz71_mmc_config},
-	{OMAP_TAG_LCD, &palmz71_lcd_config},
-	{OMAP_TAG_UART, &palmz71_uart_config},
+	{OMAP_TAG_USB,	&palmz71_usb_config},
+	{OMAP_TAG_MMC,	&palmz71_mmc_config},
+	{OMAP_TAG_LCD,	&palmz71_lcd_config},
+	{OMAP_TAG_UART,	&palmz71_uart_config},
 };
 
 static irqreturn_t
@@ -343,9 +342,9 @@ palmz71_gpio_setup(int early)
 		}
 		omap_set_gpio_direction(PALMZ71_USBDETECT_GPIO, 1);
 		if (request_irq(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO),
-			palmz71_powercable, SA_SAMPLE_RANDOM,
-			"palmz71-cable", 0))
-				printk(KERN_ERR
+				palmz71_powercable, SA_SAMPLE_RANDOM,
+				"palmz71-cable", 0))
+			printk(KERN_ERR
 					"IRQ request for power cable failed!\n");
 		palmz71_powercable(OMAP_GPIO_IRQ(PALMZ71_USBDETECT_GPIO), 0, 0);
 	}
diff --git a/include/asm-arm/arch-omap/board-palmz71.h b/include/asm-arm/arch-omap/board-palmz71.h
index 6aff149..1252a85 100644
--- a/include/asm-arm/arch-omap/board-palmz71.h
+++ b/include/asm-arm/arch-omap/board-palmz71.h
@@ -14,7 +14,7 @@
 #define __OMAP_BOARD_PALMZ71_H
 
 #define PALMZ71_USBDETECT_GPIO	0
-#define PALMZ71_PINTDAV_GPIO	6
+#define PALMZ71_PENIRQ_GPIO	6
 #define PALMZ71_MMC_WP_GPIO	8
 #define PALMZ71_HDQ_GPIO 	11
 
-- 
1.4.4.2

