Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZA1Ulo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZA1Ulo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZA1UaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:13 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32996 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbZA1UaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:10 -0500
MBOX-Line: From nobody Tue Jan 27 19:13:05 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 06/10] OMAP2: Fix definition of SGX clock register bits
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Daniel Stone <daniel.stone@nokia.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:13:05 -0700
Message-ID: <20090128021302.7244.33650.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stone <daniel.stone@nokia.com>

The GFX/SGX functional and interface clocks have different masks, for
some unknown reason, so split EN_SGX_SHIFT into one each for fclk and
iclk.

Correct according to the TRM and the far more important 'does this
actually work at all?' metric.

linux-omap source commit is de1121fdb899f762b9e717f44eaf3fae7c00cd3e.

Signed-off-by: Daniel Stone <daniel.stone@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h       |    4 ++--
 arch/arm/mach-omap2/cm-regbits-34xx.h |    8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index f8c9885..63adfab 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1293,7 +1293,7 @@ static struct clk sgx_fck = {
 	.name		= "sgx_fck",
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_FCLKEN),
-	.enable_bit	= OMAP3430ES2_EN_SGX_SHIFT,
+	.enable_bit	= OMAP3430ES2_CM_FCLKEN_SGX_EN_SGX_SHIFT,
 	.clksel_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP3430ES2_CLKSEL_SGX_MASK,
 	.clksel		= sgx_clksel,
@@ -1307,7 +1307,7 @@ static struct clk sgx_ick = {
 	.parent		= &l3_ick,
 	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_SGX_MOD, CM_ICLKEN),
-	.enable_bit	= OMAP3430ES2_EN_SGX_SHIFT,
+	.enable_bit	= OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_SHIFT,
 	.flags		= CLOCK_IN_OMAP3430ES2,
 	.clkdm_name	= "sgx_clkdm",
 	.recalc		= &followparent_recalc,
diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index a46f93c..f3c327b 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -332,8 +332,12 @@
 #define OMAP3430ES1_CLKACTIVITY_GFX_MASK		(1 << 0)
 
 /* CM_FCLKEN_SGX */
-#define OMAP3430ES2_EN_SGX_SHIFT			1
-#define OMAP3430ES2_EN_SGX_MASK				(1 << 1)
+#define OMAP3430ES2_CM_FCLKEN_SGX_EN_SGX_SHIFT		1
+#define OMAP3430ES2_CM_FCLKEN_SGX_EN_SGX_MASK		(1 << 1)
+
+/* CM_ICLKEN_SGX */
+#define OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_SHIFT		0
+#define OMAP3430ES2_CM_ICLKEN_SGX_EN_SGX_MASK		(1 << 0)
 
 /* CM_CLKSEL_SGX */
 #define OMAP3430ES2_CLKSEL_SGX_SHIFT			0


