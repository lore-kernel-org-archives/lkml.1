Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYDWSAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYDWSAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYDWR7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:59:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYDWR7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:59:54 -0400
From: eparis@redhat.com
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, serue@us.ibm.com, Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] capability: kernel/capability.c whitespace, syntax, and other cleanups
Date: Wed, 23 Apr 2008 13:52:33 -0400
Message-Id: <12089731553073-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <12089731553297-git-send-email-eparis@redhat.com>
References: <12089731541206-git-send-email-eparis@redhat.com>
 <12089731553297-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

This patch changes kernel/capability.c to fix whitespace and syntax issues.  Things that
are fixed may include (does not not have to include)

whitespace at end of lines
spaces followed by tabs
spaces used instead of tabs
spacing around parenthesis
location of { around structs and else clauses
location of * in pointer declarations
removal of initialization of static data to keep it in the right section
useless {} in if statemetns
useless checking for NULL before kfree
fixing of the indentation depth of switch statements
no assignments in if statements
include spaces around , in function calls
and any number of other things I forgot to mention

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/capability.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 39e8193..0185d10 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -161,8 +161,8 @@ out:
  * group.  We call this holding task_capability_lock and tasklist_lock.
  */
 static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
-			      kernel_cap_t *inheritable,
-			      kernel_cap_t *permitted)
+			     kernel_cap_t *inheritable,
+			     kernel_cap_t *permitted)
 {
 	struct task_struct *g, *target;
 	int ret = -EPERM;
@@ -195,27 +195,27 @@ static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
  * and self.  We call this holding task_capability_lock and tasklist_lock.
  */
 static inline int cap_set_all(kernel_cap_t *effective,
-			       kernel_cap_t *inheritable,
-			       kernel_cap_t *permitted)
+			      kernel_cap_t *inheritable,
+			      kernel_cap_t *permitted)
 {
-     struct task_struct *g, *target;
-     int ret = -EPERM;
-     int found = 0;
-
-     do_each_thread(g, target) {
-             if (target == current || is_container_init(target->group_leader))
-                     continue;
-             found = 1;
-	     if (security_capset_check(target, effective, inheritable,
-						permitted))
-		     continue;
-	     ret = 0;
-	     security_capset_set(target, effective, inheritable, permitted);
-     } while_each_thread(g, target);
-
-     if (!found)
-	     ret = 0;
-     return ret;
+	struct task_struct *g, *target;
+	int ret = -EPERM;
+	int found = 0;
+
+	do_each_thread(g, target) {
+		if (target == current || is_container_init(target->group_leader))
+			continue;
+		found = 1;
+		if (security_capset_check(target, effective, inheritable,
+					  permitted))
+			continue;
+		ret = 0;
+		security_capset_set(target, effective, inheritable, permitted);
+	} while_each_thread(g, target);
+
+	if (!found)
+		ret = 0;
+	return ret;
 }
 
 /**
-- 
1.5.2.1

