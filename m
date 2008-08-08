Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYHHRg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYHHRg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHHRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:36:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52443 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYHHRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:36:49 -0400
Date: Fri, 8 Aug 2008 13:36:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080808172259.GB8244@Krystal>
Message-ID: <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > I originally used jumps instead of nops, but unfortunately, they actually 
> > hurt performance more than adding nops. Ingo told me it was probably due
> > to using up the jump predictions of the CPU.
> > 
> 
> Hrm, are you sure you use a single 5-bytes nop instruction then, or do
> you use a mix of various nop sizes (add_nops) on some architectures ?

I use (for x86) what is in include/asm-x86/nops.h depending on what the
cpuid gives us.

> 
> You can consume the branch prediction buffers for conditional branches,
> but I doubt static jumps have this impact ? I don't see what "jump
> predictions" you are referring to here exactly.

I don't know the details, but we definitely saw a drop in preformance 
between using nops and static jumps.

-- Steve

