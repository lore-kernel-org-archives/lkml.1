Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbYBLUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbYBLUdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764208AbYBLUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:32:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbYBLUc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:32:56 -0500
Date: Tue, 12 Feb 2008 12:31:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212200354.GB16885@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0802121218350.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
 <20080212200354.GB16885@flint.arm.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Russell King wrote:
> 
> 3. rebase the branch on top of the conflicting change, throw out the
>    patches which prove to be a problem and ask the original author of
>    those patches to fix them up for the conflicting change.  The result
>    is a completely bisectable tree.
> 
> (3) is the solution which I chose, and it worked _extremely_ well.

Don't get me wrong at all. Rebasing is fine for stuff you have committed 
yourself (which I assume was the case here).

Rebasing is also a fine conflict resolution strategy when you try to 
basically turn a "big and complex one-time merge conflict" into "multiple 
much smaller ones by doing them one commit at a time".

But what rebasing is _not_ is a fine "default strategy", especially if 
other people are depending on you.

> (3) is effectively what akpm does with his tree - when a patch conflicts
> with other changes, he throws the changes out and bangs peoples heads
> together to get a new set of patches generated which work together.

Right. And it's one of the fundamental differences between git and a patch 
queue.

Patch queues are very flexible, but they simply don't scale. They don't 
scale in history (ie you cannot sanely keep track of multiple queues as 
they grow in the long run - you need a way to regularly "freeze" things 
into a release tar-ball or something like that). But they also don't scale 
with number of users - even just read-only ones.

The latter example is something we see in -mm right now. When people 
report problems against -mm, it's usually an all-or-nothing thing 
(so-and-so mm release doesn't work), but even when people sometimes bisect 
to a specific point in mm, it's not "stable" in the sense that that point 
may not make any sense in a subsequent -mm queue version.

And all of these issues are not about "-mm" per se, but are about patch 
queues in general. And "rebase" turns a git repository effectively to a 
patch queue too, with all the same downsides.

And I don't think patch queues are evil: I use git rebase all the time 
myself (not for the kernel, but for git, where I'm not the top-level 
thing). But I'd not rebase commits from other peoples trees: I rebase 
commits that I applied as patches (ie the *author* may be somebody else, 
but the committer is me!) or that I committed myself, and that I haven't 
pushed out.

Note that difference between "committer" and "author". There's nothing 
wrong with rebasing commits that are _authored_ by other people. But there 
absolutely is something wrong rebasing commits that are _commmitted_ by 
somebody else, unless you two are best buddies and know and trust each 
other and are ok with each other messing up the commits (and use some 
external method of serialization, so that you don't step on each others 
toes).

			Linus
