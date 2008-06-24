Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYFXJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYFXJDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYFXJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:03:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYFXJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:03:07 -0400
Message-ID: <4860B75A.1050307@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 16:59:06 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kobjects: Transmit return value of kobject_uevent_env()
 to caller
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error signal shouldn't be dropped.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
diff --git a/lib/kobject.c b/lib/kobject.c
index 718e510..e5de71e 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -430,7 +430,7 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
 	 * Some hotplug package track interfaces by their name and
 	 * therefore want to know when the name is changed by the user. */
 	if (!error)
-		kobject_uevent_env(kobj, KOBJ_MOVE, envp);
+		error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 
 out:
 	kfree(devpath_string);
@@ -482,7 +482,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 	kobj->parent = new_parent;
 	new_parent = NULL;
 	kobject_put(old_parent);
-	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
+	error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 out:
 	kobject_put(new_parent);
 	kobject_put(kobj);



