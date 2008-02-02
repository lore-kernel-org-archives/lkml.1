Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYBBHAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYBBHAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYBBHAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:00:39 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:57364 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYBBHAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:00:38 -0500
Date: Sat, 2 Feb 2008 02:00:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080131120605.GA8493@Krystal>
Message-ID: <Pine.LNX.4.58.0802020158000.21975@gandalf.stny.rr.com>
References: <20080130210357.927754294@goodmis.org> <20080130210528.149582393@goodmis.org>
 <20080131120605.GA8493@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5B

On Thu, 31 Jan 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > This patch adds markers to various events in the kernel.
> > (interrupts, task activation and hrtimers)
> >
>
> Hi Steven,
>
> I would propose the following standard for IRQ handler markers:
>
> trace_mark(kernel_irq_entry, "irq_id %u kernel_mode %u", irq,
>   (regs)?(!user_mode(regs)):(1));

Are you saying that two markers with the same name is ok?
That would be great if that is true.

> ....
> trace_mark(kernel_irq_exit, MARK_NOARGS);

My patches don't use this (yet) so I'm leaving out adding markers
that are not used. I'm not disagreeing with adding these, it's just that
a patch series should only add markers that are actually used.

>
> So we can know the elaspsed time in irq handlers and whether they are
> nested on user of kernel code.
>
> The same for traps :
>
> trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", trapnr,
>   instruction_pointer(regs));
>
> Where we know the trap number and the instruction pointer that caused
> the trap. Here again, we should put a :
>
> trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
>
> At the end of the trap handlers.
>
> It makes automatic analysis _much_ easier than trying to gather each and
> every handler instrumentation which would have a different name...
>

-- Steve

