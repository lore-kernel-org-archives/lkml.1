Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYBLT2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYBLT2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYBLT2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:28:38 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:55644 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYBLT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:28:33 -0500
Message-ID: <47B1F294.8000404@panasas.com>
Date: Tue, 12 Feb 2008 21:25:08 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>  <20080212044314.GA4888@kroah.com>  <20080211211751.3e265754@laptopd505.fenrus.org>  <20080211.221126.230471463.davem@davemloft.net>  <47B1CB08.4020101@garzik.org>  <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <47B1DD17.2030204@panasas.com> <alpine.LFD.1.00.0802121031520.2920@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802121031520.2920@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 12, 2008, 20:36 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> On Tue, 12 Feb 2008, Benny Halevy wrote:
>> IMHO, this base tree should typically be based off of linus' tree
>> and kept rebased on top of it.  This way you get the mainline fixes
>> through the integration base tree.
> 
> Hell no!
> 
> No rebasing! If people rebase, then it's useless as a base.

Linus, what you're saying is pretty extreme.

Our experience with pnfs development taught us that rebase was actually the only
method that worked on the long run because it allows us to maintain a *clean* series of
patchsets over an extended period of time (order of two years).

In the past, when we merged your tree into ours rather than using git-remote update and
rebase we ended up with a cluttered mess that buried all the resolved merge conflicts
in merge commits and maintaining it became an increasingly harder nightmare.

Nowadays, I rebase the linux-pnfs git tree almost on a daily basis, keeping tags
on historical refs (to be cleaned up when a branch stabilizes) and the other
contributors simply use git-remote update to refresh their tracking branches and
rebase their stuff onto the new heads.  It took the team a couple weeks to get used
to this methodology but it really works great for us now.

It seems to me that merging works well one (your :) way when patches are merged
upstream and become immutable at this point, while on the other way, keeping
a patchset fresh and comprehensible is feasible only with rebase when there
are occasional conflicts with stuff coming down from upstream.  The domino-
effect caused by rebase is manageable and not worse than merge if people
just keep track of the original bases of their development branch before
updating their tracking branches.

Maybe the missing link is a tool to help do rebasing more easily.
I wrote my own tool for that: git-rebase-tree (available on
git://git.bhalevy.com/git-tools.git) and using it makes the mechanics
of rebasing our patchsets almost trivial.  I really encourage folks
to try it out and give me feedback about it.

Benny

> 
> That base tree needs to be something people can *depend* on. It contains 
> the API changes, and not anything else. Otherwise I will never ever pull 
> the resulting mess, and you all end up with tons of extra work.
> 
> Just say *no* to rebasing.
> 
> Rebasing is fine for maintaining *your* own patch-set, ie  it is an 
> alternative to using quilt. But it is absolutely not acceptable for 
> *anythign* else. 

So what's the solution for maintaining a series of patchsets that depend
on one another?

> 
> In particular, people who rebase other peoples trees should just be shot 
> (*). It's simply not acceptable behaviour. It screws up the sign-off 
> procedure, it screws up the people whose code was merged, and it's just 
> WRONG.
> 
> 			Linus
> 
> (*) The exception being if there is something seriously wrong with the 
> tree. I think I've had trees which I just refused to pull, and while most 
> of the time I just say "I refuse to pull", early on in git development I 
> actually ended up fixing some of those trees up because my refusal was due 
> to people mis-using git in the first place. So I have actually effectively 
> rebased a maintainer tree at least once. But I still think it is seriously 
> screwed up.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

