Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYHIAgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYHIAgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHIAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:36:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYHIAgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:36:05 -0400
Date: Fri, 8 Aug 2008 20:36:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <87tzdv2g05.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com>
 <87tzdv2g05.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Andi Kleen wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > I'm stubborn, I want to get it right _and_ keep it fast.
> 
> For me it would seem better to just not use two part 5 byte nops
> instead of adding such hacks.  I doubt there are that many of them
> anyways. I bet you won't be able to measure any difference between the
> different nop types in any macro benchmark.

I wish we had a true 5 byte nop. The alternative is a jmp 0, which is 
measurable.  This is replacing mcount from a kernel compile with the -pg 
option. With a basic build (not counting modules), I have over 15,000 
locations that are turned into these 5 byte nops.

# objdump -dr vmlinux.o | grep mcount |wc
  15152   45489  764924

If we use the jmp 0, then yes, we will see the overhead. The double nop 
that is used for 5 bytes, is significantly better than the jump.

-- Steve

