Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbXFTSiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbXFTSiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbXFTSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54800 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758136AbXFTSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:15 -0400
Message-Id: <20070620183014.206809262@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:42 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       Dave Chinner <dgc@sgi.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [35/37] Large blocksize support in XFS
Content-Disposition: inline; filename=vps_filesystem_xfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Chinner <dgc@sgi.com>

The only thing that needs to change to enable Large Block I/O is to remove
the check for a too large blocksize ;-)

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/xfs/xfs_mount.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/xfs/xfs_mount.c	2007-06-18 19:05:21.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/xfs/xfs_mount.c	2007-06-19 19:45:33.000000000 -0700
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
