Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZKRIby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZKRIby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZKRIbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbZKRIbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830406"
Message-Id: <20091118082846.170413359@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/12] writeback: remove unused nonblocking and congestion checks (gfs2)
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_fs_gfs2_aops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/gfs2/aops.c |   10 ----------
 1 file changed, 10 deletions(-)

--- linux.orig/fs/gfs2/aops.c	2009-11-06 09:22:35.000000000 +0800
+++ linux/fs/gfs2/aops.c	2009-11-06 09:52:15.000000000 +0800
@@ -313,11 +313,6 @@ static int gfs2_write_jdata_pagevec(stru
 
 		if (ret || (--(wbc->nr_to_write) <= 0))
 			ret = 1;
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			ret = 1;
-		}
-
 	}
 	gfs2_trans_end(sdp);
 	return ret;
@@ -348,11 +343,6 @@ static int gfs2_write_cache_jdata(struct
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */


