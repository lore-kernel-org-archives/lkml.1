Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbYERAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbYERAgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 20:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYERAge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 20:36:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbYERAgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 20:36:33 -0400
Date: Sat, 17 May 2008 17:35:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>  <20080517015705.GA20375@mit.edu>  <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
 <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 May 2008, Jesper Juhl wrote:
> 
> What I did for my first merge-window was simply clone your tree,
> create a for-linus branch, add all the patches to that branch and ask
> you to pull. That worked nicely that once, but I guess that wiping the
> tree and starting from a fresh clone every merge window wouldn't be a
> good idea - especially since I'd like Trivial to also get pulled into
> linux-next.

Well, I actually suspect that especially for the trivial tree, that may 
not actually be a horribly bad workflow. 

The whole "fresh clone + a bunch of patches" is yet another different way 
of using git, but it's a totally valid one: it uses git as just another 
way to send a patch-series, with the added advantage that the base of that 
patch-series is explicit in the result.

(You can do that with quilt too, I think. Or at least with the scripts 
Andrew does - I think you can tell him what the base point for a series 
is. But when merging to me, git is obviously the way to go).

So for something that pretty fundamentally is literally just a series of 
random patches, I don't think the workflow of just staging them as a 
series on top of some known-good git tree is the wrong one. It's not like 
the Trivial tree is likely to be something that would have much use of git 
as a distributed model (iow - I think the trivial patches are actually 
better off seen as a patch-queue than having merges and other things in 
it).

That said, re-cloning every time is obviously pretty wasteful. There are 
better ways to track a git tree, notably it's likely best to just clone 
once and then just keep that one up-to-date. But the difference between 
that and just re-cloning is really not that huge - technically you'd end 
up doing the exact same thing and have the exact same tree, just two 
different ways to do it.

So your alternate approach:

> Start off with a clone of your tree (master branch).
> 
> Pull your tree into 'master' daily (or at least often).

So doing daily pull's is what I generally do *not* want people to do, but 
if you have a pristine tree and haven't done any development of your own, 
then the "pull" is obviously not going to do anything but keep the tree 
fresh, so in this special case it's fine.

So you'd not be merging, you'd be just refreshing your clone - and in that 
sense this is 100% equivalent to just re-cloning all the time.

> Create a for-linux-2.6.27 branch or the upcomming 2.6.27 merge window
> and apply all the patches I currently have pendng in a mailbox to that
> branch. Keep the branch reasonably up-to-date by doing a weekly git
> fetch + merge from my 'master' branch that tracks your tree.

So generally, I'd suggest against this "keep it fresh". In many ways it 
just makes things harder (if only because bisection of your series will no 
longer be a nice linear run, but also because the history will actually be 
harder to read), and if the merges are just weekly regular merges, then 
the purpose of them isn't even very clear.

So I'd literally suggest doing merges primarily only

 - at release points (now the purpose is clear; you're merging a very 
   specific state, not just some random point).

   But even this one should generally be done only if there is some real 
   reason for it (ie you're really quite far behind), and 

 - or if you actually see a merge conflict, and you want to handle the 
   conflict so that I won't have to.

   But I'll actually happily handle trivial merges too, so this is by no 
   means even a requirement - if the merge ends up being non-trivial, I'll 
   let people know anyway and either say "ok, that's so complicated, and I 
   don't know the area well enough, so can you please do it for me", or 
   say "ok, I merged it, but can you please double-check the result".

Quite frankly, if you actually do your patch-series pretty late in the -rc 
series (say, you decide to apply things at -rc6 or so), I suspect you'll 
never have any real reason to do a "git pull" at all, although it's also 
certainly not wrong to do test branches to check that everything is ok, 
for example.

> Once the 2.6.27 merge window opens, ask you to pull the
> 'for-linux-2.6.27' branch and once you have done so, leave that branch
> alone forever.
>
> Branch off a new 'for-linux-2.6.28' branch and repeat.

Yes. That's a good model.

			Linus
