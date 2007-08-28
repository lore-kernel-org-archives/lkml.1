Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbXH1TSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbXH1TSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXH1TIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58409 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756722AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190735.988979316@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:25 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [34/36] Large blocksize support in XFS
Content-Disposition: inline; filename=0034-Large-blocksize-support-in-XFS.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only change needed to enable Large Block I/O in XFS is to remove
the check for a too large blocksize ;-)

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/xfs/xfs_mount.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a66b398..47ddc89 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -326,19 +326,6 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(ENOSYS);
 	}
 
-	/*
-	 * Until this is fixed only page-sized or smaller data blocks work.
-	 */
-	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
-		xfs_fs_mount_cmn_err(flags,
-			"file system with blocksize %d bytes",
-			sbp->sb_blocksize);
-		xfs_fs_mount_cmn_err(flags,
-			"only pagesize (%ld) or less will currently work.",
-			PAGE_SIZE);
-		return XFS_ERROR(ENOSYS);
-	}
-
 	return 0;
 }
 
-- 
1.5.2.4

-- 
