Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZA1UiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZA1UiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZA1U3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32949 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZA1U3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:32 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:53 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 09/14] OMAP2/3 clock: drop recalc function pointers from
	fixed rate clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:53 -0700
Message-ID: <20090128192751.29333.10463.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rate recalculation and rate propagation are two separate
operations, drop recalc function pointers from all fixed rate clocks.
Their rates are fixed, so there's no need to recalculate.

linux-omap source commit is 5e96093d1f7f2ff27ba61f4174f429ddca15a4b9.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.h |    4 ----
 arch/arm/mach-omap2/clock34xx.h |   10 ----------
 arch/arm/plat-omap/clock.c      |   18 ++++++++++--------
 3 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 929a257..30f3c57 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -627,7 +627,6 @@ static struct clk func_32k_ck = {
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 /* Typical 12/13MHz in standalone mode, will be 26Mhz in chassis mode */
@@ -657,7 +656,6 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 /*
@@ -709,7 +707,6 @@ static struct clk apll96_ck = {
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
-	.recalc		= &propagate_rate,
 };
 
 static struct clk apll54_ck = {
@@ -724,7 +721,6 @@ static struct clk apll54_ck = {
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
 	.disable	= &omap2_clk_fixed_disable,
-	.recalc		= &propagate_rate,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 5357507..66cbe0c 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -67,7 +67,6 @@ static struct clk omap_32k_fck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk secure_32k_fck = {
@@ -76,7 +75,6 @@ static struct clk secure_32k_fck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 /* Virtual source clocks for osc_sys_ck */
@@ -86,7 +84,6 @@ static struct clk virt_12m_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk virt_13m_ck = {
@@ -95,7 +92,6 @@ static struct clk virt_13m_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk virt_16_8m_ck = {
@@ -104,7 +100,6 @@ static struct clk virt_16_8m_ck = {
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk virt_19_2m_ck = {
@@ -113,7 +108,6 @@ static struct clk virt_19_2m_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk virt_26m_ck = {
@@ -122,7 +116,6 @@ static struct clk virt_26m_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static struct clk virt_38_4m_ck = {
@@ -131,7 +124,6 @@ static struct clk virt_38_4m_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_FIXED | RATE_PROPAGATES |
 				ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 static const struct clksel_rate osc_sys_12m_rates[] = {
@@ -220,7 +212,6 @@ static struct clk sys_altclk = {
 	.name		= "sys_altclk",
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.clkdm		= { .name = "cm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 /*
@@ -232,7 +223,6 @@ static struct clk mcbsp_clks = {
 	.name		= "mcbsp_clks",
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.clkdm		= { .name = "prm_clkdm" },
-	.recalc		= &propagate_rate,
 };
 
 /* PRM EXTERNAL CLOCK OUTPUT */
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index c60548a..4cf1145 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -187,7 +187,8 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (arch_clock->clk_set_rate) {
 		ret = arch_clock->clk_set_rate(clk, rate);
 		if (ret == 0) {
-			(*clk->recalc)(clk);
+			if (clk->recalc)
+				(*clk->recalc)(clk);
 			if (clk->flags & RATE_PROPAGATES)
 				propagate_rate(clk);
 		}
@@ -212,7 +213,8 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (arch_clock->clk_set_parent) {
 		ret = arch_clock->clk_set_parent(clk, parent);
 		if (ret == 0) {
-			(*clk->recalc)(clk);
+			if (clk->recalc)
+				(*clk->recalc)(clk);
 			if (clk->flags & RATE_PROPAGATES)
 				propagate_rate(clk);
 		}
@@ -285,11 +287,10 @@ void propagate_rate(struct clk * tclk)
 	list_for_each_entry(clkp, &clocks, node) {
 		if (likely(clkp->parent != tclk))
 			continue;
-		if (likely((u32)clkp->recalc)) {
+		if (clkp->recalc)
 			clkp->recalc(clkp);
-			if (clkp->flags & RATE_PROPAGATES)
-				propagate_rate(clkp);
-		}
+		if (clkp->flags & RATE_PROPAGATES)
+			propagate_rate(clkp);
 	}
 }
 
@@ -305,8 +306,9 @@ void recalculate_root_clocks(void)
 	struct clk *clkp;
 
 	list_for_each_entry(clkp, &clocks, node) {
-		if (unlikely(!clkp->parent) && likely((u32)clkp->recalc)) {
-			clkp->recalc(clkp);
+		if (unlikely(!clkp->parent)) {
+			if (clkp->recalc)
+				clkp->recalc(clkp);
 			if (clkp->flags & RATE_PROPAGATES)
 				propagate_rate(clkp);
 		}


