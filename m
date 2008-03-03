Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYCCBkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYCCBkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYCCBiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:38:05 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:6065 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbYCCBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RtTx1+TD8NmP45dpi+wBlMlBpT8S88cR05muK9PHBLBZgDjojTuOwmimSqTpyAabwFcTL7LfCPSEKsS1TmSZuTjywJxmB5u3QNsP8dQZcltSC6uy2/tniZg/C3C+uJVMbYd1UjFgSE0BMWZ3yFFm5opgBWI12PPIyf5CUXbnjv8=
Subject: [RFC PATCH 5/5] lib: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 17:38:03 -0800
Message-Id: <1204508283.3266.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/kobject.c        |   16 ++++++++--------
 lib/kobject_uevent.c |   10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index d784dae..f66751b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -95,7 +95,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: path = '%s'\n", kobject_name(kobj),
-		 kobj, __FUNCTION__, path);
+		 kobj, __func__, path);
 }
 
 /**
@@ -182,7 +182,7 @@ static int kobject_add_internal(struct kobject *kobj)
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: parent: '%s', set: '%s'\n",
-		 kobject_name(kobj), kobj, __FUNCTION__,
+		 kobject_name(kobj), kobj, __func__,
 		 parent ? kobject_name(parent) : "<NULL>",
 		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>");
 
@@ -197,10 +197,10 @@ static int kobject_add_internal(struct kobject *kobj)
 			printk(KERN_ERR "%s failed for %s with "
 			       "-EEXIST, don't try to register things with "
 			       "the same name in the same directory.\n",
-			       __FUNCTION__, kobject_name(kobj));
+			       __func__, kobject_name(kobj));
 		else
 			printk(KERN_ERR "%s failed for %s (%d)\n",
-			       __FUNCTION__, kobject_name(kobj), error);
+			       __func__, kobject_name(kobj), error);
 		dump_stack();
 	} else
 		kobj->state_in_sysfs = 1;
@@ -546,7 +546,7 @@ static void kobject_cleanup(struct kobject *kobj)
 	const char *name = kobj->name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
@@ -599,7 +599,7 @@ void kobject_put(struct kobject *kobj)
 
 static void dynamic_kobj_release(struct kobject *kobj)
 {
-	pr_debug("kobject: (%p): %s\n", kobj, __FUNCTION__);
+	pr_debug("kobject: (%p): %s\n", kobj, __func__);
 	kfree(kobj);
 }
 
@@ -656,7 +656,7 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 	retval = kobject_add(kobj, parent, "%s", name);
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
-		       __FUNCTION__, retval);
+		       __func__, retval);
 		kobject_put(kobj);
 		kobj = NULL;
 	}
@@ -765,7 +765,7 @@ static void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 	kfree(kset);
 }
 
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 5a402e2..c76a55e 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -99,7 +99,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	int retval = 0;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
-		 kobject_name(kobj), kobj, __FUNCTION__);
+		 kobject_name(kobj), kobj, __func__);
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
@@ -109,7 +109,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	if (!top_kobj->kset) {
 		pr_debug("kobject: '%s' (%p): %s: attempted to send uevent "
 			 "without kset!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return -EINVAL;
 	}
 
@@ -121,7 +121,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		if (!uevent_ops->filter(kset, kobj)) {
 			pr_debug("kobject: '%s' (%p): %s: filter function "
 				 "caused the event to drop!\n",
-				 kobject_name(kobj), kobj, __FUNCTION__);
+				 kobject_name(kobj), kobj, __func__);
 			return 0;
 		}
 
@@ -133,7 +133,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	if (!subsystem) {
 		pr_debug("kobject: '%s' (%p): %s: unset subsystem caused the "
 			 "event to drop!\n", kobject_name(kobj), kobj,
-			 __FUNCTION__);
+			 __func__);
 		return 0;
 	}
 
@@ -175,7 +175,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		if (retval) {
 			pr_debug("kobject: '%s' (%p): %s: uevent() returned "
 				 "%d\n", kobject_name(kobj), kobj,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 			goto exit;
 		}
 	}
-- 
1.5.4.3.409.g8811

