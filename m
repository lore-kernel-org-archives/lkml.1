Return-Path: <linux-kernel-owner+w=401wt.eu-S936950AbXGLABA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936950AbXGLABA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935217AbXGKXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:33529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935282AbXGKXhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/61] sysfs: move sysfs_drop_dentry() to dir.c and make it static
Date: Wed, 11 Jul 2007 16:32:17 -0700
Message-Id: <11841970162061-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841970112965-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
 <11841970013184-git-send-email-gregkh@suse.de>
 <11841970052991-git-send-email-gregkh@suse.de>
 <11841970112965-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

After add/remove path restructuring, the only user of
sysfs_drop_dentry() is sysfs_addrm_finish().  Move sysfs_drop_dentry()
to dir.c and make it static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/inode.c |   56 ------------------------------------------------------
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index edb3062..c6f3b69 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -435,6 +435,62 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
+ *	@sd: target sysfs_dirent
+ *
+ *	Drop dentry for @sd.  @sd must have been unlinked from its
+ *	parent on entry to this function such that it can't be looked
+ *	up anymore.
+ *
+ *	@sd->s_dentry which is protected with sysfs_assoc_lock points
+ *	to the currently associated dentry but we're not holding a
+ *	reference to it and racing with dput().  Grab dcache_lock and
+ *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
+ *	dput() beats us, no need to bother.
+ */
+static void sysfs_drop_dentry(struct sysfs_dirent *sd)
+{
+	struct dentry *dentry = NULL;
+	struct inode *inode;
+
+	/* We're not holding a reference to ->s_dentry dentry but the
+	 * field will stay valid as long as sysfs_assoc_lock is held.
+	 */
+	spin_lock(&sysfs_assoc_lock);
+	spin_lock(&dcache_lock);
+
+	/* drop dentry if it's there and dput() didn't kill it yet */
+	if (sd->s_dentry && sd->s_dentry->d_inode) {
+		dentry = dget_locked(sd->s_dentry);
+		spin_lock(&dentry->d_lock);
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
+	}
+
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sysfs_assoc_lock);
+
+	dput(dentry);
+	/* XXX: unpin if directory, this will go away soon */
+	if (sysfs_type(sd) == SYSFS_DIR)
+		dput(dentry);
+
+	/* adjust nlink and update timestamp */
+	inode = ilookup(sysfs_sb, sd->s_ino);
+	if (inode) {
+		mutex_lock(&inode->i_mutex);
+
+		inode->i_ctime = CURRENT_TIME;
+		drop_nlink(inode);
+		if (sysfs_type(sd) == SYSFS_DIR)
+			drop_nlink(inode);
+
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
+	}
+}
+
+/**
  *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
  *	@acxt: addrm context to finish up
  *
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index f959668..3756e15 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -197,62 +197,6 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 	d_instantiate(dentry, inode);
 }
 
-/**
- *	sysfs_drop_dentry - drop dentry for the specified sysfs_dirent
- *	@sd: target sysfs_dirent
- *
- *	Drop dentry for @sd.  @sd must have been unlinked from its
- *	parent on entry to this function such that it can't be looked
- *	up anymore.
- *
- *	@sd->s_dentry which is protected with sysfs_assoc_lock points
- *	to the currently associated dentry but we're not holding a
- *	reference to it and racing with dput().  Grab dcache_lock and
- *	verify dentry before dropping it.  If @sd->s_dentry is NULL or
- *	dput() beats us, no need to bother.
- */
-void sysfs_drop_dentry(struct sysfs_dirent *sd)
-{
-	struct dentry *dentry = NULL;
-	struct inode *inode;
-
-	/* We're not holding a reference to ->s_dentry dentry but the
-	 * field will stay valid as long as sysfs_assoc_lock is held.
-	 */
-	spin_lock(&sysfs_assoc_lock);
-	spin_lock(&dcache_lock);
-
-	/* drop dentry if it's there and dput() didn't kill it yet */
-	if (sd->s_dentry && sd->s_dentry->d_inode) {
-		dentry = dget_locked(sd->s_dentry);
-		spin_lock(&dentry->d_lock);
-		__d_drop(dentry);
-		spin_unlock(&dentry->d_lock);
-	}
-
-	spin_unlock(&dcache_lock);
-	spin_unlock(&sysfs_assoc_lock);
-
-	dput(dentry);
-	/* XXX: unpin if directory, this will go away soon */
-	if (sysfs_type(sd) == SYSFS_DIR)
-		dput(dentry);
-
-	/* adjust nlink and update timestamp */
-	inode = ilookup(sysfs_sb, sd->s_ino);
-	if (inode) {
-		mutex_lock(&inode->i_mutex);
-
-		inode->i_ctime = CURRENT_TIME;
-		drop_nlink(inode);
-		if (sysfs_type(sd) == SYSFS_DIR)
-			drop_nlink(inode);
-
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
-}
-
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3e9a5ee..92fe1e5 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -90,7 +90,6 @@ extern int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			       struct sysfs_dirent **p_sd);
 extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_assoc_lock;
-- 
1.5.2.2

