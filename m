Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbXFQSyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbXFQSyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXFQSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:53:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbXFQSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:53:57 -0400
Date: Sun, 17 Jun 2007 11:52:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
Message-Id: <20070617115258.1f55b29d.akpm@linux-foundation.org>
In-Reply-To: <200706172053.41806.bzolnier@gmail.com>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	<6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
	<20070617142950.GW3588@stusta.de>
	<200706172053.41806.bzolnier@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007 20:53:41 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> 
> IMO we should concentrate more on preventing regressions than on fixing them.
> In the long-term preventing bugs is cheaper than fixing them afterwards.
> 
> First let me tell you all a little story...
> 
> Over two years ago I've reviewed some _cleanup_ patch and noticed three bugs
> in it (in other words I potentially prevented three regressions).  I also
> asked for more thorough verification of the patch as I suspected that it may
> have more problems.  The author fixed the issues and replied that he hasn't
> done the full verification yet but he doesn't suspect any problems...
> 
> Fast forward...
> 
> Year later I discover that the final version of the patch hit the mainline.
> I don't remember ever seeing the final version in my mailbox (there are no
> cc: lines in the patch description) and I saw that I'm not credited in the
> patch description.  However the worse part is that it seems that the full
> verification has never been done.  The result?   Regression in the release
> kernel (exactly the issue that I was worried about) which required three
> patches and over a month to be fixed completely.  It seems that a year
> was not enough to get this ~70k _cleanup_ patch fully verified and tested
> (it hit -mm soon before being merged)...

crap.  Commit ID, please ;)

> >From reviewer's POV: I have invested my time into review, discovered real
> issues and as a reward I got no credit et all and extra frustration from the
> fact that part of my review was forgotten/ignored (the part which resulted in
> real regression in the release kernel)...  Oh and in the past the said
> developer has already been asked (politely in private message) to pay more
> attention to his changes (after I silently fixed some other regression caused
> by his other patch).
> 
> But wait there is more, I happend to be the maintainer of the subsystem which
> got directly hit by the issue and I was getting bugreports from the users about
> the problem...  :-)
> 
> It wasn't my first/last bad experience as a reviewer... finally I just gave up
> on reviewing other people patches unless they are stricly for IDE subsystem.
> 
> The moral of the story is that currently it just doesn't pay off to do
> code reviews.

I dunno.  I suspect (hope) that this was an exceptional case, hence one
should not draw general conclusions from it.  It certainly sounds very bad.

>  From personal POV it pays much more to wait until buggy patch
> hits the mainline and then fix the issues yourself (at least you will get
> some credit).  To change this we should put more ephasize on the importance
> of code reviews by "rewarding" people investing their time into reviews
> and "rewarding" developers/maintainers taking reviews seriously.
> 
> We should credit reviewers more, sometimes it takes more time/knowledge to
> review the patch than to make it so getting near to zero credit for review
> doesn't sound too attractive.  Hmm, wait it can be worse - your review
> may be ignored... ;-)
> 
> >From my side I think I'll start adding less formal "Reviewed-by" to IDE
> patches even if the review resulted in no issues being found (in additon to
> explicit "Acked-by" tags and crediting people for finding real issues - which
> I currently always do as a way for showing my appreciation for their work).

yup, Reviewed-by: is good and I do think we should start adopting it,
although I haven't thought through exactly how.

On my darker days I consider treating a Reviewed-by: as a prerequisite for
merging.  I suspect that would really get the feathers flying.

> I also encourage other maintainers/developers to pay more attention to
> adding "Acked-by"/"Reviewed-by" tags and crediting reviewers.  I hope
> that maintainers will promote changes that have been reviewed by others
> by giving them priority over other ones (if the changes are on more-or-less
> the same importance level of course, you get the idea).
> 
> Now what to do with people who ignore reviews and/or have rather high
> regressions/patches ratio?

Ignoring a review would be a wildly wrong thing to do.  It's so unusual
that I'd be suspecting a lost email or an i-sent-the-wrong-patch.

As for high regressions/patches ratio: that'll be hard to calculate and
tends to be dependent upon the code which is being altered rather than who
is doing the altering: some stuff is just fragile, for various reasons.

One ratio which we might want to have a think about is the patches-sent
versus reviews-done ratio ;)

> I think that we should have info about regressions integrated into SCM,
> i.e. in git we should have optional "fixes-commit" tag and we should be
> able to do some reverse data colletion.   This feature combined with
> "Author:" info after some time should give us some very interesting
> statistics (Top Ten "Regressors").  It wouldn't be ideal (ie. we need some
> patches threshold to filter out people with 1 patch and >= 1 regression(s),
> we need to remember that some code areas are more difficult than the others
> and that patches are not equal per se etc.) however I believe than making it
> into Top Ten "Regressors" should give the winners some motivation to improve
> their work ethic.  Well, in the worst case we would just get some extra
> trivial/documentation patches. ;-)

We of course do want to minimise the amount of overhead for each developer. 
I'm a strong believer in specialisation: rather than requiring that *every*
developer/maintainer integrate new steps in their processes it would be
better to allow them to proceed in a close-to-usual fashion and to provide
for a specialist person (or team) to do the sorts of things which you're
thinking about.

