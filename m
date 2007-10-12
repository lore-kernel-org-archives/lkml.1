Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbXJLWli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbXJLWli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbXJLWUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:53364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760067AbXJLWUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/75] sysfs: Remove sysfs_instantiate
Date: Fri, 12 Oct 2007 15:16:44 -0700
Message-Id: <11922276302338-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276254051-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sysfs_get_inode is dropping the inode lock
we no longer have a need from sysfs_instantiate.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |   17 -----------------
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5a70a93..739dda1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -773,7 +773,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	sysfs_instantiate(dentry, inode);
+	d_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
  out_unlock:
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 200e1bf..0d706a8 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -211,23 +211,6 @@ struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
 	return inode;
 }
 
-/**
- *	sysfs_instantiate - instantiate dentry
- *	@dentry: dentry to be instantiated
- *	@inode: inode associated with @sd
- *
- *	Unlock @inode if locked and instantiate @dentry with @inode.
- *
- *	LOCKING:
- *	None.
- */
-void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
-{
-	BUG_ON(!dentry || dentry->d_inode);
-
-	d_instantiate(dentry, inode);
-}
-
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 0436754..8a0aea1 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -69,7 +69,6 @@ extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 extern void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
-extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
-- 
1.5.3.4

