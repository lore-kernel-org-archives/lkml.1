Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZBRAlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZBRAlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZBRAk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:40:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbZBRAkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:40:55 -0500
Date: Wed, 18 Feb 2009 01:40:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2 v2] tracing/core: use appropriate waiting on
	trace_pipe
Message-ID: <20090218004047.GF25856@elte.hu>
References: <49923a65.1358560a.198e.63ad@mx.google.com> <20090217225538.GD5194@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217225538.GD5194@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Feb 11, 2009 at 02:25:00AM +0100, Frederic Weisbecker wrote:
> > Impact: api and pipe waiting change
> > 
> > Currently, the waiting used in tracing_read_pipe() is done through a
> > 100 msecs schedule_timeout() loop which periodically check if there
> > are traces on the buffer.
> > 
> > This can cause small latencies for programs which are reading the incoming
> > events.
> > 
> > This patch makes the reader waiting for the trace_wait waitqueue except
> > for few tracers such as the sched and functions tracers which might be
> > already hold the runqueue lock while waking up the reader.
> > 
> > This is performed through a new callback wait_pipe() on struct tracer.
> > If none is implemented on a specific tracer, the default waiting for
> > trace_wait queue is attached.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c                 |   62 ++++++++++++++++++++++-----------
> >  kernel/trace/trace.h                 |   25 ++++++++++++--
> >  kernel/trace/trace_functions.c       |    1 +
> >  kernel/trace/trace_functions_graph.c |    1 +
> >  kernel/trace/trace_sched_switch.c    |    1 +
> >  kernel/trace/trace_sched_wakeup.c    |    1 +
> >  6 files changed, 67 insertions(+), 24 deletions(-)
> 
> 
> Steven, Ingo, do you agree this one?
> 
> Thanks.

yeah - this version is much cleaner. I've applied it to 
tip:tracing/ftrace, thanks Frederic!

	Ingo
