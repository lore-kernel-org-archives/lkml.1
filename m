Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYDGPup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYDGPup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759103AbYDGPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:49:42 -0400
Received: from saeurebad.de ([85.214.36.134]:44737 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbYDGPtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:49:42 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:39 2008
Message-Id: <20080407144239.856055638@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:13 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [patch 05/22 -v3] blackfin: Use generic show_mem()
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

Index: tree-linus/arch/blackfin/mm/init.c
===================================================================
--- tree-linus.orig/arch/blackfin/mm/init.c
+++ tree-linus/arch/blackfin/mm/init.c
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
Index: tree-linus/arch/blackfin/Kconfig
===================================================================
--- tree-linus.orig/arch/blackfin/Kconfig
+++ tree-linus/arch/blackfin/Kconfig
@@ -26,6 +26,7 @@ config BLACKFIN
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_SHOW_MEM
 
 config ZONE_DMA
 	bool

-- 

