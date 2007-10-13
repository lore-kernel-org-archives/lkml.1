Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbXJMAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbXJMAbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbXJMA3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:29:17 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:33491
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760202AbXJMA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:29:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/7] RT: Add support for updating push-rt priority under PI
	boost
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Fri, 12 Oct 2007 20:15:54 -0400
Message-ID: <20071013001554.7444.3543.stgit@novell1.haskins.net>
In-Reply-To: <20071013001052.7444.8363.stgit@novell1.haskins.net>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 50c88e8..62f9f0b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4663,6 +4663,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		 * this runqueue and our priority is higher than the current's
 		 */
 		if (task_running(rq, p)) {
+			set_rq_prio(rq, p->prio);
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
 		} else {
@@ -4722,6 +4723,9 @@ void set_user_nice(struct task_struct *p, long nice)
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
+
+		if (delta && task_running(rq, p))
+			set_rq_prio(rq, p->prio);
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);

