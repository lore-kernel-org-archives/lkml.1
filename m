Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0BWIqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:46:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34552 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0BWIq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:46:29 -0500
Date: Tue, 23 Feb 2010 09:45:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-ID: <20100223084552.GB17617@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
 <20100222090710.GA31357@elte.hu>
 <20100222203319.8bd497a2.sfr@canb.auug.org.au>
 <20100222102745.GJ20844@elte.hu>
 <20100222224752.0cbd5807.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222224752.0cbd5807.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Mon, 22 Feb 2010 11:27:45 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > On Mon, 22 Feb 2010 10:07:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > > >
> > > > I'll keep them in tip:master to get them tested, but note that i cannot 
> > > > push any of these patches into linux-next until this is fixed, as 
> > > > linux-next requires all architectures to build, with no regard to which 
> > > > architectures are tested by kernel testers in practice.
> > > 
> > > I merely expect people not to push known broken code into linux-next.
> > 
> > FYI, this 'mere' kind of indiscriminate definition of 'breakage' is what i am 
> > talking about.
> 
> OK, let me remove "merely" from this.
> 
> I expect people not to push known broken code into linux-next.  Code in
> linux-next is meant to be as ready as possible to be sent to Linus.  If
> you know that it breaks some architecture then it should obviously be
> fixed some how (unless the architecture maintainer really doesn't care,
> of course).
> 
> This is different from not knowing that it breaks some architecture even
> though you have done reasonable testing.
> 
> > The occasional driver build breakage can be tested relatively easily: one 
> > allyesconfig build and it's done. Build testing 22 architectures is 
> > exponentially harder: it requires the setup (and constant maintenance) of 
> > zillions of tool-chains, plus the build time is significant as well.
> > 
> > So this kind of linux-next requirement causes the over-testing of code that 
> > doesnt get all that much active usage, plus it increases build testing 
> > overhead 10-fold. That, by definition, causes the under-testing of code that 
> > _does_ matter a whole lot more to active testers of the Linux kernel.
> 
> Which is why linux-next does *not* require that. [...]

How can you reconcile that with:

> I expect people not to push known broken code into linux-next.  Code in

?

So is it your point that technically you 'expect' but dont 'require'?

That's mostly word games really IMO, as in the end there's not much of a 
difference in practice: because you report build failures of non-mainstream 
architectures pretty much the same way as the main architectures.

I.e. indirectly you push up their importance, while taking away resources from 
the main architectures. Testing and maintainer attention is a finite resource, 
it's all a zero-sum game.

So in the end maintainers either cross-build to all architectures and avoid 
all the squeaky-wheel overhead of linux-next, or avoid pushing to it all that 
frequently. Which causes the collateral damage i mentioned:

> The occasional driver build breakage can be tested relatively easily: one 
> allyesconfig build and it's done. Build testing 22 architectures is 
> exponentially harder: it requires the setup (and constant maintenance) of 
> zillions of tool-chains, plus the build time is significant as well.
>
> So this kind of linux-next requirement causes the over-testing of code that 
> doesnt get all that much active usage, plus it increases build testing 
> overhead 10-fold. That, by definition, causes the under-testing of code that 
> _does_ matter a whole lot more to active testers of the Linux kernel.
>
> Which is a problem, obviously.

The solution? Stop this anti-real-world-usage bias already. Stop pretending 
that those cross-build results are as important as say the thousands of real 
bugzilla entries we have. They are fine info, but the kind of priority you are 
giving them is causing a waste of resources.

The thing is, testing whether the kernel still builds with gcc33 has more 
practical relevance to Linux users than testing about half of the 
architectures. The ancient NE2000 driver probably still has ten times more 
users than half of the architectures we have. Do you boot-test NE2000 with 
linux-next?

Developers simply cannot be expected to build for 22 architectures, and they 
shouldnt be. It's somewhat of a waste of time even on the subsystem maintainer 
level. (although it's certainly more contained there, plus subsystem 
maintainers generally have more hw resources as well.)

The thing is, last i checked you didnt even _test_ x86 as the first step in 
your linux-next build tests. Most of your generic build bug reports are 
against PowerPC. They create the appearance that x86 is a second class citizen 
in linux-next.

IMHO a generic tree like linux-next should be fundamentally neutral and its 
testing should be weighted _towards_ real Linux usage. You should try hard to 
avoid even the _apperance_ of pro-PowerPC (and anti-x86) bias - but AFAICS you 
dont even try.

Which i see as a problem.

Thanks,

	Ingo
