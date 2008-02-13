Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYBMDtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYBMDtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYBMDtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:49:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbYBMDtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:49:00 -0500
Date: Tue, 12 Feb 2008 19:48:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802121936450.2920@woody.linux-foundation.org>
References: <47B1CB08.4020101@garzik.org>  <20080212.155853.193190548.davem@davemloft.net>  <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>  <20080212.172051.58554658.davem@davemloft.net>  <1202869550.3137.182.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org> <1202871616.3137.197.camel@localhost.localdomain> <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Linus Torvalds wrote:
>
> 	git rebase --onto $new $old

..and in case it wasn't clear - this is just a general way of saying "move 
the commits on this branch since $old to be based on top of $new" instead.

You can pick out those old/new commit ID's using gitk or whatever if you 
wish. Neither the $new or the $old needs to even be an existing branch - 
just pick them with gitk. 

So if you literally want to just move the top 5 commits (assuming those 
top five cmmits are just a nice linear thing you did) from the current 
branch to be on top on another branch instead, you can literally do this:

	# save this state, maybe we want to keep it around. Call it "old"
	git branch old-branch

	# rebase the top five commits onto $target
	git rebase --onto $target HEAD~5

ta-daa - all done. The branch you are on will now have been rewritten to 
be the top five commits moved to be on top of the $target you chose, and 
if you want to get back the old state, it's nicely squirrelled away in 
"old-branch".

(That obviously assumes no merge conflicts - you'll have to resolve those 
yourself ;)

Of course, if you didn't even want to save the old branch, just skip the 
first step. If you have reflogs enabled (and git does that by default in 
any half-way recent version), you can always find it again, even without 
having to do "git fsck --lost-found", at least as long as you don't delete 
that branch, and it hasn't gotten pruned away (kept around for the next 90 
days by default, iirc)

		Linus
