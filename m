Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYASDiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYASDiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 22:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761669AbYASDiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 22:38:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263AbYASDiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 22:38:16 -0500
Date: Fri, 18 Jan 2008 22:36:32 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
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
Message-ID: <20080119033632.GE27193@redhat.com>
References: <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com> <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com> <20080118222637.GA30900@Krystal> <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com> <20080118231928.GA5563@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118231928.GA5563@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 18, 2008 at 06:19:29PM -0500, Mathieu Desnoyers wrote:
> [...]
> Almost.. I would add :
> 
> static int trace_switch_to_enabled;
> 
> > static inline trace_switch_to(struct task_struct *prev,
> > 			struct task_struct *next)
> > {
>     if (likely(!trace_switch_to_enabled))
>       return;
> > 	trace_mark(kernel_schedudule,
> > 		"prev_pid %d next_pid %d prev_state %ld",
> > 		prev->pid, next->pid, prev->pid);
> > 
> > 	trace_context_switch(prev, next);
> > }
> 
> And some code to activate the trace_switch_to_enabled variable (ideally
> keeping a refcount). [...]

All this complexity is to be justified by keeping the raw prev/next
pointers from being sent to a naive tracer?  It seems to me way out of
proportion.

- FChE
