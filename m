Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYGCVmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYGCVmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYGCVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:37:19 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:1116 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbYGCVhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:37:17 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] sched: readjust the load whenever task_setprio() is
	invoked
To: stable@vger.kernel.org, linux-rt-users@vger.kernel.org,
       rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, ghaskins@novell.com, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2008 15:37:16 -0600
Message-ID: <20080703213716.1275.33324.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
References: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The load may change with the priority, so be sure to recompute its value.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b046754..c3f41b9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4637,6 +4637,7 @@ void task_setprio(struct task_struct *p, int prio)
 		p->sched_class = &fair_sched_class;
 
 	p->prio = prio;
+	set_load_weight(p);
 
 //	trace_special_pid(p->pid, __PRIO(oldprio), PRIO(p));
 	prev_resched = _need_resched();

