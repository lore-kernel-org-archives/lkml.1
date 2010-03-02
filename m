Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0CBXcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:32:50 -0500
Received: from kroah.org ([198.145.64.141]:38703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0CBX3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/62] sysfs: Kill unused sysfs_sb variable.
Date: Tue,  2 Mar 2010 15:28:53 -0800
Message-Id: <1267572541-410-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that there are no more users we can remove
the sysfs_sb variable.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |    2 --
 fs/sysfs/sysfs.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 89db07e..0cb1088 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -23,7 +23,6 @@
 
 
 static struct vfsmount *sysfs_mount;
-struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
 static const struct super_operations sysfs_ops = {
@@ -50,7 +49,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = SYSFS_MAGIC;
 	sb->s_op = &sysfs_ops;
 	sb->s_time_gran = 1;
-	sysfs_sb = sb;
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 7593d71..30f5a44 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -115,7 +115,6 @@ struct sysfs_addrm_cxt {
  * mount.c
  */
 extern struct sysfs_dirent sysfs_root;
-extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 /*
-- 
1.7.0.1

