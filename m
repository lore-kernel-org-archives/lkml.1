Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYGDQ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYGDQ5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYGDQv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:51:57 -0400
Received: from saeurebad.de ([85.214.36.134]:38566 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbYGDQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:51:56 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jul  4 18:14:56 2008
Message-Id: <20080704161456.468796549@saeurebad.de>
References: <20080704160737.750988999@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 18:07:51 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 14/20] h8300: use generic show_mem()
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
 arch/h8300/mm/init.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
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
 

-- 

