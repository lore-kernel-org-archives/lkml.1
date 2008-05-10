Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbYEJDSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbYEJDSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYEJDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:10:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55049 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752280AbYEJDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:19 -0400
Message-Id: <20080510030918.641537636@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:48 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mpm@selenic.com
Subject: [patch 17/21] Filesystem: Slab defrag: Reiserfs support
Content-Disposition: inline; filename=0029-FS-Slab-defrag-Reiserfs-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab defragmentation: Support reiserfs inode defragmentation.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/reiserfs/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 393cc22..69b4a86 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -532,6 +532,12 @@ static void init_once(struct kmem_cache * cachep, void *foo)
 #endif
 }
 
+static void *reiserfs_get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	return fs_get_inodes(s, nr, v,
+		offsetof(struct reiserfs_inode_info, vfs_inode));
+}
+
 static int init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
@@ -542,6 +548,8 @@ static int init_inodecache(void)
 						  init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
+	kmem_cache_setup_defrag(reiserfs_inode_cachep,
+			reiserfs_get_inodes, kick_inodes);
 	return 0;
 }
 
-- 
1.5.4.4

-- 
