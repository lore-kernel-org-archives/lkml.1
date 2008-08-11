Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYHKPTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYHKPTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHKPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:18:48 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:63095 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYHKPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:18:47 -0400
Message-Id: <20080811150659.051842926@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:31 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 15/19] Filesystem: XFS slab defragmentation
Content-Disposition: inline; filename=0027-FS-XFS-slab-defragmentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support inode defragmentation for xfs

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/xfs/linux-2.6/xfs_super.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-next.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:42:11.892359719 -0700
+++ linux-next/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:47:05.072348463 -0700
@@ -1947,6 +1947,7 @@ xfs_init_zones(void)
 	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
 	if (!xfs_ioend_zone)
 		goto out_destroy_vnode_zone;
+	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
 
 	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
 						  xfs_ioend_zone);

-- 
