Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYBQIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYBQIUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbYBQISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:18:33 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36856 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976AbYBQISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:18:31 -0500
Date: Sun, 17 Feb 2008 10:18:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: joel.becker@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] fs/configfs/ cleanups
Message-ID: <20080217081805.GJ3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global file.c:configfs_add_file() static
- #if 0 the unused inode.c:configfs_hash_and_remove()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/configfs/configfs_internal.h |    3 ---
 fs/configfs/file.c              |    3 ++-
 fs/configfs/inode.c             |    2 ++
 3 files changed, 4 insertions(+), 4 deletions(-)

651b7a33c0dce1790230fe8ba9b7445cd69c8bde diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index cca9860..378fa36 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -63,9 +63,6 @@ extern int configfs_create_file(struct config_item *, const struct configfs_attr
 extern int configfs_make_dirent(struct configfs_dirent *,
 				struct dentry *, void *, umode_t, int);
 
-extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
-extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
-
 extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
 extern void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent);
 extern int configfs_setattr(struct dentry *dentry, struct iattr *iattr);
diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 397cb50..f331a40 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -314,7 +314,8 @@ const struct file_operations configfs_file_operations = {
 };
 
 
-int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type)
+static int configfs_add_file(struct dentry * dir,
+			     const struct configfs_attribute * attr, int type)
 {
 	struct configfs_dirent * parent_sd = dir->d_fsdata;
 	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 4c1ebff..dccff59 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -233,6 +233,7 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 	}
 }
 
+#if 0
 void configfs_hash_and_remove(struct dentry * dir, const char * name)
 {
 	struct configfs_dirent * sd;
@@ -255,6 +256,7 @@ void configfs_hash_and_remove(struct dentry * dir, const char * name)
 	}
 	mutex_unlock(&dir->d_inode->i_mutex);
 }
+#endif  /*  0  */
 
 int __init configfs_inode_init(void)
 {

