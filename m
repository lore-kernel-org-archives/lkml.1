Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZFWCCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZFWCCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZFWCC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:02:27 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:60055 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZFWCC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:02:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19008.14107.115568.19439@stoffel.org>
Date: Mon, 22 Jun 2009 21:59:55 -0400
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stoffel <john@stoffel.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <alpine.LFD.2.01.0906221349220.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de>
	<alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
	<19007.60396.259650.682653@stoffel.org>
	<alpine.LFD.2.01.0906221349220.3240@localhost.localdomain>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus> On Mon, 22 Jun 2009, John Stoffel wrote:
>> 
>> I just recently submitted a patch, and it took me a while to figure
>> out a git flow for stupid, simple patches so that I, a moron, could
>> understand it.

Linus> Well, your documented flow is pretty advanced, actually. In
Linus> fact, much more advanced than what _I_ often do when I send out
Linus> patches.

Heh, but I can't write patches in my sleep like you can I bet.  And I
was looking for an easy to use method that would let me keep a small
subset of patches I write or test easily accesible.  And since I'm NOT
a C coder by day, but a SysAdmin who hacks Perl mostly... this seems
to fit into the spirit of Git usage in the kernel.

Linus> So I'm not saying that your flow is wrong at all, but for "casual" 
Linus> patches, there are simplifications..

Excellent!  I figured I was missing stuff, but like I said... 

>> # One time commands
>> > apt-get install git-email
>> > git config --global user.name "John Stoffel"
>> > git config --global user.email "john@stoffel.org"

Linus> git-email can be useful, but it's really only useful if you
Linus> plan on sending lots of patches. A lot of casual users may fin
Linus> it too much overhead).

Linus> The user name/email is always good to set up with git, though.

Linus> Of course, the really casual use won't ever even care, because
Linus> it won't necessarily even commit things! But setting it up
Linus> (once) certainly won't hurt.

I think git-email is actually really useful, even for occasional
users, since it makes sure you do it right and send a good patch,
without whitespace damage, proper signed-off-by lines, etc.  Much
easier than crafting an email by hand.  

Esp when I wanted to make it as easy as possible on you and James to
actually accept and push my patch upsteam.  Keeping it easy on the
sub-system maintainers is a key thing in my mind.  

>> # Only to be done infrequently
>> > mkdir /var/tmp/git-tree
>> > cd /var/tmp/git-tree
>> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

Linus> Yes. Something like this, although "/var/tmp" is an odd place
Linus> to put it unless it's really a one-off thing.

Me being lazy and knowing that /var/tmp doesn't get nuked on reboots.
For real documentation, I'd clean it up into another path.

>> # Make a new branch <branch> for the patch you're doing.  In this
>> case, we'll do 'sym_hipd-ratelimit'

Linus> Ok, this is where your casual use gets to be already pretty
Linus> advanced.

I figured that if I put my patch into a branch, I could then keep
pulling your tree into mine, and then merging my patch upsteam as
needed if it doesn't make it in this time.  

Linus> I would suggest starting out using the kernel git repository as
Linus> more of a "anonymous cvs" replacement, ie to just track
Linus> upstream. So just keep doing

I've *never* done any development using CVS, etc.  Just some basic
version control scripted to manage files for sysadmin type work.   So
version control is just a pain for me to do, since I do it so
infrequently. 

Linus> 	git pull origin

Linus> every once in a while, which is a really convenient way to just
Linus> say "get the latest version and update the working tree"

  git pull

will work too, assuming I'm on the master branch, right?

Linus> NOTE! It's really convenient _only_ if you don't actually do
Linus> commits. If you do your own work, it's going to do a merge etc,
Linus> and that's part of the "advanced" feature. The above is all
Linus> assuming that you do NOT commit, and you really consider it a
Linus> read-only tree with perhaps some random small local changes on
Linus> top for testing.

Should I still do branches, even if I *don't* do a commit on those
various branches?  

Linus> If you are going to do anything fancier, then your "create a
Linus> branch for testing" is good. But for somebody who doesn't
Linus> expect to really be a kernel developer, starting out with a
Linus> usage model based on anoncvs is probably a more natural one.

Heh, just having some notes which let's me hack in a patch and keep
track of where I am and juggle branches a bit is a *huge* help.  

Linus> Then, just edit the files, and use "git diff". That, along with
Linus> "git pull" would be the _only_ command you'd ever use - and you
Linus> now have a nice anoncvs-like environment to get used to git
Linus> with, without having to actually know a whole lot.

So say I want to manage multiple branches, since I want to test some
patches out, or various kernel revisions, or even git bisection?  

Or should I just use a completely seperate tree for a bisection run? 

Linus> Now, what happens if your modifications touch a file that "git
Linus> pull" will update? In that case, "git pull" will will just
Linus> refuse to update the file, and do nothing. You can decide at
Linus> that point to do one of several things:

Linus>  - maybe you just want to just stay at that base (not pull
Linus>    updates for a while, until you're all done with your
Linus>    changes)

Linus>  - decide to continue with the "anoncvs" workflow, but try to
Linus>    just forward-port the patches: learn the "git stash"
Linus>    command, and do

Linus> 	git stash		# save your changes
Linus> 	git pull		# do the update
Linus> 	git stash apply		# re-apply your changes

Ohh!  This is a new one to me.  Gotta remember this one, that's huge!
Maybe what I've written should be updated to use this method instead?  

Linus>    which obviously can be complicated if you have real
Linus>    conflicts, but no worse than the alternatives. If you change
Linus>    code that changed upstream, you'll have to resolve the thing
Linus>    _somehow_, and the above won't be that different from what
Linus>    you're used to with "cvs update" or whatever.

Linus>  - decide that you are actually going to learn to use git
Linus>    branches etc, and stop using git as just a smarter 'anoncvs'
Linus>    thing. This is when you want to learn about commit,
Linus>    branches, and perhaps "git pull --rebase" and friends.

Heh, from all I've seen with your rants, git pull --rebase isn't what
I want to do if I can help it.  :]  Even though I'll probably never
publish a branch, just small patches occasionally at times. 

Linus> In other words, you really don't have to jump in with both
Linus> feet. You could just dip your toe in the git waters before you
Linus> do anything fancier.

I prefer to think that I've just waded into the kiddy pool with
hipboots on, before I try to do any *real* fly (bug) fishing.  

Thanks for the reply, as usual, I've learned something new.  Now to
put it into practice.

John

