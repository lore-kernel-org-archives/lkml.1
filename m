Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXJLWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXJLWVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbXJLWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:53093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759984AbXJLWSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/75] Driver core: remove kset_set_kset_s
Date: Fri, 12 Oct 2007 15:16:11 -0700
Message-Id: <11922274732211-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274682487-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is only used by the driver core and is held over from when we
had subsystems.  It is not needed anymore.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c      |    2 +-
 include/linux/kobject.h |   14 --------------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 18febe2..7ad8931 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -139,7 +139,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
 	cls->kset.kobj.parent = &system_subsys.kobj;
-	kset_set_kset_s(cls, system_subsys);
+	cls->kset.kobj.kset = &system_subsys;
 	return kset_register(&cls->kset);
 }
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 0713799..ee61ef2 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -227,20 +227,6 @@ extern struct kset hypervisor_subsys;
 #define kobj_set_kset_s(obj,subsys) \
 	(obj)->kobj.kset = &(subsys)
 
-/**
- *	kset_set_kset_s(obj,subsys) - set kset for embedded kset.
- *	@obj:		ptr to some object type.
- *	@subsys:	a subsystem object (not a ptr).
- *
- *	Can be used for any object type with an embedded ->kset.
- *	Sets the kset of @obj's  embedded kobject (via its embedded
- *	kset) to @subsys.kset. This makes @obj a member of that 
- *	kset.
- */
-
-#define kset_set_kset_s(obj,subsys) \
-	(obj)->kset.kobj.kset = &(subsys)
-
 extern void subsystem_init(struct kset *);
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.4

