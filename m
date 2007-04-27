Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbXD0TFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbXD0TFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbXD0S63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:29 -0400
Received: from mail.suse.de ([195.135.220.2]:50773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbXD0S6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/46] kobject: Comment and warning fixes to kobject.c
Date: Fri, 27 Apr 2007 11:53:47 -0700
Message-Id: <1177700160896-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700156641-git-send-email-gregkh@suse.de>
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
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This dots some i's and crosses some t's after left over from when
kobject_kset_add_dir was built from kobject_add_dir.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 2882aff..cecf2fb 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -519,7 +519,7 @@ static struct kobj_type dir_ktype = {
 };
 
 /**
- *	kobject__kset_add_dir - add sub directory of object.
+ *	kobject_kset_add_dir - add sub directory of object.
  *	@kset:		kset the directory is belongs to.
  *	@parent:	object in which a directory is created.
  *	@name:	directory name.
@@ -545,8 +545,8 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
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
@@ -554,6 +554,13 @@ struct kobject *kobject_kset_add_dir(struct kset *kset,
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
1.5.1.2

