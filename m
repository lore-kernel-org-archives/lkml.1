Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0A0NRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0A0NRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219Ab0A0NRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:17:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:60515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0A0NRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:17:01 -0500
Date: Wed, 27 Jan 2010 13:16:28 GMT
From: tip-bot for Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, elendil@planet.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, elendil@planet.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <201001251456.34996.elendil@planet.nl>
References: <201001251456.34996.elendil@planet.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Correct printk whitespace in warning from cpu down task check
Message-ID: <tip-8048f77492bc428c6783e5039e759de2f960f47d@git.kernel.org>
Git-Commit-ID: 8048f77492bc428c6783e5039e759de2f960f47d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:16:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8048f77492bc428c6783e5039e759de2f960f47d
Gitweb:     http://git.kernel.org/tip/8048f77492bc428c6783e5039e759de2f960f47d
Author:     Frans Pop <elendil@planet.nl>
AuthorDate: Mon, 25 Jan 2010 14:56:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 08:34:40 +0100

sched: Correct printk whitespace in warning from cpu down task check

Due to an incorrect line break the output currently contains tabs.
Also remove trailing space.

The actual output that logcheck sent me looked like this:
 Task events/1 (pid = 10) is on cpu 1^I^I^I^I(state = 1, flags = 84208040)

After this patch it becomes:
 Task events/1 (pid = 10) is on cpu 1 (state = 1, flags = 84208040)

Signed-off-by: Frans Pop <elendilplanet.nl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <201001251456.34996.elendil@planet.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

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
