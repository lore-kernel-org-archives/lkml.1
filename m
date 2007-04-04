Return-Path: <linux-kernel-owner+w=401wt.eu-S2993011AbXDDSVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993011AbXDDSVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbXDDSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:43 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39718 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099AbXDDSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:38 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Jarkko Nikula <jarkko.nikula@nokia.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>
Subject: [PATCH 74/90] ARM: OMAP: N800: Update board-specific audio support
Date: Wed,  4 Apr 2007 14:05:53 -0400
Message-Id: <1175710172195-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101683521-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@nokia.com>

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
---
 arch/arm/mach-omap2/board-n800-audio.c |   61 ++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n800-audio.c b/arch/arm/mach-omap2/board-n800-audio.c
index 8e36691..fa6ab86 100644
--- a/arch/arm/mach-omap2/board-n800-audio.c
+++ b/arch/arm/mach-omap2/board-n800-audio.c
@@ -2,7 +2,7 @@
  * linux/arch/arm/mach-omap2/board-n800-audio.c
  *
  * Copyright (C) 2006 Nokia Corporation
- * Contact: Juha Yrj?l?
+ * Contact: Juha Yrjola
  *          Jarkko Nikula <jarkko.nikula@nokia.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -23,7 +23,6 @@
 
 #include <linux/err.h>
 #include <linux/clk.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/spi/tsc2301.h>
 
@@ -44,47 +43,63 @@ static int enable_audio;
 static int audio_ok;
 static spinlock_t audio_lock;
 
-
 /*
- * Leaving EAC pins multiplexed to EAC functionality results
- * in about 2 mA extra current leaked. The workaround is to
- * multiplex the EAC pins to protected mode (with pull-ups enabled)
+ * Leaving EAC and sys_clkout2 pins multiplexed to those subsystems results
+ * in about 2 mA extra current leak when audios are powered down. The
+ * workaround is to multiplex them to protected mode (with pull-ups enabled)
  * whenever audio is not being used.
  */
-static int mux_disabled;
+static int eac_mux_disabled = 0;
+static int clkout2_mux_disabled = 0;
 static u32 saved_mux[2];
 
 static void n800_enable_eac_mux(void)
 {
-	if (!mux_disabled)
+	if (!eac_mux_disabled)
 		return;
-	__raw_writel(saved_mux[0], IO_ADDRESS(0x480000e8));
 	__raw_writel(saved_mux[1], IO_ADDRESS(0x48000124));
-	mux_disabled = 0;
+	eac_mux_disabled = 0;
 }
 
 static void n800_disable_eac_mux(void)
 {
+	if (eac_mux_disabled) {
+		WARN_ON(eac_mux_disabled);
+		return;
+	}
+	saved_mux[1] = __raw_readl(IO_ADDRESS(0x48000124));
+	__raw_writel(0x1f1f1f1f, IO_ADDRESS(0x48000124));
+	eac_mux_disabled = 1;
+}
+
+static void n800_enable_clkout2_mux(void)
+{
+	if (!clkout2_mux_disabled)
+		return;
+	__raw_writel(saved_mux[0], IO_ADDRESS(0x480000e8));
+	clkout2_mux_disabled = 0;
+}
+
+static void n800_disable_clkout2_mux(void)
+{
 	u32 l;
 
-	if (mux_disabled) {
-		WARN_ON(mux_disabled);
+	if (clkout2_mux_disabled) {
+		WARN_ON(clkout2_mux_disabled);
 		return;
 	}
 	saved_mux[0] = __raw_readl(IO_ADDRESS(0x480000e8));
-	saved_mux[1] = __raw_readl(IO_ADDRESS(0x48000124));
 	l = saved_mux[0] & ~0xff;
 	l |= 0x1f;
 	__raw_writel(l, IO_ADDRESS(0x480000e8));
-	__raw_writel(0x1f1f1f1f, IO_ADDRESS(0x48000124));
-	mux_disabled = 1;
+	clkout2_mux_disabled = 1;
 }
 
 static int n800_eac_enable_ext_clocks(struct device *dev)
 {
 	BUG_ON(tsc2301_device == NULL);
 	n800_enable_eac_mux();
-	tsc2301_enable_mclk(tsc2301_device);
+	tsc2301_mixer_enable_mclk(tsc2301_device);
 
 	return 0;
 }
@@ -92,8 +107,8 @@ static int n800_eac_enable_ext_clocks(struct device *dev)
 static void n800_eac_disable_ext_clocks(struct device *dev)
 {
 	BUG_ON(tsc2301_device == NULL);
+	tsc2301_mixer_disable_mclk(tsc2301_device);
 	n800_disable_eac_mux();
-	tsc2301_disable_mclk(tsc2301_device);
 }
 
 static int n800_audio_set_power(void *pdata, int dac, int adc)
@@ -199,20 +214,14 @@ static void n800_codec_put_clocks(struct device *dev)
 
 static int n800_codec_enable_clock(struct device *dev)
 {
-	int err;
-
-	err = clk_enable(sys_clkout2);
-	if (err)
-		return err;
-	/* TODO: 'educated' guess for audio codec's PLL startup delay */
-	mdelay(1);
-
-	return 0;
+	n800_enable_clkout2_mux();
+	return clk_enable(sys_clkout2);
 }
 
 static void n800_codec_disable_clock(struct device *dev)
 {
 	clk_disable(sys_clkout2);
+	n800_disable_clkout2_mux();
 }
 
 static int n800_codec_init(struct device *dev)
-- 
1.4.4.2

