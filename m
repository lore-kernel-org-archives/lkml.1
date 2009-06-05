Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZFEIUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZFEIUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZFEIGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37574 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbZFEIGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 43/62] Blackfin: drop unused reserve_pda() function
Date: Fri,  5 Jun 2009 04:04:52 -0400
Message-Id: <1244189111-19639-44-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The Per-processor Data Area isn't actually reserved by this function, and
all it ended up doing was issuing a printk(), so punt it.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/pda.h |    2 --
 arch/blackfin/mach-common/smp.c |    3 ---
 arch/blackfin/mm/init.c         |   10 ----------
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/include/asm/pda.h b/arch/blackfin/include/asm/pda.h
index a671427..b42555c 100644
--- a/arch/blackfin/include/asm/pda.h
+++ b/arch/blackfin/include/asm/pda.h
@@ -64,8 +64,6 @@ struct blackfin_pda {			/* Per-processor Data Area */
 
 extern struct blackfin_pda cpu_pda[];
 
-void reserve_pda(void);
-
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_BLACKFIN_PDA_H */
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index b669595..3b8ebae 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -369,9 +369,6 @@ static void __cpuinit setup_secondary(unsigned int cpu)
 	bfin_write_ILAT(ilat);
 	CSYNC();
 
-	/* Reserve the PDA space for the secondary CPU. */
-	reserve_pda();
-
 	/* Enable interrupt levels IVG7-15. IARs have been already
 	 * programmed by the boot CPU.  */
 	bfin_irq_flags |= IMASK_IVG15 |
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 00543c8..9a62b30 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -134,12 +134,6 @@ asmlinkage void __init init_pda(void)
 #endif
 }
 
-void __cpuinit reserve_pda(void)
-{
-	printk(KERN_INFO "PDA for CPU%u reserved at %p\n", smp_processor_id(),
-					&cpu_pda[smp_processor_id()]);
-}
-
 void __init mem_init(void)
 {
 	unsigned int codek = 0, datak = 0, initk = 0;
@@ -186,10 +180,6 @@ static int __init sram_init(void)
 	/* Initialize the blackfin L1 Memory. */
 	bfin_sram_init();
 
-	/* Reserve the PDA space for the boot CPU right after we
-	 * initialized the scratch memory allocator.
-	 */
-	reserve_pda();
 	return 0;
 }
 pure_initcall(sram_init);
-- 
1.6.3.1

