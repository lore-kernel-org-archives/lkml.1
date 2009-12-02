Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZLBEhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZLBEhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZLBEh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbZLBEh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764889"
Message-Id: <20091202043043.959761646@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/24] HWPOISON: remove the anonymous entry
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-remove-anon-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(PG_swapbacked && !PG_lru) pages are rediculous.
Better to treat them as unknown pages.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-02 10:18:45.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-02 10:26:17.000000000 +0800
@@ -589,7 +589,6 @@ static struct page_state {
 
 	{ lru|dirty,	lru|dirty,	"LRU",		me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
-	{ swapbacked,	swapbacked,	"anonymous",	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.


