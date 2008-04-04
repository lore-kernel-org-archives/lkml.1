Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbYDDNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbYDDNBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbYDDM4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:56:50 -0400
Received: from saeurebad.de ([85.214.36.134]:44764 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576AbYDDM4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:56:49 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:31 2008
Message-Id: <20080404115231.308257293@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:42 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Subject: [patch 05/22 -v2] blackfin: Use generic show_mem()
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
CC: Bryan Wu <cooloney@kernel.org>
---

Index: tree-linus/arch/blackfin/Kconfig
===================================================================
--- tree-linus.orig/arch/blackfin/Kconfig
+++ tree-linus/arch/blackfin/Kconfig
@@ -26,7 +26,6 @@ config BLACKFIN
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_ARCH_SHOW_MEM
 
 config ZONE_DMA
 	bool
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

-- 

