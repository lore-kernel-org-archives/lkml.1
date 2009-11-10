Return-Path: <linux-kernel-owner+w=401wt.eu-S1751120AbZKJFLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbZKJFLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZKJFLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:11:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZKJFLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:11:49 -0500
Date: Tue, 10 Nov 2009 06:11:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/4] perf/core: Split up pinned and non pinned
 processing
Message-ID: <20091110051141.GD7897@elte.hu>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
 <1257711206-12243-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257711206-12243-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Split up pinned and non-pinned events processing in two helpers
> so that it's more flexible to handle them seperately.

> +static void
> +__perf_event_sched_in_volatile(struct perf_event_context *ctx,
> +			       struct perf_cpu_context *cpuctx, int cpu)

Small naming suggestion: 'volatile' is a C keyword and rarely used 
outside of that context in the kernel, which makes this function name a 
bit confusing.

So instead of pinned/volatile, a pinned/flexible naming would be more 
readable, i.e. __perf_event_sched_in_flexible() or so.

Also, most of the static functions in kernel/perf_event.c could lose 
their perf_event_ prefix - we already know it's a perf thing, right? 
That will shorten quite a few function names there.

These functions would turn into __sched_in_pinned()/__sched_in_flexible().

Agreed?

	Ingo
