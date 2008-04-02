Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbYDBVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbYDBVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763056AbYDBVpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:01 -0400
Received: from saeurebad.de ([85.214.36.134]:60330 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763254AbYDBVo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:44:59 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 17/22] s390: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:23 +0200
Message-Id: <12071690203023-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6fb2b79..1831833 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -282,9 +282,6 @@ config WARN_STACK_SIZE
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 comment "Kernel preemption"
 
 source "kernel/Kconfig.preempt"
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 8053245..27b94cb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -42,42 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
-void show_mem(void)
-{
-	int i, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	struct page *page;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
-	i = max_mapnr;
-	while (i-- > 0) {
-		if (!pfn_valid(i))
-			continue;
-		page = pfn_to_page(i);
-		total++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk("%d pages of RAM\n", total);
-	printk("%d reserved pages\n", reserved);
-	printk("%d pages shared\n", shared);
-	printk("%d pages swap cached\n", cached);
-
-	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
-	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
-	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
-	printk("%lu pages slab\n",
-	       global_page_state(NR_SLAB_RECLAIMABLE) +
-	       global_page_state(NR_SLAB_UNRECLAIMABLE));
-	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
-}
-
 static void __init setup_ro_region(void)
 {
 	pgd_t *pgd;
-- 
1.5.2.2

