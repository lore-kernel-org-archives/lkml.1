Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZDPWJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZDPWJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZDPWIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:08:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZDPWIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:08:52 -0400
Date: Fri, 17 Apr 2009 00:08:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add "how to write a good patch summary"
	to SubmittingPatches
Message-ID: <20090416220839.GA30920@elte.hu>
References: <1239882285-4994-1-git-send-email-tytso@mit.edu> <20090416201255.GA21608@elte.hu> <20090416204650.GN7138@mit.edu> <alpine.LFD.2.00.0904161350310.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904161350310.4042@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 16 Apr 2009, Theodore Tso wrote:
> 
> > On Thu, Apr 16, 2009 at 10:12:55PM +0200, Ingo Molnar wrote:
> > > as a bug triager i can, within 1 minute, sort all the commits by 
> > > risk:
> > > 
> > > Low risk cleanups:
> > >     ...
> > > Runtime crash fixes:
> > >     ...
> > > Robustness enhancements:
> > >     ...
> > > Low-risk features:
> > >     ...
> > > High-risk features:
> > >     ...
> > 
> > Sure, but if that's the goal, maybe instead we should have some
> > keywords that we tag onto one-line summary, i.e.
> > 
> > ext4 <LR,cleanup>: 
> 
> Hell no.

I find those artificial tags pretty ugly too.

> The fact is, those "low risk cleanups" break things.
> 
> People who think that you can assess the risk of a commit 
> before-hand and then rely on it are clueless morons.

That's why it's _hard_ to write good impact lines - it takes quite a 
bit of effort to assess the _expected_ impact of commits reliably 
and not look like a complete fool a few days, weeks or months down 
the road.

Those mistakes are also _useful_ for that exact reason: they tell us 
the exact pattern of mis-judged impact and act as a feedback cycle. 
We learned to be a _lot_ more careful about certain areas of code by 
looking at the impact lines of commits that turned out to be broken.

And if the impact cannot be assessed reliably by looking at the 
patch? Then i ask contributors to split up the patch into smaller 
steps.

And the thing is, commit logs themselves - as you can see it in the 
18 specific examples i analyzed above - can be _far more_ ambiguous 
about the true impact of a change - and you are fooling yourself if 
you dont admit to this very basic, simple daily fact of Linux kernel 
commit logs.

Also, natural language commit logs tend to be not too 
straightforward about impact because there's a basic inner 
(sub-conscious) drive in most developers to play down the impact of 
some really embarrassing brown paper bag bug, or to not think too 
hard about the risks of a new feature.

Impact lines _remove_ this fear and associated guilt factor. It 
makes the production of commit logs _more positive_, because it's an 
unavoidable hard rule to admit to crap and mistakes in a neutral, 
unemotional way. And if everyone does it consistently, it looks a 
lot less embarrasing.

The basic problem is that natural languages are one big babble 
machine stock full of inner pardoxes and contradictions: they are 
too vaguely defined, ambiguous, they are emotion laden and 
over-verbose - giving fertile ground for whitewashing and obscuring 
information - or just covering information in white noise.

A good commit log will tell us a nice story and gently and gradually 
drives us along the pathway of the developer's thought process. But 
in the overwhelming majority of cases it will not drive us along the 
more embarrassing bits: how stupid a bug it fixes, how severe that 
bug is, or how risky a new feature is.

_LOOK_ at the 18 commit logs i spent an hour to analyze. That is our 
reality - those are the top-notch commits we have - out of the best 
of the best 5%.

_ADMIT_ that this basic equation is not going to change 
significantly. There's small steps of progress, but our commit logs 
sucked 5 and 10 years ago too, and they sucked for very fundamental 
reasons.

The ext4 logs were of exceptional quality - and we even saw one 
clear 'brown paperbag' bug admitted to there, frankly and openly. 
But it's the exception, and still, the impact lines i added _clearly 
improved the end result_.

The impact line forces honesty without actually accusing people of 
trying unintentionally to mislead others. It also prevents people 
from sub-consciously _fooling themselves_.

Will there be mistakes? Sure, and managing mistakes is the _point_ 
of risk analysis so why would we want to claim that the risk 
assessment is perfect? There are mistakes everywhere in the kernel, 
and the only way to tackle them is to have a clear idea about them. 
Human mistakes fundamentally affect the quality-mapping system too - 
and analyzing that is an important part of quality analysis.

Can they be relied on? They can be relied on the same way all 
written down words can be relied on that accompany code: it depends 
on how much i trust the person who wrote it and it depends on the 
actual track record of that code. So it can be 99% trust or a very 
low level of trust.

In the end, only reading the code will tell for sure. Sometimes not 
even that.

	Ingo
