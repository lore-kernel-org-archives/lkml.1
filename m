Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbXDIVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbXDIVjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966039AbXDIVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:32:38 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33858 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966014AbXDIVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:25 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@mvista.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 16/18] ARM: OMAP: 243x: Add mappings for SDRC and SMS
Date: Mon,  9 Apr 2007 17:30:59 -0400
Message-Id: <11761543231102-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761543144181-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com> <1176154308509-git-send-email-tony@atomide.com> <1176154311389-git-send-email-tony@atomide.com> <11761543144181-git-send-email-tony@atomide.com>
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

Index: linux-2.6/arch/arm/mach-omap2/io.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/io.c	2007-04-09 15:34:44.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/io.c	2007-04-09 15:34:49.000000000 -0400
@@ -55,6 +55,18 @@ static struct map_desc omap2_io_desc[] _
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
@@ -96,11 +108,6 @@ void __init omap2_init_common_hw(void)
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
Index: linux-2.6/include/asm-arm/arch-omap/io.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/io.h	2007-04-09 15:34:44.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/io.h	2007-04-09 15:34:49.000000000 -0400
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
Index: linux-2.6/include/asm-arm/arch-omap/omap24xx.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/omap24xx.h	2007-04-09 15:34:44.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/omap24xx.h	2007-04-09 15:34:49.000000000 -0400
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
 
