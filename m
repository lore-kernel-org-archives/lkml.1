Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZD1Bvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZD1Bvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZD1BvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:51:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:9251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757AbZD1BvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:51:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,257,1239001200"; 
   d="scan'208";a="136585596"
Message-Id: <20090428014920.346316876@intel.com>
References: <20090428010907.912554629@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Apr 2009 09:09:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 2/5] pagemap: documentation 9 more exported page flags
Content-Disposition: inline; filename=kpageflags-doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add short descriptions for all of the 20 exported page flags.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/pagemap.txt |   62 +++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- mm.orig/Documentation/vm/pagemap.txt
+++ mm/Documentation/vm/pagemap.txt
@@ -49,6 +49,68 @@ There are three components to pagemap:
      8. WRITEBACK
      9. RECLAIM
     10. BUDDY
+    11. MMAP
+    12. ANON
+    13. SWAPCACHE
+    14. SWAPBACKED
+    15. COMPOUND_HEAD
+    16. COMPOUND_TAIL
+    17. UNEVICTABLE
+    18. HWPOISON
+    19. NOPAGE
+
+Short descriptions to the page flags:
+
+ 0. LOCKED
+    page is being locked for exclusive access, eg. by undergoing read/write IO
+
+ 7. SLAB
+    page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator
+    When compound page is used, SLUB/SLQB will only set this flag on the head
+    page; SLOB will not flag it at all.
+
+10. BUDDY
+    a free memory block managed by the buddy system allocator
+    The buddy system organizes free memory in blocks of various orders.
+    An order N block has 2^N physically contiguous pages, with the BUDDY flag
+    set for and _only_ for the first page.
+
+15. COMPOUND_HEAD
+16. COMPOUND_TAIL
+    A compound page with order N consists of 2^N physically contiguous pages.
+    A compound page with order 2 takes the form of "HTTT", where H donates its
+    head page and T donates its tail page(s).  The major consumers of compound
+    pages are hugeTLB pages (Documentation/vm/hugetlbpage.txt), the SLUB etc.
+    memory allocators and various device drivers. However in this interface,
+    only huge/giga pages are made visible to end users.
+
+18. HWPOISON
+    hardware detected memory corruption on this page: don't touch the data!
+
+19. NOPAGE
+    no page frame exists at the requested address
+
+    [IO related page flags]
+ 1. ERROR     IO error occurred
+ 3. UPTODATE  page has up-to-date data
+              ie. for file backed page: (in-memory data revision >= on-disk one)
+ 4. DIRTY     page has been written to, hence contains new data
+              ie. for file backed page: (in-memory data revision >  on-disk one)
+ 8. WRITEBACK page is being synced to disk
+
+    [LRU related page flags]
+ 5. LRU         page is in one of the LRU lists
+ 6. ACTIVE      page is in the active LRU list
+17. UNEVICTABLE page is in the unevictable (non-)LRU list
+                It is somehow pinned and not a candidate for LRU page reclaims,
+		eg. ramfs pages, shmctl(SHM_LOCK) and mlock() memory segments
+ 2. REFERENCED  page has been referenced since last LRU list enqueue/requeue
+ 9. RECLAIM     page will be reclaimed soon after its pageout IO completed
+11. MMAP        a memory mapped page
+12. ANON        a memory mapped page that is not part of a file
+13. SWAPCACHE   page is mapped to swap space, ie. has an associated swap entry
+14. SWAPBACKED  page is backed by swap/RAM
+
 
 Using pagemap to do something useful:
 

-- 

