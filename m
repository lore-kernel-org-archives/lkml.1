Return-Path: <linux-kernel-owner+w=401wt.eu-S936368AbZDJGRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936368AbZDJGRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763678AbZDJGQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:16:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:28520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765558AbZDJGQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:16:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,165,1239001200"; 
   d="scan'208";a="130013460"
Message-Id: <20090410061254.240509394@intel.com>
References: <20090410060957.442203404@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 14:10:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Subject: [PATCH 4/9] readahead: increase interleaved readahead size
Content-Disposition: inline; filename=readahead-interleaved-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure interleaved readahead size is larger than request size.
This also makes readahead window grow up more quickly.

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |    1 +
 1 file changed, 1 insertion(+)

--- mm.orig/mm/readahead.c
+++ mm/mm/readahead.c
@@ -403,6 +403,7 @@ ondemand_readahead(struct address_space 
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
+		ra->size += req_size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;

-- 

