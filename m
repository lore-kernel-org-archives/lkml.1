Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYEJDQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYEJDQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYEJDKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:10:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55070 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbYEJDJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:21 -0400
Message-Id: <20080510030918.409594225@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com
Subject: [patch 16/21] Filesystem: /proc filesystem support for slab defrag
Content-Disposition: inline; filename=0028-FS-Proc-filesystem-support-for-slab-defrag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support procfs inode defragmentation

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/proc/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 82b3a1b..5bc8d23 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -104,6 +104,12 @@ static void init_once(struct kmem_cache * cachep, void *foo)
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
@@ -111,6 +117,8 @@ int __init proc_init_inodecache(void)
 					     0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once);
+	kmem_cache_setup_defrag(proc_inode_cachep,
+				proc_get_inodes, kick_inodes);
 	return 0;
 }
 
-- 
1.5.4.4

-- 
