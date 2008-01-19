Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbYASDgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbYASDgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 22:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761610AbYASDgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 22:36:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933AbYASDge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 22:36:34 -0500
Date: Fri, 18 Jan 2008 22:32:38 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080119033238.GD27193@redhat.com>
References: <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com> <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com> <20080118222637.GA30900@Krystal> <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 18, 2008 at 05:49:19PM -0500, Steven Rostedt wrote:
> [...]
> > But I have not seen a lot of situations where that kind of glue-code was
> > needed, so I think it makes sense to keep markers simple to use and
> > efficient for the common case.
> >
> > Then, in this glue-code, we can put trace_mark() and calls to in-kernel
> > tracers.
> 
> I'm almost done with the latency tracer work, and there are only a total
> of 6 hooks that I needed.
> [...]
> With the above, we could have this (if this is what I think you are
> recommending). [...]
> static inline trace_switch_to(struct task_struct *prev,
> 			struct task_struct *next)
> {
> 	trace_mark(kernel_schedudule,
> 		"prev_pid %d next_pid %d prev_state %ld",
> 		prev->pid, next->pid, prev->pid);
> 
> 	trace_context_switch(prev, next);
> }

I'm afraid I don't see the point in this.  You could use one marker
for all that data (and force the more naive tracer callbacks to ignore
out some of them).  You could even use two markers (and force the more
naive tracer to attach to only to its favorite subset).  But to use a
second, different, less efficient, not more configurable tracing hook
mechanism in the same logical spot makes no sense to me.

- FChE
