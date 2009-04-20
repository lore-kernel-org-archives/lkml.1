Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZDTHAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZDTHAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZDTHAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:00:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57993 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZDTHAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:00:01 -0400
Message-ID: <49EC1D58.4040903@cn.fujitsu.com>
Date: Mon, 20 Apr 2009 14:59:36 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] trace_workqueue: Remove cpu_workqueue_stats->first_entry
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com>
In-Reply-To: <49EC1943.8080606@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_workqueue_stats->first_entry is useless because we can judge header of cpu
workqueue by:
if (&cpu_workqueue_stats->list == workqueue_cpu_stat(cpu)->list.next)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 934b27c..f52db53 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -16,8 +16,6 @@
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
 	struct list_head            list;
-/* Useful to know if we print the cpu headers */
-	bool		            first_entry;
 	int		            cpu;
 	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
@@ -103,8 +101,6 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	cws->pid = wq_thread->pid;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (list_empty(&workqueue_cpu_stat(cpu)->list))
-		cws->first_entry = true;
 	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
-- 
1.5.5.3


