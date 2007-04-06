Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXDFQrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXDFQrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXDFQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:47:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51407 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbXDFQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:47:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 1/5] kobject: Comment and warning fixes to kobject.c
References: <m164898ncw.fsf@ebiederm.dsl.xmission.com>
Date: Fri, 06 Apr 2007 10:47:11 -0600
In-Reply-To: <m164898ncw.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Fri, 06 Apr 2007 10:43:43 -0600")
Message-ID: <m11wix8n74.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This dots some i's and crosses some t's after left over from when
kobject_kset_add_dir was built from kobject_add_dir. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 lib/kobject.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f664551..09cb276 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -488,7 +488,7 @@ static struct kobj_type dir_ktype = {
 };
 
 /**
- *	kobject__kset_add_dir - add sub directory of object.
+ *	kobject_kset_add_dir - add sub directory of object.
  *	@kset:		kset the directory is belongs to.
  *	@parent:	object in which a directory is created.
  *	@name:	directory name.
@@ -514,8 +514,8 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
 	kobject_set_name(k, name);
 	ret = kobject_register(k);
 	if (ret < 0) {
-		printk(KERN_WARNING "kobject_add_dir: "
-			"kobject_register error: %d\n", ret);
+		printk(KERN_WARNING "%s: kobject_register error: %d\n",
+			__func__, ret);
 		kobject_del(k);
 		return NULL;
 	}
@@ -523,6 +523,13 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
 	return k;
 }
 
+/**
+ *	kobject_add_dir - add sub directory of object.
+ *	@parent:	object in which a directory is created.
+ *	@name:	directory name.
+ *
+ *	Add a plain directory object as child of given object.
+ */
 struct kobject *kobject_add_dir(struct kobject *parent, const char *name)
 {
 	return kobject_kset_add_dir(NULL, parent, name);
-- 
1.5.0.g53756

