Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZLPVRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZLPVRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZLPVRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:17:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:53617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbZLPVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:17:41 -0500
Subject: [PATCH 13/12] sched: remove debug check
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20091216170430.073353839@chello.nl>
References: <20091216170430.073353839@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 22:17:18 +0100
Message-ID: <1260998238.21028.384.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since you're running into this warning and not seeing any obvious ill
side-effects (you'd see some serious starvation issues), please stick
this patch in for now.

I can't seem to convince myself if its a real problem or not, and how it
could possibly happen, but my brain is giving up for today.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2036,14 +2036,6 @@ task_hot(struct task_struct *p, u64 now,
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-#ifdef CONFIG_SCHED_DEBUG
-	/*
-	 * We should never call set_task_cpu() on a blocked task,
-	 * ttwu() will sort out the placement.
-	 */
-	WARN_ON(p->state != TASK_RUNNING && p->state != TASK_WAKING);
-#endif
-
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (task_cpu(p) == new_cpu)


