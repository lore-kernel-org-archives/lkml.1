Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZFWCrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZFWCrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZFWCr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZFWCrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:47:25 -0400
Date: Mon, 22 Jun 2009 19:44:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: John Stoffel <john@stoffel.org>
cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <19008.14107.115568.19439@stoffel.org>
Message-ID: <alpine.LFD.2.01.0906221932130.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de> <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> <19007.60396.259650.682653@stoffel.org> <alpine.LFD.2.01.0906221349220.3240@localhost.localdomain> <19008.14107.115568.19439@stoffel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, John Stoffel wrote:
> 
> Linus> Then, just edit the files, and use "git diff". That, along with
> Linus> "git pull" would be the _only_ command you'd ever use - and you
> Linus> now have a nice anoncvs-like environment to get used to git
> Linus> with, without having to actually know a whole lot.
> 
> So say I want to manage multiple branches, since I want to test some
> patches out, or various kernel revisions, or even git bisection?  
> 
> Or should I just use a completely seperate tree for a bisection run? 

Oh, it really does sound like you want to do the whole "multiple branches" 
thing, and want to do way more with git than just use it as an anoncvs 
replacement.

So your workflow is fine.

My clarification was really meant for the case where people were perhaps 
more used to the CVS kind of model (and SVN is very much the same one). 
I bet there's lots of people who are used to anoncvs and carrying their 
patches (uncommitted) in their trees, and then doing "cvs update".

So I tried to just outline the git version of that. 

It's a much weaker model, and not at all as capable, but it _is_ simpler.

> Linus> 	git stash		# save your changes
> Linus> 	git pull		# do the update
> Linus> 	git stash apply		# re-apply your changes
> 
> Ohh!  This is a new one to me.  Gotta remember this one, that's huge!
> Maybe what I've written should be updated to use this method instead?  

Your multiple branch approach is much better since you do commits etc. A 
commit is a long-term stash, and you can (obviously) queue them on top of 
each other. 

With "git stash", you can have multiple different stashed things too, but 
they don't queue up on each other - they are just random independent 
patches that you've stashed away because they were inconvenient at some 
point.

So the real "branches + commits" model is what a real git user does, and 
your description wasn't bad at all. It was just perhaps more of a stretch 
than some people who are used to CVS would necessarily want to begin with.

> Heh, from all I've seen with your rants, git pull --rebase isn't what
> I want to do if I can help it.  :]  Even though I'll probably never
> publish a branch, just small patches occasionally at times. 

There's nothing wrong with "git pull --rebase" if you're a "leaf 
developer", ie you don't publish your git tree, and you don't integrate 
work from other peoples git trees.

Doing "git pull --rebase" (or "git fetch" + "git rebase origin", which is 
the same thing) is very convenient for people who do commit their changes 
with git, and aren't ready to publish them. 

I actually do it all the time myself - in my own private git source tree. 
I send git patches to Junio by email, and I don't publish my own git tree 
any more, since Junio is the real maintainer, and has been doing such a 
stellar job.

So when it comes to git, I occasionally have some git work going on 
myself, and I tend to maintain those as commits in my private tree that I 
then update with "git pull --rebase". It's an excellent _private_ 
workflow, because it means that I can trivially keep my own work 
up-to-date, and if part of it is something that I sent to Junio for 
merging, if/when he merges it, when I do "git pull --rebase" my own 
private commit automatically goes away since it's no longer needed, and 
got merged.

So it's true that I rant against people doing rebase, but I rant against 
maintainers who either rebase other peoples commits (it's happily getting 
fairly rare), or who keep a private tree that they rebase all the time, 
and then they publish what is obviously _totally_ untested crap, because I 
can tell that they rebased within the last few hours, and thus the weeks 
or months of work that they then publish has been essentially made public 
with zero testing.

So rebase has huge downsides, but for private git patch queues it's 
wonderful. There's a reason 'git rebase' is very much part of the core git 
distribution, it's not some kind of second-class citizen.

			Linus
