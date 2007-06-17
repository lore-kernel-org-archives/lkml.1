Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXFQVfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXFQVfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXFQVfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:35:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1070 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXFQVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PxxHvaxXWXeJ6nCU1oD4mFmnYUddI7eAmITK4dkCKXmMZz6RuVnz3VVokbAR9XWFrklswaaEpU8Jd+CwmVp9DuWx26yWh+UEbq+CXrfZHntDeKFDJ5UOZzYGPLJepaMLemSv2p+obISYTAar+k6ZkRNkOBMgR2nIjP2cokeL+JY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
Date: Sun, 17 Jun 2007 23:49:08 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org>
In-Reply-To: <20070617115258.1f55b29d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706172349.08813.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007, Andrew Morton wrote:
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

Will send in pm.

I don't want to reveal the "guilty" person identify in public.

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

I've been too long around to not learn a few things...

rule #3 of successful kernel developer

Ignore reviewers - fix the bugs but don't credit reviewers (crediting them
makes your patch and you look less perfect), if they are asking question
requiring you to do the work (verification of taken assumptions etc.) do not
check anything - answer in a misleading way and present the assumptions you've
taken as a truth written in the stone - eventually they will do verification
themselves.

I really shouldn't be giving these rules out (at least for free 8) so this
time only #3 but there are much more rules and they are as dead serious as
Linus' advices on Linux kernel management style...

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

Adding Reviewed-by for reviews which highlighted real issues is obvious
(with more detailed credits for noticed problems in the patch description).

Also when somebody reviewed your patch but the discussions it turned out
that the patch is valid - the review itself was still valuable so it would
be appropriate to credit the reviewer by adding Reviewed-by:.

> On my darker days I consider treating a Reviewed-by: as a prerequisite for
> merging.  I suspect that would really get the feathers flying.

Easy to workaround by a friendly mine "Reviewed-by:" for yours "Reviewed-by:"
deals (without any _proper_ review being done in reality)... ;)

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

It is not unusual et all.  I mean patches which affect code in such way
that it is difficult to prove it's (in)correctness without doing time
consuming audit.

ie. lets imagine doing a small patch affecting many drivers - you've tested
it quickly on your driver/hardware, then you skip the part of verifying
correctness of new code in other drivers and just push the patch

As a patch author you can either assume "works for me" and push the patch
or do the audit (requires good understanding of the changed code and could
be time consuming).  It is usually quite easy to find out which approach
the author has choosen - the very sparse patch description combined with
the changes in code behavior not mentioned in the patch description should
raise the red flag. :)

As a reviewer having enough knowledge in the area of code affected by patch
you can see the potential problems but you can't prove them without doing
the time consuming part.  You may try to NACK the patch if you have enough
power but you will end up being bypassed by not proving incorrectness of
the patch (not to mention that developer will feel bad about you NACKing
his patch).  Now the funny thing is that despite the fact that audit takes
more time/knowledge then making the patch you will end up with zero credit
if patch turns out to be (luckily) correct.  Even if you find out issues
and report them you are still on mercy of author for being credited so
from personal POV you are much better to wait and fix issues after they
hit mainline kernel.  You have to choose between being a good citizen and
preventing kernel regressions or being bastard and getting the credit. ;)

If you happen to be maintainer of the affected code the choice is similar
with more pros for letting the patch in especially if you can't afford the
time to do audit (and by being maintainer you are guaranteed to be heavily
time constrained).

I hope this makes people see the importance of proper review and proper
recognition of reviewers in preventing kernel regressions.

> As for high regressions/patches ratio: that'll be hard to calculate and
> tends to be dependent upon the code which is being altered rather than who
> is doing the altering: some stuff is just fragile, for various reasons.
> 
> One ratio which we might want to have a think about is the patches-sent
> versus reviews-done ratio ;)

Sounds like a good idea.

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

Makes sense... however we need to educate each and every developer about
importance of the code review and proper recognition of reviewers.

Thanks,
Bart
