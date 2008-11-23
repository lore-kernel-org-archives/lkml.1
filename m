Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYKWUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYKWUdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYKWUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:33:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYKWUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:33:02 -0500
Date: Sun, 23 Nov 2008 15:32:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
In-Reply-To: <20081123202434.GU6703@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0811231523070.13888@gandalf.stny.rr.com>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <87iqqei5ys.fsf@basil.nowhere.org> <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com> <20081123202434.GU6703@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 Nov 2008, Andi Kleen wrote:

> On Sun, Nov 23, 2008 at 02:56:42PM -0500, Steven Rostedt wrote:
> 
> You snipped my earlier suggestion? Can't you just use kernel gcov
> for this? Frankly it's output is infinitely more useful than
> the one from your patch. It also addresses Andrew's suggestion
> of profiling other control flow constructs.

I'll have to read up more on gcov.

> 
> I know it's not ftrace, but not everything is bad just because it's
> not seen through the ftrace spectacles @)

Actually, the only thing the full branch profiler shares with ftrace, is
the directory.  It really does not use any of the function tracing or 
ring buffer facilities. The "ftrace" name is just a catch all for any
type of tracing or profiling that I do ;-)

Notice, the subject is "trace:" not "ftrace:". This is because it did 
not belong to the true ftrace facility. It really should have been 
"profiling:" but I was tired when I wrote it.

> 
> > On Sun, 23 Nov 2008, Andi Kleen wrote:
> > > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > > This adds a significant amount of overhead and should only be used
> > > > by those analyzing their system.
> > > 
> > > Often this can be also done using CPU performance counters. Might 
> > > be a cheaper option. 
> > 
> > I'd love to add an option that could hook into any arch with HW support 
> > for this. We could dump out the same information, but just a different way 
> > to gather it.  But I'm still ignorant to the use of CPU performance 
> > counters and how to find which branch matches which if.
> 
> The theory is quite simple. Typically there are events for 
> "taken branches" and others for "non taken". So you set up
> two counters using the existing oprofile support and collect
> the samples.  Then combine these two sample streams.
> 
> [Sometimes you have to also synthesize these 
> events because CPUs like to count predicted and mispredicted
> (in the CPU sense) differently, but that's also quite simple
> (on x86/core these can be all specified in the unit mask for
> the same event)]
> 
> The sampling will be statistical (not every branch counted),
> but that's ok because only branches that are executed a significant
> time are interesting anyways.
> 
> The only problem is you have to map back to source code lines, which
> can be done in user space based on the oprofile output and some
> addr2line or similar hacks. oprofile can also do this,
> although it gives this information only indirectly so a custom
> tool might be easier.

My work evolves around not adding any userspace tool that is not already
supported by busybox. I'm not against anyone else doing this work. It's 
just that I'm not interested in such. In otherwords, I rather have someone 
else do that work.

> 
> Note it doesn't even need new kernel code, assuming 
> the architecture already has a working full oprofile implementation.
> 
> The main advantage over gcov would be lower runtime overhead,
> although gcov is giving the better output (and is already working
> too)


This all sounds great, and perhaps someone might decide to do this. The 
full branch tracer I added, I did in a few hours and tested on both x86 
and PPC. That was because I was waiting on output from a test running on 
another box that was taking a couple of hours, and I got bored.

I'm not against any of the suggestions you make. I'm just waiting for 
someone else to do it ;-)

-- Steve

