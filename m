Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYHASv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYHASv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYHASvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:51:48 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:33042 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYHASvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:51:47 -0400
Message-Id: <20080801182347.920763237@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:18 -0700
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
Subject: [patch 17/19] Filesystem: Slab defrag: Reiserfs support
Content-Disposition: inline; filename=0029-FS-Slab-defrag-Reiserfs-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab defragmentation: Support reiserfs inode defragmentation.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/reiserfs/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

Index: linux-2.6/fs/reiserfs/super.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/super.c	2008-07-31 12:18:12.000000000 -0500
+++ linux-2.6/fs/reiserfs/super.c	2008-07-31 12:18:15.000000000 -0500
@@ -533,6 +533,12 @@
 #endif
 }
 
+static void *reiserfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct reiserfs_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -543,6 +549,8 @@
 						  init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(reiserfs_inode_cachep,
+			reiserfs_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
