Return-Path: <linux-kernel-owner+w=401wt.eu-S1763043AbZFLN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763043AbZFLN5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbZFLN5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:57:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:49334 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZFLN46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:56:58 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612134428.GC32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu>
	 <1244812224.7172.146.camel@pasglop>  <20090612134428.GC32105@elte.hu>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 23:56:16 +1000
Message-Id: <1244814976.7172.164.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 15:44 +0200, Ingo Molnar wrote:

> This is certainly doable for agreeable features - which is the bulk 
> - and it is being done.
> 
> But this is a catch-22 for _controversial_ new features - which 
> perfcounters clearly was, in case you turned off your lkml 
> subscription ;-)

I didn't :-) My point here is that Linus can make a decision with an
email -before- merging so that -next gets a chance, at least for a
couple of days, to do the integration testing once the controversy has
been sorted by his highness.

> And if you hit that build breakage during bisection you can do:
> 
>    git cherry-pick e14112d

Right, I can, you can, but can random tester who wants to track down
what his problem is ? I'm not sure...

> Also, you seem to brush off the notion that far more bugs slip 
> through linux-next than get caught by it.

Less than without linux-next. We aren't perfect and no process will
solve everything. But this could have been easily avoided.

> So if you think linux-next matters in terms of _regression_ testing, 
> the numbers dont seem to support that notion. This particular 
> incident does support that notion though, granted - but it's taken 
> out of context IMHO:
> 
> In terms of test coverage, at least for our trees, less than 1% of 
> the bugs we handle get reported in a linux-next context - and most 
> of the bugs that get reported (against say the scheduler tree) are 
> related to rare architectures.

But most obvious bugs will have been caught way before that, which
leaves the hard to catch ones or the configuration-specific ones. Those
will pass linux-next, I agree. But that isn't my point and that isn't
what linux-next will catch.  What is will catch is that kind of really
simple mechanical problems, such as build breakage for other archs.

If perfcounters had been 1 or 2 days in -next before being merged, we
would have avoided that problem and made everybody's bisecting life
easier.

> In fact, i checked, there were _zero_ x86 bugs reported against 
> linux-next and solved against it between v2.6.30-rc1 and v2.6.30:

No but Stephen caught a bunch of mechanical compile fails due to
integration problems.

>    git log --grep=next -i v2.6.30-rc1..v2.6.30 arch/x86/
> 
> Doing it over the full cycle shows one commit altogether - a Xen 
> build failure. In fact, i just checked the whole stabilization cycle 
> for the whole kernel (v2.6.30-rc1..v2.6.30-final), and there were 
> only 5 linux-next originated patches, most of them build failures.
> 
> I did this by looking at all occurances of 'next', in all commit 
> logs:
> 
>    git log --grep=next -i v2.6.30-rc1..v2.6.30
> 
> and then manually checking the context of all 'next' matches and 
> counting the linux-next related commits.
> 
> So lets be generous and say that because some people dont put the 
> bug report originator into the changelog it was four times as many, 
> 20 - but that's still dwarved by the sheer amount of post-rc1 
> changes: thousands of changes and hundreds of regressions.
> 
> linux-next is mostly useful (to me at least) not for the 
> cross-builds it does, but in terms of mapping out upcoming conflicts 
> - which also drives early detection of problematic patches and 
> problematic conflicts.

Yes, it does. The problem is that it helps -you- that way, but won't
help -us- vs. that kind of mechanical problems unless -you- also play
the game and get your stuff in there for a little while before merging
it :-)

Cheers,
Ben.


