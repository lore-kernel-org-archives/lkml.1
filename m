Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZA1Udt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZA1Udt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZA1U3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:20 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32864 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbZA1U3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:15 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:34 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 02/14] OMAP2 SDRC: rename memory.c to sdrc2xxx.c
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:34 -0700
Message-ID: <20090128192731.29333.95754.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename arch/arm/mach-omap2/memory.c to arch/arm/mach-omap2/sdrc2xxx.c, since
it contains exclusively SDRAM-related functions.  Most of the functions
are also OMAP2xxx-specific - those which are common will be separated out
in a following patch.

linux-omap source commit is fe212f797e2efef9dc88bcb5db7cf9db3f9f562e.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile   |    2 +-
 arch/arm/mach-omap2/sdrc2xxx.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)
 rename arch/arm/mach-omap2/{memory.c => sdrc2xxx.c} (95%)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index bbd12bc..bb47d43 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y := irq.o id.o io.o memory.o control.o prcm.o clock.o mux.o \
+obj-y := irq.o id.o io.o sdrc2xxx.o control.o prcm.o clock.o mux.o \
 		devices.o serial.o gpmc.o timer-gp.o powerdomain.o \
 		clockdomain.o
 
diff --git a/arch/arm/mach-omap2/memory.c b/arch/arm/mach-omap2/sdrc2xxx.c
similarity index 95%
rename from arch/arm/mach-omap2/memory.c
rename to arch/arm/mach-omap2/sdrc2xxx.c
index 62a87cf..c636228 100644
--- a/arch/arm/mach-omap2/memory.c
+++ b/arch/arm/mach-omap2/sdrc2xxx.c
@@ -1,7 +1,7 @@
 /*
- * linux/arch/arm/mach-omap2/memory.c
+ * linux/arch/arm/mach-omap2/sdrc2xxx.c
  *
- * Memory timing related functions for OMAP24XX
+ * SDRAM timing related functions for OMAP2xxx
  *
  * Copyright (C) 2005 Texas Instruments Inc.
  * Richard Woodruff <r-woodruff2@ti.com>
@@ -91,19 +91,18 @@ u32 omap2_reprogram_sdrc(u32 level, u32 force)
 	if ((curr_perf_level == level) && !force)
 		return prev;
 
-	if (level == CORE_CLK_SRC_DPLL) {
+	if (level == CORE_CLK_SRC_DPLL)
 		dll_ctrl = omap2_memory_get_slow_dll_ctrl();
-	} else if (level == CORE_CLK_SRC_DPLL_X2) {
+	else if (level == CORE_CLK_SRC_DPLL_X2)
 		dll_ctrl = omap2_memory_get_fast_dll_ctrl();
-	} else {
+	else
 		return prev;
-	}
 
 	m_type = omap2_memory_get_type();
 
 	local_irq_save(flags);
 	prm_write_mod_reg(0xffff, OMAP24XX_GR_MOD,
-					OMAP24XX_PRCM_VOLTSETUP_OFFSET);
+			  OMAP24XX_PRCM_VOLTSETUP_OFFSET);
 	omap2_sram_reprogram_sdrc(level, dll_ctrl, m_type);
 	curr_perf_level = level;
 	local_irq_restore(flags);
@@ -127,7 +126,8 @@ void omap2_init_memory_params(u32 force_lock_to_unlock_mode)
 	unsigned long dll_cnt;
 	u32 fast_dll = 0;
 
-	mem_timings.m_type = !((sdrc_read_reg(SDRC_MR_0) & 0x3) == 0x1); /* DDR = 1, SDR = 0 */
+	/* DDR = 1, SDR = 0 */
+	mem_timings.m_type = !((sdrc_read_reg(SDRC_MR_0) & 0x3) == 0x1);
 
 	/* 2422 es2.05 and beyond has a single SIP DDR instead of 2 like others.
 	 * In the case of 2422, its ok to use CS1 instead of CS0.


