Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZLMX6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZLMX6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZLMX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZLMX6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:42 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, shemminger@vyatta.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kay.sievers@vrfy.org,
       akpm@linux-foundation.org
Subject: [PATCH 05/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:12 +0100
Message-Id: <c743d3e95038f4bc07221919c34abbf238fe4ef8.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 drivers/base/bus.c      |    4 ++--
 drivers/base/class.c    |    2 +-
 drivers/base/core.c     |    2 +-
 drivers/base/sys.c      |    4 ++--
 fs/sysfs/file.c         |    8 ++++----
 include/linux/kobject.h |    4 ++--
 lib/kobject.c           |    2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 63c143e..66ddfea 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -70,7 +70,7 @@ static ssize_t drv_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops driver_sysfs_ops = {
+static const struct sysfs_ops driver_sysfs_ops = {
 	.show	= drv_attr_show,
 	.store	= drv_attr_store,
 };
@@ -115,7 +115,7 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops bus_sysfs_ops = {
+static const struct sysfs_ops bus_sysfs_ops = {
 	.show	= bus_attr_show,
 	.store	= bus_attr_store,
 };
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 161746d..c2359c8 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -61,7 +61,7 @@ static void class_release(struct kobject *kobj)
 			 "be careful\n", class->name);
 }
 
-static struct sysfs_ops class_sysfs_ops = {
+static const struct sysfs_ops class_sysfs_ops = {
 	.show	= class_attr_show,
 	.store	= class_attr_store,
 };
diff --git a/drivers/base/core.c b/drivers/base/core.c
index f1290cb..c621664 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -100,7 +100,7 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-static struct sysfs_ops dev_sysfs_ops = {
+static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
 };
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..dd710ca 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -54,7 +54,7 @@ sysdev_store(struct kobject *kobj, struct attribute *attr,
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= sysdev_show,
 	.store	= sysdev_store,
 };
@@ -104,7 +104,7 @@ static ssize_t sysdev_class_store(struct kobject *kobj, struct attribute *attr,
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_class_ops = {
+static const struct sysfs_ops sysfs_class_ops = {
 	.show	= sysdev_class_show,
 	.store	= sysdev_class_store,
 };
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index dc30d9e..9d561f1 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -53,7 +53,7 @@ struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
 	char			* page;
-	struct sysfs_ops	* ops;
+	const struct sysfs_ops	* ops;
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
@@ -75,7 +75,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -199,7 +199,7 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -335,7 +335,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer *buffer;
-	struct sysfs_ops *ops;
+	const struct sysfs_ops *ops;
 	int error = -EACCES;
 	char *p;
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..072cee4 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -106,7 +106,7 @@ extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
 
 struct kobj_type {
 	void (*release)(struct kobject *kobj);
-	struct sysfs_ops *sysfs_ops;
+	const struct sysfs_ops *sysfs_ops;
 	struct attribute **default_attrs;
 };
 
@@ -132,7 +132,7 @@ struct kobj_attribute {
 			 const char *buf, size_t count);
 };
 
-extern struct sysfs_ops kobj_sysfs_ops;
+extern const struct sysfs_ops kobj_sysfs_ops;
 
 /**
  * struct kset - a set of kobjects of a specific type, belonging to a specific subsystem.
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..6567393 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -700,7 +700,7 @@ static ssize_t kobj_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
-struct sysfs_ops kobj_sysfs_ops = {
+const struct sysfs_ops kobj_sysfs_ops = {
 	.show	= kobj_attr_show,
 	.store	= kobj_attr_store,
 };
-- 
1.6.5.3

