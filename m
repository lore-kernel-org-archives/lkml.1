Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZFVVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZFVVIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFVVIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:08:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbZFVVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:08:46 -0400
Date: Mon, 22 Jun 2009 14:06:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: John Stoffel <john@stoffel.org>
cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <19007.60396.259650.682653@stoffel.org>
Message-ID: <alpine.LFD.2.01.0906221349220.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de> <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> <19007.60396.259650.682653@stoffel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, John Stoffel wrote:
> 
> I just recently submitted a patch, and it took me a while to figure
> out a git flow for stupid, simple patches so that I, a moron, could
> understand it.

Well, your documented flow is pretty advanced, actually. In fact, much 
more advanced than what _I_ often do when I send out patches.

So I'm not saying that your flow is wrong at all, but for "casual" 
patches, there are simplifications..

> # One time commands
> > apt-get install git-email
> > git config --global user.name "John Stoffel"
> > git config --global user.email "john@stoffel.org"

git-email can be useful, but it's really only useful if you plan on 
sending lots of patches. A lot of casual users may fin it too much 
overhead).

The user name/email is always good to set up with git, though.

Of course, the really casual use won't ever even care, because it won't 
necessarily even commit things! But setting it up (once) certainly won't 
hurt.

> # Only to be done infrequently
> > mkdir /var/tmp/git-tree
> > cd /var/tmp/git-tree
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

Yes. Something like this, although "/var/tmp" is an odd place to put it 
unless it's really a one-off thing.

> # Make a new branch <branch> for the patch you're doing.  In this
>   case, we'll do 'sym_hipd-ratelimit'

Ok, this is where your casual use gets to be already pretty advanced.

I would suggest starting out using the kernel git repository as more of a 
"anonymous cvs" replacement, ie to just track upstream. So just keep doing

	git pull origin

every once in a while, which is a really convenient way to just say "get 
the latest version and update the working tree"

NOTE! It's really convenient _only_ if you don't actually do commits. If 
you do your own work, it's going to do a merge etc, and that's part of the 
"advanced" feature. The above is all assuming that you do NOT commit, and 
you really consider it a read-only tree with perhaps some random small 
local changes on top for testing.

If you are going to do anything fancier, then your "create a branch for 
testing" is good. But for somebody who doesn't expect to really be a 
kernel developer, starting out with a usage model based on anoncvs is 
probably a more natural one.

Then, just edit the files, and use "git diff". That, along with "git pull" 
would be the _only_ command you'd ever use - and you now have a nice 
anoncvs-like environment to get used to git with, without having to 
actually know a whole lot.

Now, what happens if your modifications touch a file that "git pull" will 
update? In that case, "git pull" will will just refuse to update the file, 
and do nothing. You can decide at that point to do one of several 
things:

 - maybe you just want to just stay at that base (not pull updates for a 
   while, until you're all done with your changes)

 - decide to continue with the "anoncvs" workflow, but try to just 
   forward-port the patches: learn the "git stash" command, and do

	git stash		# save your changes
	git pull		# do the update
	git stash apply		# re-apply your changes

   which obviously can be complicated if you have real conflicts, but no 
   worse than the alternatives. If you change code that changed upstream, 
   you'll have to resolve the thing _somehow_, and the above won't be that 
   different from what you're used to with "cvs update" or whatever.

 - decide that you are actually going to learn to use git branches etc, 
   and stop using git as just a smarter 'anoncvs' thing. This is when you 
   want to learn about commit, branches, and perhaps "git pull --rebase" 
   and friends. 

In other words, you really don't have to jump in with both feet. You could 
just dip your toe in the git waters before you do anything fancier.

			Linus
