Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZDTWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZDTWbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbZDTWaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:30:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38024 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759545AbZDTWaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:30:16 -0400
Date: Tue, 21 Apr 2009 00:25:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090420222514.GA15680@redhat.com>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420084631.GA32625@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Ingo Molnar wrote:
>
> Andrew, Oleg: if you plan to make unhappy noises about this level of
> instrumentation in the workqueue code, please do it sooner rather
> than later, as there's quite some effort injected into this already.
> A tentative non-NAK now (patches are still being sorted out) and an
> Ack on the final topic tree from you (once we send it and if it's
> good) and general happiness would be the ideal outcome :)

Imho, this info is useful, and the changes are fine.

But I didn't study kernel/trace/trace_workqueue.c yet... Sorry, I was
going to do this, but I didn't.

At first glance, with or without these new changes some parts of
trace_workqueue.c looks suspicious.

For example, I don't understand cpu_workqueue_stats->pid. Why it is
needed? Why can't we just record wq_thread itself? And if we copy
wq_thread->comm to cpu_workqueue_stats, we don't even need get/put
task_struct, afaics.

probe_workqueue_destruction() does cpumask_first(cwq->cpus_allowed),
this doesn't look right. When workqueue_cpu_callback() calls
cleanup_workqueue_thread(), wq_thread is no longer affine to CPU it
was created on. This means probe_workqueue_destruction() can't always
find the correct cpu_workqueue_stats in workqueue_cpu_stat(cpu), no?

Oleg.

