Return-Path: <linux-kernel-owner+w=401wt.eu-S940027AbXG3WN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940027AbXG3WN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969336AbXG3WKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969330AbXG3WKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] kset: kernel-doc cleanups
Date: Mon, 30 Jul 2007 15:09:31 -0700
Message-Id: <1185833408744-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858334042248-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
 <11858333892232-git-send-email-gregkh@suse.de>
 <11858333931362-git-send-email-gregkh@suse.de>
 <11858334013561-git-send-email-gregkh@suse.de>
 <11858334042248-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Removed kernel-doc marker (/**) from struct kset -- each struct member
still needs annotation.

Corrected one parameter name so that kernel-doc matches the macro.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 49a08f8..949706c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -111,9 +111,15 @@ struct kobj_type {
 	struct attribute	** default_attrs;
 };
 
+struct kset_uevent_ops {
+	int (*filter)(struct kset *kset, struct kobject *kobj);
+	const char *(*name)(struct kset *kset, struct kobject *kobj);
+	int (*uevent)(struct kset *kset, struct kobject *kobj, char **envp,
+			int num_envp, char *buffer, int buffer_size);
+};
 
-/**
- *	kset - a set of kobjects of a specific type, belonging
+/*
+ *	struct kset - a set of kobjects of a specific type, belonging
  *	to a specific subsystem.
  *
  *	All kobjects of a kset should be embedded in an identical 
@@ -129,13 +135,6 @@ struct kobj_type {
  *	supress the event generation or add subsystem specific
  *	variables carried with the event.
  */
-struct kset_uevent_ops {
-	int (*filter)(struct kset *kset, struct kobject *kobj);
-	const char *(*name)(struct kset *kset, struct kobject *kobj);
-	int (*uevent)(struct kset *kset, struct kobject *kobj, char **envp,
-			int num_envp, char *buffer, int buffer_size);
-};
-
 struct kset {
 	struct kobj_type	* ktype;
 	struct list_head	list;
@@ -176,7 +175,7 @@ static inline struct kobj_type * get_ktype(struct kobject * k)
 extern struct kobject * kset_find_obj(struct kset *, const char *);
 
 
-/**
+/*
  * Use this when initializing an embedded kset with no other 
  * fields to initialize.
  */
@@ -201,7 +200,7 @@ extern struct kset kernel_subsys;
 /* The global /sys/hypervisor/ subsystem  */
 extern struct kset hypervisor_subsys;
 
-/**
+/*
  * Helpers for setting the kset of registered objects.
  * Often, a registered object belongs to a kset embedded in a 
  * subsystem. These do no magic, just make the resulting code
@@ -236,7 +235,7 @@ extern struct kset hypervisor_subsys;
 /**
  *	subsys_set_kset(obj,subsys) - set kset for subsystem
  *	@obj:		ptr to some object type.
- *	@subsys:	a subsystem object (not a ptr).
+ *	@_subsys:	a subsystem object (not a ptr).
  *
  *	Can be used for any object type with an embedded ->subsys.
  *	Sets the kset of @obj's kobject to @subsys.kset. This makes
-- 
1.5.2.2

