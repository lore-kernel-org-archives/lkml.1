Return-Path: <linux-kernel-owner+w=401wt.eu-S936738AbXGKX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936738AbXGKX6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934850AbXGKXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:34032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935306AbXGKXgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/61] sysfs: implement SYSFS_FLAG_REMOVED flag
Date: Wed, 11 Jul 2007 16:32:11 -0700
Message-Id: <11841969873230-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969814023-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Implement SYSFS_FLAG_REMOVED flag which currently is used only to
improve sanity check in sysfs_deactivate().  The flag will be used to
make directory entries reclamiable.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |    4 +++-
 fs/sysfs/inode.c      |    1 +
 include/linux/sysfs.h |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index eb9bc0a..f2ea006 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -171,7 +171,7 @@ void sysfs_deactivate(struct sysfs_dirent *sd)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(sd->s_sibling);
+	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
 	/* atomic_add_return() is a mb(), put_active() will always see
@@ -506,6 +506,7 @@ static void remove_dir(struct dentry * d)
 	mutex_lock(&parent->d_inode->i_mutex);
 
 	sysfs_unlink_sibling(sd);
+	sd->s_flags |= SYSFS_FLAG_REMOVED;
 
 	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
 		 atomic_read(&d->d_count));
@@ -540,6 +541,7 @@ static void __sysfs_remove_dir(struct dentry *dentry)
 		struct sysfs_dirent *sd = *pos;
 
 		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
+			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = removed;
 			removed = sd;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index ee3a5d9..e2f6ef1 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -296,6 +296,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 		if (!sysfs_type(sd))
 			continue;
 		if (!strcmp(sd->s_name, name)) {
+			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
 			found = 1;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5813550..2a6df64 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -84,6 +84,7 @@ struct sysfs_ops {
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_REMOVED	0x0100
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.2.2

