Return-Path: <linux-kernel-owner+w=401wt.eu-S937464AbXHGVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937464AbXHGVds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936546AbXHGVJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:09:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55229 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936536AbXHGVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:09:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 02/25] sysfs: Remove sysfs_instantiate
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:08:50 -0600
In-Reply-To: <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:08:07 -0600")
Message-ID: <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that sysfs_get_inode is dropping the inode lock
we no longer have a need from sysfs_instantiate.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |   17 -----------------
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ae06f4a..55d8299 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -771,7 +771,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	sysfs_instantiate(dentry, inode);
+	d_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
  out_unlock:
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index aefc346..70a2420 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -212,23 +212,6 @@ struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
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
1.5.1.1.181.g2de0

