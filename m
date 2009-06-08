Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZFHUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZFHUlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZFHUlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:41:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZFHUlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:41:17 -0400
Date: Mon, 8 Jun 2009 22:40:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090608204056.GA26832@elte.hu>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu> <20090608202406.GA3181@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608202406.GA3181@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> +#ifdef __NR_time
> +trace_event_syscall(1, time, time_t __user *, tloc);
> +#endif
> +
> +#ifdef __NR_stime
> +trace_event_syscall(1, stime, time_t __user *, tptr);
> +#endif
> +
> +#ifdef __NR_gettimeofday
> +trace_event_syscall(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
> +#endif

This could be reduced to a single line: just add a Kconfig entry 
(say TRACE_SYSCALL_TRACEPOINTS) wether an arch supports syscall 
tracepoints, enable it on a sane arch, make sure it has all the 
syscalls and list them ...

As more architectures turn on SYSCALL_TRACEPOINTS, they'll have to 
resolve any deviations in syscall entry points. Ideally we'd have 
one generic table that covers 95% of all syscalls, and the remaining 
5% in some architecture specific #ifdef section.

But, more generally, i'm not at all convinced that we need _any_ of 
this enumeration. Look how much the above lines duplicate 
DEFINE_SYSCALL macros. Why arent those macros re-used?

We dont need too smart pretty-printing i think - we only want to 
know the field size and the field name - nothing else. Duplicating 
all those definitions looks outright wrong to me. Do we really, 
really, really have to do it?

	Ingo
