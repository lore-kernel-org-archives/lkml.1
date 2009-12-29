Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbZL2U4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbZL2U4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZL2U4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:56:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZL2U4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:56:43 -0500
Message-ID: <4B3A6D63.4070700@gmail.com>
Date: Tue, 29 Dec 2009 21:58:11 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
       rusty@rustcorp.com.au, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Constify struct kset_uevent_ops for 2.6.33-rc2
References: <cover.1260663000.git.re.emese@gmail.com>	 <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com> <4B39AEB2.5040809@cs.helsinki.fi>
In-Reply-To: <4B39AEB2.5040809@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I double checked both the declaration and definitions of the affected
>> function/structure and they are consistently const here.
>> Can you tell me what patch/tree combination you encountered this
>> warning with?
> 
> 2.6.33-rc2 with your patch.

Here is the updated patch for 2.6.33-rc2 in one piece.
Emese


From: Emese Revfy <re.emese@gmail.com>

Constify struct kset_uevent_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---

 drivers/base/bus.c      |    2 +-
 drivers/base/core.c     |    2 +-
 drivers/base/memory.c   |    2 +-
 fs/gfs2/sys.c           |    2 +-
 include/linux/kobject.h |   10 +++++-----
 kernel/params.c         |    2 +-
 lib/kobject.c           |    4 ++--
 lib/kobject_uevent.c    |    2 +-
 mm/slub.c               |    2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index c0c5a43..2afe599 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -154,7 +154,7 @@ static int bus_uevent_filter(struct kset *kset, struct kobject *kobj)
 	return 0;
 }
 
-static struct kset_uevent_ops bus_uevent_ops = {
+static const struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..82bd3ff 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -252,7 +252,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	return retval;
 }
 
-static struct kset_uevent_ops device_uevent_ops = {
+static const struct kset_uevent_ops device_uevent_ops = {
 	.filter =	dev_uevent_filter,
 	.name =		dev_uevent_name,
 	.uevent =	dev_uevent,
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index d7d77d4..0bcf8c2 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -44,7 +44,7 @@ static int memory_uevent(struct kset *kset, struct kobject *obj, struct kobj_uev
 	return retval;
 }
 
-static struct kset_uevent_ops memory_uevent_ops = {
+static const struct kset_uevent_ops memory_uevent_ops = {
 	.name		= memory_uevent_name,
 	.uevent		= memory_uevent,
 };
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 0dc3462..9be733e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -576,7 +576,7 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 	return 0;
 }
 
-static struct kset_uevent_ops gfs2_uevent_ops = {
+static const struct kset_uevent_ops gfs2_uevent_ops = {
 	.uevent = gfs2_uevent,
 };
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..57a1eaa 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -118,9 +118,9 @@ struct kobj_uevent_env {
 };
 
 struct kset_uevent_ops {
-	int (*filter)(struct kset *kset, struct kobject *kobj);
-	const char *(*name)(struct kset *kset, struct kobject *kobj);
-	int (*uevent)(struct kset *kset, struct kobject *kobj,
+	int (* const filter)(struct kset *kset, struct kobject *kobj);
+	const char *(* const name)(struct kset *kset, struct kobject *kobj);
+	int (* const uevent)(struct kset *kset, struct kobject *kobj,
 		      struct kobj_uevent_env *env);
 };
 
@@ -155,14 +155,14 @@ struct kset {
 	struct list_head list;
 	spinlock_t list_lock;
 	struct kobject kobj;
-	struct kset_uevent_ops *uevent_ops;
+	const struct kset_uevent_ops *uevent_ops;
 };
 
 extern void kset_init(struct kset *kset);
 extern int __must_check kset_register(struct kset *kset);
 extern void kset_unregister(struct kset *kset);
 extern struct kset * __must_check kset_create_and_add(const char *name,
-						struct kset_uevent_ops *u,
+						const struct kset_uevent_ops *u,
 						struct kobject *parent_kobj);
 
 static inline struct kset *to_kset(struct kobject *kobj)
diff --git a/kernel/params.c b/kernel/params.c
index cf1b691..ac5de7d 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -737,7 +737,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
 	return 0;
 }
 
-static struct kset_uevent_ops module_uevent_ops = {
+static const struct kset_uevent_ops module_uevent_ops = {
 	.filter = uevent_filter,
 };
 
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..cecf5a0 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -789,7 +789,7 @@ static struct kobj_type kset_ktype = {
  * If the kset was not able to be created, NULL will be returned.
  */
 static struct kset *kset_create(const char *name,
-				struct kset_uevent_ops *uevent_ops,
+				const struct kset_uevent_ops *uevent_ops,
 				struct kobject *parent_kobj)
 {
 	struct kset *kset;
@@ -832,7 +832,7 @@ static struct kset *kset_create(const char *name,
  * If the kset was not able to be created, NULL will be returned.
  */
 struct kset *kset_create_and_add(const char *name,
-				 struct kset_uevent_ops *uevent_ops,
+				 const struct kset_uevent_ops *uevent_ops,
 				 struct kobject *parent_kobj)
 {
 	struct kset *kset;
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 920a3ca..c9d3a3e 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -95,7 +95,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	const char *subsystem;
 	struct kobject *top_kobj;
 	struct kset *kset;
-	struct kset_uevent_ops *uevent_ops;
+	const struct kset_uevent_ops *uevent_ops;
 	u64 seq;
 	int i = 0;
 	int retval = 0;
diff --git a/mm/slub.c b/mm/slub.c
index 8d71aaf..02b5a83 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4538,7 +4538,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
 	return 0;
 }
 
-static struct kset_uevent_ops slab_uevent_ops = {
+static const struct kset_uevent_ops slab_uevent_ops = {
 	.filter = uevent_filter,
 };
 


