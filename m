Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZKVMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZKVMLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZKVMLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:11:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:41671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751479AbZKVMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:11:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19rxC8kZ4NrJKtksjHbShiGvEckzDN0qfCr0c6ogP
	FLCS2rNT0gMS2X
Subject: [patch] sched: add the other missing clock update to migrate_task()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:11:19 +0100
Message-Id: <1258891879.14325.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: add the other missing clock update to migrate_task()

When calling set_task_cpu(), we must update both runqueue clocks in order
to get an accurate clock offset.  Add it.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2126,6 +2126,7 @@ migrate_task(struct task_struct *p, int
 	 */
 	if (!p->se.on_rq && !task_running(rq, p)) {
 		update_rq_clock(rq);
+		update_rq_clock(cpu_rq(dest_cpu));
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}


