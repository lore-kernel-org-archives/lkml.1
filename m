Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbXIMXrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbXIMXrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXIMXpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41161 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765186AbXIMXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:03 -0400
Date: Thu, 13 Sep 2007 16:40:32 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Driver core: remove subsys_put()
Message-ID: <20070913234032.GF10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
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

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -734,7 +734,7 @@ struct bus_type *get_bus(struct bus_type
 
 void put_bus(struct bus_type * bus)
 {
-	subsys_put(&bus->subsys);
+	kset_put(&bus->subsys);
 }
 
 
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -100,7 +100,7 @@ static struct class *class_get(struct cl
 static void class_put(struct class * cls)
 {
 	if (cls)
-		subsys_put(&cls->subsys);
+		kset_put(&cls->subsys);
 }
 
 
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -238,11 +238,6 @@ static inline struct kset *subsys_get(st
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
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -681,7 +681,7 @@ int subsys_create_file(struct kset *s, s
 
 	if (subsys_get(s)) {
 		error = sysfs_create_file(&s->kobj, &a->attr);
-		subsys_put(s);
+		kset_put(s);
 	}
 	return error;
 }
