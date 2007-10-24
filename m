Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXJXQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXJXQeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXJXQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33391 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759481AbXJXQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:01 -0400
Date: Wed, 24 Oct 2007 18:24:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: trond.myklebust@fys.uio.no
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make nfs_wb_page_priority() static
Message-ID: <20071024162430.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_wb_page_priority() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 9 Sep 2007

 fs/nfs/write.c         |    3 ++-
 include/linux/nfs_fs.h |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

30370f47093c3d812929d84a5a6be79ccb55a2b3 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 3e9e268..37953fd 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1424,7 +1424,8 @@ out:
 	return ret;
 }
 
-int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
+static int nfs_wb_page_priority(struct inode *inode, struct page *page,
+				int how)
 {
 	loff_t range_start = page_offset(page);
 	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f5414fc..e247a40 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -430,7 +430,6 @@ extern long nfs_sync_mapping_wait(struct address_space *, struct writeback_contr
 extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_nocommit(struct inode *inode);
 extern int nfs_wb_page(struct inode *inode, struct page* page);
-extern int nfs_wb_page_priority(struct inode *inode, struct page* page, int how);
 extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 extern int  nfs_commit_inode(struct inode *, int);

