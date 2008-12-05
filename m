Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYLELVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYLELVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYLELVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:21:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34670 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYLELVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:21:19 -0500
Date: Fri, 5 Dec 2008 12:20:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 1/3] performance counters: core code
Message-ID: <20081205112052.GA7219@elte.hu>
References: <20081204225345.654705757@linutronix.de> <20081204230228.470613892@linutronix.de> <18745.2198.389098.296393@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18745.2198.389098.296393@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Thomas Gleixner writes:
> 
> > +static void
> > +perf_install_in_context(struct perf_counter_context *ctx,
> > +			struct perf_counter *counter,
> > +			int cpu)
> > +{
> > +	struct task_struct *task = ctx->task;
> > +
> 
> [...]
> 
> > +	if (task) {
> > +		task_oncpu_function_call(task, __perf_install_in_context,
> > +					 counter);
> > +	} else {
> > +		smp_call_function_single(cpu, __perf_install_in_context,
> > +					 counter, 1);
> > +	}
> 
> What happens if we send an IPI to the cpu where the task is running, 
> but by the time the IPI arrives, the task has been migrated to another 
> cpu and is now running there?  Do you chase after it and send another 
> IPI to its new cpu, or is there some reason why it can't migrate? If 
> it's the former, where is that code?  I haven't seen it so far (at 
> least, task_oncpu_function_call doesn't seem to do it).

in that case the schedule-in method will install the perf counter 
automatically. No need to chase after it. The smp call is only for the 
case where the task does not schedule at all.

	Ingo
