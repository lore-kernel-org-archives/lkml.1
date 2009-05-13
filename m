Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZEMAJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZEMAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZEMAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:48 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56428 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbZEMAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:45 -0400
MBOX-Line: From nobody Tue May 12 18:05:25 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 08/10] OMAP3 clock: use pr_debug() rather than pr_info() in
	some clock change code
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:25 -0600
Message-ID: <20090513000522.10349.51723.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CORE DPLL M2 frequency change code should use pr_debug(), not
pr_info(), for its debug messages.  Same with
omap2_clksel_round_rate_div().  While here, convert a few printk(KERN_ERR ..
into pr_err().

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clock.c     |   12 ++++++------
 arch/arm/mach-omap2/clock34xx.c |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 4247a15..8935a8b 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -547,8 +547,8 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 	const struct clksel_rate *clkr;
 	u32 last_div = 0;
 
-	printk(KERN_INFO "clock: clksel_round_rate_div: %s target_rate %ld\n",
-	       clk->name, target_rate);
+	pr_debug("clock: clksel_round_rate_div: %s target_rate %ld\n",
+		 clk->name, target_rate);
 
 	*new_div = 1;
 
@@ -562,7 +562,7 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 
 		/* Sanity check */
 		if (clkr->div <= last_div)
-			printk(KERN_ERR "clock: clksel_rate table not sorted "
+			pr_err("clock: clksel_rate table not sorted "
 			       "for clock %s", clk->name);
 
 		last_div = clkr->div;
@@ -574,7 +574,7 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 	}
 
 	if (!clkr->div) {
-		printk(KERN_ERR "clock: Could not find divisor for target "
+		pr_err("clock: Could not find divisor for target "
 		       "rate %ld for clock %s parent %s\n", target_rate,
 		       clk->name, clk->parent->name);
 		return ~0;
@@ -582,8 +582,8 @@ u32 omap2_clksel_round_rate_div(struct clk *clk, unsigned long target_rate,
 
 	*new_div = clkr->div;
 
-	printk(KERN_INFO "clock: new_div = %d, new_rate = %ld\n", *new_div,
-	       (clk->parent->rate / clkr->div));
+	pr_debug("clock: new_div = %d, new_rate = %ld\n", *new_div,
+		 (clk->parent->rate / clkr->div));
 
 	return (clk->parent->rate / clkr->div);
 }
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 811360a..2ee58fa 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -737,10 +737,10 @@ static int omap3_core_dpll_m2_set_rate(struct clk *clk, unsigned long rate)
 		unlock_dll = 1;
 	}
 
-	pr_info("clock: changing CORE DPLL rate from %lu to %lu\n", clk->rate,
-		validrate);
-	pr_info("clock: SDRC timing params used: %08x %08x %08x\n",
-		sp->rfr_ctrl, sp->actim_ctrla, sp->actim_ctrlb);
+	pr_debug("clock: changing CORE DPLL rate from %lu to %lu\n", clk->rate,
+		 validrate);
+	pr_debug("clock: SDRC timing params used: %08x %08x %08x\n",
+		 sp->rfr_ctrl, sp->actim_ctrla, sp->actim_ctrlb);
 
 	/* REVISIT: SRAM code doesn't support other M2 divisors yet */
 	WARN_ON(new_div != 1 && new_div != 2);


