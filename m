Return-Path: <linux-kernel-owner+w=401wt.eu-S966438AbZLHVVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966438AbZLHVVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966258AbZLHVUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:20:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49531 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966257AbZLHVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:22 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [12/31] HWPOISON: remove the free buddy page handler
Message-Id: <20091208211628.63512B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

The buddy page has already be handled in the very beginning.
So remove redundant code.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -401,14 +401,6 @@ static int me_unknown(struct page *p, un
 }
 
 /*
- * Free memory
- */
-static int me_free(struct page *p, unsigned long pfn)
-{
-	return DELAYED;
-}
-
-/*
  * Clean (or cleaned) page cache page.
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
@@ -604,7 +596,6 @@ static int me_huge_page(struct page *p,
 #define tail		(1UL << PG_tail)
 #define compound	(1UL << PG_compound)
 #define slab		(1UL << PG_slab)
-#define buddy		(1UL << PG_buddy)
 #define reserved	(1UL << PG_reserved)
 
 static struct page_state {
@@ -614,7 +605,10 @@ static struct page_state {
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	"reserved kernel",	me_ignore },
-	{ buddy,	buddy,		"free kernel",	me_free },
+	/*
+	 * free pages are specially detected outside this table:
+	 * PG_buddy pages only make a small fraction of all free pages.
+	 */
 
 	/*
 	 * Could in theory check if slab page is free or if we can drop
