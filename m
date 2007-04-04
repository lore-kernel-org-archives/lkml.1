Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbXDDSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbXDDSLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbXDDSKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:10:54 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38147 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDDSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:10:48 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 48/90] ARM: OMAP: I2C-1 init fix for 2430
Date: Wed,  4 Apr 2007 14:05:27 -0400
Message-Id: <11757100982726-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100952384-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Syed Mohammed Khasim <x0khasim@ti.com>

I2C-1 for 2430 was commented previously, enabled in this patch.

Signed-off-by: Syed Mohammed Khasim <x0khasim@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/devices.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
index 2fac7d3..3e84a03 100644
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -136,8 +136,10 @@ static void omap_init_i2c(void)
 	 * it can include clocking and address info, maybe more.
 	 */
 	if (cpu_is_omap24xx()) {
-		omap_cfg_reg(M19_24XX_I2C1_SCL);
-		omap_cfg_reg(L15_24XX_I2C1_SDA);
+		if (machine_is_omap_h4()) {
+			omap_cfg_reg(M19_24XX_I2C1_SCL);
+			omap_cfg_reg(L15_24XX_I2C1_SDA);
+		}
 	} else {
 		omap_cfg_reg(I2C_SCL);
 		omap_cfg_reg(I2C_SDA);
@@ -501,13 +503,13 @@ static int __init omap_init_devices(void)
 	 * in alphabetical order so they're easier to sort through.
 	 */
 	omap_init_dsp();
-	omap_init_i2c();
 	omap_init_kp();
 	omap_init_mmc();
 	omap_init_uwire();
 	omap_init_wdt();
 	omap_init_rng();
 #endif
+	omap_init_i2c();
 	return 0;
 }
 arch_initcall(omap_init_devices);
-- 
1.4.4.2

