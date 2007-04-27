Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbXD0TME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbXD0TME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbXD0S5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:50505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbXD0S4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/46] kobject: kobject_shadow_add cleanup
Date: Fri, 27 Apr 2007 11:53:21 -0700
Message-Id: <11777000632194-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700059319-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitriy Monakhov <dmonakhov@openvz.org>

 - correct function name in comments
 - parrent assignment does metter only inside "if" block,
   so move it inside this block.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f664551..bbbfab4 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -157,7 +157,7 @@ static void unlink(struct kobject * kobj)
 }
 
 /**
- *	kobject_add - add an object to the hierarchy.
+ *	kobject_shadow_add - add an object to the hierarchy.
  *	@kobj:	object.
  *	@shadow_parent: sysfs directory to add to.
  */
@@ -190,8 +190,8 @@ int kobject_shadow_add(struct kobject * kobj, struct dentry *shadow_parent)
 
 		list_add_tail(&kobj->entry,&kobj->kset->list);
 		spin_unlock(&kobj->kset->list_lock);
+		kobj->parent = parent;
 	}
-	kobj->parent = parent;
 
 	error = create_dir(kobj, shadow_parent);
 	if (error) {
-- 
1.5.1.2

