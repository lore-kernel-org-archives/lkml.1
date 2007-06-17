Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbXFQSjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbXFQSjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbXFQSjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:39:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53541 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXFQSi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QlKAl37dqNFa17SfYbw0etoX3ZRFnk8t8/bV2CumnFOMZB7JlSm8GBVExuT3Ir29VOs+BtsmXJav429x6IZ1g82rx69FnKMV/1wtYK4VpngvwoNhDkoZHSTdrhO68RgBUq78DL/b4rZE601BdH4Fez70Yw8ZBzCDLG6Pr3mTkNQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: How to improve the quality of the kernel?
Date: Sun, 17 Jun 2007 20:53:41 +0200
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com> <20070617142950.GW3588@stusta.de>
In-Reply-To: <20070617142950.GW3588@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706172053.41806.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 17 June 2007, Adrian Bunk wrote:
> On Sun, Jun 17, 2007 at 03:17:58PM +0200, Michal Piotrowski wrote:
> > On 17/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> >...
> >> Fine with me, but:
> >>
> >> There are not so simple cases like big infrastructure patches with
> >> 20 other patches in the tree depending on it causing a regression, or
> >> even worse, a big infrastructure patch exposing a latent old bug in some
> >> completely different area of the kernel.
> >
> > It is different case.
> >
> > "If the patch introduces a new regression"
> >
> > introduces != exposes an old bug
> 
> My remark was meant as a note "this sentence can't handle all 
> regressions" (and for a user it doesn't matter whether a new 
> regression is introduced or an old regression exposed).
> 
> It could be we simply agree on this one.  ;-)
> 
> > Removal of 20 patches will be painful, but sometimes you need to
> > "choose minor evil to prevent a greater one" [1].
> > 
> >> And we should be aware that reverting is only a workaround for the real
> >> problem which lies in our bug handling.
> >...
> 
> And this is something I want to emphasize again.
> 
> How can we make any progress with the real problem and not only the 
> symptoms?
> 
> There's now much money in the Linux market, and the kernel quality 
> problems might result in real costs in the support of companies like
> IBM, SGI, Redhat or Novell (plus it harms the Linux image which might 
> result in lower revenues).
> 
> If [1] this is true, it might even pay pay off for them to each assign 
> X man hours per month of experienced kernel developers to upstream 
> kernel bug handling?
> 
> This is just a wild thought and it might be nonsense - better 
> suggestions for solving our quality problems would be highly welcome...

IMO we should concentrate more on preventing regressions than on fixing them.
In the long-term preventing bugs is cheaper than fixing them afterwards.

First let me tell you all a little story...

Over two years ago I've reviewed some _cleanup_ patch and noticed three bugs
in it (in other words I potentially prevented three regressions).  I also
asked for more thorough verification of the patch as I suspected that it may
have more problems.  The author fixed the issues and replied that he hasn't
done the full verification yet but he doesn't suspect any problems...

Fast forward...

Year later I discover that the final version of the patch hit the mainline.
I don't remember ever seeing the final version in my mailbox (there are no
cc: lines in the patch description) and I saw that I'm not credited in the
patch description.  However the worse part is that it seems that the full
verification has never been done.  The result?   Regression in the release
kernel (exactly the issue that I was worried about) which required three
patches and over a month to be fixed completely.  It seems that a year
was not enough to get this ~70k _cleanup_ patch fully verified and tested
(it hit -mm soon before being merged)...

>From reviewer's POV: I have invested my time into review, discovered real
issues and as a reward I got no credit et all and extra frustration from the
fact that part of my review was forgotten/ignored (the part which resulted in
real regression in the release kernel)...  Oh and in the past the said
developer has already been asked (politely in private message) to pay more
attention to his changes (after I silently fixed some other regression caused
by his other patch).

But wait there is more, I happend to be the maintainer of the subsystem which
got directly hit by the issue and I was getting bugreports from the users about
the problem...  :-)

It wasn't my first/last bad experience as a reviewer... finally I just gave up
on reviewing other people patches unless they are stricly for IDE subsystem.

The moral of the story is that currently it just doesn't pay off to do
code reviews.  From personal POV it pays much more to wait until buggy patch
hits the mainline and then fix the issues yourself (at least you will get
some credit).  To change this we should put more ephasize on the importance
of code reviews by "rewarding" people investing their time into reviews
and "rewarding" developers/maintainers taking reviews seriously.

We should credit reviewers more, sometimes it takes more time/knowledge to
review the patch than to make it so getting near to zero credit for review
doesn't sound too attractive.  Hmm, wait it can be worse - your review
may be ignored... ;-)

>From my side I think I'll start adding less formal "Reviewed-by" to IDE
patches even if the review resulted in no issues being found (in additon to
explicit "Acked-by" tags and crediting people for finding real issues - which
I currently always do as a way for showing my appreciation for their work).

I also encourage other maintainers/developers to pay more attention to
adding "Acked-by"/"Reviewed-by" tags and crediting reviewers.  I hope
that maintainers will promote changes that have been reviewed by others
by giving them priority over other ones (if the changes are on more-or-less
the same importance level of course, you get the idea).

Now what to do with people who ignore reviews and/or have rather high
regressions/patches ratio?

I think that we should have info about regressions integrated into SCM,
i.e. in git we should have optional "fixes-commit" tag and we should be
able to do some reverse data colletion.   This feature combined with
"Author:" info after some time should give us some very interesting
statistics (Top Ten "Regressors").  It wouldn't be ideal (ie. we need some
patches threshold to filter out people with 1 patch and >= 1 regression(s),
we need to remember that some code areas are more difficult than the others
and that patches are not equal per se etc.) however I believe than making it
into Top Ten "Regressors" should give the winners some motivation to improve
their work ethic.  Well, in the worst case we would just get some extra
trivial/documentation patches. ;-)

Sorry for a bit chaotic mail but I hope that message is clear.

Thanks,
Bart
