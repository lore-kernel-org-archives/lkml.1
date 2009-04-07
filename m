Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZDGMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZDGMCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDGMAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:23410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbZDGMAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748891"
Message-Id: <20090407115234.657957195@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ying Han <yinghan@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 08/14] readahead: remove one unnecessary radix tree lookup
Content-Disposition: inline; filename=readahead-interleaved-offset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(hit_readahead_marker != 0) means the page at @offset is present,
so we can search for non-present page starting from @offset+1.

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -420,7 +420,7 @@ ondemand_readahead(struct address_space 
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		start = radix_tree_next_hole(&mapping->page_tree, offset+1,max);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max)

-- 

