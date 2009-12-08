Return-Path: <linux-kernel-owner+w=401wt.eu-S966259AbZLHVQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966259AbZLHVQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966200AbZLHVQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966225AbZLHVQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:14 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [4/31] HWPOISON: remove the anonymous entry
Message-Id: <20091208211620.4DAC1B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

(PG_swapbacked && !PG_lru) pages should not happen.
Better to treat them as unknown pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -611,7 +611,6 @@ static struct page_state {
 
 	{ lru|dirty,	lru|dirty,	"LRU",		me_pagecache_dirty },
 	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
-	{ swapbacked,	swapbacked,	"anonymous",	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.
