Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbYEJDRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbYEJDRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYEJDKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:10:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55048 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098AbYEJDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:19 -0400
Message-Id: <20080510030917.912938675@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:45 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com
Subject: [patch 14/21] Filesystem: Ext4 filesystem defrag
Content-Disposition: inline; filename=ext4-defrag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support defragmentation for extX filesystem inodes

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2008-05-07 21:23:41.961409593 -0700
+++ linux-2.6/fs/ext4/super.c	2008-05-07 21:27:18.215159859 -0700
@@ -599,6 +599,12 @@ static void init_once(struct kmem_cache 
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
@@ -608,6 +614,8 @@ static int init_inodecache(void)
 					     init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(ext4_inode_cachep,
+			ext4_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
