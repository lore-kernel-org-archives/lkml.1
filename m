Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZA1O7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZA1O7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZA1O7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:59:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZA1O7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:59:13 -0500
Date: Wed, 28 Jan 2009 12:58:17 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH tip 1/1] blktrace: Use tracing_reset_online_cpus
Message-ID: <20090128145817.GA627@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20090128143356.GG15877@ghostprotocols.net> <c62985530901280653p3febe22cu7897999dce8777e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901280653p3febe22cu7897999dce8777e@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 28, 2009 at 03:53:48PM +0100, Frédéric Weisbecker escreveu:
> 2009/1/28 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> > Impact: cleanup
> >
> > Use tracing_reset_online_cpus instead of open coding it.
> >
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > diff --git a/block/blktrace.c b/block/blktrace.c
> > index 1b2267c..04d81d3 100644
> > --- a/block/blktrace.c
> > +++ b/block/blktrace.c
> > @@ -1109,12 +1109,7 @@ static void blk_tracer_print_header(struct seq_file *m)
> >
> >  static void blk_tracer_start(struct trace_array *tr)
> >  {
> > -       int cpu;
> > -
> > -       tr->time_start = ftrace_now(tr->cpu);
> > -
> > -       for_each_online_cpu(cpu)
> > -               tracing_reset(tr, cpu);
> > +       tracing_reset_online_cpus(tr);
> >
> >        mutex_lock(&blk_probe_mutex);
> >        if (atomic_add_return(1, &blk_probes_ref) == 1)
> >
> 
> Adding Steven in Cc, he uses to relay tracing patches as patchsets
> pull request to Ingo.

Ok, will add him for the next one.

- Arnaldo
