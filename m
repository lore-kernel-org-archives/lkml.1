Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYGDQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYGDQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbYGDQvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:20 -0400
Received: from saeurebad.de ([85.214.36.134]:38529 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbYGDQvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:18 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:53 2008
Message-Id: <20080704161453.672529198@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:42 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/20] blackfin: use generic show_mem()
Content-Disposition: inline; filename=blackfin-use-generic-show_mem.patch
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
Acked-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mm/init.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -53,33 +53,6 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
-{
-	unsigned long i;
-	int free = 0, total = 0, reserved = 0, shared = 0;
-
-	int cached = 0;
-	printk(KERN_INFO "Mem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map + i))
-			reserved++;
-		else if (PageSwapCache(mem_map + i))
-			cached++;
-		else if (!page_count(mem_map + i))
-			free++;
-		else
-			shared += page_count(mem_map + i) - 1;
-	}
-	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d free pages\n", free);
-	printk(KERN_INFO "%d reserved pages\n", reserved);
-	printk(KERN_INFO "%d pages shared\n", shared);
-	printk(KERN_INFO "%d pages swap cached\n", cached);
-}
-
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.

-- 

