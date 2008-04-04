Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYDDNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYDDNCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbYDDM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:15 -0400
Received: from saeurebad.de ([85.214.36.134]:44771 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760639AbYDDM5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:14 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:31 2008
Message-Id: <20080404115231.748825374@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:45 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 08/22 -v2] h8300: Use generic show_mem()
Content-Disposition: inline; filename=h8300-use-generic-show_mem.patch
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
---

Index: tree-linus/arch/h8300/Kconfig
===================================================================
--- tree-linus.orig/arch/h8300/Kconfig
+++ tree-linus/arch/h8300/Kconfig
@@ -9,7 +9,6 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config MMU
 	bool
Index: tree-linus/arch/h8300/mm/init.c
===================================================================
--- tree-linus.orig/arch/h8300/mm/init.c
+++ tree-linus/arch/h8300/mm/init.c
@@ -64,33 +64,6 @@ unsigned long empty_zero_page;
 
 extern unsigned long rom_length;
 
-void show_mem(void)
-{
-    unsigned long i;
-    int free = 0, total = 0, reserved = 0, shared = 0;
-    int cached = 0;
-
-    printk("\nMem-info:\n");
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
-    printk("%d pages of RAM\n",total);
-    printk("%d free pages\n",free);
-    printk("%d reserved pages\n",reserved);
-    printk("%d pages shared\n",shared);
-    printk("%d pages swap cached\n",cached);
-}
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
@@ -228,4 +201,3 @@ free_initmem()
 			(int)(addr - PAGE_SIZE));
 #endif
 }
-

-- 

