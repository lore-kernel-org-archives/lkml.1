Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYIOTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYIOTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYIOTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:09:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYIOTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:09:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from;
	b=OrSNqcENdwn3L8O+SJ3/80YMSoHJmQnmrqQgrmbOHDY/JRf/CS4mizbpbAtkit2tm
	7onLgzh8GNM14o6wxv9Pw==
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com,
       penberg@cs.helsinki.fi
Subject: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080915190638.99E613D6952@localhost>
Date: Mon, 15 Sep 2008 12:06:38 -0700 (PDT)
From: menage@google.com (Paul Menage)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix declaration of cgroup_mm_owner_callbacks()

The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
shouldn't be based on CONFIG_MM_OWNER, but on
CONFIG_CGROUPS. Otherwise kernel/exit.c fails to compile when
something other than a cgroups controller selects CONFIG_MM_OWNER

Signed-off-by: Paul Menage <menage@google.com>

---

This is a retry with a mailer that hopefully didn't break the
whitespace formatting

 include/linux/cgroup.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: mmowner-mmotm-2008-09-10/include/linux/cgroup.h
===================================================================
--- mmowner-mmotm-2008-09-10.orig/include/linux/cgroup.h
+++ mmowner-mmotm-2008-09-10/include/linux/cgroup.h
@@ -403,6 +403,9 @@ void cgroup_iter_end(struct cgroup *cgrp
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
+void cgroup_mm_owner_callbacks(struct task_struct *old,
+			       struct task_struct *new);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
@@ -421,15 +424,9 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
+static inline void cgroup_mm_owner_callbacks(struct task_struct *old,
+					     struct task_struct *new) {}
+
 #endif /* !CONFIG_CGROUPS */
 
-#ifdef CONFIG_MM_OWNER
-extern void
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new);
-#else /* !CONFIG_MM_OWNER */
-static inline void
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
-{
-}
-#endif /* CONFIG_MM_OWNER */
 #endif /* _LINUX_CGROUP_H */
