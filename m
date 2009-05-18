Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZERHyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZERHyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZERHy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:54:27 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54801
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbZERHyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:54:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Florian Mickler <florian@mickler.org>
Subject: Re: http://www.kernel.org/doc/local/git-quick.html#bisect
Date: Mon, 18 May 2009 02:54:20 -0500
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090515121829.60de2210@schatten> <200905151820.05246.rob@landley.net> <20090517231135.3c740ab2@schatten>
In-Reply-To: <20090517231135.3c740ab2@schatten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905180254.20748.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 16:11:35 Florian Mickler wrote:
> Hi!
>
> Sorry. It seems we started off on the wrong foot.
>
> I know that one never ends learning and I am glad you took the
> time to write this stuff down because it helps.
> So let this be clear between us, i'm not trying to offend you and the
> criticism is only about git-quick.html as it is found by google.
>
> I choose the 'the sky is falling' attitude to 'shout into the
> woods' and provoke at least some response. (not knowing where or who
> the maintainer was... )

You've managed that, yes.

> > > Instead you should use
> > > git bisect skip or
> > > git bisect visualize and choose another commit to test.
> >
> > I believe that both of those options were implemented _after_ I wrote
> > the above document.  (People keep telling me that the user interface
> > of git can't be said to "suck" because it keeps changing.)
>
> yes. so my email is all the more relevant, or not?

hg log -v git-quick.html says:

  changeset:   101:ae115ea731f2
  user:        Rob Landley <rob@landley.net>
  date:        Tue Aug 19 20:59:33 2008 -0500
  files:       local/git-quick.html
  description:
  Rafal Milecki brought the "git bisect skip" command to my attention.

I.E. I added a note about git bisect skip just under a year ago.  (Yes, I 
maintained revisions of that document in a mercurial archive.  No, it wasn't 
the only thing in the archive.)

> ("B" being the bug-introducing changeset, "1" the first tested commit,
> "2" the 2nd tested commit, "-" some other commit and "+" some merge or
> branchpoint. )
>
> you guess wrong at 1 (this means you classify 1 good.)
> second commit is 2 which is good, as there the bug B was never
> introduced. so you get 2 as good. which is not the opposite of your
> guess.

If you converge all the way to a single changeset and it doesn't reproduce the 
bug, you guessed wrong and have to back up.  As described.

No mechanism can automatically find a bug that was introduced in a group of 
revisions that doesn't build for you, or cannot otherwise get far enough to 
reproduce the bug.  (For that you have to patch the source to get it to work 
will enough you can test for that specific bug.)

> > The ability to do that sort of thing would presumably be why they
> > implemented the replay option in the first place.
>
> well,  i would say they introduced it so one can doublecheck the tests
> if one realizes that maybe unplugging the speakers is overshadowing the
> bug "speakers don't work in rc5, but in rc1 they worked". or smth like
> that. but this is irrelevant.

So the fact they introduced that feature before "skip" was implemented doesn't 
enter into this somehow?

> > > (and that really sucks, because all your compiliations after that
> > > one are _worthless_ ).
> >
> > No, they demonstrate that the bug isn't in that fork, at which point
> > you back up and check the other fork.
>
> no... you never know because you
> have no way of knowing if the bisection succeeded or not.

You can always either find the first commit that reproduced the bug, or 
confirm that the bug was introduced in a versions that doesn't build for you.  
The automation doesn't have any more information to work with than the manual 
method does; it can't do more than that either.

Apparently, you don't understand the method I described.  Obviously, my 
description of this method was crap.

> > > But if you defer the decision for that commit (via git-skip) you at
> > > least get a range of commits including the bad
> > > commit, or if the commit immidiatly before the bad commit is
> > > buildable, you even get the right bad commit.
> > >
> > > i'm quoting the text that neeeds to be _removed_:
> >
> > I'm going to give you the benefit of the doubt and assume that
> > "neeeds" isn't a typo rather than a "badwrong" _word_ indicating how
> > _falling_ the -=>*[(SKY)]*<=- is today.
>
> if you use git-bisect skip there is the (large) chance that your
> skipped commit is based ontop of a test-able commit which already
> has the bug 

If it's testable, why are you skipping it?

Why would the chance be larger for it to have the bug than to not have the 
bug?  (And if you think it has the bug, guess that it's bad then.)

> > Last time somebody poked me about this I added this bit:
> >
> >   Note: you can also tell git itself to skip a commit you can't test
> > with git bisect skip.  Unfortunately, the git-bisect man page gives
> > this warning about the "skip" command:
> >
> >     But computing the commit to test may be slower afterwards and git
> > may eventually not be able to tell the first bad among a bad and one
> > or more "skip"ped commits.
>
> this is nonsense (the ''being slower part'').

Why are you telling _me_ about your dissatisfaction with a quote from the 
git-bisect man page?

> > But you have yet to convince me anything's actually wrong...
>
> of course! i never expect someone to do smth without being convinced.
> some do, but thats a sign of not caring, being intimidated or being
> stupid.

In this case it would be "not caring", at least not enough to argue with you 
about this.

You're insisting that the mention of "git-bisect skip" I added a year ago 
wasn't sufficient, and what's there is potentially misleading and harmful to 
minors and so on, and thus it is vitally important that several screens worth 
of material be removed.  (Despite the technique working for me just fine.)

*shrug*  I never claimed to be a git expert.  I leave that to you.

I've removed the potentially misleading document from kernel.org.  There are 
plenty of other git tutorials, written by people who know/care far more about 
git than I do, and I have no intention of distracting you from them.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
