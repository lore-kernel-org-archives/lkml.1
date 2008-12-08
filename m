Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYLHPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYLHPuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYLHPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:50:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbYLHPua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:50:30 -0500
Date: Mon, 8 Dec 2008 16:50:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/function-graph-tracer: introduce
	__notrace_funcgraph to filter special functions
Message-ID: <20081208155018.GB405@elte.hu>
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu> <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
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

> 2008/12/8 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Impact: trace more functions
> >>
> >> When the function graph tracer is configured, three more files are not
> >> traced to prevent only four functions to be traced. And this impacts
> >> the normal function tracer too.
> >>
> >> arch/x86/kernel/process_64/32.c:
> >>
> >> I had crashes when I let this file traced. After some debugging, I saw
> >> that the "current" task point was changed inside__swtich_to(), ie:
> >> "write_pda(pcurrent, next_p);" inside process_64.c Since the tracer
> >> store the original return address of the function inside current, we
> >> had crashes. Only __switch_to() has to be traced.
> >>
> >> kernel/module.c and kernel/extable.c:
> >>
> >> Because of a function used internally by the function graph tracer:
> >> __kernel_text_address()
> >>
> >> To let the other functions inside these files to be traced, this patch
> >> introduces the __notrace_funcgraph function prefix which is __notrace
> >> if function graph tracer is configured and nothing if not.
> >>
> >> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >
> > applied to tip/tracing/function-graph-tracer, thanks Frederic!
> 
> Thanks!
> 
> > [ one small request: would it be possible to include the diffstat in the
> >  patches you send? If you use git-diff then it's the --patch-with-stat
> >  option. ]
> 
> 
> Ok. BTW. I wanted to give a try on linux-next to test the last ftrace 
> stuffs, but the auto-ftrace-next branch seems too much old. Are the 
> auto branches updated every week or something like this...?

yes - but there's a few pending regressions right now delaying the 
reintegration.

	Ingo
