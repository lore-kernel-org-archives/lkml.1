Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbXJLW4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbXJLW4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXJLWWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:50003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbXJLWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 64/75] sysfs: move sysfs_dirent->s_children into sysfs_dirent->s_dir
Date: Fri, 12 Oct 2007 15:17:08 -0700
Message-Id: <11922277403355-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277364080-git-send-email-gregkh@suse.de>
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
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
 <11922277364080-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Children list head is only meaninful for directory nodes.  Move it
into s_dir.  This doesn't save any space currently but it will with
further changes.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   17 +++++++++--------
 fs/sysfs/inode.c |    2 +-
 fs/sysfs/sysfs.h |    3 ++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 48a3ed4..4ad9422 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -26,7 +26,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	@sd: sysfs_dirent of interest
  *
  *	Link @sd into its sibling list which starts from
- *	sd->s_parent->s_children.
+ *	sd->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -40,9 +40,9 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
 
 	/* Store directory entries in order by ino.  This allows
 	 * readdir to properly restart without having to add a
-	 * cursor into the s_children list.
+	 * cursor into the s_dir.children list.
 	 */
-	for (pos = &parent_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
+	for (pos = &parent_sd->s_dir.children; *pos; pos = &(*pos)->s_sibling) {
 		if (sd->s_ino < (*pos)->s_ino)
 			break;
 	}
@@ -55,7 +55,7 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
  *	@sd: sysfs_dirent of interest
  *
  *	Unlink @sd from its sibling list which starts from
- *	sd->s_parent->s_children.
+ *	sd->s_parent->s_dir.children.
  *
  *	Locking:
  *	mutex_lock(sysfs_mutex)
@@ -64,7 +64,8 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent **pos;
 
-	for (pos = &sd->s_parent->s_children; *pos; pos = &(*pos)->s_sibling) {
+	for (pos = &sd->s_parent->s_dir.children; *pos;
+	     pos = &(*pos)->s_sibling) {
 		if (*pos == sd) {
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
@@ -570,7 +571,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 {
 	struct sysfs_dirent *sd;
 
-	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling)
+	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling)
 		if (!strcmp(sd->s_name, name))
 			return sd;
 	return NULL;
@@ -722,7 +723,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_children;
+	pos = &dir_sd->s_dir.children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
@@ -922,7 +923,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		mutex_lock(&sysfs_mutex);
 
 		/* Skip the dentries we have already reported */
-		pos = parent_sd->s_children;
+		pos = parent_sd->s_dir.children;
 		while (pos && (filp->f_pos > pos->s_ino))
 			pos = pos->s_sibling;
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index c40fb9f..2210cf0 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -127,7 +127,7 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 	struct sysfs_dirent *child;
 	int nr = 0;
 
-	for (child = sd->s_children; child; child = child->s_sibling)
+	for (child = sd->s_dir.children; child; child = child->s_sibling)
 		if (sysfs_type(child) == SYSFS_DIR)
 			nr++;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 60405a6..42b0327 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,6 +1,8 @@
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
+	/* children list starts here and goes through sd->s_sibling */
+	struct sysfs_dirent	*children;
 };
 
 struct sysfs_elem_symlink {
@@ -28,7 +30,6 @@ struct sysfs_dirent {
 	atomic_t		s_active;
 	struct sysfs_dirent	*s_parent;
 	struct sysfs_dirent	*s_sibling;
-	struct sysfs_dirent	*s_children;
 	const char		*s_name;
 
 	union {
-- 
1.5.3.4

