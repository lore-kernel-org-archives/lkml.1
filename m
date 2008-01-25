Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYAYH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYAYH1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbYAYHQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758332AbYAYHQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 038/196] kobject: make kobject_cleanup be static
Date: Thu, 24 Jan 2008 23:09:36 -0800
Message-Id: <1201245134-4876-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one except the kobject core calls it so make the function static.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    2 --
 lib/kobject.c           |    9 ++++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4a0d27f..2d19a07 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -79,8 +79,6 @@ static inline const char * kobject_name(const struct kobject * kobj)
 }
 
 extern void kobject_init(struct kobject *);
-extern void kobject_cleanup(struct kobject *);
-
 extern int __must_check kobject_add(struct kobject *);
 extern void kobject_del(struct kobject *);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 4a310e5..a152036 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -436,12 +436,11 @@ struct kobject * kobject_get(struct kobject * kobj)
 	return kobj;
 }
 
-/**
- *	kobject_cleanup - free kobject resources. 
- *	@kobj:	object.
+/*
+ * kobject_cleanup - free kobject resources.
+ * @kobj: object to cleanup
  */
-
-void kobject_cleanup(struct kobject * kobj)
+static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-- 
1.5.3.8

