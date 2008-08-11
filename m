Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYHKPXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYHKPXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYHKPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:22:54 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:4329 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYHKPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:22:51 -0400
Message-Id: <20080811150659.370383628@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:32 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Alexey Dobriyan <adobriyan@sw.ru>,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 16/19] Filesystem: /proc filesystem support for slab defrag
Content-Disposition: inline; filename=0028-FS-Proc-filesystem-support-for-slab-defrag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support procfs inode defragmentation

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/proc/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-next/fs/proc/inode.c
===================================================================
--- linux-next.orig/fs/proc/inode.c	2008-08-11 07:42:11.542357951 -0700
+++ linux-next/fs/proc/inode.c	2008-08-11 07:47:05.102359374 -0700
@@ -106,6 +106,12 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *proc_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct proc_inode, vfs_inode));
+};
+
 int __init proc_init_inodecache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
@@ -113,6 +119,8 @@ int __init proc_init_inodecache(void)
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once);
+	kmem_cache_setup_defrag(proc_inode_cachep,
+				proc_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
