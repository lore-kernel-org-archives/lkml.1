Return-Path: <linux-kernel-owner+w=401wt.eu-S1946643AbXBIQij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946643AbXBIQij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946637AbXBIQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:38:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51662 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946633AbXBIQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:16 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] arch/powerpc trivial annotations
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HFYlL-0006kg-KO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/iommu.c |    5 +++--
 arch/powerpc/platforms/chrp/setup.c |    4 ++--
 arch/powerpc/xmon/spu-dis.c         |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index b43466b..67d617b 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -149,7 +149,8 @@ static int cbe_nr_iommus;
 static void invalidate_tce_cache(struct cbe_iommu *iommu, unsigned long *pte,
 		long n_ptes)
 {
-	unsigned long *reg, val;
+	unsigned long __iomem *reg;
+	unsigned long val;
 	long n;
 
 	reg = iommu->xlate_regs + IOC_IOPT_CacheInvd;
@@ -592,7 +593,7 @@ static void __init cell_iommu_init_one(struct device_node *np, unsigned long off
 	/* Init base fields */
 	i = cbe_nr_iommus++;
 	iommu = &iommus[i];
-	iommu->stab = 0;
+	iommu->stab = NULL;
 	iommu->nid = nid;
 	snprintf(iommu->name, sizeof(iommu->name), "iommu%d", i);
 	INIT_LIST_HEAD(&iommu->windows);
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index e1f51d4..117c9a0 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -75,7 +75,7 @@ extern irqreturn_t xmon_irq(int, void *);
 extern unsigned long loops_per_jiffy;
 
 /* To be replaced by RTAS when available */
-static unsigned int *briq_SPOR;
+static unsigned int __iomem *briq_SPOR;
 
 #ifdef CONFIG_SMP
 extern struct smp_ops_t chrp_smp_ops;
@@ -267,7 +267,7 @@ void __init chrp_setup_arch(void)
 	} else if (machine && strncmp(machine, "TotalImpact,BRIQ-1", 18) == 0) {
 		_chrp_type = _CHRP_briq;
 		/* Map the SPOR register on briq and change the restart hook */
-		briq_SPOR = (unsigned int *)ioremap(0xff0000e8, 4);
+		briq_SPOR = ioremap(0xff0000e8, 4);
 		ppc_md.restart = briq_restart;
 	} else {
 		/* Let's assume it is an IBM chrp if all else fails */
diff --git a/arch/powerpc/xmon/spu-dis.c b/arch/powerpc/xmon/spu-dis.c
index ee929c6..e5f8983 100644
--- a/arch/powerpc/xmon/spu-dis.c
+++ b/arch/powerpc/xmon/spu-dis.c
@@ -85,7 +85,7 @@ get_index_for_opcode (unsigned int insn)
   if ((index = spu_disassemble_table[opcode & 0x7ff]) != 0)
     return index;
 
-  return 0;
+  return NULL;
 }
 
 /* Print a Spu instruction.  */
-- 
1.5.0-rc2.GIT


