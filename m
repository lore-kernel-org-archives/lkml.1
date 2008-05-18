Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYERW1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYERW1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYERW1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:27:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbYERW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:27:15 -0400
Date: Sun, 18 May 2008 15:26:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <9a8748490805181509r751cd152l3c9a765806da195d@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805181513590.32253@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>  <20080517015705.GA20375@mit.edu>  <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org> 
 <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>  <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org> <9a8748490805181509r751cd152l3c9a765806da195d@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Jesper Juhl wrote:
> 
> Ok, thanks a lot.  Now, I have one final question for you.
> In order to be able to play around with the patches, see if they
> apply, fix them up, test for merge conflicts etc etc, I obviously need
> a tree with content, not just a bare tree. But I see on
> master.kernel.org that all the published trees are bare trees.

I think just about *everybody* does their own development on their own 
machine. I know I do, and I'm pretty certain that everybody else does too. 
Then we just upload the end result to master.kernel.org into a bare 
repository that is only used for exporting to others, never for anything 
else.

> So, I assume I create a tree in my homedir like so;
>   $ git clone -l -s /pub/scm/linux/kernel/git/torvalds/linux-2.6.git /home/juhl/trivial-work-tree
> create all the branches and do all the work in that one,

You can do that, and actually work on master.kernel.org, but do you really 
want to?

It's much easier to work at home (or office, whatever - on your own 
workstation), unless you have some really weak computer.

Then, the easiest way to publish the result is to just create a bare 
repository on master.kernel.org, and push to it. And just make sure that 
you pre-populate that bare repo with my tree, so that when you push from 
your home machine, it only pushes the (smallish) actual changes!

So the workflow I'd suggest is:

 - do all the work on your own hardware

 - create the initial (bare) kernel.org tree with

	cd /pub/scm/linux/kernel/git/juhl
	git clone --bare -l -s ../torvalds/linux-2.6 trivial-2.6

 - then just push to that tree from your own machine

and voila, you're all done.

> But that only seems to make my master branch accessible, not new
> branches I create in my work tree.  How do I go about doing this
> properly?

If you do the "clone locally, then push from the remote", the "push" stage 
is when you decide which branches you'll want to push.

The easiest thing to do is to just use "--all", which will push all the 
branches to the remote (you may want to use "--force" if this ends up 
being a non-fast-forward, which can happen - for example - just because 
your "clone" might have cloned a later version of my tree than the one you 
based your own 'master' branch off).

But you can push individual branches too, see 'man git-push'.

If you really *want* to work on master.kernel.org, you can do so, and you 
can do the final clone with "git clone --mirror --bare" and use that as a 
way to clone all branches as a mirror of your work-tree, but it really is 
a fairly unusual way to work.

		Linus
