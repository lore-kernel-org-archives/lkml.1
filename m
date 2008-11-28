Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYK1XeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYK1XeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYK1XeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:34:00 -0500
Received: from onyx.pirko.cz ([84.16.102.30]:37612 "EHLO onyx.pirko.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbYK1Xd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:33:59 -0500
Date: Sat, 29 Nov 2008 00:33:47 +0100
From: Jirka Pirko <jirka@pirko.cz>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] get rid of some "may be used uninitialized" compiler
 warnings
Message-ID: <20081129003347.2295622f@jirka.pirko.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just used uninitialized_var() macro when it's appropriate. I checked
that warning is meaningless in all these cases.

Signed-off-by: Jirka Pirko <jirka@pirko.cz>
---
 arch/x86/kernel/cpu/mtrr/main.c |    2 +-
 drivers/ata/sata_via.c          |    2 +-
 drivers/net/niu.c               |    4 ++--
 drivers/video/aty/aty128fb.c    |    2 +-
 kernel/cpuset.c                 |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index c78c048..c94c0ef 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1361,7 +1361,7 @@ static int __init mtrr_cleanup(unsigned address_bits)
 	memset(result, 0, sizeof(result));
 	for (gran_size = (1ULL<<16); gran_size < (1ULL<<32); gran_size <<= 1) {
 		char gran_factor;
-		unsigned long gran_base;
+		unsigned long uninitialized_var(gran_base);
 
 		if (debug_print)
 			gran_base = to_size_factor(gran_size >> 10, &gran_factor);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c18935f..01df26b 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -564,7 +564,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	unsigned int i;
 	int rc;
-	struct ata_host *host;
+	struct ata_host *uninitialized_var(host);
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 1b6f548..0d88aa0 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -448,7 +448,7 @@ static int serdes_init_niu_1g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u16 pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	u32 tx_cfg, rx_cfg;
 	unsigned long i;
 	int err;
@@ -547,7 +547,7 @@ static int serdes_init_niu_10g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u32 tx_cfg, rx_cfg, pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	unsigned long i;
 	int err;
 
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 243ea4a..7364610 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1326,7 +1326,7 @@ static int aty128_var_to_pll(u32 period_in_ps, struct aty128_pll *pll,
 {
 	const struct aty128_constants c = par->constants;
 	unsigned char post_dividers[] = {1,2,4,8,3,6,12};
-	u32 output_freq;
+	u32 uninitialized_var(output_freq);
 	u32 vclk;        /* in .01 MHz */
 	int i = 0;
 	u32 n, d;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index da7ff61..0a58fa0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -585,7 +585,7 @@ static int generate_sched_domains(cpumask_t **domains,
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
-	int ndoms;		/* number of sched domains in result */
+	int uninitialized_var(ndoms);		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
 	doms = NULL;
-- 
1.5.4.3

