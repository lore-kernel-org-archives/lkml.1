Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbXGaOFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbXGaOFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbXGaOEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:04:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbXGaOEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:04:53 -0400
Date: Tue, 31 Jul 2007 16:04:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070731140432.GA21339@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu> <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com> <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org> <20070731100511.GI32582@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731100511.GI32582@gnuppy.monkey.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> Here's the problem, *a lot* of folks can do scheduler development in 
> and outside community, so what's with exclusive-only attitude towards 
> the scheduler ?

You came to us as an ex-BSD developer (which has a completely different 
contribution culture) and early on i tried to explain to you (and we met 
in person at OLS2004) that the Linux way of getting code upstream is not 
that of social-engineering or talking the code upstream, but that of 
_coding_ your stuff upstream: working with others and getting good code 
accepted. I'm not sure you ever realized that point.

To counter your myth of "upstream development exclusivity", here are 
some git-provided hard numbers. Since 2.6.22 was released 3 weeks ago, 
over half a million lines of code were added/modified/removed in the 
upstream -git kernel:

 5965 files changed, 332689 insertions(+), 269500 deletions(-)

that massive amount of work was done by over 750 contributors. Out of 
those 750 contributors, more than 160 are _first time contributors_. 
Think about it, there's _lots_ of fresh blood, about 650 new kernel 
contributors a year. The kernel/sched.c file itself, with 274 commits 
and 88 unique contributors over the past ~2 years alone is one of the 
most actively and most diversely developed core kernel subsystems in the 
kernel.

Regarding PlugSched, i'd suggest you to read the detailed explanation 
that has been offered in this and in related discussions over the past 
few years on lkml. (see: http://lkml.org/lkml/2007/4/15/124 and 
http://lkml.org/lkml/2007/4/15/64 and many other postings)

To recap: we dont have a pluggable TCP/IP core either. Nor do we have a 
pluggable MM. Pluggable I/O schedulers are not an unconditional success 
either - Nick (I/O scheduler author) recently stated that and suggested 
the CPU scheduler to not be pluggable.

Whether something becomes pluggable or not depends on many 
_technological_ factors but you appear to be dead-set on spinning _any_ 
technical decision against pluggability into a conjured-up non-sequitor 
non-technical "so this means you have an exclusive-only attitude" 
position.

Why do you do that? Why cannot you accept the plain fact that:

  _in a kernel, some things should not be pluggable_

Simple as that. I am still in favor of PlugSched as a nice external 
patch because it keeps people interested in schedulers and keeps the 
competitive pressure up even higher (and other reasons), but there are 
_stronger factors than that_ against its inclusion into mainline. (see 
those many mails about those factors)

Besides the technological advantages, the competitive pressure can be 
_even higher_ if the 'competition' is not in-tree but out-of-tree - and 
the end result is an ultimately better scheduler. Had we not rejected 
PlugSched 4 years ago CFS could easily never have happened. We'd have 
2-3 mediocre schedulers, instead of one good scheduler and _users_ would 
resist the removal of any of those schedulers, so no clear winner could
ever gain enough momentum and Linux would forever be stuck with a stupid
and inferior "you have to tweak the scheduler selection manually to your
workload to get the max out of the system" handicap.

But ... i can also understand it that you as a _person_ are unhappy:

You were quite unhappy and bitter about me not including your lockstat 
patch in -rt, while all that happened was that for months i (and others) 
told you that the lockstat idea is nice and sound and tried to point it 
out to you how much simpler and more elegant it would be to use the 
lockdep infrastructure for the same purpose and tried to encourage you 
to pick that route. Peter Zijlstra implemented that approach meanwhile, 
and he used around a magnitude less code than your patch did. That code 
is upstream now. _You_ could have been the one who did that, and it was 
you who prevented yourself from having done that major contribution to 
Linux lock instrumentation.

Perhaps partly influenced by your negative lockstat experience, you were 
also the first one who brought up the (pretty bogus) "elitist" "old 
guard" argument [ http://lkml.org/lkml/2007/4/14/115 ] as a reply to my 
initial CFS announcement, and shortly after your mail Con wrote his 
infamous outburst against CFS [ http://lkml.org/lkml/2007/4/14/199 ], to 
which you came up with another bogus "the main failure I see here is 
that Con wasn't included in this design or privately in review process" 
reply [ http://lkml.org/lkml/2007/4/15/4 ] that only fanned the flames.

I believe by doing so you poured the oil of your own bitterness on his 
fire, thinly masked as neutral constructive criticism.

So in my opinion you are far from being an unbiased observer in this 
matter, you keep repeating your old arguments without apparently 
listening to the replies and thus i doubt anything i say could really 
make you 'happy' :-/

Really, i'd love it if you started contributing to Linux in a major way, 
instead of doing what seems to amount to stirring up personal 
controversy, and i believe the only inhibitor to such positive kernel 
contributions is _yourself_. If you spent half of the energy you are 
spending on writing these emails on producing actual code you could have 
become a maintainer of some nice Linux subsystem easily. (as many other 
people have become that who came to Linux much later than you) That door 
is still not closed of course, and i believe it all only depends on you, 
not on any upstream maintainer.

	Ingo
