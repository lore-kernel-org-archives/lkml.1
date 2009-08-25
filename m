Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbZHYXsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbZHYXsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbZHYXsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:48:54 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49190 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbZHYXsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:48:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19092.30814.227577.14257@cargo.ozlabs.ibm.com>
Date: Wed, 26 Aug 2009 09:48:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090825135017.GA31340@elte.hu>
References: <20090822153346.GA3313@elte.hu>
	<19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
	<19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	<20090825082612.GA17692@elte.hu>
	<19091.46451.893720.573893@cargo.ozlabs.ibm.com>
	<20090825101742.GA26801@elte.hu>
	<19091.52205.222449.441072@cargo.ozlabs.ibm.com>
	<20090825135017.GA31340@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Ingo Molnar writes:
> > 
> > > * Paul Mackerras <paulus@samba.org> wrote:
> > > 
> > > > Ingo Molnar writes:
> > > > 
> > > > > If you suggest that each and every subsystem maintainer who 
> > > > > touches code that can be built on non-x86 architectures has to 
> > > > > cross-build to 20+ architectures to be able to push out a tree, 
> > > > > all the time, and has to rebase if this ever gets omitted, you 
> > > > > are really defying reality and are hurting Linux.
> > > > 
> > > > Nice straw man, but I never said or even suggested anything like 
> > > > that. :)
> > > 
> > > ... but what you say in essence amounts to that. Every change to a 
> > > file that is built on an architecture 'affects' that architecture so 
> > > your arguments can be repeated for that one. It's a slippery slope 
> > > built on a wrong premise.
> > 
> > Not at all.  I'm saying that committing code, some of which has 
> > never ever been compiled on any architecture, is just sloppy.
> 
> But this is not what happened. We committed it because it was a good 
> patch and this _enabled_ the wider testing of it, even in areas that 
> developers dont normally use.

One of the points that I have been trying to make all along is that
it helps to make a distinction between "committing for testing" and
"committing to the permanent record", particularly for subsystem and
architecture maintainers (i.e. people who aren't Linus).

> In other words while i do a lot of cross-testing and applied your 
> fix immediately i'm not willing to whitewash the "PowerPC is rarely 
> used" fact out of Git trees via ugly rebasing - especially if the 
> distance between the original commit and the fix is just 4 hops.

Well, I disagree with the word "rarely", but let's not get into a
great long discussion about that.

> Nor am i going to require people/developers to test on a dozen of 
> architectures or more before we can commit something - it's not 
> reasonable.
> 
> ( Nor is there any real upside to rebasing for this reason alone,
>   and there's a lot of downsides to it, many of which i already
>   mentioned in my prior replies. )
> 
> > It's basic good engineering practice to have at least compiled the 
> > code you're committing - at least once on at least one 
> > architecture. [...]
> 
> And i very much do that before i push such changes to Linus.
> 
> It's a push show-stopper but not a commit show-stopper.
> 
> You chose to see the intermediate steps by checking the development 
> stage, why are you surprised that less used and less tested areas of 
> the code breaks?

I'm not surprised it breaks, I'm surprised you set it in stone before
you discover it breaks.  Or at least I was surprised - your workflow
is pretty unique, and I think I have come to understand it better
through this discussion.  If I understand correctly, you don't have a
specific, defined point where a commit gets "frozen", rather, commits
start out fairly liquid and turn to slush and then ice (to change the
metaphor :) within a few days.  Is that a reasonable description?

> Everything that happens rarely, such as big pushes to Linus, can be 
> (and does get) tested widely like that. For for the most critical 
> part of the workflow, the commit latency, we dont want extra 
> buerocracy that buys us nothing.
> 
> Let the platforms do their own testing and _provide developers_ who 
> will make it damn sure new bits work on their architecture out of 
> box. Or if they dont (or cannot) and just sit there expecting the 
> upstream kernel to do development for them, let them deal with the 
> consequences.

OK.  I assume you have a branch in the tip tree that pulls together
all the work in progress - what is that branch called?  I'll try to
organize some regular build-testing on powerpc of that branch.

> > [...]  It's like making changes inside #ifdef CONFIG_FOO but never 
> > testing with CONFIG_FOO turned on.  You'd complain, and rightly, 
> > if someone did that.
> 
> You again seem to ignore the very valid case i pointed out: if i 
> change generic code (or an include, an inline function or a define) 
> which somehow affects an architecture, by your logic i'd be 
> compelled to test it on that architecture - because it affects it. 
> That's not reasonable overhead.

Well, the "by your logic I'd be compelled" part just doesn't follow.
Certainly, if you make a change that obviously affects somebody's
code, it would be good manners to inform them, but that's quite a
different thing from what I was saying.

> > > I can only repeat what i said because i did not see you really 
> > > counter the core of my argument (you snipped out much of my mail 
> > > that details this and only replied to the last paragraph):
> > 
> > Well, though much of what you said is true, in the end it seems to 
> > boil down to saying that non-x86 architectures don't have any 
> > right to expect any degree of care or attention from you, because 
> > only x86 is important.  And of course you have a perfect right to 
> > pay attention to whatever you find interesting and ignore anything 
> > else, including difficulties that you cause along the way for 
> > other kernel developers.
> > 
> > There doesn't seem to be any useful response to that.
> 
> You paraphrased my opinion into something i did not say.
> 
> Exactly which bit of "i cross-build test every architecture that 
> builds fine upstream before i push out to linux-next" do you 
> understand as me not caring?

I didn't say you didn't care.  I paraphrased your statement as
"non-x86 architectures don't have a right to expect me to care", which
is a different thing.  Perhaps that is a slight exaggeration, but
"non-x86 architectures don't have a right to expect more than a very
limited degree of care from me" is certainly the message that has been
coming through loud and strong from you on many occasions.

> > The "should" in what I said is just good manners, not bureaucracy.
> > 
> > The stuff about kisskb was an offer to help, not bureaucracy. 
> > No-one's forcing you to do anything.
> 
> Well, me pointing out that such measures slow down the critical path 
> of patch submission is a valid concern - and "you are not forced to 
> do that" pretty much defeats you having suggested it, doesnt it? (i 
> hope i'm not misprepresenting your words)

You're saying that making a suggestion that someone isn't forced to
follow is pointless?  Huh?

As for the latency of patch submission - that's an interesting
question, and I don't believe that the optimum latency is zero,
because then there's no chance for review.  But certainly we don't
want it to be unnecessarily long either.  Maybe the optimum patch
latency would be an interesting topic to discuss at kernel summit.
Anyway, I am inclined to think that something in the range from a day
or two up to a week would be about right, depending on the nature of
the patch (bug fix, enhancement, new feature) and the width of its
impact across the tree (number of subsystems/architectures affected,
etc.).

Finally, I do think that putting changes to some architecture's code
into your tree without even cc'ing the maintainer for that
architecture, let alone getting their ack, is just plain rude.  And,
correct me if I'm wrong, but that does appear to be what happened
here, and it does seem to be happening more and more often in the tip
tree, unfortunately.

Paul.

