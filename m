Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYHKPVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYHKPVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHKPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:20:53 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:1871 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYHKPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:20:52 -0400
Message-Id: <20080811150701.969106732@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:33 -0700
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
 1 file changed, 8 insertions(+)

Index: linux-next/fs/reiserfs/super.c
===================================================================
--- linux-next.orig/fs/reiserfs/super.c	2008-08-11 07:42:11.712359126 -0700
+++ linux-next/fs/reiserfs/super.c	2008-08-11 07:47:05.122348709 -0700
@@ -533,6 +533,12 @@ static void init_once(void *foo)
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
@@ -543,6 +549,8 @@ static int init_inodecache(void)
 						  init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(reiserfs_inode_cachep,
+			reiserfs_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
