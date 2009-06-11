Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZFKUt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZFKUt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZFKUtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:49:20 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35634 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZFKUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:49:19 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090611202341.GA23590@elte.hu>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	 <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
	 <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
	 <20090611202341.GA23590@elte.hu>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 22:49:17 +0200
Message-Id: <1244753357.27363.82.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> > What the "keep it in the kernel sources" approach hopefully allows is
> > 
> >  - taking advantage of new features in a timely manner.
> > 
> >    NOT with some ABI breakage, but simply things like supporting a 
> >    new CPU architecture or new counters. The thing that oprofile 
> >    failed at so badly in my experience.
> >
> >  - Make it easier for developers, and _avoiding_ the horrible 
> >    situation where you have two different groups that don't talk 
> >    well to each other because one is a group of user-space 
> >    weenies, and the other is a group of manly kernel people, and 
> >    there is no common ground.
> 
> Yes, very much agreed.
> 
> Btw., here are a couple of other arguments why i find it useful to 
> have the tools/perf/ in the kernel repo:
> 
> 1) Super-fast and synchronized release cycles
> 
> The kernel is one of the fastest moving packages in Linux - most 
> user-space packages have (much!) longer release cycles than 3 
> months.

that might be true for some projects, but for others this is wrong. You
are just making an assumption out of thin air.

> A tight release schedule forces a certain amount of release 
> discipline on tooling as well - so i'm glad that the two will be 
> coupled. It's so easy for a promising tool to degrade into 
> tinkerware with odd release cycles with time - if it's part of the 
> kernel then at least the release cycles wont be odd but at precise 3 
> months.

And you can't do that within a perf.git tree on kernel.org because?

> 2) Performance _matters_
> 
> This is an argument pretty specific to perfcounters: Performance 
> analysis tools under Linux suck pretty summarily. Yet, one of the 
> major strengths of Linux is (or at least used to be) performance. So 
> i find it very fitting that the kernel community takes performance 
> analysis tooling into their own hand.
> 
> 3) Strict quality control under a proven mode
> 
> In the kernel repo i can be sure that:
> 
>   - No one will even think of adding autofools to tools/perf/.

That argument is non-sense. While autoconf/automake is maybe not to your
liking, nobody forces you to use it. Projects like git, iw etc. do
perfectly fine without it. I don't mind having autoconf/automake around.

>   - No one will send us code with Hungarian notation and two spaces
>     tabulation.

What kind of shitty argument it is that. I enforce kernel coding style
in my userspace project all the time. No problem with that.

>   - No one will put getopt.h into the code

And that is so bad because?

>   - No one will rewrite it in some weird language

And they can do as they please. You don't have to accept the re-write.
These are all non-sense arguments. If you maintain a userspace project
properly then you will not see any of these problems.

> I can point contributors to well-established kernel coding 
> principles, without having to argue no end about them.

Come on. A lot of projects use kernel coding style nowadays. That is not
a problem here.

> All in one - the Linux kernel is a fire breathing monster engine 
> when it comes to producing good software. Who says it that that this 
> infrastructure and experience can only be used to produce kernel 
> space code?

And who says that all userspace people have no idea what they are doing.
We have a lot of successful project that follow almost the same rules as
the kernel.

> 4) Code reuse
> 
> We actually use code from the kernel: list.h primitives and 
> rbtrees.c. We privatized them for now under 
> tools/perf/util/rbtree.[ch] and tools/perf/util/list.h because 
> there's some header and type pollution in them, but it would be nice 
> to include them directly and share the facilities.

Lets see if you are making up an argument or if you are really trying to
work this out and solve it.

> 5) Reality check for kernel developers
> 
> I think kernel hackers need a reality check too. It's easy to say 
> that user-space sucks - but now there's a way and channel that 
> frustration via direct action and make a real difference. I do hope 
> that the extra superfluous mental energies visible in this thread 
> can be used for good purposes too ;-)
> 
> 6) It's a lot of fun
> 
> I never thought i'd say that - but hacking properly structured 
> user-space code in the kernel repo is serious fun. It's even 
> relaxing at times: i can be reasonably sure that i wont crash the 
> kernel.
> 
> All in one, we did this because we found that it produces better 
> code in practice and does it faster - and i dont think we should 
> rigidly limit the kernel repo to kernel-space projects alone.

Linus has a bad expierience with oprofile and wants to try something new
and I can follow that argument to a certain degree. I don't agree with
it, but that is fine.

So you are saying that only good code comes from including it into
linux-2.6.git and otherwise you will never get there. Have you actually
tried to maintain this in a separate repository on kernel.org?

Regards

Marcel


