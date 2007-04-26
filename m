Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXDZTZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXDZTZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXDZTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:25:31 -0400
Received: from www.osadl.org ([213.239.205.134]:34505 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754952AbXDZTZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:25:30 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070425214704.GA32572@elte.hu>
References: <20070425214704.GA32572@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 21:27:26 +0200
Message-Id: <1177615646.25960.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 23:47 +0200, Ingo Molnar wrote:
> i got lots of -v5 feedback (thanks and please keep the reports coming!) 

You asked for it :)

CFS breaks the PI support for futexes. Fix below.

	tglx

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3234,6 +3234,12 @@ void rt_mutex_setprio(struct task_struct
 	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
+
+	if (rt_prio(prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
+
 	p->prio = prio;
 
 	if (on_rq) {


