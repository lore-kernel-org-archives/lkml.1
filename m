Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYBMB6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYBMB6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYBMB6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:58:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013AbYBMB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:58:41 -0500
Date: Tue, 12 Feb 2008 17:57:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212.173817.111913348.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org> <20080212.173817.111913348.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, David Miller wrote:
> 
> Now how do I remove a bogus commit for a tree that I've already pushed
> out and published for other people, without any record of it appearing
> in the GIT tree any more?

So, the answer is: if others have actually pulled, it's simply not 
possible.

There simply is no way to undo history that isn't local any more. You just 
*have* to revert, or you need to find every single person that pulled 
(directly or indirectly) and ask them to undo all the work they did on top 
of your bad commit.

This is not git-related, btw. That's just how the world works. It's a bit 
like the internet - if you said something stupid on #IRC and it made it to 
bash.org, there's not a whole lot you can do to "undo" your stupidity. You 
can only hope to do better in the future and assume people forget. 

> How do I insert build fixes into existing changesets so that the tree
> is more bisectable?

Just delay pushing out. There really is _zero_ downside to this. None at 
all. There are only upsides.

> If Jeff merged in a tree that introduced a ton of whitespace errors
> git is complaing about, is there a way I can fixup that changeset
> in-place? (or should I tell Jeff to start adhering to GIT's whitespace
> warning messages when he applies patches?)

Umm. Git doesn't complain about whitespace _except_ when applying patches. 
So if you don't rebase his work, you'll never see the whitespace warnings 
either!

Of course, we'd probably wish that Jeff cared about the whitespace 
warnings and pushed back on them, but the fact is, that warning isn't 
meant for you - because by the time you pull Jeff's tree, it's simply not 
your issue any more. Jeff already applied it. Either he's your trusted 
lietenant or he's not.

Quite frankly, to me it sounds like you're not ready to "let go" and trust 
the people under you. Trust me, it's worth it. It's why your life is easy: 
I have let go and I trust you. 

Also, I'd *much* rather have a few problems in the tree than have people 
screw up history in order to hide them. Sure, we want to keep things 
bisectable, but quite frankly, if you do a reasonable job and compile the 
kernel before you push out, it will be "mostly bisectable".

And yes, mistakes happen. Mistakes will *always* happen. It's ok. Relax. 

Let me put it another way: You're _both_ going to be *much* better off 
pushing back on Jeff, telling him that "I can't pull from you because your 
tree is ugly and doesn't compile", than taking his tree and rebasing it.

Remember? I used to do that all the time. I berated the ACPI people for 
creating monster trees that were horrible and contained fifteen merges and 
two real commits. I didn't try to clean it up for them, I just told them 
what the problem was, and you know what? The ACPI tree is one of the 
cleanest ones out there now!

So in short:

 - clean trees and bisectability are all wonderful things. No doubt about 
   that at all.

 - but if getting there means that you lose a lot of _other_ wonderful 
   things (like being able to trust history, and the people being under 
   your watchful eyes havign to deal with you re-writing their trees), 
   we'd be much better off taking the occasional commit that fixes things 
   up _after_ the fact rather than before!

 - and you actually can help fix your issues by doing some simple things 
   *before* pushing out, rather than push out immediately. IOW, do your 
   whitespace sanity fixes, your compile checks etc early, and don't push 
   out until after you've done them.

Hmm?

			Linus
