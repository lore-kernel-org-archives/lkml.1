Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYLMHt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYLMHt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 02:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYLMHtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 02:49:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYLMHtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 02:49:45 -0500
Date: Sat, 13 Dec 2008 08:49:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt
	triggering on output
Message-ID: <20081213074930.GA4205@elte.hu>
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com> <20081212101448.GE18152@elte.hu> <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > applied to tip/tracing/function-graph-tracer, thanks Frederic!
> >
> > The output looks really nice.
> >
> >        Ingo
> >
> 
> Thanks :-)
> 
> If anyone  has other needs or suggestions about this tracer, don't
> hesitate to request it.
> I remember Peter suggested that the preempt count could be output.

that reminds me ... did you know about hardirq_count()? We could use it 
to detect IRQ entries in a more generic way, instead of the section 
trick?

Another thing, i just noticed that ftrace_print() is broken in certain 
situations, for example a plain newline:

        ftrace_printk("\n");

printed via trace_pipe will print some weirdly concatenated line:

           <...>-2994  [007]   406.498986: debug_show:          <...>-2994  [007]   406.498986:            <...>-2994  [007]   406.498986: debug_show: 

not via a separate, standalone, empty line.

Another thing: it would be nice to have a trace_option to leave out this 
preamble:

           <...>-2994  [007]   406.498986: debug_show:  test printk

and just give this output:

 test printk

i.e. some 'printk compatibility' mode. That way i could use 
ftrace_printk() as a pure replacement for printk, during development.

	Ingo
