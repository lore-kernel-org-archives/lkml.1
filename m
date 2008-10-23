Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYJWQlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYJWQlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYJWQln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:41:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbYJWQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:41:39 -0400
Message-ID: <4900A8D4.4010806@zytor.com>
Date: Thu, 23 Oct 2008 09:39:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, john stultz <johnstul@us.ibm.com>,
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
References: <20081016232729.699004293@polymtl.ca> <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org> <48FD0633.70604@zytor.com> <200810211211.00332.bjorn.helgaas@hp.com> <alpine.LFD.2.00.0810230838410.3287@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810230838410.3287@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> They are almost inevitable for another reason too: the interconnect seldom 
> has a concept of "clock signal" other than for the signalling itself, and 
> the signal clock is designed for the signal itself and is designed for 
> signal integrity rather than "stable clock".
> 
> Does _any_ common interconnect have integral support for clock 
> distribution?
> 

How do you mean "integral"?  All it really would end up being would be a 
separate wire anyway carrying the 14.318 MHz clock, so the only way it 
would ever be "integral" is as part of the slot connector definition.

Note that this is a *frequency standard*.  This is a much simpler task 
than distributing a clock that has to be in phase with a bunch of data 
wires.

> And no, nobody is going to add another clock network for just clock 
> distribution. 

I have defitely seen machines with a common backplane clock source. 
That does not mean that it is common.  I can certainly see the 
redundancy issues being a big deal there.

> So even ignoring redundancy issues, and the fact that people want to 
> hot-plug things (and yes, that would make a central clock interesting), I 
> doubt any hw manufacturer really looks at it the way we do.

Hotplugging isn't so bad (the clock source is tiny, and goes on the 
backplane.)  Redundancy is harder, but not impossible -- even cheap 
TCXOs can usually operate either self-running or as slaves to an 
incoming signal.  The hard part is to avoid partition on failure, since 
in that case you have to handle the unsynchronized case correctly anyway.

> The best we could hope for is some hardware assist for helping distribute 
> a common clock. Ie not a real single crystal, but having time-packets in 
> the interconnect that are used to synchronize nodes whenever there is 
> communication between them. It's hard to do that in software, because the 
> overhead is fairly high, but if hardware does at least some of it you 
> could probably get a damn fine distributed clock source.
> 
> But I don't know if any hw people are worried enough about it to do it...

Most likely not, which means that any solutions we as software guys 
propose are probably pointless.

	-hpa

