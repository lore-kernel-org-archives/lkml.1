Return-Path: <linux-kernel-owner+w=401wt.eu-S934228AbXJLWq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbXJLWq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932623AbXJLWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:49906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbXJLWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/75] sysfs: Remove s_dentry
Date: Fri, 12 Oct 2007 15:16:52 -0700
Message-Id: <11922276672660-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276622731-git-send-email-gregkh@suse.de>
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
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The only uses of s_dentry left are the code that maintains
s_dentry and trivial users that don't actually need it.
So this patch removes the s_dentry maintenance code and
restructures the trivial uses to use something else.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   32 ++++----------------------------
 fs/sysfs/mount.c |    1 -
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1c3dc5d..36b6c79 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -289,22 +289,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
-	if (sd) {
-		/* sd->s_dentry is protected with sysfs_assoc_lock.
-		 * This allows sysfs_drop_dentry() to dereference it.
-		 */
-		spin_lock(&sysfs_assoc_lock);
-
-		/* The dentry might have been deleted or another
-		 * lookup could have happened updating sd->s_dentry to
-		 * point the new dentry.  Ignore if it isn't pointing
-		 * to this dentry.
-		 */
-		if (sd->s_dentry == dentry)
-			sd->s_dentry = NULL;
-		spin_unlock(&sysfs_assoc_lock);
-		sysfs_put(sd);
-	}
+	sysfs_put(sd);
 	iput(inode);
 }
 
@@ -352,9 +337,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
  *	@sd: target sysfs_dirent
  *	@dentry: dentry to associate
  *
- *	Associate @sd with @dentry.  This is protected by
- *	sysfs_assoc_lock to avoid race with sysfs_d_iput().
- *
  *	LOCKING:
  *	mutex_lock(sysfs_mutex)
  */
@@ -362,12 +344,6 @@ static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
 {
 	dentry->d_op = &sysfs_dentry_ops;
 	dentry->d_fsdata = sysfs_get(sd);
-
-	/* protect sd->s_dentry against sysfs_d_iput */
-	spin_lock(&sysfs_assoc_lock);
-	sd->s_dentry = dentry;
-	spin_unlock(&sysfs_assoc_lock);
-
 	d_rehash(dentry);
 }
 
@@ -846,7 +822,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 
 	/* rename */
 	d_add(new_dentry, NULL);
-	d_move(sd->s_dentry, new_dentry);
+	d_move(old_dentry, new_dentry);
 
 	error = 0;
 	goto out_unlock;
@@ -881,7 +857,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 		error = PTR_ERR(old_dentry);
 		goto out_dput;
 	}
-	old_parent = sd->s_parent->s_dentry;
+	old_parent = old_dentry->d_parent;
 
 	new_parent = sysfs_get_dentry(new_parent_sd);
 	if (IS_ERR(new_parent)) {
@@ -907,7 +883,7 @@ again:
 	} else
 		error = 0;
 	d_add(new_dentry, NULL);
-	d_move(sd->s_dentry, new_dentry);
+	d_move(old_dentry, new_dentry);
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8989cbb..28bf359 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -56,7 +56,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 		iput(inode);
 		return -ENOMEM;
 	}
-	sysfs_root.s_dentry = root;
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
 	return 0;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 179e6a2..791b3ed 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -37,7 +37,6 @@ struct sysfs_dirent {
 	unsigned int		s_flags;
 	umode_t			s_mode;
 	ino_t			s_ino;
-	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;
 };
-- 
1.5.3.4

