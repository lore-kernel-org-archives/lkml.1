Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZK0Lgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZK0Lgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZK0Lgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:22848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbZK0Lgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271273"
Message-Id: <20091127110407.781077241@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:12 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/6] writeback: remove unused nonblocking and congestion checks (xfs)
References: <20091127105908.944744141@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_fs_xfs_linux-2.6_xfs_aops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-19 16:00:51.000000000 +0800
+++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-19 16:04:33.000000000 +0800
@@ -904,16 +904,9 @@ xfs_convert_page(
 
 	if (startio) {
 		if (count) {
-			struct backing_dev_info *bdi;
-
-			bdi = inode->i_mapping->backing_dev_info;
 			wbc->nr_to_write--;
-			if (bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			} else if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0)
 				done = 1;
-			}
 		}
 		xfs_start_page_writeback(page, !page_dirty, count);
 	}


