Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZGCCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZGCCfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZGCCfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:35:42 -0400
Received: from sandeen.net ([209.173.210.139]:17710 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZGCCfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:35:41 -0400
Message-ID: <4A4D6E7F.4060204@sandeen.net>
Date: Thu, 02 Jul 2009 21:35:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] un-static xfs_read_agf
References: <20090703100551.e3f21aa0.sfr@canb.auug.org.au>
In-Reply-To: <20090703100551.e3f21aa0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_XFS_DEBUG builds still need xfs_read_agf to be
non-static, oops.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_ag.h
+++ linux-2.6/fs/xfs/xfs_ag.h
@@ -91,6 +91,9 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGF_DADDR(mp))
 #define	XFS_BUF_TO_AGF(bp)	((xfs_agf_t *)XFS_BUF_PTR(bp))
 
+extern int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+
 /*
  * Size of the unlinked inode hash table in the agi.
  */
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6/fs/xfs/xfs_alloc.c
@@ -2248,7 +2248,7 @@ xfs_alloc_put_freelist(
 /*
  * Read in the allocation group header (free/alloc section).
  */
-STATIC int				/* error */
+int					/* error */
 xfs_read_agf(
 	struct xfs_mount	*mp,	/* mount point structure */
 	struct xfs_trans	*tp,	/* transaction pointer */

