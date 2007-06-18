Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXFRUlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXFRUlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764362AbXFRUll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:41:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760382AbXFRUlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:41:40 -0400
Date: Mon, 18 Jun 2007 13:41:32 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] debugfs: create file error handling
Message-ID: <20070618134132.463a6699@localhost.localdomain>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't Debugfs file routines should either return NULL or use ERR_PTR()
not mixed? The following patch changes the create routines to
propagate return values.

--- a/fs/debugfs/file.c	2007-05-30 10:32:32.000000000 -0700
+++ b/fs/debugfs/file.c	2007-06-18 13:38:01.000000000 -0700
@@ -83,12 +83,11 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
@@ -124,12 +123,11 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugf
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value)
@@ -165,12 +163,11 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugf
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
@@ -207,12 +204,11 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugf
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				 struct dentry *parent, u64 *value)
@@ -286,12 +282,11 @@ static const struct file_operations fops
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				   struct dentry *parent, u32 *value)
@@ -330,12 +325,12 @@ static const struct file_operations fops
  * This function will return a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the debugfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, %NULL will be returned.
+ * you are responsible here.)
  *
- * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ *
+ * If an error occurs, an invalid pointer will be returned, use
+ * the function IS_ERR() to check. The error code can be extracted
+ * with PTR_ERR().
  */
 struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				   struct dentry *parent,
--- a/fs/debugfs/inode.c	2007-05-30 10:32:32.000000000 -0700
+++ b/fs/debugfs/inode.c	2007-06-18 13:38:26.000000000 -0700
@@ -226,14 +226,11 @@ struct dentry *debugfs_create_file(const
 	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
 			      &debugfs_mount_count);
 	if (error)
-		goto exit;
+		goto err;
 
 	error = debugfs_create_by_name(name, mode, parent, &dentry);
-	if (error) {
-		dentry = NULL;
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-		goto exit;
-	}
+	if (error)
+		goto release;
 
 	if (dentry->d_inode) {
 		if (data)
@@ -241,8 +238,12 @@ struct dentry *debugfs_create_file(const
 		if (fops)
 			dentry->d_inode->i_fop = fops;
 	}
-exit:
+
 	return dentry;
+release:
+	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+err:
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file);
 
