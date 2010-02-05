Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab0BEOxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:53:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:53900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0BEOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:53:45 -0500
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1265381266.24386.32.camel@gandalf.stny.rr.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
	 <1265381266.24386.32.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 15:53:24 +0100
Message-ID: <1265381604.22001.682.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 09:47 -0500, Steven Rostedt wrote:
> On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> > TRACE_EVENT_INJECT macro is the same as TRACE_EVENT but takes one
> 
> >  #undef DEFINE_EVENT
> >  #define DEFINE_EVENT(template, call, proto, args)		\
> >  static void ftrace_profile_##call(proto)			\
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 189b09b..5c75cc7 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -142,6 +142,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
> >  				break;
> >  			}
> >  			call->enabled = 1;
> > +
> > +			if (call->inject)
> > +				call->inject();
> >  		}
> >  		break;
> >  	}
> 
> With the proposal I'm suggesting:
> 
> register_event_command(event, NULL, NULL, inject_me, inject_me, data);
> 
> The above would do basically what this patch does. When ever the event
> is enabled or disabled the inject_me function will be called.
> 
> Would this work?

No, because a dump all inject sucks chunks.

