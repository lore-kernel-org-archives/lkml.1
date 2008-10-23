Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYJWPuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYJWPuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYJWPtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:49:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652AbYJWPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:49:38 -0400
Date: Thu, 23 Oct 2008 08:47:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, john stultz <johnstul@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <200810211211.00332.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.2.00.0810230838410.3287@nehalem.linux-foundation.org>
References: <20081016232729.699004293@polymtl.ca> <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org> <48FD0633.70604@zytor.com> <200810211211.00332.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Oct 2008, Bjorn Helgaas wrote:

> On Monday 20 October 2008 04:29:07 pm H. Peter Anvin wrote:
> > Linus Torvalds wrote:
> > > 
> > > But it's not going to solve the "hey, I have 512 CPU's, they are all on 
> > > different boards, and no, they are _not_ synchronized to one global 
> > > clock!".
> > > 
> > > That's why I'd suggest making _purely_ local time, and then aiming for 
> > > something NTP-like. But maybe there are better solutions out there.
> > 
> > At the same time, it would definitely be nice to encourage vendors of 
> > large SMP systems to provide a common root crystal (frequency standard) 
> > for a single SMP domain.  Preferrably a really good one, TCXO or better.
> 
> A single root crystal is nice for us software guys.  But it often
> also turns into a single point of failure, which the hardware guys
> are always trying to eliminate.  So I think multiple crystals are
> inevitable for the really large machines.

They are almost inevitable for another reason too: the interconnect seldom 
has a concept of "clock signal" other than for the signalling itself, and 
the signal clock is designed for the signal itself and is designed for 
signal integrity rather than "stable clock".

Does _any_ common interconnect have integral support for clock 
distribution?

And no, nobody is going to add another clock network for just clock 
distribution. 

So even ignoring redundancy issues, and the fact that people want to 
hot-plug things (and yes, that would make a central clock interesting), I 
doubt any hw manufacturer really looks at it the way we do.

The best we could hope for is some hardware assist for helping distribute 
a common clock. Ie not a real single crystal, but having time-packets in 
the interconnect that are used to synchronize nodes whenever there is 
communication between them. It's hard to do that in software, because the 
overhead is fairly high, but if hardware does at least some of it you 
could probably get a damn fine distributed clock source.

But I don't know if any hw people are worried enough about it to do it...

		Linus
