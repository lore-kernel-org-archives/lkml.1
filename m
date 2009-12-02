Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZLBEjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZLBEjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZLBEh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:57394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764904"
Message-Id: <20091202043044.878843398@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/24] HWPOISON: remove the free buddy page handler
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-remove-free-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buddy page has already be handled in the very beginning.
So remove redundant code.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |    9 ---------
 1 file changed, 9 deletions(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-09 10:57:50.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-09 10:59:26.000000000 +0800
@@ -379,14 +379,6 @@ static int me_unknown(struct page *p, un
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
@@ -592,7 +584,6 @@ static struct page_state {
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	"reserved kernel",	me_ignore },
-	{ buddy,	buddy,		"free kernel",	me_free },
 
 	/*
 	 * Could in theory check if slab page is free or if we can drop


