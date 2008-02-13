Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYBMCTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYBMCTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYBMCTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:19:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYBMCTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:19:40 -0500
Date: Tue, 12 Feb 2008 18:18:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, bfields@fieldses.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212180613.a1a07264.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802121813020.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net> <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org> <20080212.173817.111913348.davem@davemloft.net>
 <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org> <20080212180613.a1a07264.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Andrew Morton wrote:
> 
> So it would not be efficient for David to do all this queue-cleaning
> *prior* to putting the tree into linux-next, because more stuff will pop up
> anyway.

Well, what others have done is to have special "temporary branches".

This is what git itself does, for example. The "pu" branch in git is used 
for experimental stuff, and it's _declared_ to be rebased, redone, and 
generally just unsafe at any moment.

So it is easy to have a special "testing" branch that is just declared to 
be unsafe.  Make Linux-next pull that testing branch - it will pollute the 
Linux-next tree (and anybody else who just wants to see what the current 
state is), but since those are re-generatd from scratch every day 
_anyway_, so who cares?

But don't make it something people pull by mistake (ie never call it 
"master", and when mentioning it in some email message, always mention the 
fact that it's not a stable branch, and never ask anybody to pull it 
without making it very clear that it's just for testing, not for real 
merging).

So git does have support for those things. They are very much "secondary" 
branches (any tree they are pulled into will itself become "poisoned" and 
unstable), but it's easy enough to have something like that for testing 
purposes. And if it all tests out fine, you can just move it as-is into 
the "real" branch if you want to.

			Linus
