Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZKRIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZKRIdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZKRIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:33:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZKRIb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830445"
Message-Id: <20091118082846.921451469@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:27:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] bdi: use bdi_stat_sum() for more accurate debugfs stats
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=bdi-debug-dump-sum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/mm/backing-dev.c	2009-11-18 16:25:28.000000000 +0800
+++ linux/mm/backing-dev.c	2009-11-18 16:26:10.000000000 +0800
@@ -104,8 +104,8 @@ static int bdi_debug_stats_show(struct s
 		   "wb_mask:          %8lx\n"
 		   "wb_list:          %8u\n"
 		   "wb_cnt:           %8u\n",
-		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
-		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
+		   (unsigned long) K(bdi_stat_sum(bdi, BDI_WRITEBACK)),
+		   (unsigned long) K(bdi_stat_sum(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh), K(dirty_thresh),
 		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,


