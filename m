Return-Path: <linux-kernel-owner+w=401wt.eu-S936965AbZDJGSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936965AbZDJGSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765803AbZDJGQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:28520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765682AbZDJGQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013466"
Message-Id: <20090410061254.052551915@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 3/9] readahead: remove one unnecessary radix tree lookup
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
@@ -395,7 +395,7 @@ ondemand_readahead(struct address_space 
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		start = radix_tree_next_hole(&mapping->page_tree, offset+1,max);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max)

-- 

