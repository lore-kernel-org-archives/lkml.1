Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYIOSmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYIOSmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYIOSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:42:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1166 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752687AbYIOSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:42:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:to:content-type:
	content-transfer-encoding:mime-version:subject:date:cc:x-mailer;
	b=HjoQlmZEWU4ZlG7XpEa9n8vrePHx6AlJhAUxz2l8fJYq4XdfkhgC/kZpDxVrl6wh1
	F6818wtKsakVAwHLQ/ktw==
Message-Id: <B21AC749-D9D3-4B6C-B490-091F06F78E41@google.com>
From: Paul Menage <menage@google.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linuxfoundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: [PATCH] Fix declaration of cgroup_mm_owner_callbacks()
Date: Mon, 15 Sep 2008 11:41:47 -0700
Cc: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.919.2)
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
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct  
*new);
-#else /* !CONFIG_MM_OWNER */
-static inline void
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct  
*new)
-{
-}
-#endif /* CONFIG_MM_OWNER */
#endif /* _LINUX_CGROUP_H */

