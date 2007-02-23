Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbXBWXUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbXBWXUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbXBWXTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:19:46 -0500
Received: from mail.suse.de ([195.135.220.2]:54381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264AbXBWXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:30 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/9] sysfs: move struct sysfs_dirent to private header
Date: Fri, 23 Feb 2007 15:15:50 -0800
Message-Id: <11722725623183-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <11722725592291-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam J. Richter <adam@yggdrasil.com>

struct sysfs_dirent is private to the fs/sysfs/ subtree.  It is
not even referenced as an opaque structure outside of that subtree.

The following patch moves the declaration from include/linux/sysfs.h to
fs/sysfs/sysfs.h, making it clearer that nothing else in the kernel
dereferences it.

I have been running this patch for years.  Please integrate and forward
upstream if there are no objections.

From: "Adam J. Richter" <adam@yggdrasil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/sysfs.h      |   11 +++++++++++
 include/linux/sysfs.h |   13 +------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index d976b00..a77c57e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,3 +1,14 @@
+struct sysfs_dirent {
+	atomic_t		s_count;
+	struct list_head	s_sibling;
+	struct list_head	s_children;
+	void 			* s_element;
+	int			s_type;
+	umode_t			s_mode;
+	struct dentry		* s_dentry;
+	struct iattr		* s_iattr;
+	atomic_t		s_event;
+};
 
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 192de3a..f07065c 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -17,6 +17,7 @@
 struct kobject;
 struct module;
 struct nameidata;
+struct dentry;
 
 struct attribute {
 	const char		* name;
@@ -68,18 +69,6 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
-struct sysfs_dirent {
-	atomic_t		s_count;
-	struct list_head	s_sibling;
-	struct list_head	s_children;
-	void 			* s_element;
-	int			s_type;
-	umode_t			s_mode;
-	struct dentry		* s_dentry;
-	struct iattr		* s_iattr;
-	atomic_t		s_event;
-};
-
 #define SYSFS_ROOT		0x0001
 #define SYSFS_DIR		0x0002
 #define SYSFS_KOBJ_ATTR 	0x0004
-- 
1.5.0.1

