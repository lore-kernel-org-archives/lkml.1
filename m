Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZBYNHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZBYNHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBYNHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:07:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46620 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZBYNHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:07:32 -0500
Date: Wed, 25 Feb 2009 08:07:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] tracing: make event directory structure
In-Reply-To: <20090225065948.GA5200@nowhere>
Message-ID: <alpine.DEB.2.00.0902250803070.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025754.297578658@goodmis.org> <20090225065948.GA5200@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Frederic Weisbecker wrote:

> On Tue, Feb 24, 2009 at 09:56:12PM -0500, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch adds the directory /debug/tracing/events/ that will contain
> > all the registered trace points.
> > 
> >  # ls /debug/tracing/events/
> > sched_kthread_stop      sched_process_fork  sched_switch
> > sched_kthread_stop_ret  sched_process_free  sched_wait_task
> > sched_migrate_task      sched_process_wait  sched_wakeup
> > sched_process_exit      sched_signal_send   sched_wakeup_new
> > 
> >  # ls /debug/tracing/events/sched_switch/
> > enable
> > 
> >  # cat /debug/tracing/events/sched_switch/enable
> > 1
> > 
> >  # cat /debug/tracing/set_event
> > sched_switch
> 
> 
> Do you plan to add other things inside these events directory?

That's actually the plan. We might want to trigger a stack trace or 
something on that event. The idea will be to add attributes to each 
individual event, and it should be pretty easy to implement since each 
event has its own structure.

> I mean, if you plan to only put an enable file on each of 
them, > it would be better to have just one file:
> 
> cat /debug/tracing/events/sched_switch
> 1
> 
>  
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/trace_events.c |  137 +++++++++++++++++++++++++++++++++++++++++--
> >  kernel/trace/trace_events.h |    7 ++-
> >  2 files changed, 137 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 05bc80e..3bcb9df 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -12,6 +12,11 @@
> >  
> >  #include "trace_events.h"
> >  
> > +#define events_for_each(event)						\
> > +	for (event = __start_ftrace_events;				\
> > +	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
> > +	     event++)
> > +
> 
> 
> The name for_each_events seems to me more intuitive, but it's just
> a matter of taste.

I like that better too. But I was trying to be more consistent with the 
kernel. "list_for_each", "hlist_for_each".

But come to think about it, we do have "for_each_cpu_mask". Hmm?

But it is local to the file. Not something to worry about now ;-)

-- Steve

