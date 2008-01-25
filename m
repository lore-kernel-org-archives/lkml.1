Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYAYIWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYAYIWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764062AbYAYIA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:53685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761223AbYAYH7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 175/196] Kobject: remove kobject_unregister() as no one uses it anymore
Date: Thu, 24 Jan 2008 23:33:24 -0800
Message-Id: <1201246425-5058-96-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no in-kernel users of kobject_unregister() so it should be
removed.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    2 --
 lib/kobject.c           |   17 -----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index be03ce8..504ac0e 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -101,8 +101,6 @@ extern struct kobject * __must_check kobject_create_and_add(const char *name,
 extern int __must_check kobject_rename(struct kobject *, const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
-extern void kobject_unregister(struct kobject *);
-
 extern struct kobject * kobject_get(struct kobject *);
 extern void kobject_put(struct kobject *);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 462946e..a077373 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -533,22 +533,6 @@ void kobject_del(struct kobject * kobj)
 }
 
 /**
- *	kobject_unregister - remove object from hierarchy and decrement refcount.
- *	@kobj:	object going away.
- */
-
-void kobject_unregister(struct kobject * kobj)
-{
-	if (!kobj)
-		return;
-	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
-	kobject_uevent(kobj, KOBJ_REMOVE);
-	kobject_del(kobj);
-	kobject_put(kobj);
-}
-
-/**
  *	kobject_get - increment refcount for object.
  *	@kobj:	object.
  */
@@ -877,7 +861,6 @@ struct kset *kset_create_and_add(const char *name,
 }
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
-EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);
 EXPORT_SYMBOL(kobject_del);
-- 
1.5.3.8

