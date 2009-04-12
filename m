Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZDLKZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZDLKZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZDLKZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:25:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbZDLKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:25:40 -0400
Date: Sun, 12 Apr 2009 12:25:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace: Separate include/trace/kmemtrace.h to
	kmemtrace part and tracepoint part
Message-ID: <20090412102525.GA21282@elte.hu>
References: <49DEE68A.5040902@cn.fujitsu.com> <20090410110303.GB21506@elte.hu> <20090410152121.GA5505@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410152121.GA5505@localhost>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Fri, Apr 10, 2009 at 01:03:03PM +0200, Ingo Molnar wrote:
> > 
> > * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > 
> > > Current kmemtrace.h is used both as header file of kmemtrace and kmem's
> > > tracepoints definition.
> > > Tracepoints' definition file may be used by other code, and should only have
> > > definition of tracepoint.
> > > 
> > > We can separate include/trace/kmemtrace.h into 2 files:
> > >   include/linux/kmemtrace.h: header file for kmemtrace
> > >   include/trace/kmem.h:      definition of kmem tracepoints
> > > 
> > > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > ---
> > >  include/linux/kmemtrace.h             |   25 +++++++++++++++++++++++++
> > >  include/linux/slab_def.h              |    2 +-
> > >  include/linux/slub_def.h              |    2 +-
> > >  include/trace/{kmemtrace.h => kmem.h} |   25 +++----------------------
> > >  init/main.c                           |    2 +-
> > >  kernel/trace/kmemtrace.c              |    2 +-
> > >  kernel/trace/trace.h                  |    2 +-
> > >  mm/slab.c                             |    2 +-
> > >  mm/slob.c                             |    2 +-
> > >  mm/slub.c                             |    2 +-
> > >  10 files changed, 36 insertions(+), 30 deletions(-)
> > >  create mode 100644 include/linux/kmemtrace.h
> > >  rename include/trace/{kmemtrace.h => kmem.h} (78%)
> > 
> > Pekka, Eduard, do you agree with these two patches? Converting those 
> > tracepoints to TRACE_EVENT() is really nice. The above include file 
> > restructuring makes sense too - it separates tracepoint definition 
> > from the plugin init method.
> > 
> > 	Ingo
> 
> Yes, these two patches look great. The first one makes the 
> kmem tracepoints usable by other things (e.g. kmemcheck) 
> in a kmemtrace-independent fashion, which is nice. Thanks, 
> Zhao.
>
> One thing I don't actually get is why have kmem_event_types.h 
> separate from kmem.h, but it's not really an issue, I see other 
> tracers doing the same thing. Other than that, it looks fine 
> although I didn't test. Here's the ack if you need it:
> 
> Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

I've applied the patches to tip:tracing/ftrace - thanks guys!

The separation of kmem.h from kmem_event_types.h is mainly to keep 
the generic event definitions separate from other 'glue'. Indeed it 
looks a bit artificial here.

	Ingo
