Return-Path: <linux-kernel-owner+w=401wt.eu-S937171AbXG0Qcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937171AbXG0Qcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbXG0Qck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:32:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46761 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbXG0Qcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:32:39 -0400
Date: Fri, 27 Jul 2007 09:36:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, mochel@osdl.org,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Fix kobject documentation
Message-Id: <20070727093626.76d0c56f.randy.dunlap@oracle.com>
In-Reply-To: <20070727132115.45b70a5e@gondolin.boeblingen.de.ibm.com>
References: <87abtijg4x.wl%takeuchi_satoru@jp.fujitsu.com>
	<20070727132115.45b70a5e@gondolin.boeblingen.de.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 13:21:15 +0200 Cornelia Huck wrote:

> On Fri, 27 Jul 2007 19:27:26 +0900,
> Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> > Fix kobject documentation as follows.
> > 
> >  - remove trailing spaces.
> >  - struct device_subsys -> devices_subsys
> > 
> > Signed-off-by: Satoru Takeuchi<takeuchi_satoru@jp.fujitsu.com>
> 
> This is certainly a start, but kobject.txt needs more updates. For
> example, it still refers to the removed struct subsystem, and
> uevent_ops are not mentioned. Looking at kobject.h, the kerneldoc there
> needs some updates as well...

Here's a start at that.
---


From: Randy Dunlap <randy.dunlap@oracle.com>

Removed kernel-doc marker (/**) from struct kset -- each struct member
still needs annotation.

Corrected one parameter name so that kernel-doc matches the macro.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kobject.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- linux-2623-rc1g2.orig/include/linux/kobject.h
+++ linux-2623-rc1g2/include/linux/kobject.h
@@ -108,9 +108,15 @@ struct kobj_type {
 	struct attribute	** default_attrs;
 };
 
+struct kset_uevent_ops {
+	int (*filter)(struct kset *kset, struct kobject *kobj);
+	const char *(*name)(struct kset *kset, struct kobject *kobj);
+	int (*uevent)(struct kset *kset, struct kobject *kobj, char **envp,
+			int num_envp, char *buffer, int buffer_size);
+};
 
-/**
- *	kset - a set of kobjects of a specific type, belonging
+/*
+ *	struct kset - a set of kobjects of a specific type, belonging
  *	to a specific subsystem.
  *
  *	All kobjects of a kset should be embedded in an identical 
@@ -126,13 +132,6 @@ struct kobj_type {
  *	supress the event generation or add subsystem specific
  *	variables carried with the event.
  */
-struct kset_uevent_ops {
-	int (*filter)(struct kset *kset, struct kobject *kobj);
-	const char *(*name)(struct kset *kset, struct kobject *kobj);
-	int (*uevent)(struct kset *kset, struct kobject *kobj, char **envp,
-			int num_envp, char *buffer, int buffer_size);
-};
-
 struct kset {
 	struct kobj_type	* ktype;
 	struct list_head	list;
@@ -173,7 +172,7 @@ static inline struct kobj_type * get_kty
 extern struct kobject * kset_find_obj(struct kset *, const char *);
 
 
-/**
+/*
  * Use this when initializing an embedded kset with no other 
  * fields to initialize.
  */
@@ -198,7 +197,7 @@ extern struct kset kernel_subsys;
 /* The global /sys/hypervisor/ subsystem  */
 extern struct kset hypervisor_subsys;
 
-/**
+/*
  * Helpers for setting the kset of registered objects.
  * Often, a registered object belongs to a kset embedded in a 
  * subsystem. These do no magic, just make the resulting code
@@ -233,7 +232,7 @@ extern struct kset hypervisor_subsys;
 /**
  *	subsys_set_kset(obj,subsys) - set kset for subsystem
  *	@obj:		ptr to some object type.
- *	@subsys:	a subsystem object (not a ptr).
+ *	@_subsys:	a subsystem object (not a ptr).
  *
  *	Can be used for any object type with an embedded ->subsys.
  *	Sets the kset of @obj's kobject to @subsys.kset. This makes
