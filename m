Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbXIABsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbXIABsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXIABn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:43:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46128 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751758AbXIABmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:24 -0400
Message-Id: <20070901014223.907580798@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:27 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 20/26] FS: Proc filesystem support for slab defrag
Content-Disposition: inline; filename=0020-slab_defrag_proc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support procfs inode defragmentation

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/proc/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index a5b0dfd..83a66d7 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -113,6 +113,12 @@ static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flag
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
@@ -122,6 +128,8 @@ int __init proc_init_inodecache(void)
 					     init_once);
 	if (proc_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(proc_inode_cachep,
+				proc_get_inodes, kick_inodes);
 	return 0;
 }
 
-- 
1.5.2.4

-- 
