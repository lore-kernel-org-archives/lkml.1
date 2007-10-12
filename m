Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXJLW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXJLW06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbXJLWSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:50 -0400
Received: from mail.suse.de ([195.135.220.2]:53158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297AbXJLWSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/75] Driver core: clean up removed functions from the documentation
Date: Fri, 12 Oct 2007 15:16:20 -0700
Message-Id: <11922275121763-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275074080-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index 8ee49ee..5e7aca2 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -54,7 +54,6 @@ embedded in larger data structures and replace fields they duplicate.
 
 struct kobject {
 	const char		* k_name;
-	char			name[KOBJ_NAME_LEN];
 	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
@@ -223,18 +222,15 @@ decl_subsys(devices, &ktype_device, &device_uevent_ops);
 is equivalent to doing:
 
 struct kset devices_subsys = {
-     .kobj = {
-	   .name = "devices",
-     },
      .ktype = &ktype_devices,
      .uevent_ops = &device_uevent_ops,
 };
-
+kobject_set_name(&devices_subsys, name);
 
 The objects that are registered with a subsystem that use the
 subsystem's default list must have their kset ptr set properly. These
 objects may have embedded kobjects or ksets. The
-following helpers make setting the kset easier:
+following helper makes setting the kset easier:
 
 
 kobj_set_kset_s(obj,subsys)
@@ -242,22 +238,9 @@ kobj_set_kset_s(obj,subsys)
 - Assumes that obj->kobj exists, and is a struct kobject.
 - Sets the kset of that kobject to the kset <subsys>.
 
-
-kset_set_kset_s(obj,subsys)
-
-- Assumes that obj->kset exists, and is a struct kset.
-- Sets the kset of the embedded kobject to the kset <subsys>.
-
-subsys_set_kset(obj,subsys)
-
-- Assumes obj->subsys exists, and is a struct subsystem.
-- Sets obj->subsys.kset.kobj.kset to the subsystem's embedded kset.
-
 void subsystem_init(struct kset *s);
 int subsystem_register(struct kset *s);
 void subsystem_unregister(struct kset *s);
-struct kset *subsys_get(struct kset *s);
-void kset_put(struct kset *s);
 
 These are just wrappers around the respective kset_* functions.
 
-- 
1.5.3.4

