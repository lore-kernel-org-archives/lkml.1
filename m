Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZA1Uih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZA1Uih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZA1U3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:44 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32960 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZA1U3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:33 -0500
MBOX-Line: From nobody Tue Jan 27 19:12:54 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 03/10] OMAP24xx clock: add missing SSI L4 interface clock
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:12:54 -0700
Message-ID: <20090128021250.7244.77061.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a missing OMAP24xx clock, the SSI L4 interface clock,
as "ssi_l4_ick".

linux-omap source commit is ace129d39b3107d330d4cf6934385d13521f2fec.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index ad6d98d..f8bed57 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -1290,6 +1290,20 @@ static struct clk ssi_ssr_sst_fck = {
 	.set_rate	= &omap2_clksel_set_rate
 };
 
+/*
+ * Presumably this is the same as SSI_ICLK.
+ * TRM contradicts itself on what clockdomain SSI_ICLK is in
+ */
+static struct clk ssi_l4_ick = {
+	.name		= "ssi_l4_ick",
+	.parent		= &l4_ck,
+	.clkdm_name	= "core_l4_clkdm",
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.enable_reg	= OMAP_CM_REGADDR(CORE_MOD, CM_ICLKEN2),
+	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
+	.recalc		= &followparent_recalc,
+};
+
 
 /*
  * GFX clock domain
@@ -2685,6 +2699,7 @@ static struct clk *onchip_24xx_clks[] __initdata = {
 	&usb_l4_ick,
 	/* L4 domain clocks */
 	&l4_ck,			/* used as both core_l4 and wu_l4 */
+	&ssi_l4_ick,
 	/* virtual meta-group clock */
 	&virt_prcm_set,
 	/* general l4 interface ck, multi-parent functional clk */


