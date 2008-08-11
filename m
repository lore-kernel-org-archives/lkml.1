Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYHKPVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYHKPVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHKPVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:21:43 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:2946 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYHKPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:21:42 -0400
Message-Id: <20080811150658.233952076@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:28 -0700
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
Subject: [patch 12/19] Filesystem: Ext2 filesystem defrag
Content-Disposition: inline; filename=ext2-defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support defragmentation for ext2 filesystem inodes

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/ext2/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-next/fs/ext2/super.c
===================================================================
--- linux-next.orig/fs/ext2/super.c	2008-08-11 07:42:10.212350007 -0700
+++ linux-next/fs/ext2/super.c	2008-08-11 07:47:05.022348226 -0700
@@ -171,6 +171,12 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext2_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext2_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
@@ -180,6 +186,9 @@ static int init_inodecache(void)
 					     init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
+
+	kmem_cache_setup_defrag(ext2_inode_cachep,
+			ext2_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
