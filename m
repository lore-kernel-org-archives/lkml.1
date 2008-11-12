Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYKLBN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYKLBN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYKLBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:13:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYKLBNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:13:48 -0500
Date: Tue, 11 Nov 2008 20:13:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: David Howells <dhowells@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, rmk+lkml@arm.linux.org.uk, mingo@elte.hu,
       linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
       mingo@redhat.com, tglx@linutronix.de, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
In-Reply-To: <1226443050.6696.12.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0811112012190.12838@gandalf.stny.rr.com>
References: <20081111182759.GA8052@Krystal> <20081109064855.GA23782@Krystal>  <alpine.LFD.2.00.0811090827160.13034@xanadu.home>  <20081109162250.GB10181@Krystal>  <alpine.LFD.2.00.0811092304300.13034@xanadu.home>  <20081109204256.89ab7925.akpm@linux-foundation.org>
  <alpine.LFD.2.00.0811101627510.13034@xanadu.home>  <20081110135850.0d620f3c.akpm@linux-foundation.org>  <alpine.LFD.2.00.0811101811130.13034@xanadu.home>  <20081110152221.64948d23.akpm@linux-foundation.org>  <alpine.LFD.2.00.0811101917450.13034@xanadu.home>
  <8896.1226442702@redhat.com> <1226443050.6696.12.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Nov 2008, Peter Zijlstra wrote:

> On Tue, 2008-11-11 at 22:31 +0000, David Howells wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > @@ -52,18 +57,22 @@ unsigned long long sched_clock(void)
> > > ...
> > > +	preempt_disable_notrace();
> > 
> > Please, no!  sched_clock() is called with preemption or interrupts disabled
> > everywhere except from some debugging code (lock tracing IIRC).  If you need
> > to insert this preemption disablement somewhere, please insert it there.  At
> > least then sched_clock() will be called consistently.
> 
> Agreed. You could do a WARN_ON(!in_atomic); in sched_clock() depending
> on DEBUG_PREEMPT or something to ensure this.

It would also be nice if this requirement (calling sched_clock with 
preemption disabled) was documented somewhere more obvious.

Doing as Peter suggested, adding a WARN_ON and documenting that this must 
be called with preemption disabled, would be nice.

-- Steve

