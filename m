Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZFODRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZFODRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZFODO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:14:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:22811 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZFODOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154267328"
Message-Id: <20090615031254.581319975@intel.com>
References: <20090615024520.786814520@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 10:45:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mel@csn.ul.ie>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 16/22] mm: move page flag numbers for user space to page-flags.h
Content-Disposition: inline; filename=kpageflags-export-page_uflags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll be exporting them in other places than /proc/kpageflags.
For example, in hwpoison uevents for describing the poisoned page.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/page.c             |   40 +--------------------------------
 include/linux/page-flags.h |   42 +++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 38 deletions(-)

--- sound-2.6.orig/fs/proc/page.c
+++ sound-2.6/fs/proc/page.c
@@ -72,48 +72,12 @@ static const struct file_operations proc
 
 /* These macros are used to decouple internal flags from exported ones */
 
-#define KPF_LOCKED		0
-#define KPF_ERROR		1
-#define KPF_REFERENCED		2
-#define KPF_UPTODATE		3
-#define KPF_DIRTY		4
-#define KPF_LRU			5
-#define KPF_ACTIVE		6
-#define KPF_SLAB		7
-#define KPF_WRITEBACK		8
-#define KPF_RECLAIM		9
-#define KPF_BUDDY		10
-
-/* 11-20: new additions in 2.6.31 */
-#define KPF_MMAP		11
-#define KPF_ANON		12
-#define KPF_SWAPCACHE		13
-#define KPF_SWAPBACKED		14
-#define KPF_COMPOUND_HEAD	15
-#define KPF_COMPOUND_TAIL	16
-#define KPF_HUGE		17
-#define KPF_UNEVICTABLE		18
-#define KPF_HWPOISON		19
-#define KPF_NOPAGE		20
-
-/* kernel hacking assistances
- * WARNING: subject to change, never rely on them!
- */
-#define KPF_RESERVED		32
-#define KPF_MLOCKED		33
-#define KPF_MAPPEDTODISK	34
-#define KPF_PRIVATE		35
-#define KPF_PRIVATE_2		36
-#define KPF_OWNER_PRIVATE	37
-#define KPF_ARCH		38
-#define KPF_UNCACHED		39
-
 static inline u64 kpf_copy_bit(u64 kflags, int ubit, int kbit)
 {
 	return ((kflags >> kbit) & 1) << ubit;
 }
 
-static u64 get_uflags(struct page *page)
+u64 page_uflags(struct page *page)
 {
 	u64 k;
 	u64 u;
@@ -214,7 +178,7 @@ static ssize_t kpageflags_read(struct fi
 		else
 			ppage = NULL;
 
-		if (put_user(get_uflags(ppage), out)) {
+		if (put_user(page_uflags(ppage), out)) {
 			ret = -EFAULT;
 			break;
 		}
--- sound-2.6.orig/include/linux/page-flags.h
+++ sound-2.6/include/linux/page-flags.h
@@ -132,6 +132,46 @@ enum pageflags {
 	PG_slub_debug = PG_error,
 };
 
+/*
+ * stable flag numbers exported to user space
+ */
+
+#define KPF_LOCKED		0
+#define KPF_ERROR		1
+#define KPF_REFERENCED		2
+#define KPF_UPTODATE		3
+#define KPF_DIRTY		4
+#define KPF_LRU			5
+#define KPF_ACTIVE		6
+#define KPF_SLAB		7
+#define KPF_WRITEBACK		8
+#define KPF_RECLAIM		9
+#define KPF_BUDDY		10
+
+/* 11-20: new additions in 2.6.31 */
+#define KPF_MMAP		11
+#define KPF_ANON		12
+#define KPF_SWAPCACHE		13
+#define KPF_SWAPBACKED		14
+#define KPF_COMPOUND_HEAD	15
+#define KPF_COMPOUND_TAIL	16
+#define KPF_HUGE		17
+#define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
+#define KPF_NOPAGE		20
+
+/* kernel hacking assistances
+ * WARNING: subject to change, never rely on them!
+ */
+#define KPF_RESERVED		32
+#define KPF_MLOCKED		33
+#define KPF_MAPPEDTODISK	34
+#define KPF_PRIVATE		35
+#define KPF_PRIVATE_2		36
+#define KPF_OWNER_PRIVATE	37
+#define KPF_ARCH		38
+#define KPF_UNCACHED		39
+
 #ifndef __GENERATING_BOUNDS_H
 
 /*
@@ -284,6 +324,8 @@ TESTSETFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+u64 page_uflags(struct page *page);
+
 static inline int PageUptodate(struct page *page)
 {
 	int ret = test_bit(PG_uptodate, &(page)->flags);

-- 

