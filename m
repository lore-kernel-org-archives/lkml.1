Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbYDDNED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbYDDNED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbYDDM55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:57 -0400
Received: from saeurebad.de ([85.214.36.134]:44800 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbYDDM54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:57:56 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:32 2008
Message-Id: <20080404115232.479618744@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:50 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 13/22 -v2] mn10300: Use generic show_mem()
Content-Disposition: inline; filename=mn10300-use-generic-show_mem.patch
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
CC: David Howells <dhowells@redhat.com>
---

Index: tree-linus/arch/mn10300/Kconfig
===================================================================
--- tree-linus.orig/arch/mn10300/Kconfig
+++ tree-linus/arch/mn10300/Kconfig
@@ -7,7 +7,6 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
-	select HAVE_ARCH_SHOW_MEM
 
 config AM33
 	def_bool y
Index: tree-linus/arch/mn10300/mm/pgtable.c
===================================================================
--- tree-linus.orig/arch/mn10300/mm/pgtable.c
+++ tree-linus/arch/mn10300/mm/pgtable.c
@@ -27,33 +27,6 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
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
  * Associate a large virtual page frame with a given physical page frame
  * and protection flags for that frame. pfn is for the base of the page,

-- 

