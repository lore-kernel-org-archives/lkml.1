Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYKYP4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYKYP4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKYP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:56:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKYP4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:56:44 -0500
Date: Tue, 25 Nov 2008 16:56:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
Message-ID: <20081125155631.GA22006@elte.hu>
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com> <20081124162719.GA11532@elte.hu> <c62985530811250718q3aa5f2ednd795b7c927abb8e4@mail.gmail.com> <20081125153653.GA21001@elte.hu> <20081125154054.GA21493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125154054.GA21493@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Do you agree with "full function tracer" (since we hook now on the 
> > > two sides)?
> > 
> > "full function tracer" sounds a bit funny and quirky. How about 
> > "function call tracer"? Versus the "function tracer" or "function 
> > entry tracer" which is the lighter variant - both in name and in 
> > overhead. So we'd have:
> > 
> >  # cat /debug/tracing/available_tracers 
> >  mmiotrace wakeup irqsoff function function-call sysprof sched_switch initcall nop
> > 
> > note how intuitive it is: "function-call" is 'more' than just the 
> > plain function-tracer. It also expresses its main property: it 
> > traces the full call, entry and exit and return code as well.
> 
> another similar naming would be: the "function-graph" tracer. 
> function-callgraph would be too long.

Steve thinks function-graph is even more expressive, so lets go with 
that instead :)

it will certainly make sure there's no misunderstanding about the role 
and scope of this tracer, and it's short and expressive as well.

so i'd suggest the following sed -i rules:

 s/FUNCTION_RET_TRACER/FUNCTION_GRAPH_TRACER/g

i'd suggest to keep the ret_stack names - those are proper. (the thing 
that is used to construct the graph is the return stack)

also, please do:

   git mv kernel/tracing/trace_functions_return.c kernel/tracing/trace_functions_graph.c

and Makefile glue fixup:

   s/functions_return/functions_graph/g

	Ingo
