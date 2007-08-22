Return-Path: <linux-kernel-owner+w=401wt.eu-S934581AbXHVWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581AbXHVWXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbXHVWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:22:14 -0400
Received: from mail.suse.de ([195.135.220.2]:54063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934513AbXHVWWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:22:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] sysfs: don't warn on removal of a nonexistent binary file
Date: Wed, 22 Aug 2007 15:10:20 -0700
Message-Id: <11878206634149-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <11878206493042-git-send-email-gregkh@suse.de>
References: <20070822220747.GA30603@kroah.com>
 <1187820620110-git-send-email-gregkh@suse.de>
 <11878206273940-git-send-email-gregkh@suse.de>
 <11878206353562-git-send-email-gregkh@suse.de>
 <11878206493042-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as960) removes the error message and stack dump logged by
sysfs_remove_bin_file() when someone tries to remove a nonexistent
file.  The warning doesn't seem to be needed, since none of the other
file-, symlink-, or directory-removal routines in sysfs complain in a
comparable way.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 135353f..5afe2a2 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -248,12 +248,7 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 
 void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
-	if (sysfs_hash_and_remove(kobj->sd, attr->attr.name) < 0) {
-		printk(KERN_ERR "%s: "
-			"bad dentry or inode or no such file: \"%s\"\n",
-			__FUNCTION__, attr->attr.name);
-		dump_stack();
-	}
+	sysfs_hash_and_remove(kobj->sd, attr->attr.name);
 }
 
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
-- 
1.5.3.rc5

