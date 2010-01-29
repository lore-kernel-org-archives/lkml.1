Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246Ab0A2UxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0A2UxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062Ab0A2UvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:19 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42685 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0A2UvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:14 -0500
Message-Id: <20100129205006.657323814@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:46 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Filesystem: XFS slab defragmentation
Content-Disposition: inline; filename=xfs_defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support inode defragmentation for xfs

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/xfs/linux-2.6/xfs_super.c |    2 ++
 1 file changed, 2 insertions(+)

Index: slab-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- slab-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2010-01-22 15:09:43.000000000 -0600
+++ slab-2.6/fs/xfs/linux-2.6/xfs_super.c	2010-01-22 16:23:51.000000000 -0600
@@ -1608,6 +1608,8 @@ xfs_init_zones(void)
 	if (!xfs_ioend_zone)
 		goto out;
 
+	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
+
 	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
 						  xfs_ioend_zone);
 	if (!xfs_ioend_pool)

-- 
