Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZLCEHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZLCEHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZLCEHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:07:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbZLCEHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:07:03 -0500
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
In-Reply-To: <4B1737E2.6010502@redhat.com>
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
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 23:07:08 -0500
Message-Id: <1259813228.12870.108.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 23:00 -0500, Masami Hiramatsu wrote:
> Mathieu Desnoyers wrote:
> > In addition, I wonder if we should rename "CREATE_TRACE_POINTS" to
> > something more suitable while we are here ? Basically, it will affect
> > all TRACE_CLASS/TRACE_CLASS_EVENT/TRACE_EVENT from headers included
> > after it's defined.
> 
> Agreed, CREATE_TRACE_POINTS is a bit irritating thing :-(

Well, I think the name could use some help, but I don't think it is the
name that irritates you.

> 
> For example, if we call tracepoints defined in same-header on
> several different files, we need to check other people have
> already defined CREATE_TRACE_POINTS on another file, because
> CREATE_TRACE_POINTS must be used once for each header...
> 
> So, how about introducing a c file which is only for defining
> tracepoints for kernel parts ? or defining tracepoints in
> kernel at the beginning of kernel/tracepoint.c ? (and don't
> touch tracepoints in modules)

I think the proper fix is to have each tracepoint header have its own C
file. I believe Christoph does this with xfs.

Basically, we should have a:

kernel/sched_trace.c that includes the include/trace/events/sched.h and
does the define.

And the same goes for other trace points.

> 
> e.g.
> 
> @kernel/tracepoint.c
>  ...
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
>  #include <trace/events/...>

We could do this for all that is defined in the include/trace/events.

>  ...
> 
> @kernel/sched.c
>  ...
>  #include <trace/events/sched.h>	/* Just include events header */
>  ...
> 
> @fs/ext4/super.c (no change, since it can be module)
>  ...
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ext4.h>

Perhaps we should move out anything in include/trace/events that is also
a module into its sub system?

>  ...
> 
> Hmm?

Hrmmm?

-- Steve


