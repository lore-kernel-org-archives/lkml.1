Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZJ2T3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZJ2T3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZJ2T3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:29:09 -0400
Received: from kroah.org ([198.145.64.141]:34069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbZJ2T3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:29:07 -0400
Subject: patch driver-core-devtmpfs-use-sys_mount.patch added to gregkh-2.6 tree
To: kay.sievers@vrfy.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Oct 2009 12:29:06 -0700
In-Reply-To: <1256755877.2618.322.camel@yio.site>
Message-ID: <12568445461385@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver Core: devtmpfs: use sys_mount()

to my gregkh-2.6 tree.  Its filename is

    driver-core-devtmpfs-use-sys_mount.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kay.sievers@vrfy.org  Thu Oct 29 11:59:46 2009
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 28 Oct 2009 19:51:17 +0100
Subject: Driver Core: devtmpfs: use sys_mount()
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1256755877.2618.322.camel@yio.site>


From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/devtmpfs.c |    9 ++-------
 include/linux/device.h  |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -330,9 +330,8 @@ out:
  * If configured, or requested by the commandline, devtmpfs will be
  * auto-mounted after the kernel mounted the root filesystem.
  */
-int devtmpfs_mount(const char *mountpoint)
+int devtmpfs_mount(const char *mntdir)
 {
-	struct path path;
 	int err;
 
 	if (!dev_mount)
@@ -341,15 +340,11 @@ int devtmpfs_mount(const char *mountpoin
 	if (!dev_mnt)
 		return 0;
 
-	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-	err = do_add_mount(dev_mnt, &path, 0, NULL);
+	err = sys_mount("none", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
 		printk(KERN_INFO "devtmpfs: mounted\n");
-	path_put(&path);
 	return err;
 }
 
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -558,7 +558,7 @@ extern void wait_for_device_probe(void);
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);
 extern int devtmpfs_delete_node(struct device *dev);
-extern int devtmpfs_mount(const char *mountpoint);
+extern int devtmpfs_mount(const char *mntdir);
 #else
 static inline int devtmpfs_create_node(struct device *dev) { return 0; }
 static inline int devtmpfs_delete_node(struct device *dev) { return 0; }

