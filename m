Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZEMAKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZEMAKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZEMAHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:51 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56456 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbZEMAHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:49 -0400
MBOX-Line: From nobody Tue May 12 18:05:31 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 10/10] OMAP2xxx clock: rename clk_init_one() to clk_preinit()
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:31 -0600
Message-ID: <20090513000527.10349.36883.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename clk_init_one() to clk_preinit() to distinguish its function
from clk_init() and the individual struct clk init functions.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap1/clock.c             |    2 +-
 arch/arm/mach-omap2/clock24xx.c         |    2 +-
 arch/arm/mach-omap2/clock34xx.c         |    2 +-
 arch/arm/plat-omap/clock.c              |    4 ++--
 arch/arm/plat-omap/include/mach/clock.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 336e51d..436eed2 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -776,7 +776,7 @@ int __init omap1_clk_init(void)
 	arm_idlect1_mask = ~0;
 
 	for (c = omap_clks; c < omap_clks + ARRAY_SIZE(omap_clks); c++)
-		clk_init_one(c->lk.clk);
+		clk_preinit(c->lk.clk);
 
 	cpu_mask = 0;
 	if (cpu_is_omap16xx())
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index efc59c4..cc94672 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -722,7 +722,7 @@ int __init omap2_clk_init(void)
 	clk_init(&omap2_clk_functions);
 
 	for (c = omap24xx_clks; c < omap24xx_clks + ARRAY_SIZE(omap24xx_clks); c++)
-		clk_init_one(c->lk.clk);
+		clk_preinit(c->lk.clk);
 
 	osc_ck.rate = omap2_osc_clk_recalc(&osc_ck);
 	propagate_rate(&osc_ck);
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 2ee58fa..62092f2 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -964,7 +964,7 @@ int __init omap2_clk_init(void)
 	clk_init(&omap2_clk_functions);
 
 	for (c = omap34xx_clks; c < omap34xx_clks + ARRAY_SIZE(omap34xx_clks); c++)
-		clk_init_one(c->lk.clk);
+		clk_preinit(c->lk.clk);
 
 	for (c = omap34xx_clks; c < omap34xx_clks + ARRAY_SIZE(omap34xx_clks); c++)
 		if (c->cpu & cpu_clkflg) {
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 29efc27..508c96a 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -240,13 +240,13 @@ void recalculate_root_clocks(void)
 }
 
 /**
- * clk_init_one - initialize any fields in the struct clk before clk init
+ * clk_preinit - initialize any fields in the struct clk before clk init
  * @clk: struct clk * to initialize
  *
  * Initialize any struct clk fields needed before normal clk initialization
  * can run.  No return value.
  */
-void clk_init_one(struct clk *clk)
+void clk_preinit(struct clk *clk)
 {
 	INIT_LIST_HEAD(&clk->children);
 }
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 073a2c5..d7bd19c 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -119,7 +119,7 @@ struct clk_functions {
 extern unsigned int mpurate;
 
 extern int clk_init(struct clk_functions *custom_clocks);
-extern void clk_init_one(struct clk *clk);
+extern void clk_preinit(struct clk *clk);
 extern int clk_register(struct clk *clk);
 extern void clk_reparent(struct clk *child, struct clk *parent);
 extern void clk_unregister(struct clk *clk);


