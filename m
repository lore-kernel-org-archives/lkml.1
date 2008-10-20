Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbYJTFbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbYJTFbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYJTFa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:30:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYJTFa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:30:57 -0400
Message-ID: <48FC1784.70108@cn.fujitsu.com>
Date: Mon, 20 Oct 2008 13:30:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: tiny cleanups
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove 'private' field from struct subsys
- remove cgroup_init_smp()
- remove unused 'i' in cgroup_tasks_start()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    4 ----
 kernel/cgroup.c        |    1 -
 2 files changed, 5 deletions(-)

--- linux-mm/include/linux/cgroup.h.orig	2008-10-20 13:25:39.000000000 +0800
+++ linux-mm/include/linux/cgroup.h	2008-10-20 13:26:08.000000000 +0800
@@ -25,7 +25,6 @@ struct cgroup;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
-extern void cgroup_init_smp(void);
 extern void cgroup_lock(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
@@ -348,8 +347,6 @@ struct cgroup_subsys {
 	struct cgroupfs_root *root;
 
 	struct list_head sibling;
-
-	void *private;
 };
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _subsys;
@@ -410,7 +407,6 @@ void cgroup_mm_owner_callbacks(struct ta
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
-static inline void cgroup_init_smp(void) {}
 static inline void cgroup_fork(struct task_struct *p) {}
 static inline void cgroup_fork_callbacks(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
--- linux-mm/kernel/cgroup.c.orig	2008-10-20 13:25:56.000000000 +0800
+++ linux-mm/kernel/cgroup.c	2008-10-20 13:26:08.000000000 +0800
@@ -2104,7 +2104,6 @@ static void *cgroup_tasks_start(struct s
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
