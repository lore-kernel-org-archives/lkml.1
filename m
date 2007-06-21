Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbXFUXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbXFUXss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXFUXsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:48:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35884 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbXFUXsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:48:40 -0400
Date: Fri, 22 Jun 2007 01:48:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Debbugs developers <debian-debbugs@lists.debian.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070621234857.GC23017@stusta.de>
References: <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 08:01:19AM -0700, Linus Torvalds wrote:
> On Tue, 19 Jun 2007, Adrian Bunk wrote:
>...
> > The -mm kernel already implements what your proposed PTS would do.
> > 
> > Plus it gives testers more or less all patches currently pending 
> > inclusion into Linus' tree in one kernel they can test.
> > 
> > The problem are more social problems like patches Andrew has never heard 
> > of before getting into Linus' tree during the merge window.
> 
> Not really. The "problem" boils down to this:
> 
> 	[torvalds@woody linux]$ git-rev-list --all --since=100.days.ago | wc -l
> 	7147
> 	[torvalds@woody linux]$ git-rev-list --no-merges --all --since=100.days.ago | wc -l
> 	6768
> 
> ie over the last hundred days, we have averaged over 70 changes per day, 
> and even ignoring merges and only looking at "pure patches" we have more 
> than an average of 65 patches per day. Every day. Day in and day out.
> 
> That translates to five hundred commits a week, two _thousand_ commits per 
> month, and 25 thousand commits per year. As a fairly constant stream.
> 
> Will mistakes happen? Hell *yes*. 
> 
> And I'd argue that any flow that tries to "guarantee" that mistakes don't 
> happen is broken. It's a sure-fire way to just frustrate people, simply 
> because it assumes a level of perfection in maintainers and developers 
> that isn't possible.
> 
> The accepted industry standard for bug counts is basically one bug per a 
> thousand lines of code. And that's for released, *debugged* code. 
> 
> Yes, we should aim higher. Obviously. Let's say that we aim for 0.1 bugs 
> per KLOC, and that we actually aim for that not just in _released_ code, 
> but in patches.
> 
> What does that mean?
> 
> Do the math:
> 
> 	git log -M -p --all --since=100.days.ago | grep '^+' | wc -l
> 
> That basically takes the last one hundred days of development, shows it 
> all as patches, and just counts the "new" lines. It takes about ten 
> seconds to run, and returns 517252 for me right now.
> 
> That's *over*half*a*million* lines added or changed!
> 
> And even with the expectation that we do ten times better than what is 
> often quoted as an industry average, and even with the expectation that 
> this is already fully debugged code, that's at least 50 bugs in the last 
> one hundred days.
> 
> Yeah, we can be even more stringent, and actually subtract the number of 
> lines _removed_ (274930), and assume that only *new* code contains bugs, 
> and that's still just under a quarter million purely *added* lines, and 
> maybe we'd expect just new 24 bugs in the last 100 days.
> 
> [ Argument: some of the old code also contained bugs, so the lines added 
>   to replace it balance out. Counter-argument: new code is less well 
>   tested by *definition* than old code, so.. Counter-counter-argument: the 
>   new code was often added to _fix_ a bug, so the code removed had an even 
>   _higher_ bug rate than normal code.. 
> 
>   End result? We don't know. This is all just food for thought. ]
> 
> So here's the deal: even by the most *stringent* reasonable rules, we add 
> a new bug every four days. That's just something that people need to 
> accept. The people who say "we must never introduce a regression" aren't 
> living on planet earth, they are living in some wonderful world of 
> Blarney, where mistakes don't happen, developers are perfect, hardware is 
> perfect, and maintainers always catch things.
>...

Exactly: We cannot get a regression free or even bug free kernel.
But we could handle the reported regressions (or even the reported bugs) 
better than we do.

Lesson #6:
Get the data.

Some real life numbers from 2.6.21 development:
- 80 days between 2.6.20 and 2.6.21
- 98 post-2.6.20 regression have been reported before 2.6.21 was released
- 15 open post-2.6.20 regression reports at the time of the 2.6.21 release
- 8 open post-2.6.20 regression reports at the time of the 2.6.21 release
    that were reported at least 3 weeks before the 2.6.21 release

This:
- only includes regressions with reasonably usable reports [1] and
- confirmed to be regressions and
- reported by the relatively small number (compared to the complete
  number of Linux users) of -rc testers and
- reported before the release of 2.6.21.

We weren't even able to handle all reported recent regressions in 
2.6.21, and for other bugs our numbers won't be better.

When Dave Jones says that for a kernel for a new RHEL release that is 
based on a "stable" upstream kernel they spend 3 months only for shaking 
out bugs in the kernel that's IMHO a good description of our "stable" 
kernels.

I'm not claiming the kernel could become bug-free, but aiming at being 
able to handle all incoming bug reports is IMHO a worthwhile and not 
completely unrealistic goal with benefits for all Linux users (and the 
overall image of Linux).

Currently, we are light years away from this goal.

> 		Linus

cu
Adrian

[1] submitter has given all information requested

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

