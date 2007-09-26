Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbXIZD2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbXIZD2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbXIZD2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:28:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34665 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbXIZD2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:28:19 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 24/25] Unionfs: add un/likely conditionals on xattr ops
Date: Tue, 25 Sep 2007 23:10:03 -0400
Message-Id: <11907762142249-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/xattr.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 7f77d7d..bd2de06 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -23,14 +23,14 @@ void *unionfs_xattr_alloc(size_t size, size_t limit)
 {
 	void *ptr;
 
-	if (size > limit)
+	if (unlikely(size > limit))
 		return ERR_PTR(-E2BIG);
 
 	if (!size)		/* size request, no buffer is needed */
 		return NULL;
 
 	ptr = kmalloc(size, GFP_KERNEL);
-	if (!ptr)
+	if (unlikely(!ptr))
 		return ERR_PTR(-ENOMEM);
 	return ptr;
 }
@@ -48,7 +48,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -77,7 +77,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -106,7 +106,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -135,7 +135,7 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
-- 
1.5.2.2

