Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbXENJic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbXENJic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXENJh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:37:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46762 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966129AbXENJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:37:54 -0400
Date: Mon, 14 May 2007 15:15:19 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 14/14] tmpfs whiteout support
Message-ID: <20070514094519.GP4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: tmpfs whiteout support

Introduce whiteout support to tmpfs.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 mm/shmem.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -74,7 +74,7 @@
 #define LATENCY_LIMIT	 64
 
 /* Pretend that each entry is of this size in directory's i_size */
-#define BOGO_DIRENT_SIZE 20
+#define BOGO_DIRENT_SIZE 1
 
 /* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
 enum sgp_type {
@@ -1772,6 +1772,11 @@ static int shmem_create(struct inode *di
 	return shmem_mknod(dir, dentry, mode | S_IFREG, 0);
 }
 
+static int shmem_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	return shmem_mknod(dir, dentry, S_IRUGO | S_IWUGO | S_IFWHT, 0);
+}
+
 /*
  * Link a file..
  */
@@ -2399,6 +2404,7 @@ static const struct inode_operations shm
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.whiteout       = shmem_whiteout,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
@@ -2453,6 +2459,7 @@ static struct file_system_type tmpfs_fs_
 	.name		= "tmpfs",
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
+	.fs_flags	= FS_WHT,
 };
 static struct vfsmount *shm_mnt;
 
