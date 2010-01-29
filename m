Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0A2UwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0A2UwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123Ab0A2UwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:52:09 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:43355 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0A2UwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:52:02 -0500
Message-Id: <20100129205007.248543650@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:47 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Filesystems: /proc filesystem support for slab defrag
Content-Disposition: inline; filename=defrag_proc
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

Index: linux-2.6/fs/proc/inode.c
===================================================================
--- linux-2.6.orig/fs/proc/inode.c	2009-12-18 13:13:24.000000000 -0600
+++ linux-2.6/fs/proc/inode.c	2010-01-29 10:33:22.000000000 -0600
@@ -77,6 +77,12 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
+static void *proc_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct proc_inode, vfs_inode));
+}
+
 void __init proc_init_inodecache(void)
 {
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
@@ -84,6 +90,8 @@ void __init proc_init_inodecache(void)
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once);
+	kmem_cache_setup_defrag(proc_inode_cachep,
+				proc_get_inodes, kick_inodes)
 }
 
 static const struct super_operations proc_sops = {

-- 
