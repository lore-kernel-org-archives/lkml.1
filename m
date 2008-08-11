Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYHKPTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYHKPTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbYHKPS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:18:58 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:63095 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbYHKPS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:18:57 -0400
Message-Id: <20080811150658.772823198@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:30 -0700
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
Subject: [patch 14/19] Filesystem: Ext4 filesystem defrag
Content-Disposition: inline; filename=ext4-defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support defragmentation for extX filesystem inodes

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-next/fs/ext4/super.c
===================================================================
--- linux-next.orig/fs/ext4/super.c	2008-08-11 07:42:10.412359410 -0700
+++ linux-next/fs/ext4/super.c	2008-08-11 07:47:05.062348866 -0700
@@ -605,6 +605,12 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext4_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext4_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
@@ -614,6 +620,8 @@ static int init_inodecache(void)
 					     init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(ext4_inode_cachep,
+			ext4_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
