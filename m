Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXDSXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXDSXBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422709AbXDSXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:01:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbXDSXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:01:13 -0400
Date: Thu, 19 Apr 2007 15:59:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] kvm oops fix
In-Reply-To: <alpine.LFD.0.98.0704191325000.9964@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0704191538460.9964@woody.linux-foundation.org>
References: <1176997839110-git-send-email-avi@qumranet.com>
 <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
 <4627BE6B.8030006@garzik.org>
 <alpine.LFD.0.98.0704191325000.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Apr 2007, Linus Torvalds wrote:
> 
> You can either do
> 
> 	git reset --hard ORIG_HEAD
> 	git reset --hard @{1}

Btw, on the same kind of subject: the whole "what was my previous HEAD" 
issues are obviously also how you'd generally want to see what those 
new patches were, regardless of whether you want to undo them or not.

So it might be worth repeating for people what I do after any pull that I 
feel I want to give a quick look-over.. A simple

	gitk ORIG_HEAD..
or
	gitk HEAD@{1}..
or
	gitk @{1}..
or
	gitk @{12.hours.ago}..

are all variations of the same theme: show what is new since either "last 
update" or "what I had in my tree 12 hours ago".

Btw, the

	gitk @{12.hours.ago}..

thing is very different from

	gitk --since=12.hours.ago

even if they involve the same date.

The "@{12.hours.ago}" syntax pinpoints a particular *commit*, namely what 
your HEAD was pointing at 12 hours ago. So it's literally about your 
particular repository history (give a branch name if you want to specify 
one: so "for-linus@{2.hours.ago}" specifies the *commit* that was the head 
of the "for-linus" branch in your repository 2 hours ago).

In contrast, the "--since=12.hours.ago" means something totally different: 
it measn that you want to ignore all commits that are older than 12 hours, 
regardless of whether they were actually in your tree at that point or 
not. Which is often a very different issue indeed.

So another reasonably common things you can do:

	git fetch linus
	gitk linus@{1}..linus

this assumes that you've set up a separate tracking branch "linus", and 
that you've taught it to fetch my current tree into it. So in the above 
sequence, the "git fetch linus" will fetch everything new from my tree 
into your "linus" tracking branch, and the "gitk" will then show all the 
new commits on that branch that you got.

NOTE! The above is very much designed to work whether you are on that 
branch or not, and in fact, the normal reason to do something like the 
above is explicitly that you want to see what is going on in somebody 
elses tree without actually necessarily merging it into your own branch 
(perhaps in order to decide whether you _want_ to merge it or not).

And that "linus@{1}" really just means "what is the previous commit I had 
on my 'linus' branch". You can obviously dig deeper down, and "linus@{10}" 
is something less commonly used, but basically means "what was on that 
branch ten revision updates ago".

Note that this is *very*different* from "linus~10", which means "what is 
the tenth _parent_ of the "linus" branch. They *can* be the same thing (if 
each operation adds exactly one commit), but if you do things like "git 
fetch", then the "linus" branch ten operations ago may be hundreds of 
commits ago, because some of those ten operations may have added lots of 
commits thanks to synching up with some other tree!

And as already noted, the "branch@{xyzzy}" format also allows "xyzzy" to 
be a date, not just a numeral. In fact, that was the original revlog 
tracking behaviour, and the numeric thing, while simpler, is actually a 
newer feature (as is the "don't specify a branch name at all", which just 
means "current branch")

So

	gitk @{24.hours.ago}..

is a nice way to see what has happend in *your* repository, on the current 
branch, in the last 24 hours.

(NOTE: You can also say "HEAD@{2.hours.ago}" and that actually doesn't use 
the current branch at all, it actually says what HEAD was 2 hours ago: you 
may have been on some totally _different_ branch back then, and if you 
wonder what the heck of a branch you are running and you look at the time 
of the binary, but you don't remember what branch you had checked out when 
you built it, that may be what you want. Of course, you may also want a 
better attention span ;)

Some of this is pretty recent, and generally, if some of this doesn't work 
for you, it means that you are using some ancient version of git. If it's 
not git-1.5.x, upgrade. It's worth it.

		Linus
