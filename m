Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXJJPDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXJJPDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXJJPC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:02:56 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:51197
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbXJJPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:02:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] RT: Fix special-case exception for preempting the local CPU
To: mingo@elte.hu, peterz@infradead.org, kravetz@us.ibm.com,
       rostedt@goodmis.org
Cc: ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 10 Oct 2007 10:49:35 -0400
Message-ID: <20071010144824.21333.52155.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to 2.6.23-rc9-rt2...  This is another RTO related fix from the thread
two days ago.

---
RT: Fix special-case exception for preempting the local CPU

Check whether the local CPU is eligible to take the task before trying to
preempt it.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3e75c62..b7f7a96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1869,7 +1869,8 @@ out_activate:
 		 * extra locking in this particular case, because
 		 * we are on the current CPU.)
 		 */
-		if (TASK_PREEMPTS_CURR(p, this_rq))
+		if (TASK_PREEMPTS_CURR(p, this_rq)
+		    && cpu_isset(this_cpu, p->cpus_allowed))
 			set_tsk_need_resched(this_rq->curr);
 		else
 			/*

