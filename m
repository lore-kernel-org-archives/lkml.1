Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087Ab0A2UvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0A2UvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992Ab0A2UvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:18 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42650 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0A2UvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:11 -0500
Message-Id: <20100129205005.552853163@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:44 -0600
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
Subject: Filesystem: Ext3 filesystem defrag
Content-Disposition: inline; filename=ext3-defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support defragmentation for ext3 filesystem inodes

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/ext3/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-next/fs/ext3/super.c
===================================================================
--- linux-next.orig/fs/ext3/super.c	2008-08-11 07:42:10.348607875 -0700
+++ linux-next/fs/ext3/super.c	2008-08-11 07:47:05.042348829 -0700
@@ -484,6 +484,12 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *ext3_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct ext3_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
@@ -493,6 +499,8 @@ static int init_inodecache(void)
 					     init_once);
 	if (ext3_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(ext3_inode_cachep,
+			ext3_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
