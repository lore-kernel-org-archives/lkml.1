Return-Path: <linux-kernel-owner+w=401wt.eu-S2992760AbXDDSRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992760AbXDDSRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXDDSOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:14:36 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39941 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084AbXDDSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:58 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@mvista.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 75/90] ARM: OMAP: 243x: Add mappings for SDRC and SMS
Date: Wed,  4 Apr 2007 14:05:54 -0400
Message-Id: <11757101754123-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710172195-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@mvista.com>

Add mappings for SDRC ans SMS so that omap2_memory_init() works on the
2430.  This also allows the mpurate= command-line option to work.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/io.c             |   17 ++++++++++++-----
 include/asm-arm/arch-omap/io.h       |    7 +++++++
 include/asm-arm/arch-omap/omap24xx.h |    3 ++-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index c3dafcb..871fde3 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -61,6 +61,18 @@ static struct map_desc omap2_io_desc[] __initdata = {
 		.length		= OMAP243X_GPMC_SIZE,
 		.type		= MT_DEVICE
 	},
+	{
+		.virtual	= OMAP243X_SDRC_VIRT,
+		.pfn		= __phys_to_pfn(OMAP243X_SDRC_PHYS),
+		.length		= OMAP243X_SDRC_SIZE,
+		.type		= MT_DEVICE
+	},
+	{
+		.virtual	= OMAP243X_SMS_VIRT,
+		.pfn		= __phys_to_pfn(OMAP243X_SMS_PHYS),
+		.length		= OMAP243X_SMS_SIZE,
+		.type		= MT_DEVICE
+	},
 #endif
 	{
 		.virtual	= DSP_MEM_24XX_VIRT,
@@ -102,11 +114,6 @@ void __init omap2_init_common_hw(void)
 {
 	omap2_mux_init();
 	omap2_clk_init();
-/*
- * Need to Fix this for 2430
- */
-#ifndef CONFIG_ARCH_OMAP2430
 	omap2_init_memory();
-#endif
 	gpmc_init();
 }
diff --git a/include/asm-arm/arch-omap/io.h b/include/asm-arm/arch-omap/io.h
index 289082d..d2fe0d0 100644
--- a/include/asm-arm/arch-omap/io.h
+++ b/include/asm-arm/arch-omap/io.h
@@ -80,6 +80,13 @@
 #define OMAP243X_GPMC_PHYS	OMAP243X_GPMC_BASE	/* 0x49000000 */
 #define OMAP243X_GPMC_VIRT	0xFE000000
 #define OMAP243X_GPMC_SIZE	SZ_1M
+#define OMAP243X_SDRC_PHYS	OMAP24XX_SDRC_BASE
+#define OMAP243X_SDRC_VIRT	0xFD000000
+#define OMAP243X_SDRC_SIZE	SZ_1M
+#define OMAP243X_SMS_PHYS	OMAP243X_SMS_BASE
+#define OMAP243X_SMS_VIRT	0xFC000000
+#define OMAP243X_SMS_SIZE	SZ_1M
+
 #endif
 
 #define IO_OFFSET	0x90000000
diff --git a/include/asm-arm/arch-omap/omap24xx.h b/include/asm-arm/arch-omap/omap24xx.h
index 14c0f94..764329c 100644
--- a/include/asm-arm/arch-omap/omap24xx.h
+++ b/include/asm-arm/arch-omap/omap24xx.h
@@ -27,8 +27,9 @@
 #ifdef CONFIG_ARCH_OMAP2430
 #define OMAP24XX_32KSYNCT_BASE	(L4_WK_243X_BASE + 0x20000)
 #define OMAP24XX_PRCM_BASE	(L4_WK_243X_BASE + 0x6000)
-#define OMAP24XX_SDRC_BASE	(0x6D000000)
 #define OMAP242X_CONTROL_STATUS	(L4_24XX_BASE + 0x2f8)
+#define OMAP243X_SMS_BASE	0x6C000000
+#define OMAP24XX_SDRC_BASE	0x6D000000
 #define OMAP243X_GPMC_BASE	0x6E000000
 #endif
 
-- 
1.4.4.2

