Return-Path: <linux-kernel-owner+w=401wt.eu-S936353AbXGKX6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936353AbXGKX6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935318AbXGKXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:34039 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935314AbXGKXgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/61] sysfs: implement sysfs_find_dirent() and sysfs_get_dirent()
Date: Wed, 11 Jul 2007 16:32:12 -0700
Message-Id: <11841969912096-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969873230-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Implement sysfs_find_dirent() and sysfs_get_dirent().
sysfs_dirent_exist() is replaced by sysfs_find_dirent().  These will
be used to make directory entries reclamiable.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   61 +++++++++++++++++++++++++++++++++++++--------------
 fs/sysfs/file.c    |    2 +-
 fs/sysfs/symlink.c |    2 +-
 fs/sysfs/sysfs.h   |    5 +++-
 4 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f2ea006..4762a9a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -317,28 +317,55 @@ void sysfs_attach_dirent(struct sysfs_dirent *sd,
 	}
 }
 
-/*
+/**
+ *	sysfs_find_dirent - find sysfs_dirent with the given name
+ *	@parent_sd: sysfs_dirent to search under
+ *	@name: name to look for
  *
- * Return -EEXIST if there is already a sysfs element with the same name for
- * the same parent.
+ *	Look for sysfs_dirent with name @name under @parent_sd.
  *
- * called with parent inode's i_mutex held
+ *	LOCKING:
+ *	mutex_lock(parent->i_mutex)
+ *
+ *	RETURNS:
+ *	Pointer to sysfs_dirent if found, NULL if not.
  */
-int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
-			  const unsigned char *new)
+struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
+				       const unsigned char *name)
 {
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent *sd;
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if (sysfs_type(sd)) {
-			if (strcmp(sd->s_name, new))
-				continue;
-			else
-				return -EEXIST;
-		}
-	}
+	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+		if (sysfs_type(sd) && !strcmp(sd->s_name, name))
+			return sd;
+	return NULL;
+}
 
-	return 0;
+/**
+ *	sysfs_get_dirent - find and get sysfs_dirent with the given name
+ *	@parent_sd: sysfs_dirent to search under
+ *	@name: name to look for
+ *
+ *	Look for sysfs_dirent with name @name under @parent_sd and get
+ *	it if found.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to sysfs_dirent if found, NULL if not.
+ */
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name)
+{
+	struct sysfs_dirent *sd;
+
+	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
+	sd = sysfs_find_dirent(parent_sd, name);
+	sysfs_get(sd);
+	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
+
+	return sd;
 }
 
 static int create_dir(struct kobject *kobj, struct dentry *parent,
@@ -382,7 +409,7 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 
 	/* link in */
 	error = -EEXIST;
-	if (sysfs_dirent_exist(parent->d_fsdata, name))
+	if (sysfs_find_dirent(parent->d_fsdata, name))
 		goto out_iput;
 
 	sysfs_instantiate(dentry, inode);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a84b734..e448b88 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -421,7 +421,7 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 
 	mutex_lock(&dir->d_inode->i_mutex);
 
-	if (sysfs_dirent_exist(parent_sd, attr->name)) {
+	if (sysfs_find_dirent(parent_sd, attr->name)) {
 		error = -EEXIST;
 		goto out_unlock;
 	}
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index ff605d3..45b62e2 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -95,7 +95,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		return -ENOENT;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	if (!sysfs_dirent_exist(dentry->d_fsdata, name))
+	if (!sysfs_find_dirent(dentry->d_fsdata, name))
 		error = sysfs_add_link(parent_sd, name, target_sd);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 06b5085..f1629b4 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -59,7 +59,10 @@ extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
-extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
+extern struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
+					      const unsigned char *name);
+extern struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+					     const unsigned char *name);
 extern struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode,
 					     int type);
 extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
-- 
1.5.2.2

