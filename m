Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZKRIcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZKRIcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZKRIb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZKRIbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830441"
Message-Id: <20091118082846.051582471@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Steve French <sfrench@samba.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] writeback: remove unused nonblocking and congestion checks (cifs)
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_fs_cifs_file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Steve French <sfrench@samba.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/cifs/file.c |   10 ----------
 1 file changed, 10 deletions(-)

--- linux.orig/fs/cifs/file.c	2009-11-18 16:25:49.000000000 +0800
+++ linux/fs/cifs/file.c	2009-11-18 16:25:57.000000000 +0800
@@ -1379,16 +1379,6 @@ static int cifs_writepages(struct addres
 		return generic_writepages(mapping, wbc);
 
 
-	/*
-	 * BB: Is this meaningful for a non-block-device file system?
-	 * If it is, we should test it again after we do I/O
-	 */
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		kfree(iov);
-		return 0;
-	}
-
 	xid = GetXid();
 
 	pagevec_init(&pvec, 0);


