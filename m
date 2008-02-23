Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYBWMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYBWMei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYBWMeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:34:00 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38173 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756593AbYBWMd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:33:58 -0500
From: Paul Jackson <pj@sgi.com>
To: akpm@linux-foundation.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>
Date: Sat, 23 Feb 2008 04:33:57 -0800
Message-Id: <20080223123357.2668.56473.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cgroup: fix sparse warning of shadow symbol in cgroup.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix a code warning: symbol 'p' shadows an earlier one

This is a reincarnation of Harvey Harrison's patch:
	cpuset: sparse warnings in cpuset.c

Independently, Cliff Wickman moved the affected code,
from kernel/cpuset.c to kernel/cgroup.c, in his patch:
	cpusets: update_cpumask revision

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Cliff Wickman <cpw@sgi.com>

---
 kernel/cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- 2.6.25-rc2-mm1.orig/kernel/cgroup.c	2008-02-16 01:04:48.000000000 -0800
+++ 2.6.25-rc2-mm1/kernel/cgroup.c	2008-02-23 04:19:44.006614677 -0800
@@ -1897,14 +1897,14 @@ int cgroup_scan_tasks(struct cgroup_scan
 
 	if (heap->size) {
 		for (i = 0; i < heap->size; i++) {
-			struct task_struct *p = heap->ptrs[i];
+			struct task_struct *q = heap->ptrs[i];
 			if (i == 0) {
-				latest_time = p->start_time;
-				latest_task = p;
+				latest_time = q->start_time;
+				latest_task = q;
 			}
 			/* Process the task per the caller's callback */
-			scan->process_task(p, scan);
-			put_task_struct(p);
+			scan->process_task(q, scan);
+			put_task_struct(q);
 		}
 		/*
 		 * If we had to process any tasks at all, scan again

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
