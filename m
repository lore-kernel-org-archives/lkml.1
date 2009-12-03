Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZLCNyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZLCNyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZLCNyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:54:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33348 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZLCNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:54:50 -0500
Subject: Re: trace/events: DECLARE vs DEFINE semantic
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, wcohen@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <4B17C25A.8090703@redhat.com>
References: <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
	 <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
	 <1259781578.12870.78.camel@gandalf.stny.rr.com>
	 <4B16EC06.6010706@redhat.com>
	 <1259794005.12870.102.camel@gandalf.stny.rr.com>
	 <20091202231019.GB14770@Krystal>  <4B1737E2.6010502@redhat.com>
	 <1259813228.12870.108.camel@gandalf.stny.rr.com>
	 <4B17C25A.8090703@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 03 Dec 2009 08:54:53 -0500
Message-Id: <1259848493.12870.114.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 08:51 -0500, Masami Hiramatsu wrote:

> > Basically, we should have a:
> > 
> > kernel/sched_trace.c that includes the include/trace/events/sched.h and
> > does the define.
> > 
> > And the same goes for other trace points.
> 
> Hmm, I'd rather like to move it into kernel/events/ or something new
> sub directory, since those files will have just two lines (define and
> include).

I'm fine with a kernel/events dir.

> 
> >> e.g.
> >>
> >> @kernel/tracepoint.c
> >>  ...
> >>  #define CREATE_TRACE_POINTS
> >>  #include <trace/events/sched.h>
> >>  #include <trace/events/...>
> > 
> > We could do this for all that is defined in the include/trace/events.
> > 
> >>  ...
> >>
> >> @kernel/sched.c
> >>  ...
> >>  #include <trace/events/sched.h>	/* Just include events header */
> >>  ...
> >>
> >> @fs/ext4/super.c (no change, since it can be module)
> >>  ...
> >>  #define CREATE_TRACE_POINTS
> >>  #include <trace/events/ext4.h>
> > 
> > Perhaps we should move out anything in include/trace/events that is also
> > a module into its sub system?
> 
> Would you mean putting those headers in sub-system's directory?
> (e.g. fs/ext4/)
> In that case, a problem will happen when user want to hook those
> tracepoint from their module, because it is hard to find those
> local headers.

Why? Modules usually do have their own headers in their sub system.

OK, if a module keeps their headers global (include/linux) then sure
they can keep their tracepoint header in include/trace/events. But I
still think that the module CREATE_TRACE_POINTS code should be kept with
the module code itself (but in a small separate file).

-- Steve


