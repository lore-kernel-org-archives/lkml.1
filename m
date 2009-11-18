Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZKRIeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZKRIeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZKRIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:34:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:48883 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbZKRIby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830425"
Message-Id: <20091118082846.279046849@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/12] writeback: remove unused nonblocking and congestion checks (xfs)
References: <20091118082648.140755818@intel.com>
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
 fs/xfs/linux-2.6/xfs_aops.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:22:35.000000000 +0800
+++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:52:21.000000000 +0800
@@ -908,12 +908,8 @@ xfs_convert_page(
 
 			bdi = inode->i_mapping->backing_dev_info;
 			wbc->nr_to_write--;
-			if (bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
+			if (wbc->nr_to_write <= 0)
 				done = 1;
-			} else if (wbc->nr_to_write <= 0) {
-				done = 1;
-			}
 		}
 		xfs_start_page_writeback(page, !page_dirty, count);
 	}


