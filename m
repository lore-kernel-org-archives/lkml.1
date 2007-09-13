Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXIMXr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXIMXr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXIMXpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57150 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbXIMXpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:05 -0400
Date: Thu, 13 Sep 2007 16:40:51 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Driver core: remove subsys_set_kset
Message-ID: <20070913234051.GG10856@kroah.com>
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
 drivers/base/bus.c      |    3 ++-
 drivers/base/class.c    |    2 +-
 include/linux/kobject.h |   13 -------------
 3 files changed, 3 insertions(+), 15 deletions(-)

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
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -149,7 +149,7 @@ int class_register(struct class * cls)
 	if (error)
 		return error;
 
-	subsys_set_kset(cls, class_subsys);
+	cls->subsys.kobj.kset = &class_subsys;
 
 	error = subsystem_register(&cls->subsys);
 	if (!error) {
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
