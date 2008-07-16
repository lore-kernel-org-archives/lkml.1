Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbYGPPVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbYGPPVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYGPPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:19:08 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61108 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290AbYGPPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:19:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+iY+KWE93+r2ut6cLiAMNe
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 08/10] ARM: OMAP2: Clockdomain: Associate clocks with clockdomains
Date: Wed, 16 Jul 2008 18:19:13 +0300
Message-Id: <1216221555-18958-9-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-8-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
 <1216221555-18958-4-git-send-email-tony@atomide.com>
 <1216221555-18958-5-git-send-email-tony@atomide.com>
 <1216221555-18958-6-git-send-email-tony@atomide.com>
 <1216221555-18958-7-git-send-email-tony@atomide.com>
 <1216221555-18958-8-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Associate each OMAP24xx clock in arch/arm/mach-omap2/clock24xx.h
with a clockdomain.

Also move the L4 clock up higher in the file in preparation to
define the SSI L4 iclk.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index be4e255..242a19d 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -626,6 +626,7 @@ static struct clk func_32k_ck = {
 	.rate		= 32000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &propagate_rate,
 };
 
@@ -634,17 +635,19 @@ static struct clk osc_ck = {		/* (*12, *13, 19.2, *26, 38.4)MHz */
 	.name		= "osc_ck",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.enable		= &omap2_enable_osc_ck,
 	.disable	= &omap2_disable_osc_ck,
 	.recalc		= &omap2_osc_clk_recalc,
 };
 
-/* With out modem likely 12MHz, with modem likely 13MHz */
+/* Without modem likely 12MHz, with modem likely 13MHz */
 static struct clk sys_ck = {		/* (*12, *13, 19.2, 26, 38.4)MHz */
 	.name		= "sys_ck",		/* ~ ref_clk also */
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &omap2_sys_clk_recalc,
 };
 
@@ -653,6 +656,7 @@ static struct clk alt_ck = {		/* Typical 54M or 48M, may not exist */
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | ALWAYS_ENABLED | RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &propagate_rate,
 };
 
@@ -684,6 +688,7 @@ static struct clk dpll_ck = {
 	.dpll_data	= &dpll_dd,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | ALWAYS_ENABLED,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &omap2_dpllcore_recalc,
 	.set_rate	= &omap2_reprogram_dpllcore,
 };
@@ -694,6 +699,7 @@ static struct clk apll96_ck = {
 	.rate		= 96000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_96M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -707,6 +713,7 @@ static struct clk apll54_ck = {
 	.rate		= 54000000,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_FIXED | RATE_PROPAGATES | ENABLE_ON_INIT,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKEN),
 	.enable_bit	= OMAP24XX_EN_54M_PLL_SHIFT,
 	.enable		= &omap2_clk_fixed_enable,
@@ -741,6 +748,7 @@ static struct clk func_54m_ck = {
 	.parent		= &apll54_ck,	/* can also be alt_clk */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_54M_SOURCE,
@@ -753,6 +761,7 @@ static struct clk core_ck = {
 	.parent		= &dpll_ck,		/* can also be 32k */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -779,6 +788,7 @@ static struct clk func_96m_ck = {
 	.parent		= &apll96_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP2430_96M_SOURCE,
@@ -811,6 +821,7 @@ static struct clk func_48m_ck = {
 	.parent		= &apll96_ck,	 /* 96M or Alt */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_48M_SOURCE,
@@ -826,6 +837,7 @@ static struct clk func_12m_ck = {
 	.fixed_div	= 4,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES | PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
 
@@ -878,6 +890,7 @@ static struct clk sys_clkout_src = {
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
 	.enable_bit	= OMAP24XX_CLKOUT_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -908,6 +921,7 @@ static struct clk sys_clkout = {
 	.parent		= &sys_clkout_src,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
 	.clksel_mask	= OMAP24XX_CLKOUT_DIV_MASK,
 	.clksel		= sys_clkout_clksel,
@@ -921,6 +935,7 @@ static struct clk sys_clkout2_src = {
 	.name		= "sys_clkout2_src",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | RATE_PROPAGATES,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
 	.enable_bit	= OMAP2420_CLKOUT2_EN_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -942,6 +957,7 @@ static struct clk sys_clkout2 = {
 	.name		= "sys_clkout2",
 	.parent		= &sys_clkout2_src,
 	.flags		= CLOCK_IN_OMAP242X | PARENT_CONTROLS_CLOCK,
+	.clkdm_name	= "wkup_clkdm",
 	.clksel_reg	= OMAP24XX_PRCM_CLKOUT_CTRL,
 	.clksel_mask	= OMAP2420_CLKOUT2_DIV_MASK,
 	.clksel		= sys_clkout2_clksel,
@@ -954,6 +970,7 @@ static struct clk emul_ck = {
 	.name		= "emul_ck",
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP24XX_PRCM_CLKEMUL_CTRL,
 	.enable_bit	= OMAP24XX_EMULATION_EN_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -990,12 +1007,13 @@ static struct clk mpu_ck = {	/* Control cpu */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+	.clkdm_name	= "mpu_clkdm",
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(MPU_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP24XX_CLKSEL_MPU_MASK,
 	.clksel		= mpu_clksel,
 	.recalc		= &omap2_clksel_recalc,
-	.round_rate     = &omap2_clksel_round_rate,
+	.round_rate	= &omap2_clksel_round_rate,
 	.set_rate	= &omap2_clksel_set_rate
 };
 
@@ -1031,6 +1049,7 @@ static struct clk dsp_fck = {
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+	.clkdm_name	= "dsp_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_CLKSEL),
@@ -1054,10 +1073,7 @@ static const struct clksel dsp_irate_ick_clksel[] = {
 	{ .parent = NULL }
 };
 
-/*
- * This clock does not exist as such in the TRM, but is added to
- * separate source selection from  XXX
- */
+/* This clock does not exist as such in the TRM. */
 static struct clk dsp_irate_ick = {
 	.name		= "dsp_irate_ick",
 	.parent		= &dsp_fck,
@@ -1089,11 +1105,17 @@ static struct clk iva2_1_ick = {
 	.enable_bit	= OMAP24XX_CM_FCLKEN_DSP_EN_DSP_SHIFT,
 };
 
+/*
+ * The IVA1 is an ARM7 core on the 2420 that has nothing to do with
+ * the C54x, but which is contained in the DSP powerdomain.  Does not
+ * exist on later OMAPs.
+ */
 static struct clk iva1_ifck = {
 	.name		= "iva1_ifck",
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CONFIG_PARTICIPANT |
 				RATE_PROPAGATES | DELAYED_APP,
+	.clkdm_name	= "iva1_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_COP_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_CLKSEL),
@@ -1109,6 +1131,7 @@ static struct clk iva1_mpu_int_ifck = {
 	.name		= "iva1_mpu_int_ifck",
 	.parent		= &iva1_ifck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "iva1_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(OMAP24XX_DSP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2420_EN_IVA_MPU_SHIFT,
 	.fixed_div	= 2,
@@ -1156,6 +1179,7 @@ static struct clk core_l3_ck = {	/* Used for ick and fck, interconnect */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				ALWAYS_ENABLED | DELAYED_APP |
 				CONFIG_PARTICIPANT | RATE_PROPAGATES,
+	.clkdm_name	= "core_l3_clkdm",
 	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
 	.clksel_mask	= OMAP24XX_CLKSEL_L3_MASK,
 	.clksel		= core_l3_clksel,
@@ -1177,11 +1201,13 @@ static const struct clksel usb_l4_ick_clksel[] = {
 	{ .parent = NULL },
 };
 
+/* It is unclear from TRM whether usb_l4_ick is really in L3 or L4 clkdm */
 static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.name		= "usb_l4_ick",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP | CONFIG_PARTICIPANT,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
@@ -1193,10 +1219,42 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 };
 
 /*
+ * L4 clock management domain
+ *
+ * This domain contains lots of interface clocks from the L4 interface, some
+ * functional clocks.	Fixed APLL functional source clocks are managed in
+ * this domain.
+ */
+static const struct clksel_rate l4_core_l3_rates[] = {
+	{ .div = 1, .val = 1, .flags = RATE_IN_24XX | DEFAULT_RATE },
+	{ .div = 2, .val = 2, .flags = RATE_IN_24XX },
+	{ .div = 0 }
+};
+
+static const struct clksel l4_clksel[] = {
+	{ .parent = &core_l3_ck, .rates = l4_core_l3_rates },
+	{ .parent = NULL }
+};
+
+static struct clk l4_ck = {		/* used both as an ick and fck */
+	.name		= "l4_ck",
+	.parent		= &core_l3_ck,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
+				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
+	.clkdm_name	= "core_l4_clkdm",
+	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
+	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
+	.clksel		= l4_clksel,
+	.recalc		= &omap2_clksel_recalc,
+	.round_rate	= &omap2_clksel_round_rate,
+	.set_rate	= &omap2_clksel_set_rate
+};
+
+/*
  * SSI is in L3 management domain, its direct parent is core not l3,
  * many core power domain entities are grouped into the L3 clock
  * domain.
- * SSI_SSR_FCLK, SSI_SST_FCLK, SSI_L4_CLIK
+ * SSI_SSR_FCLK, SSI_SST_FCLK, SSI_L4_ICLK
  *
  * ssr = core/1/2/3/4/5, sst = 1/2 ssr.
  */
@@ -1221,6 +1279,7 @@ static struct clk ssi_ssr_sst_fck = {
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
@@ -1231,6 +1290,7 @@ static struct clk ssi_ssr_sst_fck = {
 	.set_rate	= &omap2_clksel_set_rate
 };
 
+
 /*
  * GFX clock domain
  *	Clocks:
@@ -1254,6 +1314,7 @@ static struct clk gfx_3d_fck = {
 	.name		= "gfx_3d_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "gfx_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_3D_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
@@ -1268,6 +1329,7 @@ static struct clk gfx_2d_fck = {
 	.name		= "gfx_2d_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "gfx_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_2D_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
@@ -1282,6 +1344,7 @@ static struct clk gfx_ick = {
 	.name		= "gfx_ick",		/* From l3 */
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "gfx_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1311,6 +1374,7 @@ static struct clk mdm_ick = {		/* used both as a ick and fck */
 	.name		= "mdm_ick",
 	.parent		= &core_ck,
 	.flags		= CLOCK_IN_OMAP243X | DELAYED_APP | CONFIG_PARTICIPANT,
+	.clkdm_name	= "mdm_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_CM_ICLKEN_MDM_EN_MDM_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_CLKSEL),
@@ -1325,52 +1389,13 @@ static struct clk mdm_osc_ck = {
 	.name		= "mdm_osc_ck",
 	.parent		= &osc_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "mdm_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(OMAP2430_MDM_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP2430_EN_OSC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
 /*
- * L4 clock management domain
- *
- * This domain contains lots of interface clocks from the L4 interface, some
- * functional clocks.	Fixed APLL functional source clocks are managed in
- * this domain.
- */
-static const struct clksel_rate l4_core_l3_rates[] = {
-	{ .div = 1, .val = 1, .flags = RATE_IN_24XX | DEFAULT_RATE },
-	{ .div = 2, .val = 2, .flags = RATE_IN_24XX },
-	{ .div = 0 }
-};
-
-static const struct clksel l4_clksel[] = {
-	{ .parent = &core_l3_ck, .rates = l4_core_l3_rates },
-	{ .parent = NULL }
-};
-
-static struct clk l4_ck = {		/* used both as an ick and fck */
-	.name		= "l4_ck",
-	.parent		= &core_l3_ck,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ALWAYS_ENABLED | DELAYED_APP | RATE_PROPAGATES,
-	.clksel_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
-	.clksel_mask	= OMAP24XX_CLKSEL_L4_MASK,
-	.clksel		= l4_clksel,
-	.recalc		= &omap2_clksel_recalc,
-	.round_rate	= &omap2_clksel_round_rate,
-	.set_rate	= &omap2_clksel_set_rate
-};
-
-static struct clk ssi_l4_ick = {
-	.name		= "ssi_l4_ick",
-	.parent		= &l4_ck,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
-	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
-	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
-	.recalc		= &followparent_recalc,
-};
-
-/*
  * DSS clock domain
  * CLOCKs:
  * DSS_L4_ICLK, DSS_L3_ICLK,
@@ -1409,6 +1434,7 @@ static struct clk dss_ick = {		/* Enables both L3,L4 ICLK's */
 	.name		= "dss_ick",
 	.parent		= &l4_ck,	/* really both l3 and l4 */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "dss_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1419,6 +1445,7 @@ static struct clk dss1_fck = {
 	.parent		= &core_ck,		/* Core or sys */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
+	.clkdm_name	= "dss_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1451,6 +1478,7 @@ static struct clk dss2_fck = {		/* Alt clk used in power management */
 	.parent		= &sys_ck,		/* fixed at sys_ck or 48MHz */
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
 				DELAYED_APP,
+	.clkdm_name	= "dss_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_DSS2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1464,6 +1492,7 @@ static struct clk dss_54m_fck = {	/* Alt clk used in power management */
 	.name		= "dss_54m_fck",	/* 54m tv clk */
 	.parent		= &func_54m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "dss_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_TV_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1491,6 +1520,7 @@ static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1500,6 +1530,7 @@ static struct clk gpt1_fck = {
 	.name		= "gpt1_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1515,6 +1546,7 @@ static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1524,6 +1556,7 @@ static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1537,6 +1570,7 @@ static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1546,6 +1580,7 @@ static struct clk gpt3_fck = {
 	.name		= "gpt3_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1559,6 +1594,7 @@ static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1568,6 +1604,7 @@ static struct clk gpt4_fck = {
 	.name		= "gpt4_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1581,6 +1618,7 @@ static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1590,6 +1628,7 @@ static struct clk gpt5_fck = {
 	.name		= "gpt5_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1603,6 +1642,7 @@ static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1612,6 +1652,7 @@ static struct clk gpt6_fck = {
 	.name		= "gpt6_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1634,6 +1675,7 @@ static struct clk gpt7_fck = {
 	.name		= "gpt7_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1647,6 +1689,7 @@ static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1656,6 +1699,7 @@ static struct clk gpt8_fck = {
 	.name		= "gpt8_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1669,6 +1713,7 @@ static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1678,6 +1723,7 @@ static struct clk gpt9_fck = {
 	.name		= "gpt9_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1691,6 +1737,7 @@ static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1700,6 +1747,7 @@ static struct clk gpt10_fck = {
 	.name		= "gpt10_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1713,6 +1761,7 @@ static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1722,6 +1771,7 @@ static struct clk gpt11_fck = {
 	.name		= "gpt11_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1735,6 +1785,7 @@ static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1744,6 +1795,7 @@ static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -1758,6 +1810,7 @@ static struct clk mcbsp1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1768,6 +1821,7 @@ static struct clk mcbsp1_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1778,6 +1832,7 @@ static struct clk mcbsp2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1788,6 +1843,7 @@ static struct clk mcbsp2_fck = {
 	.id		= 2,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1798,6 +1854,7 @@ static struct clk mcbsp3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1808,6 +1865,7 @@ static struct clk mcbsp3_fck = {
 	.id		= 3,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1818,6 +1876,7 @@ static struct clk mcbsp4_ick = {
 	.id		= 4,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1828,6 +1887,7 @@ static struct clk mcbsp4_fck = {
 	.id		= 4,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1838,6 +1898,7 @@ static struct clk mcbsp5_ick = {
 	.id		= 5,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1848,6 +1909,7 @@ static struct clk mcbsp5_fck = {
 	.id		= 5,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1857,6 +1919,7 @@ static struct clk mcspi1_ick = {
 	.name		= "mcspi_ick",
 	.id		= 1,
 	.parent		= &l4_ck,
+	.clkdm_name	= "core_l4_clkdm",
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
@@ -1868,6 +1931,7 @@ static struct clk mcspi1_fck = {
 	.id		= 1,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1878,6 +1942,7 @@ static struct clk mcspi2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1888,6 +1953,7 @@ static struct clk mcspi2_fck = {
 	.id		= 2,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1898,6 +1964,7 @@ static struct clk mcspi3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1908,6 +1975,7 @@ static struct clk mcspi3_fck = {
 	.id		= 3,
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1917,6 +1985,7 @@ static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1926,6 +1995,7 @@ static struct clk uart1_fck = {
 	.name		= "uart1_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1935,6 +2005,7 @@ static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1944,6 +2015,7 @@ static struct clk uart2_fck = {
 	.name		= "uart2_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1953,6 +2025,7 @@ static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1962,6 +2035,7 @@ static struct clk uart3_fck = {
 	.name		= "uart3_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1971,6 +2045,7 @@ static struct clk gpios_ick = {
 	.name		= "gpios_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1980,6 +2055,7 @@ static struct clk gpios_fck = {
 	.name		= "gpios_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1989,6 +2065,7 @@ static struct clk mpu_wdt_ick = {
 	.name		= "mpu_wdt_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -1998,6 +2075,7 @@ static struct clk mpu_wdt_fck = {
 	.name		= "mpu_wdt_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "wkup_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2006,31 +2084,40 @@ static struct clk mpu_wdt_fck = {
 static struct clk sync_32k_ick = {
 	.name		= "sync_32k_ick",
 	.parent		= &l4_ck,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
+				ENABLE_ON_INIT,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_32KSYNC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
+
 static struct clk wdt1_ick = {
 	.name		= "wdt1_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
+
 static struct clk omapctrl_ick = {
 	.name		= "omapctrl_ick",
 	.parent		= &l4_ck,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
+				ENABLE_ON_INIT,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP24XX_EN_OMAPCTRL_SHIFT,
 	.recalc		= &followparent_recalc,
 };
+
 static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP2430_EN_ICR_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2040,15 +2127,22 @@ static struct clk cam_ick = {
 	.name		= "cam_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
+/*
+ * cam_fck controls both CAM_MCLK and CAM_FCLK.  It should probably be
+ * split into two separate clocks, since the parent clocks are different
+ * and the clockdomains are also different.
+ */
 static struct clk cam_fck = {
 	.name		= "cam_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_CAM_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2058,6 +2152,7 @@ static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MAILBOXES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2067,6 +2162,7 @@ static struct clk wdt4_ick = {
 	.name		= "wdt4_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2076,6 +2172,7 @@ static struct clk wdt4_fck = {
 	.name		= "wdt4_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2085,6 +2182,7 @@ static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2094,6 +2192,7 @@ static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2103,6 +2202,7 @@ static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2112,6 +2212,7 @@ static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2121,6 +2222,7 @@ static struct clk mmc_ick = {
 	.name		= "mmc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2130,6 +2232,7 @@ static struct clk mmc_fck = {
 	.name		= "mmc_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2139,6 +2242,7 @@ static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2148,6 +2252,7 @@ static struct clk fac_fck = {
 	.name		= "fac_fck",
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2157,6 +2262,7 @@ static struct clk eac_ick = {
 	.name		= "eac_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2166,6 +2272,7 @@ static struct clk eac_fck = {
 	.name		= "eac_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2175,6 +2282,7 @@ static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2184,6 +2292,7 @@ static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2194,6 +2303,7 @@ static struct clk i2c2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2204,6 +2314,7 @@ static struct clk i2c2_fck = {
 	.id		= 2,
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2214,6 +2325,7 @@ static struct clk i2chs2_fck = {
 	.id		= 2,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2224,6 +2336,7 @@ static struct clk i2c1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2234,6 +2347,7 @@ static struct clk i2c1_fck = {
 	.id		= 1,
 	.parent		= &func_12m_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2244,6 +2358,7 @@ static struct clk i2chs1_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_I2CHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2252,7 +2367,9 @@ static struct clk i2chs1_fck = {
 static struct clk gpmc_fck = {
 	.name		= "gpmc_fck",
 	.parent		= &core_l3_ck,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
+				ENABLE_ON_INIT,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2260,6 +2377,7 @@ static struct clk sdma_fck = {
 	.name		= "sdma_fck",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2267,6 +2385,7 @@ static struct clk sdma_ick = {
 	.name		= "sdma_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l3_clkdm",
 	.recalc		= &followparent_recalc,
 };
 
@@ -2274,6 +2393,7 @@ static struct clk vlynq_ick = {
 	.name		= "vlynq_ick",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2308,6 +2428,7 @@ static struct clk vlynq_fck = {
 	.name		= "vlynq_fck",
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
 	.init		= &omap2_init_clksel_parent,
@@ -2323,6 +2444,7 @@ static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN3),
 	.enable_bit	= OMAP2430_EN_SDRC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2332,6 +2454,7 @@ static struct clk des_ick = {
 	.name		= "des_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_DES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2341,6 +2464,7 @@ static struct clk sha_ick = {
 	.name		= "sha_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_SHA_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2350,6 +2474,7 @@ static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_RNG_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2359,6 +2484,7 @@ static struct clk aes_ick = {
 	.name		= "aes_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_AES_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2368,6 +2494,7 @@ static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_ICLKEN4),
 	.enable_bit	= OMAP24XX_EN_PKA_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2377,6 +2504,7 @@ static struct clk usb_fck = {
 	.name		= "usb_fck",
 	.parent		= &func_48m_ck,
 	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2386,6 +2514,7 @@ static struct clk usbhs_ick = {
 	.name		= "usbhs_ick",
 	.parent		= &core_l3_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_USBHS_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2396,6 +2525,7 @@ static struct clk mmchs1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2406,6 +2536,7 @@ static struct clk mmchs1_fck = {
 	.id		= 1,
 	.parent		= &func_96m_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l3_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2416,6 +2547,7 @@ static struct clk mmchs2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2435,6 +2567,7 @@ static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2444,6 +2577,7 @@ static struct clk gpio5_fck = {
 	.name		= "gpio5_fck",
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2453,6 +2587,7 @@ static struct clk mdm_intc_ick = {
 	.name		= "mdm_intc_ick",
 	.parent		= &l4_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
 	.enable_bit	= OMAP2430_EN_MDM_INTC_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2463,6 +2598,7 @@ static struct clk mmchsdb1_fck = {
 	.id		= 1,
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB1_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2473,6 +2609,7 @@ static struct clk mmchsdb2_fck = {
 	.id		= 2,
 	.parent		= &func_32k_ck,
 	.flags		= CLOCK_IN_OMAP243X,
+	.clkdm_name	= "core_l4_clkdm",
 	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, OMAP24XX_CM_FCLKEN2),
 	.enable_bit	= OMAP2430_EN_MMCHSDB2_SHIFT,
 	.recalc		= &followparent_recalc,
@@ -2551,7 +2688,6 @@ static struct clk *onchip_24xx_clks[] __initdata = {
 	&usb_l4_ick,
 	/* L4 domain clocks */
 	&l4_ck,			/* used as both core_l4 and wu_l4 */
-	&ssi_l4_ick,
 	/* virtual meta-group clock */
 	&virt_prcm_set,
 	/* general l4 interface ck, multi-parent functional clk */
