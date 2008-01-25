Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbYAYINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbYAYINt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbYAYIA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:28 -0500
Received: from mail.suse.de ([195.135.220.2]:59403 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762636AbYAYH7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 165/196] Kobject: remove kobject_init() as no one uses it anymore
Date: Thu, 24 Jan 2008 23:33:14 -0800
Message-Id: <1201246425-5058-86-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old kobject_init() function is on longer in use, so let us remove it
from the public scope (kset mess in the kobject.c file still uses it,
but that can be cleaned up later very simply.)

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 -
 lib/kobject.c           |   11 +++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 84c5afd..53458b6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -78,7 +78,6 @@ static inline const char * kobject_name(const struct kobject * kobj)
 	return kobj->k_name;
 }
 
-extern void kobject_init(struct kobject *);
 extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *kobj,
 				    struct kobject *parent,
diff --git a/lib/kobject.c b/lib/kobject.c
index 359e114..10d977b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -124,11 +124,7 @@ char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL_GPL(kobject_get_path);
 
-/**
- *	kobject_init - initialize object.
- *	@kobj:	object in question.
- */
-void kobject_init(struct kobject * kobj)
+static void kobject_init_internal(struct kobject * kobj)
 {
 	if (!kobj)
 		return;
@@ -232,7 +228,7 @@ int kobject_register(struct kobject * kobj)
 {
 	int error = -EINVAL;
 	if (kobj) {
-		kobject_init(kobj);
+		kobject_init_internal(kobj);
 		error = kobject_add(kobj);
 		if (!error)
 			kobject_uevent(kobj, KOBJ_ADD);
@@ -695,7 +691,7 @@ EXPORT_SYMBOL_GPL(kobject_create_and_add);
 
 void kset_init(struct kset * k)
 {
-	kobject_init(&k->kobj);
+	kobject_init_internal(&k->kobj);
 	INIT_LIST_HEAD(&k->list);
 	spin_lock_init(&k->list_lock);
 }
@@ -887,7 +883,6 @@ struct kset *kset_create_and_add(const char *name,
 }
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
-EXPORT_SYMBOL(kobject_init);
 EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
-- 
1.5.3.8

