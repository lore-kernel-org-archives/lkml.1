Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbXJLWzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbXJLWzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbXJLWWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:53551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXJLWW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 62/75] sysfs: open code sysfs_attach_dentry()
Date: Fri, 12 Oct 2007 15:17:06 -0700
Message-Id: <1192227731677-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277261501-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs_attach_dentry() now has only one caller and isn't doing much
other than obfuscating the code.  Open code and kill it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 6ee76a8..48a3ed4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -332,21 +332,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
-/**
- *	sysfs_attach_dentry - associate sysfs_dirent with dentry
- *	@sd: target sysfs_dirent
- *	@dentry: dentry to associate
- *
- *	LOCKING:
- *	mutex_lock(sysfs_mutex)
- */
-static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
-{
-	dentry->d_op = &sysfs_dentry_ops;
-	dentry->d_fsdata = sysfs_get(sd);
-	d_rehash(dentry);
-}
-
 static int sysfs_ilookup_test(struct inode *inode, void *arg)
 {
 	struct sysfs_dirent *sd = arg;
@@ -696,8 +681,11 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
+	/* instantiate and hash dentry */
+	dentry->d_op = &sysfs_dentry_ops;
+	dentry->d_fsdata = sysfs_get(sd);
 	d_instantiate(dentry, inode);
-	sysfs_attach_dentry(sd, dentry);
+	d_rehash(dentry);
 
  out_unlock:
 	mutex_unlock(&sysfs_mutex);
-- 
1.5.3.4

