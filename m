Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbYDGPzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbYDGPzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759804AbYDGPvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:51:24 -0400
Received: from saeurebad.de ([85.214.36.134]:44801 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759795AbYDGPvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:51:23 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Mon Apr  7 16:42:42 2008
Message-Id: <20080407144242.037850112@skyscraper.fehenstaub.lan>
References: <20080407144008.124362640@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 07 Apr 2008 16:40:28 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Miles Bader <miles@gnu.org>
Subject: [patch 20/22 -v3] v850: Use generic show_mem()
Content-Disposition: inline; filename=v850-use-generic-show_mem.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific show_mem() in favor of the generic version.

This also removes the following redundant information display:

	- free pages, printed in show_free_areas()
	- pages in swapcache, printed by show_swap_cache_info()

where show_mem() calls show_free_areas(), which calls
show_swap_cache_info().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Miles Bader <miles@gnu.org>
---

Index: tree-linus/arch/v850/Kconfig
===================================================================
--- tree-linus.orig/arch/v850/Kconfig
+++ tree-linus/arch/v850/Kconfig
@@ -79,6 +79,7 @@ config V850
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_GENERIC_SHOW_MEM
 
 menu "Processor type and features"
 
Index: tree-linus/arch/v850/kernel/setup.c
===================================================================
--- tree-linus.orig/arch/v850/kernel/setup.c
+++ tree-linus/arch/v850/kernel/setup.c
@@ -298,33 +298,3 @@ init_mem_alloc (unsigned long ram_start,
 	free_area_init_node (0, NODE_DATA(0), zones_size,
 			     ADDR_TO_PAGE (PAGE_OFFSET), 0);
 }
-
-
-
-/* Taken from m68knommu */
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

-- 

