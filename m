Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239Ab0AYN4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0AYN4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961Ab0AYN4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:56:38 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:62859 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab0AYN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:56:36 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: correct whitespace in warning from cpu down task check
Date: Mon, 25 Jan 2010 14:56:34 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <201001250542.08642.elendil@planet.nl>
In-Reply-To: <201001250542.08642.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001251456.34996.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jan 2010 13:56:35.0604 (UTC) FILETIME=[35415540:01CA9DC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to an incorrect line break the output currently contains tabs.
Also remove trailing space.
    
Signed-off-by: Frans Pop <elendilplanet.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---

The actual output that logcheck sent me looked like this:
Task events/1 (pid = 10) is on cpu 1^I^I^I^I(state = 1, flags = 84208040)

After this patch it becomes:
Task events/1 (pid = 10) is on cpu 1 (state = 1, flags = 84208040)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 08e54e7..677f253 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -154,10 +154,10 @@ static inline void check_for_tasks(int cpu)
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (!cputime_eq(p->utime, cputime_zero) ||
 		     !cputime_eq(p->stime, cputime_zero)))
-			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\
-				(state = %ld, flags = %x) \n",
-				 p->comm, task_pid_nr(p), cpu,
-				 p->state, p->flags);
+			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
+				"(state = %ld, flags = %x)\n",
+				p->comm, task_pid_nr(p), cpu,
+				p->state, p->flags);
 	}
 	write_unlock_irq(&tasklist_lock);
 }
