Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbYDBVtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbYDBVtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763295AbYDBVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:45:25 -0400
Received: from saeurebad.de ([85.214.36.134]:60375 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763282AbYDBVpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:45:22 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: [RFC 19/22] um: Use generic show_mem()
Date: Wed,  2 Apr 2008 22:40:25 +0200
Message-Id: <12071690432631-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12071688283927-git-send-email-hannes@saeurebad.de>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index f3b75af..dba8e05 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -86,10 +86,6 @@ config STATIC_LINK
 	  2.75G) for UML.
 
 source "arch/um/Kconfig.arch"
-
-config HAVE_ARCH_SHOW_MEM
-	def_bool y
-
 source "mm/Kconfig"
 source "kernel/time/Kconfig"
 
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 2eea1ff..e1c7d20 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -295,37 +295,6 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void show_mem(void)
-{
-	int pfn, total = 0, reserved = 0;
-	int shared = 0, cached = 0;
-	int high_mem = 0;
-	struct page *page;
-
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	printk(KERN_INFO "Free swap:       %6ldkB\n",
-	       nr_swap_pages<<(PAGE_SHIFT-10));
-	pfn = max_mapnr;
-	while (pfn-- > 0) {
-		page = pfn_to_page(pfn);
-		total++;
-		if (PageHighMem(page))
-			high_mem++;
-		if (PageReserved(page))
-			reserved++;
-		else if (PageSwapCache(page))
-			cached++;
-		else if (page_count(page))
-			shared += page_count(page) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", high_mem);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /* Allocate and free page tables. */
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
-- 
1.5.2.2

