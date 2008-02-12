Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYBLUJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYBLUJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYBLUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:08:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbYBLUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:08:58 -0500
Date: Tue, 12 Feb 2008 12:07:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       John Linville <linville@tuxdriver.com>
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212193754.GC18625@fieldses.org>
Message-ID: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, J. Bruce Fields wrote:
> 
> But the "author" is still preserved, right?  Why do you need the
> committer name to be preserved?  (I'm not denying that there could be
> reasons, I'm just curious what they are.)

It's not that the committer should be preserved, but:

 - the chain from author -> committer should be visible in the 
   Signed-off-by: lines.

   If you rebase somebody elses tree, you screw that up. You need to add 
   your sign-off, since now *you* are the new committer, and *you* took
   somebody elses work!

 - you should respect the down-stream developer, and if that downstream 
   developer continues to work with his branch or works with other people, 
   you shouldn't screw that up!

Both of those basically say that you should never rebase somebody elses 
work. You can use rebase to rebase your *own* work on top of somebody 
elses thing (since that doesn't change the sign-off chain, and you still 
respect the downstream developers development model)!

But of course, if you rebase, you should respect the wishes of the 
up-stream developer too. I don't do rebases. So if you asked me to pull, 
the stuff I pulled can never be rebased, because it just *is* in my tree. 

Put another way: think of the absolute *chaos* that would happen if I were 
to rebase instead of just merging. Every time I pull from you I'd 
invalidate your whole tree, and you'd have to re-generate. It gets 
unmaintainable very quickly.

And that's actually ignoring a real issue: stability of commits. The nice 
thing about stable commit naming is that all bug-reports from other people 
that told where the bug happened are basically 100% trust-worthy and the 
code is 100% reproducible not just for you, but for everybody else. 

In other words, you really shouldn't rebase stuff that has been exposed 
anywhere outside of your own private tree. But *within* your own private 
tree, and within the commits that have never seen the light of day, 
rebasing is fine.

(And yes, there are exceptions. If it's a clear "throw-away tree" all the 
rules go out the window, of course, as long as everybody involved *knows* 
it's a throw-away tree, and know that if they pull it they have to 
synchronise 100% with you - so within a very tight-knit case or within a 
very specific small detail that is actively being worked on, those rebases 
with cleanups make tons of sense).

			Linus
