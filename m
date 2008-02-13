Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbYBMBcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbYBMBcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBMBce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:32:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749AbYBMBcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:32:32 -0500
Date: Tue, 12 Feb 2008 17:31:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212.165014.01238510.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
References: <47B1C9F4.30402@garzik.org> <20080212193754.GC18625@fieldses.org> <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org> <20080212.165014.01238510.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, David Miller wrote:
> 
> > Put another way: think of the absolute *chaos* that would happen if I were 
> > to rebase instead of just merging. Every time I pull from you I'd 
> > invalidate your whole tree, and you'd have to re-generate. It gets 
> > unmaintainable very quickly.
> 
> I actually wouldn't mind that, the first thing I do when sending a
> pull request is I stop putting things into my tree and as soon as the
> recipient pulls I wipe out my tree and clone a fresh copy of their's.

You *really* don't see the problem here?

> I really like that mode of operation.

*YOU* like it, because it never generates any issues for *you*. You're the 
top in your heap, and the people above you don't do that insane thing, so 
you get all of the advantages, with none of the downsides. Of *course* you 
like it.

But as people have pointed out, it generates issues for the people under 
you! If I did it, the people who now complain about networking would 
not just be a couple, it would be everybody. Nobody could depend on 
anything out there, because everything would have to rebase.

You just don't see the problems, because the only person above you isn't 
crazy enough to do what you propose. You also don't do ten merges a day of 
subsystems you don't know.

The importance of merging (rather, not screwing up history in general) 
becomes really obvious when things go tits-up. Then they go tits-up 
*without* screwing up the history of the trees that were hopefully tested 
individually.

If you re-base things that others developed, you lose that. Imagine if I 
merged first Greg's tree (by rebasing), and then there was some 
fundamental thing that didn't cause a conflict, but just made something 
not work, when I rebased yours on top. Think about what happens.

Now I've merged (say) 1500 networking-related commits by rebasing, but 
because I rebased on top of Greg's tree that I had also rebased, 
absolutely *none* of that has been tested in any shape of form. I'd not 
use most of the things I pulled, so I'd never see it, I'd just push out 
something that was very different from *both* trees I pulled, with no way 
to really blame the merge - because it doesn't even exist.

So as a result, some *random* commit that was actually fine on its own has 
now become a bug, just because it was re-written. 

You don't see the problem here?

Yes, this is the *crap* you do all the time. You don't see the problems as 
much, because you merge probably only about a tenth of the volume I merge, 
and you can keep track of the subsystem more. But even though you don't 
have nearly the same kinds of problems, people have complained about your 
process.

So there's a real reason why we strive to *not* rewrite history. Rewriting 
history silently turns tested code into totally untested code, with 
absolutely no indication left to say that it now is untested.

You can limit the damage by keeping it to a single subsystem and by 
serializing that subsystem by - for example - talking it over amonst 
yourself what order you do things in, and yes, most of the time rewriting 
doesn't hurt anything at all, but I guarantee you that it's a big mistake 
to do, and the mistake gets bigger the more _independent_ people you have 
involved.

			Linus
