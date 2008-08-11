Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYHKPXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYHKPXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYHKPWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:22:52 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:4329 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYHKPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:22:48 -0400
Message-Id: <20080811150658.494092606@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:29 -0700
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
Subject: [patch 13/19] Filesystem: Ext3 filesystem defrag
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
