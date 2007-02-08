Return-Path: <linux-kernel-owner+w=401wt.eu-S1422850AbXBHAdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850AbXBHAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161507AbXBHAda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422904AbXBHAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:38 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/28] sysfs: kobject_put cleanup
Date: Wed,  7 Feb 2007 16:30:07 -0800
Message-Id: <11708946832214-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946802786-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch removes redundant argument checks for kobject_put().

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c  |    5 ++---
 fs/sysfs/file.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9ec1c85..d3b9f5f 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -147,7 +147,7 @@ static int open(struct inode * inode, struct file * file)
  Error:
 	module_put(attr->attr.owner);
  Done:
-	if (error && kobj)
+	if (error)
 		kobject_put(kobj);
 	return error;
 }
@@ -158,8 +158,7 @@ static int release(struct inode * inode, struct file * file)
 	struct bin_attribute * attr = to_bin_attr(file->f_path.dentry);
 	u8 * buffer = file->private_data;
 
-	if (kobj) 
-		kobject_put(kobj);
+	kobject_put(kobj);
 	module_put(attr->attr.owner);
 	kfree(buffer);
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cba4c1c..46618f8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -361,7 +361,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	error = -EACCES;
 	module_put(attr->owner);
  Done:
-	if (error && kobj)
+	if (error)
 		kobject_put(kobj);
 	return error;
 }
@@ -375,8 +375,7 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 
 	if (buffer)
 		remove_from_collection(buffer, inode);
-	if (kobj) 
-		kobject_put(kobj);
+	kobject_put(kobj);
 	/* After this point, attr should not be accessed. */
 	module_put(owner);
 
-- 
1.4.4.4

