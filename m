Return-Path: <linux-kernel-owner+w=401wt.eu-S1764735AbYEBDx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764735AbYEBDx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbYEBDwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48822 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbYEBDwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S30Bjc9r+SOpGBPfoZBK8UlWO8CUL12eBXnjxRPYPZx5wUMUDLHMnE+tuH1XbQ9f46yWWETyYptIHsLkL1V10bOPxT0TjX3E7MIo6YUCLBZi/2oZgUw+ya8eiVvX7nxsLqUAEXoFqU7m0r1sQsPT+t3Om9TkKMHPRLaX7FLk6iM=
Subject: [PATCH 6/8] xfs: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:57 -0700
Message-Id: <1209700377.22362.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/xfs/xfs_inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cf0bb9c..c6327c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -580,8 +580,8 @@ xfs_iformat_extents(
 		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
 			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-			ep->l0 = be64_to_cpu(get_unaligned(&dp->l0));
-			ep->l1 = be64_to_cpu(get_unaligned(&dp->l1));
+			ep->l0 = get_unaligned_be64(&dp->l0);
+			ep->l1 = get_unaligned_be64(&dp->l1);
 		}
 		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
 		if (whichfork != XFS_DATA_FORK ||
-- 
1.5.5.1.350.gbbbf


