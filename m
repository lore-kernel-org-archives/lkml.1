Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038Ab0ALHAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0ALHAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180Ab0ALG74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:59:56 -0500
Received: from ozlabs.org ([203.10.76.45]:45455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0ALG6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:58:45 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 4/7 v2] arm/versatile: remove oscoff from clk_versatile
Message-Id: <1263279511.161599.615234274711.4.gpush@pororo>
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Tue, 12 Jan 2010 17:58:31 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only use one value for oscoff, so remove it from the struct.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 arch/arm/mach-versatile/clock.h |    1 -
 arch/arm/mach-versatile/core.c  |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-versatile/clock.h b/arch/arm/mach-versatile/clock.h
index d1c8791..6ac30c5 100644
--- a/arch/arm/mach-versatile/clock.h
+++ b/arch/arm/mach-versatile/clock.h
@@ -15,7 +15,6 @@ struct clk_versatile {
 	struct clk			clk;
 	unsigned long			rate;
 	const struct icst307_params	params;
-	u32				oscoff;
 	void				(*setvco)(struct clk_versatile *,
 						  struct icst307_vco);
 };
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index b6964bc..2b670bb 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -384,13 +384,14 @@ static void versatile_oscvco_set(struct clk_versatile *clk, struct icst307_vco v
 {
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 	void __iomem *sys_lock = sys + VERSATILE_SYS_LOCK_OFFSET;
+	void __iomem *sys_osc = sys + VERSATILE_SYS_OSCCLCD_OFFSET;
 	u32 val;
 
-	val = readl(sys + clk->oscoff) & ~0x7ffff;
+	val = readl(sys_osc) & ~0x7ffff;
 	val |= vco.v | (vco.r << 9) | (vco.s << 16);
 
 	writel(0xa05f, sys_lock);
-	writel(val, sys + clk->oscoff);
+	writel(val, sys_osc);
 	writel(0, sys_lock);
 }
 
@@ -406,7 +407,6 @@ static struct clk_versatile osc4_clk = {
 		.rd_min		= 1 + 2,
 		.rd_max		= 127 + 2,
 	},
-	.oscoff = VERSATILE_SYS_OSCCLCD_OFFSET,
 	.setvco = versatile_oscvco_set,
 };
 
