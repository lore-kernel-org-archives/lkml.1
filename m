Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbZD3A2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbZD3A2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760772AbZD3A1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbZD3A1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hv6qfoe2HYAUJPk0i2YL1YLtV8bf++V+pdf3qA3lSp+Jf34nHpuARI8bFunQr/IkEH
         EAw40+IaoJrlpRRhNJA08dyBkkMLHsEuVImfVU2+hmue123IJ9muzILTFtj3QnptRrLM
         WnTSDwx421T2ZzsrkWpqz1I9Ha/TOSssRN2dM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/19] trace_workqueue: remove cpu_workqueue_stats->first_entry
Date: Thu, 30 Apr 2009 02:27:04 +0200
Message-Id: <1241051240-4280-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

cpu_workqueue_stats->first_entry is useless because we can retrieve the
header of a cpu workqueue using:
if (&cpu_workqueue_stats->list == workqueue_cpu_stat(cpu)->list.next)

[ Impact: cleanup ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 128b64b..890974a 100644
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
1.6.2.3

