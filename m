Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXIMXqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXIMXqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbXIMXo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:44:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57145 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765208AbXIMXoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:44:55 -0400
Date: Thu, 13 Sep 2007 16:39:23 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Driver core: remove kset_set_kset_s
Message-ID: <20070913233923.GC10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is only used by the driver core and is held over from when we
had subsystems.  It is not needed anymore.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/sys.c      |    2 +-
 include/linux/kobject.h |   14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -139,7 +139,7 @@ int sysdev_class_register(struct sysdev_
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
 	cls->kset.kobj.parent = &system_subsys.kobj;
-	kset_set_kset_s(cls, system_subsys);
+	cls->kset.kobj.kset = &system_subsys;
 	return kset_register(&cls->kset);
 }
 
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
