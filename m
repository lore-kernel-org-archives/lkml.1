Return-Path: <linux-kernel-owner+w=401wt.eu-S2992998AbXDDSRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992998AbXDDSRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDDSPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:15:13 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:40431 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422707AbXDDSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:14:44 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Eduardo Valentin <eduardo.valentin@indt.org.br>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 90/90] ARM: OMAP: H2 lcd updates for SPI framework
Date: Wed,  4 Apr 2007 14:06:09 -0400
Message-Id: <11757102172403-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757102142759-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 4438390..810dabb 100644
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

