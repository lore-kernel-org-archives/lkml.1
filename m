Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZDGM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZDGM7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZDGM6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:58:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbZDGM6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:58:49 -0400
Date: Tue, 7 Apr 2009 14:57:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
Message-ID: <20090407125726.GA31372@elte.hu>
References: <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org> <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu> <20090407090229.GA2467@elte.hu> <1239104035.22733.443.camel@macbook.infradead.org> <20090407121457.GC11641@elte.hu> <1239108263.22733.492.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239108263.22733.492.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-04-07 at 14:14 +0200, Ingo Molnar wrote:
> > Well, i consider it a feature that it flags weird if (x, y) 
> > constructs: and yes, these iterators you introduced, while they are 
> > legit C, definitely count as 'weird'. If regular code was doing it, 
> > not a loop abstraction, i'd call it non-obvious and borderline 
> > broken straight away.
> > 
> > We should _never ever_ put comma statements into if () 
> > constructs without a _really_ good reason - and if yes, we can 
> > flag that we know what we are doing, via extra parentheses.
> 
> I disagree. I don't think we should be declaring valid C syntax as 
> 'off limits', however rare it is.
>
> _Especially_ if it only actually fails with a fairly esoteric 
> config option set. That's just asking for build breakage.

It failed within 10 minutes of testing for me. And i did not say 
'off limits', i said 'needs a second look and a i-know-what-i-am 
doing flag'.

Anyway, we apparently disagree about what constitutes acceptable 
code and what not. I am more cautious about "weird looking" 
constructs, and for a good reason: often a 'hm, this looks a bit 
weird' sub-conscious feeling is the only sign we have of a serious 
bug in the making.

So making code not look weird and teaching people to not use weird 
looking patterns in usual code is a prime goal - at least to me. 

Does such an approach limit the C language? Yes, of course it does, 
that's the whole point. You appear to be more of the "if it's valid 
C it's fine" camp.

> > and if yes, we can flag that we know what we are doing, via 
> > extra parentheses.
> 
> That's hardly much of a barrier. The requirement to sprinkle 
> gratuitous-looking extra parentheses around the place really isn't 
> going to give us much of a _benefit_ in return for the build 
> breakage.

The thing is, the branch-tracer might be even more weird than your 
iterator (it certainly is, and we might even remove it if it's 
causing undue problems), but it has been upstream for some time 
already and it is certainly useful for certain types of 
difficult-to-analyze codepaths.

Also, it is not breaking the build currently [with any given 
combination of weird .config combos] - so there's no 'sprinking' 
anywhere except your arguably under-tested iterator ;-)

	Ingo
