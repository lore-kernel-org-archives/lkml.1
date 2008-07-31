Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYGaCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYGaCZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGaCYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:24:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYGaCYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:24:51 -0400
Message-ID: <489121F8.2020008@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 10:22:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: Add comments for update_domain_attr_tree
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add comments for update_domain_attr_tree().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index adf66c0..fed1f42 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -487,15 +487,21 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
 	if (dattr->relax_domain_level < c->relax_domain_level)
 		dattr->relax_domain_level = c->relax_domain_level;
-	return;
 }
 
+/*
+ * Helper routine for rebuild_sched_domains().
+ * Walk the specified cpuset subtree and update @dattr with the
+ * largest relax_domain_level.
+ *
+ * Called with cgroup_mutex held.
+ */
 static void
-update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
+update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *root)
 {
 	LIST_HEAD(q);
 
-	list_add(&c->stack_list, &q);
+	list_add(&root->stack_list, &q);
 	while (!list_empty(&q)) {
 		struct cpuset *cp;
 		struct cgroup *cont;


