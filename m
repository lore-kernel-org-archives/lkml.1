Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXJLWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXJLWn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbXJLWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:49851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760582AbXJLWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/75] sysfs: Make sysfs_mount static
Date: Fri, 12 Oct 2007 15:16:46 -0700
Message-Id: <11922276392200-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227634772-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the users of sysfs_mount to use sysfs_root
instead (which is what they are looking for).  It then
makes sysfs_mount static to keep people from using it
by accident.

The net result is slightly faster and cleaner code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |    4 +---
 fs/sysfs/mount.c   |    2 +-
 fs/sysfs/symlink.c |    7 +++----
 fs/sysfs/sysfs.h   |    1 -
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 739dda1..7f4abe1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -737,10 +737,8 @@ int sysfs_create_dir(struct kobject * kobj)
 
 	if (kobj->parent)
 		parent_sd = kobj->parent->sd;
-	else if (sysfs_mount && sysfs_mount->mnt_sb)
-		parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
 	else
-		return -EFAULT;
+		parent_sd = &sysfs_root;
 
 	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
 	if (!error)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ac76256..8989cbb 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -14,7 +14,7 @@
 /* Random magic number */
 #define SYSFS_MAGIC 0x62656572
 
-struct vfsmount *sysfs_mount;
+static struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a6b13f1..8ad38bc 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -60,10 +60,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	BUG_ON(!name);
 
-	if (!kobj) {
-		if (sysfs_mount && sysfs_mount->mnt_sb)
-			parent_sd = sysfs_mount->mnt_sb->s_root->d_fsdata;
-	} else
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
 		parent_sd = kobj->sd;
 
 	error = -EFAULT;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 8a0aea1..77253aa 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -51,7 +51,6 @@ struct sysfs_addrm_cxt {
 	int			cnt;
 };
 
-extern struct vfsmount * sysfs_mount;
 extern struct sysfs_dirent sysfs_root;
 extern struct kmem_cache *sysfs_dir_cachep;
 
-- 
1.5.3.4

