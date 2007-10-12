Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXJLWU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXJLWU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbXJLWSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:53087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760972AbXJLWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/75] Driver core: remove subsys_set_kset
Date: Fri, 12 Oct 2007 15:16:10 -0700
Message-Id: <11922274682487-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274643370-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is only used by the driver core and is held over from when we
had subsystems.  It is not needed anymore.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c      |    3 ++-
 drivers/base/class.c    |    2 +-
 include/linux/kobject.h |   13 -------------
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index ff850d1..625f7e6 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -823,7 +823,8 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto out;
 
-	subsys_set_kset(bus, bus_subsys);
+	bus->subsys.kobj.kset = &bus_subsys;
+
 	retval = subsystem_register(&bus->subsys);
 	if (retval)
 		goto out;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index ecd6336..cf9cf66 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -149,7 +149,7 @@ int class_register(struct class * cls)
 	if (error)
 		return error;
 
-	subsys_set_kset(cls, class_subsys);
+	cls->subsys.kobj.kset = &class_subsys;
 
 	error = subsystem_register(&cls->subsys);
 	if (!error) {
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 626bdd3..0713799 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -241,19 +241,6 @@ extern struct kset hypervisor_subsys;
 #define kset_set_kset_s(obj,subsys) \
 	(obj)->kset.kobj.kset = &(subsys)
 
-/**
- *	subsys_set_kset(obj,subsys) - set kset for subsystem
- *	@obj:		ptr to some object type.
- *	@_subsys:	a subsystem object (not a ptr).
- *
- *	Can be used for any object type with an embedded ->subsys.
- *	Sets the kset of @obj's kobject to @subsys.kset. This makes
- *	the object a member of that kset.
- */
-
-#define subsys_set_kset(obj,_subsys) \
-	(obj)->subsys.kobj.kset = &(_subsys)
-
 extern void subsystem_init(struct kset *);
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.4

