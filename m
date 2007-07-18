Return-Path: <linux-kernel-owner+w=401wt.eu-S936543AbXGRXaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543AbXGRXaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936192AbXGRX0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:57436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936211AbXGRX0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/14] sysfs: make sysfs_init_inode() static
Date: Wed, 18 Jul 2007 16:25:44 -0700
Message-Id: <11848011802979-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184801177102-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

With sysfs_fill_super() converted to use sysfs_get_inode(), there is
no user of sysfs_init_inode() outside of fs/sysfs/inode.c.  Make it
static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    2 +-
 fs/sysfs/sysfs.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 3756e15..10d1b52 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -133,7 +133,7 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
  */
 static struct lock_class_key sysfs_inode_imutex_key;
 
-void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
+static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &sysfs_aops;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6a37f23..6b8c8d7 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -71,7 +71,6 @@ extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 extern int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 extern void sysfs_delete_inode(struct inode *inode);
-extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
 extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
-- 
1.5.2.2

