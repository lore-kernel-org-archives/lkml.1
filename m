Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbXJXRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbXJXRga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXJXRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:36:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43881 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbXJXRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:36:21 -0400
From: Paul Jackson <pj@sgi.com>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2007 10:36:20 -0700
Message-Id: <20071024173620.24359.59915.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] cgroup brace coding style fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Coding style fix - one line conditionals don't get braces.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

This patch applies --after-- Adrian Bunk's patch:
    [2.6 patch] kernel/cgroup.c: remove dead code

 kernel/cgroup.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- 2.6.23-mm1.orig/kernel/cgroup.c	2007-10-24 09:51:20.289137770 -0700
+++ 2.6.23-mm1/kernel/cgroup.c	2007-10-24 09:51:52.153617193 -0700
@@ -1182,9 +1182,8 @@ static int attach_task(struct cgroup *cg
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
 			retval = ss->can_attach(ss, cgrp, tsk);
-			if (retval) {
+			if (retval)
 				return retval;
-			}
 		}
 	}
 
@@ -1193,9 +1192,8 @@ static int attach_task(struct cgroup *cg
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
-	if (!newcg) {
+	if (!newcg)
 		return -ENOMEM;
-	}
 
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
@@ -1215,9 +1213,8 @@ static int attach_task(struct cgroup *cg
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
-		if (ss->attach) {
+		if (ss->attach)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
-		}
 	}
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
@@ -1353,9 +1350,8 @@ static ssize_t cgroup_common_file_write(
 	{
 		struct cgroupfs_root *root = cgrp->root;
 		/* Strip trailing newline */
-		if (nbytes && (buffer[nbytes-1] == '\n')) {
+		if (nbytes && (buffer[nbytes-1] == '\n'))
 			buffer[nbytes-1] = 0;
-		}
 		/* We never write anything other than '\0'
 		 * into the last char of release_agent_path,
 		 * so it always remains a NUL-terminated
@@ -2123,9 +2119,8 @@ static inline int cgroup_has_css_refs(st
 		 * matter, since it can only happen if the cgroup
 		 * has been deleted and hence no longer needs the
 		 * release agent to be called anyway. */
-		if (css && atomic_read(&css->refcnt)) {
+		if (css && atomic_read(&css->refcnt))
 			return 1;
-		}
 	}
 	return 0;
 }

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
