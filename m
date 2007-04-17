Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbXDQNRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbXDQNRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXDQNRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:17:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35469 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbXDQNR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:17:28 -0400
Date: Tue, 17 Apr 2007 18:54:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 14/15] tmpfs whiteout support
Message-ID: <20070417132451.GO4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
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
@@ -2400,6 +2405,7 @@ static const struct inode_operations shm
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.whiteout       = shmem_whiteout,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
@@ -2454,6 +2460,7 @@ static struct file_system_type tmpfs_fs_
 	.name		= "tmpfs",
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
+	.fs_flags	= FS_WHT,
 };
 static struct vfsmount *shm_mnt;
 
