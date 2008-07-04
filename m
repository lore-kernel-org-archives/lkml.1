Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYGDQ6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYGDQ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYGDQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:52:10 -0400
Received: from saeurebad.de ([85.214.36.134]:38575 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbYGDQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:52:09 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:57 2008
Message-Id: <20080704161457.353841113@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:54 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 17/20] m68k: use generic show_mem()
Content-Disposition: inline; filename=m68k-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed by show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/init.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -69,36 +69,6 @@ void __init m68k_setup_node(int node)
 void *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
 
-void show_mem(void)
-{
-	pg_data_t *pgdat;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-	int cached = 0;
-	int i;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat->node_mem_map + i;
-			total++;
-			if (PageReserved(page))
-				reserved++;
-			else if (PageSwapCache(page))
-				cached++;
-			else if (!page_count(page))
-				free++;
-			else
-				shared += page_count(page) - 1;
-		}
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 extern void init_pointer_table(unsigned long ptable);
 
 /* References to section boundaries */

-- 

