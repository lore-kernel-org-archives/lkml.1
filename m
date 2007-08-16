Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXHPUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXHPUNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXHPUNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:13:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45020 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750910AbXHPUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:13:08 -0400
Date: Thu, 16 Aug 2007 16:13:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <htejun@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: don't warn on removal of a nonexistent binary file
Message-ID: <Pine.LNX.4.44L0.0708161609060.2553-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as960) removes the error message and stack dump logged by
sysfs_remove_bin_file() when someone tries to remove a nonexistent
file.  The warning doesn't seem to be needed, since none of the other
file-, symlink-, or directory-removal routines in sysfs complain in a
comparable way.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This is 2.6.23 material.  The spurious error message can be triggered
by USB code added since 2.6.22, so it needs to be removed before the 
final release.

Alan Stern



Index: usb-2.6/fs/sysfs/bin.c
===================================================================
--- usb-2.6.orig/fs/sysfs/bin.c
+++ usb-2.6/fs/sysfs/bin.c
@@ -248,12 +248,7 @@ int sysfs_create_bin_file(struct kobject
 
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

