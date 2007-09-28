Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbXI1NWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbXI1NWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXI1NVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:21:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4757 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXI1NVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:21:52 -0400
Date: Fri, 28 Sep 2007 14:21:38 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928132138.GG18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928104935.GA606@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 12:49:35PM +0200, Ingo Molnar wrote:
> 
> * Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > On Fri, Sep 28, 2007 at 11:39:02AM +0200, Ingo Molnar wrote:
> >
> > > And this is not about any particular false positive. I dont mind an 
> > > "advanced mode" non-default opt-in option for the script, if someone 
> > > is interested in borderline or hard to judge warnings too, but these 
> > > default false positives are _lethal_ for a tool like this. (and i 
> > > made this point before.) This is a _fundamental_ thing, and i'm 
> > > still not sure whether you accept and understand that point. This is 
> > > very basic and very important, and this isnt the first (or second) 
> > > time i raised this.
> > 
> > You are striving for a level of perfection that is simply not 
> > achieveable.
> 
> you _still_ fail to understand (let alone address), the fundamental 
> issues i raised many times. (see below for details)

That is unfair.  Every time we discuss it I state that I disagree that
hiding mostly useful tests is a good thing.  I would love the tests to
be 100% accurate, but if I removed all the tests that can false positive
I would literally have none.  There is a balance to be struck and we
have significantly different ideas on where the balance is.

> > v8 is silent about sched.c because it is not checking very much of it,
> 
> the most usable checkpatch.pl version was v6/v7. It went downhill after 
> that. Look at the script size versus the number of complaints about 
> kernel/sched.c:
> 
>   size                          # warnings
>   ----------------------------------------
>   25383  checkpatch.pl.v6       5
>   26038  checkpatch.pl.v7       6
>   29603  checkpatch.pl.v8       65
>   31160  checkpatch.pl.v9       24
>   34950  checkpatch.pl.v10      28
> 
> i.e. size did not increase all that significantly, still the number of 
> warnings has increased significantly - with little benefit.
> 
> and here's the breakdown for v10: out of 28 warnings, only 6 are 
> legitimate! So the signal to noise ratio has worsened significantly 
> since v6. One warning per 300 lines of sched.c is _not manageable_. It 
> translates to _over 25 thousand false positives_ for the whole kernel.
> 
> every false warning has additive costs: i will have to ignore it from 
> that point on, forever - and i frequently have to re-check the same 
> thing again, and again - just to discover that the warning is still 
> bogus.
> 
> the mails from me in your mbox during the past few months should be 
> proof that i'm fully constructive regarding this matter and that i'm not 
> striving for 100% level of perfection. I'm simply stating the obvious: 
> your tool is less and less useful with every new version and more 
> troubling than that is your apparent inability to realize what this 
> whole issue is about. (see below for details)
>
> > I think it is clear that we differ on what should and should not be 
> > output by default.  Clever people are able to opt out of the warnings, 
> > of things they think they dissagree with.  It is the people with 
> > little experience who need the most guidance and those people who the 
> > tool should target by default.  You cannot expect someone with no 
> > experience to know they need to add '--i-need-more-help' whereas _you_ 
> > I can expect to say '--leave-me-alone' or indeed to make the call that 
> > the output is plain wrong and _you_ know you should ignore it.
> 
> you still dont get the point of this. This isnt about writing a tool 
> that 'can' find something to complain about. This whole kernel source 
> code quality task is about:
> 
>      _making kernel source code quality better_
> 
> not more, not less. If your tool outputs way too many false positives 
> and way too many unimportant borderline cases, people will ignore the 
> tool, and consequently YOU MAKE THE KERNEL'S SOURCE CODE WORSE than it 
> could be. How hard is that to understand?? Having zero (or near zero) 
> output from a checker mechanism is FUNDAMENTAL.
> 
> ( and note that i was a goddamn early adopter of your tool, i'm a tester 
>   and i gave you feedback, and i'm one of the few kernel hackers who 
>   actually use your script as a mandatory component of their 
>   patch-toolchain here and today. But your unchanged fundamentalistic
>   attitude has turned me from a happy supporter of checkpatch.pl into an
>   almost-opponent. If anything, that should be a warning shot for you. )

That is just stupid, I am no fundamentalist.  I personally care not what
tests there are or indeed if they are enabled by default.  I personally
feel you are more capable of turning off things you think are wrong, and
as such the default should be to offer all of the tests.  You disagree,
that doesn't make either of us fundamentalist.

> > Fundamentally I am not trying to help the people who are careful but 
> > those who do not know better.  As for the false positives, those I am 
> > always interested in and always striving to remove, as they annoy me 
> > as much as the next man.
> 
> then remove most of those 22 false positives as a starter. I dont care 
> if it's "hard/impossible" or not. If it cannot be coded like that, DONT 
> output that particular type of check by default. Let people OPT IN if 
> there's a reasonable chance for false positives.
> 
> ( the same is true for gcc warnings: false positives are a huge PITA and
>   they _CAUSE_ bugs because people have learned to ignore gcc warnings 
>   and will accidentally ignore real bugs too. )

Yes, but dispite that we don't just turn warnings off.  Even though they
produce false positives, as having them has some benefit.  My contention
is that checkpatch is following that same approach, risking some false
positives to try and catch problems.


Anyhow.  I have already added a --check/--no-check option which controls
the more subjective tests which will be in the next release; though its
likely the option name will be something more useful by then.

The only question is whether this should default to on.  You are voting
off.  I personally think on.

Andrew?  Randy?  Joel?

-apw
