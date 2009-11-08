Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZKHNHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZKHNHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZKHNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:07:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:59139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZKHNH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:07:29 -0500
Date: Sun, 8 Nov 2009 13:07:09 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091026192414.GB5321@lenovo>
References: <20091026192414.GB5321@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use root_task_group_empty only with FAIR_GROUP_SCHED
Message-ID: <tip-e9036b36eed4d3cdb33fa9cbcdd9888ae516889f@git.kernel.org>
Git-Commit-ID: e9036b36eed4d3cdb33fa9cbcdd9888ae516889f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9036b36eed4d3cdb33fa9cbcdd9888ae516889f
Gitweb:     http://git.kernel.org/tip/e9036b36eed4d3cdb33fa9cbcdd9888ae516889f
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 26 Oct 2009 22:24:14 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 13:15:48 +0100

sched: Use root_task_group_empty only with FAIR_GROUP_SCHED

root_task_group_empty is used only with FAIR_GROUP_SCHED
so if we use other scheduler options we get:

  kernel/sched.c:314: warning: 'root_task_group_empty' defined but not used

So move CONFIG_FAIR_GROUP_SCHED up that it covers
root_task_group_empty().

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091026192414.GB5321@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7d7d5fc..3c11ae0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -309,6 +309,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
 #ifdef CONFIG_SMP
 static int root_task_group_empty(void)
 {
@@ -316,7 +318,6 @@ static int root_task_group_empty(void)
 }
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
 #else /* !CONFIG_USER_SCHED */
