Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbXA1NbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbXA1NbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXA1NbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:31:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbXA1N3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:29:30 -0500
Message-Id: <20070128132436.178008000@programming.kicks-ass.net>
References: <20070128131343.628722000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 14:13:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/14] mm: remove find_tylock_page
Content-Disposition: inline; filename=kill-find_trylock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

its the last read_lock user of tree_lock, and since its unused remove
it rather than convert it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   20 --------------------
 2 files changed, 22 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-01-22 20:11:09.000000000 +0100
+++ linux-2.6/mm/filemap.c	2007-01-22 20:11:13.000000000 +0100
@@ -624,26 +624,6 @@ repeat:
 EXPORT_SYMBOL(find_get_page);
 
 /**
- * find_trylock_page - find and lock a page
- * @mapping: the address_space to search
- * @offset: the page index
- *
- * Same as find_get_page(), but trylock it instead of incrementing the count.
- */
-struct page *find_trylock_page(struct address_space *mapping, unsigned long offset)
-{
-	struct page *page;
-
-	read_lock_irq(&mapping->tree_lock);
-	page = radix_tree_lookup(&mapping->page_tree, offset);
-	if (page && TestSetPageLocked(page))
-		page = NULL;
-	read_unlock_irq(&mapping->tree_lock);
-	return page;
-}
-EXPORT_SYMBOL(find_trylock_page);
-
-/**
  * find_lock_page - locate, pin and lock a pagecache page
  * @mapping: the address_space to search
  * @offset: the page index
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h	2007-01-22 20:11:07.000000000 +0100
+++ linux-2.6/include/linux/pagemap.h	2007-01-22 20:11:13.000000000 +0100
@@ -202,8 +202,6 @@ extern struct page * find_get_page(struc
 				unsigned long index);
 extern struct page * find_lock_page(struct address_space *mapping,
 				unsigned long index);
-extern __deprecated_for_modules struct page * find_trylock_page(
-			struct address_space *mapping, unsigned long index);
 extern struct page * find_or_create_page(struct address_space *mapping,
 				unsigned long index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,

--

