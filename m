Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYAYIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYAYIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764106AbYAYIBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:01 -0500
Received: from mail.suse.de ([195.135.220.2]:59455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764074AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 194/196] Kobject: fix coding style issues in kobject.h
Date: Thu, 24 Jan 2008 23:33:43 -0800
Message-Id: <1201246425-5058-115-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally clean up the odd spaces and other mess in kobject.h

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   67 ++++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4adbe1d..caa3f41 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -3,15 +3,14 @@
  *
  * Copyright (c) 2002-2003 Patrick Mochel
  * Copyright (c) 2002-2003 Open Source Development Labs
- * Copyright (c) 2006-2007 Greg Kroah-Hartman <greg@kroah.com>
- * Copyright (c) 2006-2007 Novell Inc.
+ * Copyright (c) 2006-2008 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (c) 2006-2008 Novell Inc.
  *
  * This file is released under the GPLv2.
  *
- * 
  * Please read Documentation/kobject.txt before using the kobject
  * interface, ESPECIALLY the parts about reference counts and object
- * destructors. 
+ * destructors.
  */
 
 #ifndef _KOBJECT_H_
@@ -64,20 +63,20 @@ struct kobject {
 	const char		*name;
 	struct kref		kref;
 	struct list_head	entry;
-	struct kobject		* parent;
-	struct kset		* kset;
-	struct kobj_type	* ktype;
-	struct sysfs_dirent	* sd;
+	struct kobject		*parent;
+	struct kset		*kset;
+	struct kobj_type	*ktype;
+	struct sysfs_dirent	*sd;
 	unsigned int state_initialized:1;
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
 	unsigned int state_remove_uevent_sent:1;
 };
 
-extern int kobject_set_name(struct kobject *, const char *, ...)
-	__attribute__((format(printf,2,3)));
+extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
+			    __attribute__((format(printf, 2, 3)));
 
-static inline const char * kobject_name(const struct kobject * kobj)
+static inline const char *kobject_name(const struct kobject *kobj)
 {
 	return kobj->name;
 }
@@ -91,7 +90,7 @@ extern int __must_check kobject_init_and_add(struct kobject *kobj,
 					     struct kobject *parent,
 					     const char *fmt, ...);
 
-extern void kobject_del(struct kobject *);
+extern void kobject_del(struct kobject *kobj);
 
 extern struct kobject * __must_check kobject_create(void);
 extern struct kobject * __must_check kobject_create_and_add(const char *name,
@@ -100,15 +99,15 @@ extern struct kobject * __must_check kobject_create_and_add(const char *name,
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
-extern struct kobject * kobject_get(struct kobject *);
-extern void kobject_put(struct kobject *);
+extern struct kobject *kobject_get(struct kobject *kobj);
+extern void kobject_put(struct kobject *kobj);
 
-extern char * kobject_get_path(struct kobject *, gfp_t);
+extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
 
 struct kobj_type {
-	void (*release)(struct kobject *);
-	struct sysfs_ops	* sysfs_ops;
-	struct attribute	** default_attrs;
+	void (*release)(struct kobject *kobj);
+	struct sysfs_ops *sysfs_ops;
+	struct attribute **default_attrs;
 };
 
 struct kobj_uevent_env {
@@ -153,30 +152,30 @@ extern struct sysfs_ops kobj_sysfs_ops;
  * desired.
  */
 struct kset {
-	struct list_head	list;
-	spinlock_t		list_lock;
-	struct kobject		kobj;
-	struct kset_uevent_ops	*uevent_ops;
+	struct list_head list;
+	spinlock_t list_lock;
+	struct kobject kobj;
+	struct kset_uevent_ops *uevent_ops;
 };
 
-extern void kset_init(struct kset * k);
-extern int __must_check kset_register(struct kset * k);
-extern void kset_unregister(struct kset * k);
+extern void kset_init(struct kset *kset);
+extern int __must_check kset_register(struct kset *kset);
+extern void kset_unregister(struct kset *kset);
 extern struct kset * __must_check kset_create_and_add(const char *name,
 						struct kset_uevent_ops *u,
 						struct kobject *parent_kobj);
 
-static inline struct kset * to_kset(struct kobject * kobj)
+static inline struct kset *to_kset(struct kobject *kobj)
 {
-	return kobj ? container_of(kobj,struct kset,kobj) : NULL;
+	return kobj ? container_of(kobj, struct kset, kobj) : NULL;
 }
 
-static inline struct kset * kset_get(struct kset * k)
+static inline struct kset *kset_get(struct kset *k)
 {
 	return k ? to_kset(kobject_get(&k->kobj)) : NULL;
 }
 
-static inline void kset_put(struct kset * k)
+static inline void kset_put(struct kset *k)
 {
 	kobject_put(&k->kobj);
 }
@@ -186,7 +185,7 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
 	return kobj->ktype;
 }
 
-extern struct kobject * kset_find_obj(struct kset *, const char *);
+extern struct kobject *kset_find_obj(struct kset *, const char *);
 
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
@@ -208,18 +207,20 @@ int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 int kobject_action_type(const char *buf, size_t count,
 			enum kobject_action *type);
 #else
-static inline int kobject_uevent(struct kobject *kobj, enum kobject_action action)
+static inline int kobject_uevent(struct kobject *kobj,
+				 enum kobject_action action)
 { return 0; }
 static inline int kobject_uevent_env(struct kobject *kobj,
 				      enum kobject_action action,
 				      char *envp[])
 { return 0; }
 
-static inline int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
+static inline int add_uevent_var(struct kobj_uevent_env *env,
+				 const char *format, ...)
 { return 0; }
 
 static inline int kobject_action_type(const char *buf, size_t count,
-			enum kobject_action *type)
+				      enum kobject_action *type)
 { return -EINVAL; }
 #endif
 
-- 
1.5.3.8

