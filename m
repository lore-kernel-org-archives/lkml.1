Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbXFQTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbXFQTQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbXFQTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:11:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34252 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761487AbXFQTLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:11:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
Date: Sun, 17 Jun 2007 21:18:17 +0200
User-Agent: KMail/1.9.5
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org>
In-Reply-To: <20070617115258.1f55b29d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706172118.19214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 June 2007 20:52, Andrew Morton wrote:
> On Sun, 17 Jun 2007 20:53:41 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > 
> > 
> > IMO we should concentrate more on preventing regressions than on fixing them.
> > In the long-term preventing bugs is cheaper than fixing them afterwards.
> > 
> > First let me tell you all a little story...
> > 
> > Over two years ago I've reviewed some _cleanup_ patch and noticed three bugs
> > in it (in other words I potentially prevented three regressions).  I also
> > asked for more thorough verification of the patch as I suspected that it may
> > have more problems.  The author fixed the issues and replied that he hasn't
> > done the full verification yet but he doesn't suspect any problems...
> > 
> > Fast forward...
> > 
> > Year later I discover that the final version of the patch hit the mainline.
> > I don't remember ever seeing the final version in my mailbox (there are no
> > cc: lines in the patch description) and I saw that I'm not credited in the
> > patch description.  However the worse part is that it seems that the full
> > verification has never been done.  The result?   Regression in the release
> > kernel (exactly the issue that I was worried about) which required three
> > patches and over a month to be fixed completely.  It seems that a year
> > was not enough to get this ~70k _cleanup_ patch fully verified and tested
> > (it hit -mm soon before being merged)...
> 
> crap.  Commit ID, please ;)
> 
> > >From reviewer's POV: I have invested my time into review, discovered real
> > issues and as a reward I got no credit et all and extra frustration from the
> > fact that part of my review was forgotten/ignored (the part which resulted in
> > real regression in the release kernel)...  Oh and in the past the said
> > developer has already been asked (politely in private message) to pay more
> > attention to his changes (after I silently fixed some other regression caused
> > by his other patch).
> > 
> > But wait there is more, I happend to be the maintainer of the subsystem which
> > got directly hit by the issue and I was getting bugreports from the users about
> > the problem...  :-)
> > 
> > It wasn't my first/last bad experience as a reviewer... finally I just gave up
> > on reviewing other people patches unless they are stricly for IDE subsystem.
> > 
> > The moral of the story is that currently it just doesn't pay off to do
> > code reviews.
> 
> I dunno.  I suspect (hope) that this was an exceptional case, hence one
> should not draw general conclusions from it.  It certainly sounds very bad.
> 
> >  From personal POV it pays much more to wait until buggy patch
> > hits the mainline and then fix the issues yourself (at least you will get
> > some credit).  To change this we should put more ephasize on the importance
> > of code reviews by "rewarding" people investing their time into reviews
> > and "rewarding" developers/maintainers taking reviews seriously.
> > 
> > We should credit reviewers more, sometimes it takes more time/knowledge to
> > review the patch than to make it so getting near to zero credit for review
> > doesn't sound too attractive.  Hmm, wait it can be worse - your review
> > may be ignored... ;-)
> > 
> > >From my side I think I'll start adding less formal "Reviewed-by" to IDE
> > patches even if the review resulted in no issues being found (in additon to
> > explicit "Acked-by" tags and crediting people for finding real issues - which
> > I currently always do as a way for showing my appreciation for their work).
> 
> yup, Reviewed-by: is good and I do think we should start adopting it,
> although I haven't thought through exactly how.
> 
> On my darker days I consider treating a Reviewed-by: as a prerequisite for
> merging.  I suspect that would really get the feathers flying.

How about the following "algorithm":

* Step 1: Send a patch as an RFC to the relevant lists/people and only if there
  are no negative comments within at least n days, you are allowed to proceed
  to the next step.  If anyone has reviewed/acked the patch, add their names
  and email addresses as "Reviewed-by"/"Acked-by" to the patch in the next
  step.
* Step 2: Send the patch as an RC to the relevant lists/people _and_ LKML and
  if there are no negative comments within at least n days, you can proceed to
  the next step.  If anyone has reviewed/acked the patch, add their names
  and email addresses as "Reviewed-by"/"Acked-by" to the patch in the next
  step.
* Step 3: Submit the patch for merging to the right maintainer (keeping the
  previous CC list).

where n is a number that needs to be determined (I think that n could be 3).
Well, "negative comments" should also be defined more precisely. ;-)

> > I also encourage other maintainers/developers to pay more attention to
> > adding "Acked-by"/"Reviewed-by" tags and crediting reviewers.  I hope
> > that maintainers will promote changes that have been reviewed by others
> > by giving them priority over other ones (if the changes are on more-or-less
> > the same importance level of course, you get the idea).
> > 
> > Now what to do with people who ignore reviews and/or have rather high
> > regressions/patches ratio?
> 
> Ignoring a review would be a wildly wrong thing to do.  It's so unusual
> that I'd be suspecting a lost email or an i-sent-the-wrong-patch.
> 
> As for high regressions/patches ratio: that'll be hard to calculate and
> tends to be dependent upon the code which is being altered rather than who
> is doing the altering: some stuff is just fragile, for various reasons.
> 
> One ratio which we might want to have a think about is the patches-sent
> versus reviews-done ratio ;)
> 
> > I think that we should have info about regressions integrated into SCM,
> > i.e. in git we should have optional "fixes-commit" tag and we should be
> > able to do some reverse data colletion.   This feature combined with
> > "Author:" info after some time should give us some very interesting
> > statistics (Top Ten "Regressors").  It wouldn't be ideal (ie. we need some
> > patches threshold to filter out people with 1 patch and >= 1 regression(s),
> > we need to remember that some code areas are more difficult than the others
> > and that patches are not equal per se etc.) however I believe than making it
> > into Top Ten "Regressors" should give the winners some motivation to improve
> > their work ethic.  Well, in the worst case we would just get some extra
> > trivial/documentation patches. ;-)
> 
> We of course do want to minimise the amount of overhead for each developer. 
> I'm a strong believer in specialisation: rather than requiring that *every*
> developer/maintainer integrate new steps in their processes it would be
> better to allow them to proceed in a close-to-usual fashion and to provide
> for a specialist person (or team) to do the sorts of things which you're
> thinking about.

Still, even very experienced developers make trivial mistakes, so there should
be a way to catch such things before they hit -rc or even -mm kernels

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
