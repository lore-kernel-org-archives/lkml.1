Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYBQIVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYBQIVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYBQITK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:19:10 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59678 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbYBQITI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:19:08 -0500
Date: Sun, 17 Feb 2008 10:18:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make vfs_ioctl() static
Message-ID: <20080217081842.GM3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global vfs_ioctl() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ioctl.c         |    4 ++--
 include/linux/fs.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

18bc247a745a825238208f88fbe1b86ba1ef304e diff --git a/fs/ioctl.c b/fs/ioctl.c
index f32fbde..7db32b3 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -28,8 +28,8 @@
  *
  * Returns 0 on success, -errno on error.
  */
-long vfs_ioctl(struct file *filp, unsigned int cmd,
-	       unsigned long arg)
+static long vfs_ioctl(struct file *filp, unsigned int cmd,
+		      unsigned long arg)
 {
 	int error = -ENOTTY;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..23528b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1919,7 +1919,6 @@ extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 
-extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 

