Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYGDQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYGDQw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYGDQvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:17 -0400
Received: from saeurebad.de ([85.214.36.134]:38526 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463AbYGDQvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:14 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:53 2008
Message-Id: <20080704161453.351433284@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:41 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 04/20] avr32: use generic show_mem()
Content-Disposition: inline; filename=avr32-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in slabs, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mm/init.c |   39 ---------------------------------------
 1 file changed, 39 deletions(-)

--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -36,45 +36,6 @@ EXPORT_SYMBOL(empty_zero_page);
  */
 unsigned long mmu_context_cache = NO_CONTEXT;
 
-void show_mem(void)
-{
-	int total = 0, reserved = 0, cached = 0;
-	int slab = 0, free = 0, shared = 0;
-	pg_data_t *pgdat;
-
-	printk("Mem-info:\n");
-	show_free_areas();
-
-	for_each_online_pgdat(pgdat) {
-		struct page *page, *end;
-
-		page = pgdat->node_mem_map;
-		end = page + pgdat->node_spanned_pages;
-
-		do {
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (PageSlab(page))
-				slab++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-			page++;
-		} while (page < end);
-	}
-
-	printk ("%d pages of RAM\n", total);
-	printk ("%d free pages\n", free);
-	printk ("%d reserved pages\n", reserved);
-	printk ("%d slab pages\n", slab);
-	printk ("%d pages shared\n", shared);
-	printk ("%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() sets up the page tables
  *

-- 

