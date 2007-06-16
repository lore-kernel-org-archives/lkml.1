Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbXFPF2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbXFPF2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 01:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXFPF2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 01:28:14 -0400
Received: from iabervon.org ([66.92.72.58]:3849 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXFPF2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 01:28:14 -0400
Date: Sat, 16 Jun 2007 01:28:13 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Carlo Wood <carlo@alinoe.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
In-Reply-To: <20070616040747.GA21076@alinoe.com>
Message-ID: <Pine.LNX.4.64.0706160059210.4740@iabervon.org>
References: <20070616001255.GA11403@alinoe.com> <Pine.LNX.4.64.0706152026320.4740@iabervon.org>
 <20070616040747.GA21076@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Carlo Wood wrote:

> I don't understand - any branch that I am on has many tags. I can use
> 'git reset --hard sometag' to change the source tree to that tag (which
> works if I look at the version in the Makefile and pick tags that are
> far apart enough).

That's not actually the right image. There's a graph of commits with a lot 
of splitting and joining lines. Each branch and each tag sits something in 
this web. The difference between branches and tags is that you're expected 
to move branch pointers around, and tags stay mostly in place. There's no 
accounting of commits newer than the current spot in the web for a branch 
belonging to that branch, so if you move a branch back to an older tag (or 
other commit), the spot it's leaving is no longer "on the branch".

So master is a point in the web, and bisect jumps around through the web 
according to some special rules (due to having git-bisect use the good/bad 
marks do determine which commit to try next, and jump there). git-bisect 
doesn't really even care that you started on any single branch. It's just 
operating on the web, and the branch you start on is treated as an 
arbitrary commit that has the problem.

You may find "gitk --all" informative.

> Anyway, I tried this:
> 
> $ git checkout master
> $ git branch
>   bisect
> * master
>   origin
> $ BRANCH=$(git branch | grep "^\*" | sed -e "s/\* //")
> $ echo $BRANCH
> master
> $ git rev-list --max-count=1 $BRANCH
> 5ecd3100e695228ac5e0ce0e325e252c0f11806f
> 
> Is it correct that this last command gives me the 'git id' (if that
> is the correct name for the hash) of the revision that my local
> working copy is at?

Yes.

> Can you tell me what is the latest git id that you see?

I'm seeing de7f928ca460005086a8296be07c217aac4b625d, but I just got the 
latest code, more recently than you probably did.

> Because, if I compile 5ecd3100e695228ac5e0ce0e325e252c0f11806f is
> still hangs at boot :(

It looks like you moved master back to 2.6.22-rc4 (with git reset --hard 
v2.6.22-rc4) at some point.

What you should do now is:

$ git checkout master
$ git merge origin

Which should move master forward through the web to "origin", which is 
(unless you've moved it) what you got from upsteam.

Alternatively:

$ git checkout master
$ git pull

Should fetch the latest stuff and advance master to the fetched version.

	-Daniel
*This .sig left intentionally blank*
