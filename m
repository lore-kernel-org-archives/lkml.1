Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYAYIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYAYIRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763726AbYAYIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:45 -0500
Received: from ns1.suse.de ([195.135.220.2]:59441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 167/196] Kobject: remove kobject_register()
Date: Thu, 24 Jan 2008 23:33:16 -0800
Message-Id: <1201246425-5058-88-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is no longer used by anyone in the kernel, and it prevents
the proper sending of the kobject uevent after the needed files are set
up by the caller.  kobject_init_and_add() can be used in its place.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 -
 lib/kobject.c           |   18 ------------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index d9d8c36..2590847 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -96,7 +96,6 @@ extern struct kobject * __must_check kobject_create_and_add(const char *name,
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
-extern int __must_check kobject_register(struct kobject *);
 extern void kobject_unregister(struct kobject *);
 
 extern struct kobject * kobject_get(struct kobject *);
diff --git a/lib/kobject.c b/lib/kobject.c
index 4cc231c..3326281 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -220,23 +220,6 @@ static int kobject_add_internal(struct kobject *kobj)
 }
 
 /**
- *	kobject_register - initialize and add an object.
- *	@kobj:	object in question.
- */
-
-int kobject_register(struct kobject * kobj)
-{
-	int error = -EINVAL;
-	if (kobj) {
-		kobject_init_internal(kobj);
-		error = kobject_add(kobj);
-		if (!error)
-			kobject_uevent(kobj, KOBJ_ADD);
-	}
-	return error;
-}
-
-/**
  * kobject_set_name_vargs - Set the name of an kobject
  * @kobj: struct kobject to set the name of
  * @fmt: format string used to build the name
@@ -883,7 +866,6 @@ struct kset *kset_create_and_add(const char *name,
 }
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
-EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);
-- 
1.5.3.8

