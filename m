Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXJXQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXJXQ23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbXJXQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33334 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757511AbXJXQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:02 -0400
Date: Wed, 24 Oct 2007 18:23:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make sysfs_{get,put}_active() static
Message-ID: <20071024162332.GR30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_{get,put}_active() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/sysfs/dir.c   |    4 ++--
 fs/sysfs/sysfs.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

b8cce4e640340e80d233c704163f3c94718ae307 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7a8ce9e..3371629 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -132,7 +132,7 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
  *	RETURNS:
  *	Pointer to @sd on success, NULL on failure.
  */
-struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
+static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 {
 	if (unlikely(!sd))
 		return NULL;
@@ -161,7 +161,7 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
  *	Put an active reference to @sd.  This function is noop if @sd
  *	is NULL.
  */
-void sysfs_put_active(struct sysfs_dirent *sd)
+static void sysfs_put_active(struct sysfs_dirent *sd)
 {
 	struct completion *cmpl;
 	int v;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f841798..ff17f8d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -103,8 +103,6 @@ extern const struct file_operations sysfs_dir_operations;
 extern const struct inode_operations sysfs_dir_inode_operations;
 
 struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
-struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
-void sysfs_put_active(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 void sysfs_put_active_two(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,

