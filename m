Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbXITIPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbXITIPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbXITIGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33587 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbXITIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=LI3nwahDJrxkM3Yf/co3MSSkEs9hDsecPdCSb7dTZxLfjiav5x1Opv+5sRHLLd7mVuRx+YrbKqy1TZc/ZoOL0W9OwbgQ2gwBFr6ICKkIsQ73Bk92VySWv7lAbT2NgyrxBhcWj5ts1bVwIdRcSPR+OLNyKVrVOkbELbRpbNc6+pk=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 22/22] sysfs: move sysfs_assoc_lock into fs/sysfs/kobject.c and make it static
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:42 +0900
Message-Id: <11902755424114-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_assoc_lock which protects kobj <-> sd association is now only
used in fs/sysfs/kobject.c.  Move it there and make it static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |    1 -
 fs/sysfs/kobject.c |    2 ++
 fs/sysfs/sysfs.h   |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d0eb9bf..a74ca4a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -31,7 +31,6 @@
  */
 DEFINE_MUTEX(sysfs_op_mutex);
 DEFINE_MUTEX(sysfs_mutex);
-spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 55b884b..16e10de 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -19,6 +19,8 @@
 
 #define to_sattr(a) container_of(a,struct subsys_attribute, attr)
 
+static spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
+
 static int sysfs_remove_child(struct sysfs_dirent *parent, const char *name)
 {
 	struct sysfs_dirent *sd;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 69e1451..732b292 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -89,7 +89,6 @@ extern struct kmem_cache *sysfs_dir_cachep;
  */
 extern struct mutex sysfs_op_mutex;
 extern struct mutex sysfs_mutex;
-extern spinlock_t sysfs_assoc_lock;
 
 extern const struct file_operations sysfs_dir_operations;
 extern const struct inode_operations sysfs_dir_inode_operations;
-- 
1.5.0.3


