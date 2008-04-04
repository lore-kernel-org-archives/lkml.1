Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYDDNBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYDDNBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbYDDM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:57:00 -0400
Received: from saeurebad.de ([85.214.36.134]:44767 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760632AbYDDM47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:56:59 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Fri Apr  4 13:52:31 2008
Message-Id: <20080404115231.455409043@skyscraper.fehenstaub.lan>
References: <20080404115137.397502419@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 13:51:43 +0200
From: hannes@saeurebad.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Subject: [patch 06/22 -v2] cris: Use generic show_mem()
Content-Disposition: inline; filename=cris-use-generic-show_mem.patch
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
CC: Mikael Starvik <starvik@axis.com>
---

Index: tree-linus/arch/cris/Kconfig
===================================================================
--- tree-linus.orig/arch/cris/Kconfig
+++ tree-linus/arch/cris/Kconfig
@@ -55,7 +55,6 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_ARCH_SHOW_MEM
 
 config HZ
 	int
Index: tree-linus/arch/cris/mm/init.c
===================================================================
--- tree-linus.orig/arch/cris/mm/init.c
+++ tree-linus/arch/cris/mm/init.c
@@ -19,36 +19,6 @@ unsigned long empty_zero_page;
 extern char _stext, _edata, _etext; /* From linkerscript */
 extern char __init_begin, __init_end;
 
-void 
-show_mem(void)
-{
-	int i,free = 0,total = 0,cached = 0, reserved = 0, nonshared = 0;
-	int shared = 0;
-
-	printk("\nMem-info:\n");
-	show_free_areas();
-	i = max_mapnr;
-	while (i-- > 0) {
-		total++;
-		if (PageReserved(mem_map+i))
-			reserved++;
-		else if (PageSwapCache(mem_map+i))
-			cached++;
-		else if (!page_count(mem_map+i))
-			free++;
-		else if (page_count(mem_map+i) == 1)
-			nonshared++;
-		else
-			shared += page_count(mem_map+i) - 1;
-	}
-	printk("%d pages of RAM\n",total);
-	printk("%d free pages\n",free);
-	printk("%d reserved pages\n",reserved);
-	printk("%d pages nonshared\n",nonshared);
-	printk("%d pages shared\n",shared);
-	printk("%d pages swap cached\n",cached);
-}
-
 void __init
 mem_init(void)
 {

-- 

