Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbXIQVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbXIQVzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbXIQVze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:55:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55163 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305AbXIQVzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:55:32 -0400
Date: Mon, 17 Sep 2007 16:50:54 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 9/11] eCryptfs: Initialize persistent lower file on inode create
Message-ID: <20070917215054.GQ13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize persistent lower file on inode create.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/super.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index b97e210..f8cdab2 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -47,15 +47,16 @@ struct kmem_cache *ecryptfs_inode_info_cache;
  */
 static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
 {
-	struct ecryptfs_inode_info *ecryptfs_inode;
+	struct ecryptfs_inode_info *inode_info;
 	struct inode *inode = NULL;
 
-	ecryptfs_inode = kmem_cache_alloc(ecryptfs_inode_info_cache,
-					  GFP_KERNEL);
-	if (unlikely(!ecryptfs_inode))
+	inode_info = kmem_cache_alloc(ecryptfs_inode_info_cache, GFP_KERNEL);
+	if (unlikely(!inode_info))
 		goto out;
-	ecryptfs_init_crypt_stat(&ecryptfs_inode->crypt_stat);
-	inode = &ecryptfs_inode->vfs_inode;
+	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
+	mutex_init(&inode_info->lower_file_mutex);
+	inode_info->lower_file = NULL;
+	inode = &inode_info->vfs_inode;
 out:
 	return inode;
 }
-- 
1.5.1.6

