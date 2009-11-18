Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZKRIcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZKRIcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZKRIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:13622 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZKRIbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830432"
Message-Id: <20091118082845.828021716@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Evgeniy Polyakov <zbr@ioremap.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/12] writeback: remove unused nonblocking and congestion checks (pohmelfs)
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_drivers_staging_pohmelfs_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |    9 ---------
 1 file changed, 9 deletions(-)

--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-11-06 09:22:36.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-11-06 09:52:12.000000000 +0800
@@ -152,11 +152,6 @@ static int pohmelfs_writepages(struct ad
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -248,10 +243,6 @@ retry:
 
 			if (wbc->nr_to_write <= 0)
 				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			}
 
 			continue;
 out_continue:


