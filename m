Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXJaFM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXJaFM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXJaFM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:12:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:34762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026AbXJaFMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:12:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] sysfs: make sysfs_{get,put}_active() static
Date: Tue, 30 Oct 2007 22:11:42 -0700
Message-Id: <1193807505-3821-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193807505-3821-2-git-send-email-gregkh@suse.de>
References: <20071031050954.GA3791@kroah.com>
 <1193807505-3821-1-git-send-email-gregkh@suse.de>
 <1193807505-3821-2-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

sysfs_{get,put}_active() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    4 ++--
 fs/sysfs/sysfs.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

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
-- 
1.5.3.4

