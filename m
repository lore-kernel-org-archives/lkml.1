Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYERWKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYERWKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYERWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:09:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57364 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYERWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T3GyvLrPRe9v2Wqjr/Q4A2RAio3nSo0wYb9GmRuC+sJ/DjP4tfZzuXQ4ATM4JgT+h/mw26HC4vyli0M1U3ELm+puO1UYUA1GNTgb9LeE2gDCesN1YyOh9MxgKNbV1qR5jMp+u1MludLZ31hX1N5RWbBzG+4mn0aS9HrekTqwfNM=
Message-ID: <9a8748490805181509r751cd152l3c9a765806da195d@mail.gmail.com>
Date: Mon, 19 May 2008 00:09:49 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Cc: "Theodore Tso" <tytso@mit.edu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
	 <20080517015705.GA20375@mit.edu>
	 <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
	 <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
	 <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/18 Linus Torvalds <torvalds@linux-foundation.org>:
>

Hi Linus,

Thank you for responding. A few more small questions below.

>
> On Sun, 18 May 2008, Jesper Juhl wrote:
>>
>> What I did for my first merge-window was simply clone your tree,
>> create a for-linus branch, add all the patches to that branch and ask
>> you to pull. That worked nicely that once, but I guess that wiping the
>> tree and starting from a fresh clone every merge window wouldn't be a
>> good idea - especially since I'd like Trivial to also get pulled into
>> linux-next.
>
> Well, I actually suspect that especially for the trivial tree, that may
> not actually be a horribly bad workflow.
>
> The whole "fresh clone + a bunch of patches" is yet another different way
> of using git, but it's a totally valid one: it uses git as just another
> way to send a patch-series, with the added advantage that the base of that
> patch-series is explicit in the result.
>
> (You can do that with quilt too, I think. Or at least with the scripts
> Andrew does - I think you can tell him what the base point for a series
> is. But when merging to me, git is obviously the way to go).
>
Yeah, I figured that trying to get a good git workflow up and running
would probably be the best in the long run.


> So for something that pretty fundamentally is literally just a series of
> random patches, I don't think the workflow of just staging them as a
> series on top of some known-good git tree is the wrong one. It's not like
> the Trivial tree is likely to be something that would have much use of git
> as a distributed model (iow - I think the trivial patches are actually
> better off seen as a patch-queue than having merges and other things in
> it).
>
Right. By definition it is just a bunch of random patches queued up in
that tree so they don't get lost and so that lots of individual people
don't have to keep re-sending them.

> That said, re-cloning every time is obviously pretty wasteful. There are
> better ways to track a git tree, notably it's likely best to just clone
> once and then just keep that one up-to-date. But the difference between
> that and just re-cloning is really not that huge - technically you'd end
> up doing the exact same thing and have the exact same tree, just two
> different ways to do it.
>
> So your alternate approach:
>
>> Start off with a clone of your tree (master branch).
>>
>> Pull your tree into 'master' daily (or at least often).
>
> So doing daily pull's is what I generally do *not* want people to do, but
> if you have a pristine tree and haven't done any development of your own,
> then the "pull" is obviously not going to do anything but keep the tree
> fresh, so in this special case it's fine.
>
Good.

> So you'd not be merging, you'd be just refreshing your clone - and in that
> sense this is 100% equivalent to just re-cloning all the time.
>
>> Create a for-linux-2.6.27 branch or the upcomming 2.6.27 merge window
>> and apply all the patches I currently have pendng in a mailbox to that
>> branch. Keep the branch reasonably up-to-date by doing a weekly git
>> fetch + merge from my 'master' branch that tracks your tree.
>
> So generally, I'd suggest against this "keep it fresh". In many ways it
> just makes things harder (if only because bisection of your series will no
> longer be a nice linear run, but also because the history will actually be
> harder to read), and if the merges are just weekly regular merges, then
> the purpose of them isn't even very clear.
>
> So I'd literally suggest doing merges primarily only
>
>  - at release points (now the purpose is clear; you're merging a very
>   specific state, not just some random point).
>
<snip>

Ok, so let's say I start off my upcomming trivial branch at -rc1 and
start applying patches to it, then doing a merge with my master branch
that tracks your tree at points like, say, -rc5, -rc9 etc would be
fine, but really only needed if there are conflicts (which I can test
for in a temporary experimental branch) - got it.

>> Once the 2.6.27 merge window opens, ask you to pull the
>> 'for-linux-2.6.27' branch and once you have done so, leave that branch
>> alone forever.
>>
>> Branch off a new 'for-linux-2.6.28' branch and repeat.
>
> Yes. That's a good model.
>

Ok, thanks a lot.  Now, I have one final question for you.
In order to be able to play around with the patches, see if they
apply, fix them up, test for merge conflicts etc etc, I obviously need
a tree with content, not just a bare tree. But I see on
master.kernel.org that all the published trees are bare trees.

So, I assume I create a tree in my homedir like so;
  $ git clone -l -s /pub/scm/linux/kernel/git/torvalds/linux-2.6.git
/home/juhl/trivial-work-tree
create all the branches and do all the work in that one,

I would have assumed that to then publish my work and create a
publicly accessile version I'd do;
  $ git clone --bare -l -s /home/juhl/trivial-work-tree
/pub/scm/linux/kernel/git/juhl/trivial.git

But that only seems to make my master branch accessible, not new
branches I create in my work tree.  How do I go about doing this
properly?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
