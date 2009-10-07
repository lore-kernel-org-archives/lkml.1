Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbZJGIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbZJGIB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZJGIB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:58309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbZJGIBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971263"
Message-Id: <20091007074903.991897309@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/45] writeback: show bdi write bandwidth in debugfs
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-bandwidth-show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Theodore Ts'o <tytso@mit.edu>
CC: Jan Kara <jack@suse.cz> 
CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:44.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:38:44.000000000 +0800
@@ -93,6 +93,7 @@ static int bdi_debug_stats_show(struct s
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
+		   "WriteBandwidth:   %8lu kBps\n"
 		   "WriteBack threads:%8lu\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
@@ -104,8 +105,9 @@ static int bdi_debug_stats_show(struct s
 		   "wb_cnt:           %8u\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
+		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
+		   (unsigned long) K(bdi->write_bandwidth),
+		   nr_wb, nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,
 		   !list_empty(&bdi->wb_list), bdi->wb_cnt);
 #undef K


