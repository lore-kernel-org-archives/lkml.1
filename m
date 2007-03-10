Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbXCJK77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbXCJK77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXCJK76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:59:58 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:5341 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbXCJK76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:59:58 -0500
To: linux-kernel@vger.kernel.org
CC: gregkh@suse.de
Subject: [patch] kobject: kobject_shadow_add cleanup
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sat, 10 Mar 2007 14:00:10 +0300
Message-ID: <87r6rx9xdx.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - correct function name in comments
 - parrent assignment does metter only inside "if" block, 
   so move it inside this block.
Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

diff --git a/lib/kobject.c b/lib/kobject.c
index b94f208..e4b477d 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -201,7 +201,7 @@ static void unlink(struct kobject * kobj)
 }
 
 /**
- *	kobject_add - add an object to the hierarchy.
+ *	kobject_shadow_add - add an object to the hierarchy.
  *	@kobj:	object.
  *	@shadow_parent: sysfs directory to add to.
  */
@@ -234,8 +234,8 @@ int kobject_shadow_add(struct kobject * kobj, struct dentry *shadow_parent)
 
 		list_add_tail(&kobj->entry,&kobj->kset->list);
 		spin_unlock(&kobj->kset->list_lock);
+		kobj->parent = parent;
 	}
-	kobj->parent = parent;
 
 	error = create_dir(kobj, shadow_parent);
 	if (error) {

