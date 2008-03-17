Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYCQCBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYCQCBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYCQB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:27 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:65464 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbYCQB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:24 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [9/18] Export prep_compound_page to the hugetlb allocator
Message-Id: <20080317015823.025301B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:23 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:48.0736 (UTC) FILETIME=[7693A000:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hugetlb will need to get compound pages from bootmem to handle
the case of them being larger than MAX_ORDER. Export
the constructor function needed for this.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/internal.h   |    2 ++
 mm/page_alloc.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/mm/internal.h
===================================================================
--- linux.orig/mm/internal.h
+++ linux/mm/internal.h
@@ -13,6 +13,8 @@
 
 #include <linux/mm.h>
 
+extern void prep_compound_page(struct page *page, unsigned long order);
+
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -272,7 +272,7 @@ static void free_compound_page(struct pa
 	__free_pages_ok(page, compound_order(page));
 }
 
-static void prep_compound_page(struct page *page, unsigned long order)
+void prep_compound_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
