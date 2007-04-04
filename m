Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXDDSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXDDSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXDDSI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:59 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37205 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXDDSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:56 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 33/90] ARM: OMAP: This patch enables I2C-2 support for 2430 SDP
Date: Wed,  4 Apr 2007 14:05:12 -0400
Message-Id: <1175710059333-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100511172-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Syed Mohammed Khasim <x0khasim@ti.com>

This patch enables I2C-2 support for 2430 SDP.

Signed-off-by: Syed Mohammed Khasim <x0khasim@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index cb5e775..bc42a7d 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -52,11 +52,13 @@ static struct platform_device omap_i2c_device2 = {
 static void omap_init_i2c(void)
 {
 	/* REVISIT: Second I2C not in use on H4? */
-	if (machine_is_omap_h4() || machine_is_omap_2430sdp())
+	if (machine_is_omap_h4())
 		return;
 
-	omap_cfg_reg(J15_24XX_I2C2_SCL);
-	omap_cfg_reg(H19_24XX_I2C2_SDA);
+	if (!cpu_is_omap2430()) {
+		omap_cfg_reg(J15_24XX_I2C2_SCL);
+		omap_cfg_reg(H19_24XX_I2C2_SDA);
+	}
 	(void) platform_device_register(&omap_i2c_device2);
 }
 
-- 
1.4.4.2

