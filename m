Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbXJLWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbXJLWVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760788AbXJLWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:49615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594AbXJLWSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/75] Driver core: remove subsys_put()
Date: Fri, 12 Oct 2007 15:16:12 -0700
Message-Id: <11922274772578-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274732211-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more subsystems, it's a kset now so remove the function and
the only two users, which are in the driver core.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c      |    2 +-
 drivers/base/class.c    |    2 +-
 include/linux/kobject.h |    5 -----
 lib/kobject.c           |    2 +-
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 625f7e6..2f77593 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -734,7 +734,7 @@ struct bus_type *get_bus(struct bus_type *bus)
 
 void put_bus(struct bus_type * bus)
 {
-	subsys_put(&bus->subsys);
+	kset_put(&bus->subsys);
 }
 
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index cf9cf66..50e3413 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -100,7 +100,7 @@ static struct class *class_get(struct class *cls)
 static void class_put(struct class * cls)
 {
 	if (cls)
-		subsys_put(&cls->subsys);
+		kset_put(&cls->subsys);
 }
 
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ee61ef2..45effed 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -238,11 +238,6 @@ static inline struct kset *subsys_get(struct kset *s)
 	return NULL;
 }
 
-static inline void subsys_put(struct kset *s)
-{
-	kset_put(s);
-}
-
 struct subsys_attribute {
 	struct attribute attr;
 	ssize_t (*show)(struct kset *, char *);
diff --git a/lib/kobject.c b/lib/kobject.c
index 4b08e0f..0aa4e90 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -681,7 +681,7 @@ int subsys_create_file(struct kset *s, struct subsys_attribute *a)
 
 	if (subsys_get(s)) {
 		error = sysfs_create_file(&s->kobj, &a->attr);
-		subsys_put(s);
+		kset_put(s);
 	}
 	return error;
 }
-- 
1.5.3.4

