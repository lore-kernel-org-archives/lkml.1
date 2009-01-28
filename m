Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZA1UoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZA1UoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZA1Uat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:49 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33009 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbZA1Uak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:40 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:18 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 04/10] OMAP3 PRCM: add DPLL1-5 powerdomains, clockdomains;
	mark clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:18 -0700
Message-ID: <20090128024415.27240.58514.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each DPLL exists in its own powerdomain (cf 34xx TRM figure 4-18) and
clockdomain; so, create powerdomain and clockdomain structures for them.
Mark each DPLL clock as belonging to their respective DPLL clockdomain.
cf. 34xx TRM Table 4-27 (among other references).

linux-omap source commits are acdb615850b9b4f7d1ab68133a16be8c8c0e7419 and
a8798a48f33e9268dcc7f30a4b4a3ce4220fe0c9.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h        |   27 +++++++++++++++++++++++++
 arch/arm/mach-omap2/clockdomains.h     |   35 ++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/powerdomains.h     |    5 +++++
 arch/arm/mach-omap2/powerdomains34xx.h |   31 ++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index ca432e0..e1650f2 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -316,6 +316,7 @@ static struct clk dpll1_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
+	.clkdm		= { .name = "dpll1_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -328,6 +329,7 @@ static struct clk dpll1_x2_ck = {
 	.parent		= &dpll1_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll1_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -350,6 +352,7 @@ static struct clk dpll1_x2m2_ck = {
 	.clksel		= div16_dpll1_x2m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll1_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -387,6 +390,7 @@ static struct clk dpll2_ck = {
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
+	.clkdm		= { .name = "dpll2_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -409,6 +413,7 @@ static struct clk dpll2_m2_ck = {
 	.clksel		= div16_dpll2_m2x2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll2_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -440,6 +445,7 @@ static struct clk dpll3_ck = {
 	.dpll_data	= &dpll3_dd,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | ALWAYS_ENABLED,
 	.round_rate	= &omap2_dpll_round_rate,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -452,6 +458,7 @@ static struct clk dpll3_x2_ck = {
 	.parent		= &dpll3_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -509,6 +516,7 @@ static struct clk dpll3_m2_ck = {
 	.clksel		= div31_dpll3m2_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -544,6 +552,7 @@ static struct clk dpll3_m2x2_ck = {
 	.clksel		= dpll3_m2x2_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -563,6 +572,7 @@ static struct clk dpll3_m3_ck = {
 	.clksel		= div16_dpll3_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -573,6 +583,7 @@ static struct clk dpll3_m3x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_EMU_CORE_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -591,6 +602,7 @@ static struct clk emu_core_alwon_ck = {
 	.clksel		= emu_core_alwon_ck_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll3_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -626,6 +638,7 @@ static struct clk dpll4_ck = {
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -639,6 +652,7 @@ static struct clk dpll4_x2_ck = {
 	.parent		= &dpll4_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -657,6 +671,7 @@ static struct clk dpll4_m2_ck = {
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -667,6 +682,7 @@ static struct clk dpll4_m2x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_96M_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -743,6 +759,7 @@ static struct clk dpll4_m3_ck = {
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -754,6 +771,7 @@ static struct clk dpll4_m3x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_TV_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -852,6 +870,7 @@ static struct clk dpll4_m4_ck = {
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 	.set_rate	= &omap2_clksel_set_rate,
 	.round_rate	= &omap2_clksel_round_rate,
@@ -864,6 +883,7 @@ static struct clk dpll4_m4x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -877,6 +897,7 @@ static struct clk dpll4_m5_ck = {
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -887,6 +908,7 @@ static struct clk dpll4_m5x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_CAM_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -900,6 +922,7 @@ static struct clk dpll4_m6_ck = {
 	.clksel		= div16_dpll4_clksel,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
@@ -911,6 +934,7 @@ static struct clk dpll4_m6x2_ck = {
 	.enable_reg	= _OMAP34XX_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP3430_PWRDN_EMU_PERIPH_SHIFT,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | INVERT_ENABLE,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &omap3_clkoutx2_recalc,
 };
 
@@ -919,6 +943,7 @@ static struct clk emu_per_alwon_ck = {
 	.parent		= &dpll4_m6x2_ck,
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
@@ -955,6 +980,7 @@ static struct clk dpll5_ck = {
 	.disable	= &omap3_noncore_dpll_disable,
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
+	.clkdm		= { .name = "dpll5_clkdm" },
 	.recalc		= &omap3_dpll_recalc,
 };
 
@@ -972,6 +998,7 @@ static struct clk dpll5_m2_ck = {
 	.clksel		= div16_dpll5_clksel,
 	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "dpll5_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index e8320ee..bafa650 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -259,6 +259,36 @@ static struct clockdomain emu_clkdm = {
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
 };
 
+static struct clockdomain dpll1_clkdm = {
+	.name		= "dpll1_clkdm",
+	.pwrdm		= { .name = "dpll1_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain dpll2_clkdm = {
+	.name		= "dpll2_clkdm",
+	.pwrdm		= { .name = "dpll2_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain dpll3_clkdm = {
+	.name		= "dpll3_clkdm",
+	.pwrdm		= { .name = "dpll3_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain dpll4_clkdm = {
+	.name		= "dpll4_clkdm",
+	.pwrdm		= { .name = "dpll4_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct clockdomain dpll5_clkdm = {
+	.name		= "dpll5_clkdm",
+	.pwrdm		= { .name = "dpll5_pwrdm" },
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+};
+
 #endif   /* CONFIG_ARCH_OMAP34XX */
 
 /*
@@ -321,6 +351,11 @@ static struct clockdomain *clockdomains_omap[] = {
 	&usbhost_clkdm,
 	&per_clkdm,
 	&emu_clkdm,
+	&dpll1_clkdm,
+	&dpll2_clkdm,
+	&dpll3_clkdm,
+	&dpll4_clkdm,
+	&dpll5_clkdm,
 #endif
 
 	NULL,
diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
index 1e151fa..1329443 100644
--- a/arch/arm/mach-omap2/powerdomains.h
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -178,6 +178,11 @@ static struct powerdomain *powerdomains_omap[] __initdata = {
 	&emu_pwrdm,
 	&sgx_pwrdm,
 	&usbhost_pwrdm,
+	&dpll1_pwrdm,
+	&dpll2_pwrdm,
+	&dpll3_pwrdm,
+	&dpll4_pwrdm,
+	&dpll5_pwrdm,
 #endif
 
 	NULL
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index 3a8e4fb..7b63fa0 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -322,6 +322,37 @@ static struct powerdomain usbhost_pwrdm = {
 	},
 };
 
+static struct powerdomain dpll1_pwrdm = {
+	.name		= "dpll1_pwrdm",
+	.prcm_offs	= MPU_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct powerdomain dpll2_pwrdm = {
+	.name		= "dpll2_pwrdm",
+	.prcm_offs	= OMAP3430_IVA2_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct powerdomain dpll3_pwrdm = {
+	.name		= "dpll3_pwrdm",
+	.prcm_offs	= PLL_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct powerdomain dpll4_pwrdm = {
+	.name		= "dpll4_pwrdm",
+	.prcm_offs	= PLL_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct powerdomain dpll5_pwrdm = {
+	.name		= "dpll5_pwrdm",
+	.prcm_offs	= PLL_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+};
+
+
 #endif    /* CONFIG_ARCH_OMAP34XX */
 
 


