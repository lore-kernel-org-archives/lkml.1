Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZA1U2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZA1U2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZA1U10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:27:26 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60900 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZA1U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:24 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:16 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 01/11] OMAP: Add clk_get_parent() for OMAP2/3
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org,
       =?utf-8?b?TcOlbnM=?= =?utf-8?b?UnVsbGfDpXJk?= <mans@mansr.com>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:18:16 -0700
Message-ID: <20090128191807.16688.91255.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

This makes clk_get_parent() work on OMAP2/3.

linux-omap source commit is efd65273726b12e42c7225bd1703e5252bdb46c0.

Signed-off-by: Måns Rullgård <mans@mansr.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c     |    5 +++++
 arch/arm/mach-omap2/clock.h     |    1 +
 arch/arm/mach-omap2/clock24xx.c |    1 +
 arch/arm/mach-omap2/clock34xx.c |    1 +
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index e57694f..9957813 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -870,6 +870,11 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	return 0;
 }
 
+struct clk *omap2_clk_get_parent(struct clk *clk)
+{
+	return clk->parent;
+}
+
 /* DPLL rate rounding code */
 
 /**
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 72bb320..4dbd582 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -44,6 +44,7 @@ int omap2_clk_set_rate(struct clk *clk, unsigned long rate);
 int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent);
 int omap2_dpll_set_rate_tolerance(struct clk *clk, unsigned int tolerance);
 long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate);
+struct clk *omap2_clk_get_parent(struct clk *clk);
 
 #ifdef CONFIG_OMAP_RESET_CLOCKS
 void omap2_clk_disable_unused(struct clk *clk);
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index a2c13ef..2398711 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -436,6 +436,7 @@ static struct clk_functions omap2_clk_functions = {
 	.clk_round_rate		= omap2_clk_round_rate,
 	.clk_set_rate		= omap2_clk_set_rate,
 	.clk_set_parent		= omap2_clk_set_parent,
+	.clk_get_parent		= omap2_clk_get_parent,
 	.clk_disable_unused	= omap2_clk_disable_unused,
 #ifdef	CONFIG_CPU_FREQ
 	.clk_init_cpufreq_table	= omap2_clk_init_cpufreq_table,
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 33d5a51..0c8d88e 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -565,6 +565,7 @@ static struct clk_functions omap2_clk_functions = {
 	.clk_round_rate		= omap2_clk_round_rate,
 	.clk_set_rate		= omap2_clk_set_rate,
 	.clk_set_parent		= omap2_clk_set_parent,
+	.clk_get_parent		= omap2_clk_get_parent,
 	.clk_disable_unused	= omap2_clk_disable_unused,
 };
 


