Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZA2NaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZA2NaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZA2N3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:29:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZA2N3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:29:50 -0500
Date: Thu, 29 Jan 2009 14:29:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: Use tracing_reset_online_cpus in more places
Message-ID: <20090129132938.GC24391@elte.hu>
References: <20090128150212.GB627@ghostprotocols.net> <c62985530901280706x61b4e4d1nbb43913f9b53e07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901280706x61b4e4d1nbb43913f9b53e07@mail.gmail.com>
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

> 2009/1/28 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> > Impact: cleanup
> >
> > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> > index ca017e0..1284145 100644
> > --- a/kernel/trace/trace_branch.c
> > +++ b/kernel/trace/trace_branch.c
> > @@ -133,11 +133,7 @@ static void stop_branch_trace(struct trace_array *tr)
> >
> >  static int branch_trace_init(struct trace_array *tr)
> >  {
> > -       int cpu;
> > -
> > -       for_each_online_cpu(cpu)
> > -               tracing_reset(tr, cpu);
> > -
> > +       tracing_reset_online_cpus(tr);
> >        start_branch_trace(tr);
> >        return 0;
> >  }
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index 66fc7b8..c97594d 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -52,15 +52,11 @@ static struct tracer_flags tracer_flags = {
> >
> >  static int graph_trace_init(struct trace_array *tr)
> >  {
> > -       int cpu, ret;
> > -
> > -       for_each_online_cpu(cpu)
> > -               tracing_reset(tr, cpu);
> > -
> > -       ret = register_ftrace_graph(&trace_graph_return,
> > +       int ret = register_ftrace_graph(&trace_graph_return,
> >                                        &trace_graph_entry);
> >        if (ret)
> >                return ret;
> > +       tracing_reset_online_cpus(tr);
> >        tracing_start_cmdline_record();
> >
> >        return 0;
> > diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
> > index b9767ac..087b6cb 100644
> > --- a/kernel/trace/trace_nop.c
> > +++ b/kernel/trace/trace_nop.c
> > @@ -47,12 +47,8 @@ static void stop_nop_trace(struct trace_array *tr)
> >
> >  static int nop_trace_init(struct trace_array *tr)
> >  {
> > -       int cpu;
> >        ctx_trace = tr;
> > -
> > -       for_each_online_cpu(cpu)
> > -               tracing_reset(tr, cpu);
> > -
> > +       tracing_reset_online_cpus(tr);
> >        start_nop_trace(tr);
> >        return 0;
> >  }
> >
> 
> Thanks :-)
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Applied to tip/tracing/ftrace (with your Ack added), thanks guys!

	Ingo
