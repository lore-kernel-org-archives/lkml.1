Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXKNTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXKNTzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXKNTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:54:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbXKNTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:54:55 -0500
Date: Wed, 14 Nov 2007 11:54:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <200711140356.31483.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.9999.0711141144080.2786@woody.linux-foundation.org>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <200711140356.31483.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Nov 2007, Nick Piggin wrote:
> 
> Not if you said their regression causing patches will get reverted unless it
> can be fixed for release.

Actually, I'm pretty happy reverting patches that cause regressions even 
if it *can* be "fixed for release". If there isn't a fix available within 
a day or two, it should get reverted.

The "fix" can then be re-applying the *fixed* patch - and at that point we 
should strive to require the person who re-submits the patch (with fixes) 
having to have an Ack from the person who found the problem in the first 
place, so that it's verified to actually fix things!

So I really would encourage people to send me emails like

	Please revert commit xyz, because it breaks abc, and there is no 
	fix available even though this was reported x days ago.

	I have verified that revert just that change fixes the issue.

and just make the "because it breaks abc" be specific and clear enough 
that I go "Ahh, ok, I'd better revert it".

Also, please notice the latter part of the suggestion above: even if 
somebody has bisected down their problem to a specific commit, I really 
*do* want to hear that actually undoing the commit on top of the current 
tree acually fixes it again, because sometimes that just isn't the case - 
sometimes you end up having various interactions that means that reverting 
a commit might simply not even work.

I have no trouble at all with reverting commits in general. I think 
regressions are serious.

So the problematic cases are the cases where:

 - the commit no longer reverts cleanly, or just otherwise introduces 
   other infrastructure that other commits that already got merged depend 
   on.

   So sometimes you actually need a patch along with the revert (Andrew 
   does that kind of thing anyway, since he works with patches regardless, 
   so the "needs a patch" case is obviously not limited to just the 
   problem cases)

 - more commonly: it's not entirely clear which commit actually caused the 
   problem.

but I *do* want to encourage people to revert (and ask other people to 
revert) much more aggressively. I personally try to revert things that 
people report regressions to me about very actively, unless I know 
somebody already has or is working on a fix.

				Linus
