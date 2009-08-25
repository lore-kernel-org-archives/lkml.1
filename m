Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZHYNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZHYNug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZHYNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:50:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45461 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZHYNue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:50:34 -0400
Date: Tue, 25 Aug 2009 15:50:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090825135017.GA31340@elte.hu>
References: <20090822153346.GA3313@elte.hu> <19088.47213.327897.703458@cargo.ozlabs.ibm.com> <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com> <20090824082318.GD2424@elte.hu> <19091.24374.210127.155521@drongo.ozlabs.ibm.com> <20090825082612.GA17692@elte.hu> <19091.46451.893720.573893@cargo.ozlabs.ibm.com> <20090825101742.GA26801@elte.hu> <19091.52205.222449.441072@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19091.52205.222449.441072@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > Ingo Molnar writes:
> > > 
> > > > If you suggest that each and every subsystem maintainer who 
> > > > touches code that can be built on non-x86 architectures has to 
> > > > cross-build to 20+ architectures to be able to push out a tree, 
> > > > all the time, and has to rebase if this ever gets omitted, you 
> > > > are really defying reality and are hurting Linux.
> > > 
> > > Nice straw man, but I never said or even suggested anything like 
> > > that. :)
> > 
> > ... but what you say in essence amounts to that. Every change to a 
> > file that is built on an architecture 'affects' that architecture so 
> > your arguments can be repeated for that one. It's a slippery slope 
> > built on a wrong premise.
> 
> Not at all.  I'm saying that committing code, some of which has 
> never ever been compiled on any architecture, is just sloppy.

But this is not what happened. We committed it because it was a good 
patch and this _enabled_ the wider testing of it, even in areas that 
developers dont normally use.

In other words while i do a lot of cross-testing and applied your 
fix immediately i'm not willing to whitewash the "PowerPC is rarely 
used" fact out of Git trees via ugly rebasing - especially if the 
distance between the original commit and the fix is just 4 hops.

Nor am i going to require people/developers to test on a dozen of 
architectures or more before we can commit something - it's not 
reasonable.

( Nor is there any real upside to rebasing for this reason alone,
  and there's a lot of downsides to it, many of which i already
  mentioned in my prior replies. )

> It's basic good engineering practice to have at least compiled the 
> code you're committing - at least once on at least one 
> architecture. [...]

And i very much do that before i push such changes to Linus.

It's a push show-stopper but not a commit show-stopper.

You chose to see the intermediate steps by checking the development 
stage, why are you surprised that less used and less tested areas of 
the code breaks?

Everything that happens rarely, such as big pushes to Linus, can be 
(and does get) tested widely like that. For for the most critical 
part of the workflow, the commit latency, we dont want extra 
buerocracy that buys us nothing.

Let the platforms do their own testing and _provide developers_ who 
will make it damn sure new bits work on their architecture out of 
box. Or if they dont (or cannot) and just sit there expecting the 
upstream kernel to do development for them, let them deal with the 
consequences.

> [...]  It's like making changes inside #ifdef CONFIG_FOO but never 
> testing with CONFIG_FOO turned on.  You'd complain, and rightly, 
> if someone did that.

You again seem to ignore the very valid case i pointed out: if i 
change generic code (or an include, an inline function or a define) 
which somehow affects an architecture, by your logic i'd be 
compelled to test it on that architecture - because it affects it. 
That's not reasonable overhead.

> > I can only repeat what i said because i did not see you really 
> > counter the core of my argument (you snipped out much of my mail 
> > that details this and only replied to the last paragraph):
> 
> Well, though much of what you said is true, in the end it seems to 
> boil down to saying that non-x86 architectures don't have any 
> right to expect any degree of care or attention from you, because 
> only x86 is important.  And of course you have a perfect right to 
> pay attention to whatever you find interesting and ignore anything 
> else, including difficulties that you cause along the way for 
> other kernel developers.
> 
> There doesn't seem to be any useful response to that.

You paraphrased my opinion into something i did not say.

Exactly which bit of "i cross-build test every architecture that 
builds fine upstream before i push out to linux-next" do you 
understand as me not caring?

But it does not get as strong testing, it's not a commit 
show-stopper (unless coupled with other badness) and sometimes bugs 
slip through and get fixed after (quickly).

> > Say that patch also touches arch/xtensa/. Can you cross-build to 
> > xtensa?
> 
> Sure, I just ask Michael Ellerman to point kisskb at a tree with 
> my proposed patch in it.

FYI, would be a challenge, xtensa's defconfig didnt build upstream 
for quite a long time:

/home/mingo/tip/arch/xtensa/kernel/pci.c: In function '__pci_mmap_set_pgprot':
/home/mingo/tip/arch/xtensa/kernel/pci.c:362: error: '_PAGE_NO_CACHE' undeclared (first use in this function)
/home/mingo/tip/arch/xtensa/kernel/pci.c:362: error: (Each undeclared identifier is reported only once
/home/mingo/tip/arch/xtensa/kernel/pci.c:362: error: for each function it appears in.)

> > > Patches which touch multiple architecture's arch-specific code 
> > > should also get sent to the maintainers of the affected 
> > > architectures and the linux-arch mailing list.  I don't recall 
> > > seeing this patch on linux-arch, though I may have missed it 
> > > (and anyway that would be Martin's responsibility not yours, 
> > > but it does contribute to the sense of being blindsided).
> > > 
> > > More generally - if you don't have the resources to do regular 
> > > build testing for powerpc or other architectures, then publish 
> > > a testing branch and we'll get kisskb 
> > > (http://kisskb.ellerman.id.au/) to build a selection of 
> > > configs and architectures automatically.
> > 
> > Slowing down patches via buerocracy like that is not acceptable 
> > at all. Make developers care more about your architecture via 
> > natural means, not via buerocratic measures.
> 
> The "should" in what I said is just good manners, not bureaucracy.
> 
> The stuff about kisskb was an offer to help, not bureaucracy. 
> No-one's forcing you to do anything.

Well, me pointing out that such measures slow down the critical path 
of patch submission is a valid concern - and "you are not forced to 
do that" pretty much defeats you having suggested it, doesnt it? (i 
hope i'm not misprepresenting your words)

	Ingo
