Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZEHLN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZEHLN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbZEHLMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:12:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:48712 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbZEHLMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,316,1239001200"; 
   d="scan'208";a="140664184"
Message-Id: <20090508111030.604626949@intel.com>
References: <20090508105320.316173813@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:53:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, <linux-mm@kvack.org>
Subject: [PATCH 2/8] slob: use PG_slab for identifying SLOB pages
Content-Disposition: inline; filename=mm-slob-page-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the sake of consistency.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/page-flags.h |    2 --
 mm/slob.c                  |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

--- linux.orig/include/linux/page-flags.h
+++ linux/include/linux/page-flags.h
@@ -120,7 +120,6 @@ enum pageflags {
 	PG_savepinned = PG_dirty,
 
 	/* SLOB */
-	PG_slob_page = PG_active,
 	PG_slob_free = PG_private,
 
 	/* SLUB */
@@ -203,7 +202,6 @@ PAGEFLAG(SavePinned, savepinned);			/* X
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
-__PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
--- linux.orig/mm/slob.c
+++ linux/mm/slob.c
@@ -132,17 +132,17 @@ static LIST_HEAD(free_slob_large);
  */
 static inline int is_slob_page(struct slob_page *sp)
 {
-	return PageSlobPage((struct page *)sp);
+	return PageSlab((struct page *)sp);
 }
 
 static inline void set_slob_page(struct slob_page *sp)
 {
-	__SetPageSlobPage((struct page *)sp);
+	__SetPageSlab((struct page *)sp);
 }
 
 static inline void clear_slob_page(struct slob_page *sp)
 {
-	__ClearPageSlobPage((struct page *)sp);
+	__ClearPageSlab((struct page *)sp);
 }
 
 static inline struct slob_page *slob_page(const void *addr)

-- 

