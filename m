Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753565AbYLQLJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYLQLJa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYLQLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:09:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49948 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYLQLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:09:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove CONFIG_OUT_OF_LINE_PFN_TO_PAGE
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081217200812.FF1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 20:09:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, any architecture don't use CONFIG_OUT_OF_LINE_PFN_TO_PAGE at all.
it can be removed.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/asm-generic/memory_model.h |    7 -------
 mm/page_alloc.c                    |   13 -------------
 2 files changed, 20 deletions(-)

Index: b/include/asm-generic/memory_model.h
===================================================================
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -69,15 +69,8 @@
 })
 #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
 
-#ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
-struct page;
-/* this is useful when inlined pfn_to_page is too big */
-extern struct page *pfn_to_page(unsigned long pfn);
-extern unsigned long page_to_pfn(struct page *page);
-#else
 #define page_to_pfn __page_to_pfn
 #define pfn_to_page __pfn_to_page
-#endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 
 #endif /* __ASSEMBLY__ */
 
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4593,19 +4593,6 @@ void *__init alloc_large_system_hash(con
 	return table;
 }
 
-#ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
-struct page *pfn_to_page(unsigned long pfn)
-{
-	return __pfn_to_page(pfn);
-}
-unsigned long page_to_pfn(struct page *page)
-{
-	return __page_to_pfn(page);
-}
-EXPORT_SYMBOL(pfn_to_page);
-EXPORT_SYMBOL(page_to_pfn);
-#endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
-
 /* Return a pointer to the bitmap storing bits affecting a block of pages */
 static inline unsigned long *get_pageblock_bitmap(struct zone *zone,
 							unsigned long pfn)


