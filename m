Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbYBBOOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbYBBOOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYBBOOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:14:33 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:53808 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbYBBOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:14:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP4IpEdMQWYq/2dsb2JhbACBWKwu
Date: Sat, 2 Feb 2008 09:14:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 21/23 -v8] Add markers to various events
Message-ID: <20080202141425.GA16086@Krystal>
References: <20080130210357.927754294@goodmis.org> <20080130210528.149582393@goodmis.org> <20080131120605.GA8493@Krystal> <Pine.LNX.4.58.0802020158000.21975@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802020158000.21975@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:09:17 up 90 days, 19:14,  2 users,  load average: 0.91, 0.82,
	0.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 5B
> 
> On Thu, 31 Jan 2008, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > This patch adds markers to various events in the kernel.
> > > (interrupts, task activation and hrtimers)
> > >
> >
> > Hi Steven,
> >
> > I would propose the following standard for IRQ handler markers:
> >
> > trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", irq,
> >   (regs)?(!user_mode(regs)):(1));
> 
> Are you saying that two markers with the same name is ok?
> That would be great if that is true.
> 

Yep. Just make sure that they have the exact same format string,
otherwise the marker infrastructure will refuse to connect probes to
them (and will printk an error message saying this). You can even put a
marker in an inline function or unrolled loop (many markers will be
generated and this is ok).

> > ....
> > trace_mark(kernel_irq_exit, MARK_NOARGS);
> 
> My patches don't use this (yet) so I'm leaving out adding markers
> that are not used. I'm not disagreeing with adding these, it's just that
> a patch series should only add markers that are actually used.
> 

Ok, I agree with your approach. About using the markers, I wonder if it
would be best for me to continue to concentrate my effort in getting the
low-level stuff into the kernel first or to switch my focus on posting
the higher-level stuff : the tracer itself, which is mostly a
stand-alone kernel module.

Mathieu

> >
> > So we can know the elaspsed time in irq handlers and whether they are
> > nested on user of kernel code.
> >
> > The same for traps :
> >
> > trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", trapnr,
> >   instruction_pointer(regs));
> >
> > Where we know the trap number and the instruction pointer that caused
> > the trap. Here again, we should put a :
> >
> > trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
> >
> > At the end of the trap handlers.
> >
> > It makes automatic analysis _much_ easier than trying to gather each and
> > every handler instrumentation which would have a different name...
> >
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
