Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYINPIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYINPIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYINPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:08:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYINPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:08:09 -0400
Date: Sun, 14 Sep 2008 17:07:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] timers: fix itimer/many thread hang, fix
Message-ID: <20080914150749.GA26984@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080914150651.GK12522@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied the small build fix below to tip/timers/posixtimers.

	Ingo

------------>
>From 430b5294bd72c085c730e1e4b86580f164d976bf Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Sep 2008 16:33:01 +0200
Subject: [PATCH] timers: fix itimer/many thread hang, fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 kernel/fork.c:843: error: ‘struct signal_struct’ has no member named ‘sum_sched_runtime’
 kernel/irq/handle.c:117: warning: ‘sparse_irq_lock’ defined but not used

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index a8ac2ef..1181b9a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -834,7 +834,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
-	sig->sum_sched_runtime = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
