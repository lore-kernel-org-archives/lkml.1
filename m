Return-Path: <linux-kernel-owner+w=401wt.eu-S1765691AbYAYIUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765691AbYAYIUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbYAYIAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:52 -0500
Received: from ns2.suse.de ([195.135.220.15]:53691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761679AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 168/196] Kset: remove kset_add function
Date: Thu, 24 Jan 2008 23:33:17 -0800
Message-Id: <1201246425-5058-89-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling this anymore, so just remove it and hard-code the one
internal-use of it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 -
 lib/kobject.c           |   13 +------------
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 2590847..63967da 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -158,7 +158,6 @@ struct kset {
 };
 
 extern void kset_init(struct kset * k);
-extern int __must_check kset_add(struct kset * k);
 extern int __must_check kset_register(struct kset * k);
 extern void kset_unregister(struct kset * k);
 extern struct kset * __must_check kset_create_and_add(const char *name,
diff --git a/lib/kobject.c b/lib/kobject.c
index 3326281..c321f19 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -710,17 +710,6 @@ struct sysfs_ops kobj_sysfs_ops = {
 };
 
 /**
- *	kset_add - add a kset object to the hierarchy.
- *	@k:	kset.
- */
-
-int kset_add(struct kset * k)
-{
-	return kobject_add_internal(&k->kobj);
-}
-
-
-/**
  *	kset_register - initialize and add a kset.
  *	@k:	kset.
  */
@@ -733,7 +722,7 @@ int kset_register(struct kset * k)
 		return -EINVAL;
 
 	kset_init(k);
-	err = kset_add(k);
+	err = kobject_add_internal(&k->kobj);
 	if (err)
 		return err;
 	kobject_uevent(&k->kobj, KOBJ_ADD);
-- 
1.5.3.8

