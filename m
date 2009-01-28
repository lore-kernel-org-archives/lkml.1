Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZA1Uix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZA1Uix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZA1U3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:45 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32956 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbZA1U3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:32 -0500
MBOX-Line: From nobody Wed Jan 28 12:28:07 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 14/14] OMAP clock: rearrange clock.h structure order
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:28:07 -0700
Message-ID: <20090128192804.29333.82743.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

... to eliminate unnecessary padding.  We have rather a lot of these
structures, so eliminating unnecessary padding results in a saving of
1488 bytes.

[paul@pwsan.com: updated against current linux-omap clock tree, now saves
1512 bytes on OMAP3 builds]

linux-omap source commit is 64a423d87fae87608642c28393bb440b45e5e25e.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/include/mach/clock.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 58450a1..9d38a25 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -20,8 +20,8 @@ struct clockdomain;
 #if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 
 struct clksel_rate {
-	u8			div;
 	u32			val;
+	u8			div;
 	u8			flags;
 };
 
@@ -31,30 +31,30 @@ struct clksel {
 };
 
 struct dpll_data {
-	u16			mult_div1_reg;
 	u32			mult_mask;
 	u32			div1_mask;
-	u16			last_rounded_m;
-	u8			last_rounded_n;
 	unsigned long		last_rounded_rate;
 	unsigned int		rate_tolerance;
-	u16			max_multiplier;
-	u8			min_divider;
-	u8			max_divider;
 	u32			max_tolerance;
 	struct clk		*bypass_clk;
-	u16			control_reg;
 	u32			enable_mask;
+	u16			mult_div1_reg;
+	u16			control_reg;
+	u16			max_multiplier;
+	u16			last_rounded_m;
+	u8			last_rounded_n;
+	u8			min_divider;
+	u8			max_divider;
 #  if defined(CONFIG_ARCH_OMAP3)
-	u16			idlest_reg;
-	u32			idlest_mask;
-	u32			freqsel_mask;
 	u8			modes;
 	u8			auto_recal_bit;
 	u8			recal_en_bit;
 	u8			recal_st_bit;
 	u16			autoidle_reg;
+	u16			idlest_reg;
 	u32			autoidle_mask;
+	u32			idlest_mask;
+	u32			freqsel_mask;
 #  endif
 };
 
@@ -85,18 +85,17 @@ struct clk {
 	struct list_head	children;
 	__u32			flags;
 	u32			enable_reg;
-	__u8			enable_bit;
-	__s8			usecount;
-	u8			idlest_bit;
 	void			(*recalc)(struct clk *, unsigned long, u8);
 	int			(*set_rate)(struct clk *, unsigned long);
 	long			(*round_rate)(struct clk *, unsigned long);
 	void			(*init)(struct clk *);
 	int			(*enable)(struct clk *);
 	void			(*disable)(struct clk *);
+	__u8			enable_bit;
+	__s8			usecount;
+	u8			idlest_bit;
 #if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 	u8			fixed_div;
-	u16			clksel_reg;
 	u32			clksel_mask;
 	const struct clksel	*clksel;
 	struct dpll_data	*dpll_data;
@@ -104,6 +103,7 @@ struct clk {
 		const char		*name;
 		struct clockdomain	*ptr;
 	} clkdm;
+	u16			clksel_reg;
 	s16			prcm_mod;
 #else
 	__u8			rate_offset;


