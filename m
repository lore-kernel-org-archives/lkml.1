Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYHAShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYHAShp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbYHASfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:35:30 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:8607 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441AbYHASf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:35:28 -0400
Message-Id: <20080801182347.686593269@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:17 -0700
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
 1 files changed, 8 insertions(+), 0 deletions(-)

Index: linux-2.6/fs/proc/inode.c
===================================================================
--- linux-2.6.orig/fs/proc/inode.c	2008-07-31 12:18:12.000000000 -0500
+++ linux-2.6/fs/proc/inode.c	2008-07-31 12:18:15.000000000 -0500
@@ -106,6 +106,12 @@
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
@@ -113,6 +119,8 @@
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once);
+	kmem_cache_setup_defrag(proc_inode_cachep,
+				proc_get_inodes, kick_inodes);
 	return 0;
 }
 

-- 
