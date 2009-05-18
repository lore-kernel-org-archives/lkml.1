Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZERXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZERXjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZERXjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:39:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44512
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZERXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:39:44 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Florian Mickler <florian@mickler.org>
Subject: Re: http://www.kernel.org/doc/local/git-quick.html#bisect
Date: Mon, 18 May 2009 18:39:40 -0500
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090515121829.60de2210@schatten> <200905180254.20748.rob@landley.net> <20090518214022.632d5d20@schatten>
In-Reply-To: <20090518214022.632d5d20@schatten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181839.41184.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 14:40:22 Florian Mickler wrote:
> On Mon, 18 May 2009 02:54:20 -0500
>
> Rob Landley <rob@landley.net> wrote:
> > You've managed that, yes.
>
> good. please, i'm a friendly guy.. at least i think so. i'm
> terribly sorry if i upset you.
>
> > > ("B" being the bug-introducing changeset, "1" the first tested
> > > commit, "2" the 2nd tested commit, "-" some other commit and "+"
> > > some merge or branchpoint. )
> > >
> > > you guess wrong at 1 (this means you classify 1 good.)
> > > second commit is 2 which is good, as there the bug B was never
> > > introduced. so you get 2 as good. which is not the opposite of your
> > > guess.
> >
> > If you converge all the way to a single changeset and it doesn't
> > reproduce the bug, you guessed wrong and have to back up.  As
> > described.
>
> but in this case the changeset (mergecommit) has the bug, as the
> mergecommit is on-top of 1 which is on top of B.
>
> reverting it is probably non-trivial. replaying with all the
> guesses reverted needs 2^[nr-of-guesses] compiles. which is not
> feasible if there are many buildbreakages.

Reverting in what sense?  "git replay" is an O(1) operation that returns you 
to a previous state, which you've presumably already tested.  Why would you 
recompile a previously tested state?

If you mean "coming up with a patch to fix the intermediate step enough you 
can test it", that has nothing to do with git.  Reverting cherry-picked 
patches is sometimes a way to do that, but usually other patches apply on top 
of that so the revert won't apply to the middle of the broken range.  Another 
way to fix it is finding a later patch that fixed whatever it was (sometimes 
the first version that compiles after the "broken" range does that), and 
sometimes you have to fix it up by hand.

Mostly, you have to read the code, figure out what broke, and fix it.  Or you 
hope very much that it's _not_ in the broken range and continue to bisect 
until you've proved it is.  (And yes, confirming that means changing what 
you're testing for halfway through a bisect, and thus changing what 
you're "good" and "bad" answers mean, and _that_ means understanding what 
you're _doing_, no matter which tools you're using to do it.)

> > Apparently, you don't understand the method I described.  Obviously,
> > my description of this method was crap.
>
> well, maybe i didn't tried hard enough to understand it?

If my description required more effort to understand than you put into this 
conversation telling me how I should throw it out and replace it, then the 
description was crap.

> what i meant: if you bisect through the kernel (2^17 commits from 2.6.27
> to 2.6.30-rc5) your chance is large that any nonbuilding-patch-range is
> small and cut-off  from your bug-introducing commit.

The first bug I tried to bisect in the kernel was introduced somewhere in a 
range of about 3000 commits that didn't compile.  (I tend to test non-x86 
architectures.  Some non-x86 boards only get regression tested once or twice 
a year.)

> but you are working overtime with this method! perhaps it's ok, if you
> don't have to do too many guesses and i never tried your method

Are you saying you never tried it, but felt the need to complain about it?

> . but if 
> i tried to explain git bisect the way i _think_ it is right and
> understandable , and you are satisfied with it, would you consider
> putting it back up?

No, but you're welcome to write your own document explaining git bisect the 
way you think is "right and understandable", and post it anywhere you like.

I'm done arguing with you.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
