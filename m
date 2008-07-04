Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYGDQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYGDQ5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbYGDQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:52:06 -0400
Received: from saeurebad.de ([85.214.36.134]:38572 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759885AbYGDQwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:52:04 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:57 2008
Message-Id: <20080704161457.056057813@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:53 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 16/20] m68knommu: use generic show_mem()
Content-Disposition: inline; filename=m68knommu-use-generic-show_mem.patch
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
CC: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68knommu/mm/init.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/arch/m68knommu/mm/init.c
+++ b/arch/m68knommu/mm/init.c
@@ -62,33 +62,6 @@ static unsigned long empty_bad_page;
 
 unsigned long empty_zero_page;
 
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk(KERN_INFO "\nMem-info:\n");
-    show_free_areas();
-    i = max_mapnr;
-    while (i-- > 0) {
-	total++;
-	if (PageReserved(mem_map+i))
-	    reserved++;
-	else if (PageSwapCache(mem_map+i))
-	    cached++;
-	else if (!page_count(mem_map+i))
-	    free++;
-	else
-	    shared += page_count(mem_map+i) - 1;
-    }
-    printk(KERN_INFO "%d pages of RAM\n",total);
-    printk(KERN_INFO "%d free pages\n",free);
-    printk(KERN_INFO "%d reserved pages\n",reserved);
-    printk(KERN_INFO "%d pages shared\n",shared);
-    printk(KERN_INFO "%d pages swap cached\n",cached);
-}
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 

-- 

