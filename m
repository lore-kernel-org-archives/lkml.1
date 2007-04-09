Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXDIVBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXDIVBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDIVBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:01:41 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:11597 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXDIVBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:01:40 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/10] ARM: OMAP: Enable 24xx GPIO autoidling
Date: Mon,  9 Apr 2007 17:01:03 -0400
Message-Id: <1176152483689-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761524713580-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Enable 24xx GPIO autoidling

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1083,6 +1083,10 @@ static int __init _omap_gpio_init(void)
 		if (bank->method == METHOD_GPIO_24XX) {
 			__raw_writel(0x00000000, bank->base + OMAP24XX_GPIO_IRQENABLE1);
 			__raw_writel(0xffffffff, bank->base + OMAP24XX_GPIO_IRQSTATUS1);
+			__raw_writew(0x0015, bank->base + OMAP24XX_GPIO_SYSCONFIG);
+
+			/* Initialize interface clock ungated, module enabled */
+			__raw_writel(0, bank->base + OMAP24XX_GPIO_CTRL);
 
 			gpio_count = 32;
 		}
@@ -1105,6 +1109,12 @@ static int __init _omap_gpio_init(void)
 	if (cpu_is_omap16xx())
 		omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04, ULPD_CAM_CLK_CTRL);
 
+#ifdef CONFIG_ARCH_OMAP24XX
+	/* Enable autoidle for the OCP interface */
+	if (cpu_is_omap24xx())
+		omap_writel(1 << 0, 0x48019010);
+#endif
+
 	return 0;
 }
 
-- 
1.4.4.2

