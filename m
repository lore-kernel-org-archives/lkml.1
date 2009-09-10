Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZIJFaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZIJFaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZIJFaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:30:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZIJFaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:30:01 -0400
Date: Thu, 10 Sep 2009 07:29:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>, Arjan van de Ven <arjan@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: add filter Documentation
Message-ID: <20090910052949.GC1335@elte.hu>
References: <1252560281.6431.38.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252560281.6431.38.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> +# cat /debug/tracing/events/sched/sched_wakeup/format
> +
> +name: sched_wakeup
> +ID: 60
> +format:
> +	field:unsigned short common_type;	offset:0;	size:2;
> +	field:unsigned char common_flags;	offset:2;	size:1;
> +	field:unsigned char common_preempt_count;	offset:3;	size:1;
> +	field:int common_pid;	offset:4;	size:4;
> +	field:int common_tgid;	offset:8;	size:4;
> +
> +	field:char comm[TASK_COMM_LEN];	offset:12;	size:16;
> +	field:pid_t pid;	offset:28;	size:4;
> +	field:int prio;	offset:32;	size:4;
> +	field:int success;	offset:36;	size:4;
> +	field:int cpu;	offset:40;	size:4;
> +
> +print fmt: "task %s:%d [%d] success=%d [%03d]", REC->comm, REC->pid,
> +	   REC->prio, REC->success, REC->cpu

Btw., are we willing to pin down this format in some sort of ABI?

If yes then this enumeration should probably also be represented in 
/proc/events/ or /sys/kernel/events/.

Then we also need a TRACE_EVENT_ABI():

  #define TRACE_EVENT_ABI TRACE_EVENT

To document and declare tracepoints that maintainers are willing to 
maintain as an ABI component.

The scheduler tracepoints could certainly be propagated to that 
status. (For that they need to be made 32-bit/64-bit safe first by 
using u32/u64, etc. - but that's doable.)

Thoughts?

	Ingo
