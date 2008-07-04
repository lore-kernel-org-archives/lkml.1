Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYGDQ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYGDQ7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbYGDQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:52:23 -0400
Received: from saeurebad.de ([85.214.36.134]:38587 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbYGDQwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:52:21 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:58 2008
Message-Id: <20080704161458.252875138@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:57 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Mikael Starvik <starvik@axis.com>
Subject: [PATCH 20/20] cris: use generic show_mem()
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
Acked-by: Mikael Starvik <starvik@axis.com>
---
 arch/cris/mm/init.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
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

