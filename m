Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZCJJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZCJJqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZCJJqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:46:03 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:5570 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751250AbZCJJqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:46:01 -0400
X-BigFish: VPS-44(zz1431J1432R62a3L98dR936eQ148cM1805Mzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KGAB4C-04-Z0G-01
Date: Tue, 10 Mar 2009 10:44:57 +0100
From: Robert Richter <robert.richter@amd.com>
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090310094457.GU10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu> <20090309013902.GK10085@erda.amd.com> <18869.40904.382716.827097@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18869.40904.382716.827097@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Mar 2009 09:44:57.0471 (UTC) FILETIME=[DF7750F0:01C9A164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.09 10:01:28, Paul Mackerras wrote:
> > Some points to mention here. This patch set actually introduces two
> > interfaces, a new user/kernel interface and an in-kernel api to access
> > performance counters. These are separate things and sometimes mixed
> > too much. There is a strong need for an in-kernel api. This is the
> 
> We have been concentrating more on the user/kernel API since that is
> the one that cannot be changed in an incompatible way once this stuff
> goes upstream.  The in-kernel API can be changed at any time and is
> still evolving.

I agree, it is much more easier to change the in-kernel i/f. I just
wanted to emphasize the importance of this i/f. Oprofile, Perfmon and
also LPC will exist in the future too and should share the same code
base. That's what I missed in the discussion until now.

> 
> > third implementation I am involved (oprofile, perfmon are the others)
> > and the things are always the same way. All these subsystems should be
> > merged to one in-kernel implemenation and share the same code. The
> > different user/kernel i/fs could then coexist and meet the users
> > different needs.
> 
> It would certainly be good to get oprofile to use the same low-level
> machinery as perf_counters.  I'm not sure what the fate of perfmon
> will be, but it seems unlikely it will go upstream in anything like
> its present form.

Right, as I sad above, all should share the same low-level code. And,
this code already exists. The question is more how to merge it and
bring the things together.

[...]

> > So, instead of making the list a public data structure, better pass
> > the type to an arch specific function, e.g.:
> > 
> > int arch_xxx_setup_event(int event_type);
> 
> That's exactly what we have, except that it's called
> hw_perf_counter_init and the event_type you have there is in the
> struct perf_counter that gets passed in.

Thanks for pointing this out, I was misinterpreting this as a general
hw initialization function, but instead a counter is allocated.

> 
> > If the type is not supported, an error could be returned. There is no
> > more impact. Even the binaries of the builds would be identically if
> > hw_event_types would be extended for a single different architecture.
> > 
> > The same applies also for counters and so on, better implement
> > functions.
> 
> All of that is already done; hw_perf_counter_init gets to interpret
> the counter->hw_event.type and counter->hw_event.raw fields and decide
> whether the event is supported, and return an error if not.  On x86 it
> looks like there is a further ops structure (struct pmc_x86_ops) which
> allows each x86-compatible cpu type to supply its own functions for
> doing the interpretation of counter->hw_event and other things.

Ok, maybe I mixed too much the architectural with the x86 model
specific implementation. My impression is that there is data in
generic structures what should be better private for the model or
architecture. However, I have to figure out the details here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

