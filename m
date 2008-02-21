Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbYBUWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbYBUWDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYBUWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:03:12 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:17054 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYBUWDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:03:11 -0500
Message-Id: <47BDAD3C.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 21 Feb 2008 14:56:28 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Bill Huey (hui)" <bill.huey@gmail.com>
Cc: <a.p.zijlstra@chello.nl>, <rostedt@goodmis.org>, <kevin@hilman.org>,
       <tglx@linutronix.de>, <cminyard@mvista.com>, <dsingleton@mvista.com>,
       <dwalker@mvista.com>, "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH [RT] 00/14] RFC - adaptive real-time locks
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221212420.GA20953@elte.hu>
 <9810cff90802211333k3d19ca2exf28c18ae5a2b86a@mail.gmail.com>
 <20080221214219.GA27209@elte.hu>
In-Reply-To: <20080221214219.GA27209@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 21, 2008 at  4:42 PM, in message <20080221214219.GA27209@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Bill Huey (hui) <bill.huey@gmail.com> wrote:
> 
>> I came to the original conclusion that it wasn't originally worth it, 
>> but the dbench number published say otherwise. [...]
> 
> dbench is a notoriously unreliable and meaningless workload. It's being 
> frowned upon by the VM and the IO folks.

I agree...its a pretty weak benchmark.  BUT, it does pound on dcache_lock and therefore was a good demonstration of the benefits of lower-contention overhead.  Also note we also threw other tests in that PDF if you scroll to the subsequent pages.

> If that's the only workload 
> where spin-mutexes help, and if it's only a 3% improvement [of which it 
> is unclear how much of that improvement was due to ticket spinlocks], 
> then adaptive mutexes are probably not worth it.

Note that the "3%" figure being thrown around was from a single patch within the series.  We are actually getting a net average gain of 443% in dbench.  And note that the number goes *up* when you remove the ticketlocks.  The ticketlocks are there to prevent latency spikes, not improve throughput.

Also take a look at the hackbench numbers which are particularly promising.   We get a net average gain of 493% faster for RT10 based hackbench runs.  The kernel build was only a small gain, but it was all gain nonetheless.  We see similar results for any other workloads we throw at this thing.  I will gladly run any test requested to which I have the ability to run, and I would encourage third party results as well.


> 
> I'd not exclude them fundamentally though, it's really the numbers that 
> matter. The code is certainly simple enough (albeit the .config and 
> sysctl controls are quite ugly and unacceptable - adaptive mutexes 
> should really be ... adaptive, with no magic constants in .configs or 
> else).

We can clean this up, per your suggestions.

> 
> But ... i'm somewhat sceptic, after having played with spin-a-bit 
> mutexes before.

Its very subtle to get this concept to work.  The first few weeks, we were getting 90% regressions ;)  Then we had a breakthrough and started to get this thing humming along quite nicely.

Regards,
-Greg




