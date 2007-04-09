Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXDIVay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXDIVay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966002AbXDIVaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:30:25 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:32271 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966001AbXDIVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:30:08 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Eduardo Valentin <eduardo.valentin@indt.org.br>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 14/14] ARM: OMAP: H2 lcd updates for SPI framework
Date: Mon,  9 Apr 2007 17:28:39 -0400
Message-Id: <1176154183384-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154179661-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com> <1176154157419-git-send-email-tony@atomide.com> <117615416178-git-send-email-tony@atomide.com> <11761541643961-git-send-email-tony@atomide.com> <1176154169578-git-send-email-tony@atomide.com> <11761541721823-git-send-email-tony@atomide.com> <1176154176346-git-send-email-tony@atomide.com> <1176154179661-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@indt.org.br>

This is an updated patch to fix lcd for H2 board. It uses platform_data
field to pass spi_device to lcd driver.

Signed-off-by: Eduardo Valentin <eduardo.valentin@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h2.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -308,6 +308,17 @@ struct {
 #define TSC2101_MUX_MCLK_ON	R10_1610_MCLK_ON
 #define TSC2101_MUX_MCLK_OFF	R10_1610_MCLK_OFF
 
+static void h2_lcd_dev_init(struct spi_device *tsc2101)
+{
+	/* The LCD is connected to the GPIO pins of the TSC2101, so
+	 * we have to tie them here. We can also register the LCD driver
+	 * first only here, where we know that the TSC driver is ready.
+	 */
+
+	h2_lcd_device.dev.platform_data = tsc2101;
+	platform_device_register(&h2_lcd_device);
+}
+
 static int h2_tsc2101_init(struct spi_device *spi)
 {
 	int r;
@@ -331,6 +342,8 @@ static int h2_tsc2101_init(struct spi_device *spi)
 	omap_cfg_reg(TSC2101_MUX_MCLK_OFF);
 	omap_cfg_reg(N15_1610_UWIRE_CS1);
 
+	h2_lcd_dev_init(spi);
+
 	return 0;
 err:
 	clk_put(h2_tsc2101.mclk);
@@ -413,7 +426,6 @@ static struct platform_device *h2_devices[] __initdata = {
 	&h2_smc91x_device,
 	&h2_irda_device,
 	&h2_kp_device,
-	&h2_lcd_device,
 	&h2_mcbsp1_device,
 };
 
-- 
1.4.4.2

