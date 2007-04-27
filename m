Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbXD0TFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbXD0TFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbXD0S6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:50746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbXD0S6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 30/46] kobject core: remove rwsem from struct subsystem
Date: Fri, 27 Apr 2007 11:53:44 -0700
Message-Id: <1177700148815-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001442148-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't used at all by the driver core anymore, and the few usages of
it within the kernel have now all been fixed as most of them were using
it incorrectly.  So remove it.

Now the whole struct subsys can be removed from the system, but that's
for a later patch...

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    2 --
 lib/kobject.c           |    4 +---
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index d37cd7f..a659a97 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -22,7 +22,6 @@
 #include <linux/sysfs.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>
 #include <linux/kref.h>
 #include <linux/kernel.h>
 #include <linux/wait.h>
@@ -177,7 +176,6 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 
 struct subsystem {
 	struct kset		kset;
-	struct rw_semaphore	rwsem;
 };
 
 #define decl_subsys(_name,_type,_uevent_ops) \
diff --git a/lib/kobject.c b/lib/kobject.c
index eb251aa..2882aff 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -652,7 +652,6 @@ struct kobject * kset_find_obj(struct kset * kset, const char * name)
 
 void subsystem_init(struct subsystem * s)
 {
-	init_rwsem(&s->rwsem);
 	kset_init(&s->kset);
 }
 
@@ -661,8 +660,7 @@ void subsystem_init(struct subsystem * s)
  *	@s:	the subsystem we're registering.
  *
  *	Once we register the subsystem, we want to make sure that 
- *	the kset points back to this subsystem for correct usage of 
- *	the rwsem. 
+ *	the kset points back to this subsystem.
  */
 
 int subsystem_register(struct subsystem * s)
-- 
1.5.1.2

