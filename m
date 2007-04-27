Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXD0XIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXD0XIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbXD0XIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:08:17 -0400
Received: from iabervon.org ([66.92.72.58]:4929 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879AbXD0XIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:08:16 -0400
Date: Fri, 27 Apr 2007 19:08:12 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426125802.GL3468@stusta.de>
Message-ID: <Pine.LNX.4.64.0704271720510.28708@iabervon.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Adrian Bunk wrote:

> Linus said 2.6.20 was a stable kernel. My impression was that at least 
> two of the regressions from my 2.6.20 regressions list should have been 
> fixed before 2.6.20.
> 
> They have both been fixed through -stable, but I also remember a quite 
> experienced kernel maintainer running into one of them after 2.6.20 was 
> released and spending half a day tracking it down - and my answer was
> "known unfixed regression, first reported more than a month ago".

I think there is an issue with two different things being conflated, and 
this causes real stability problems. 2.6.x is both the first kernel in a 
series that is judged to be "stable" and the kernel that is the split 
between 2.6.x.y and 2.6.x+1. This is a fundamental problem, because it 
means that 2.6.x must have all of the problems that are being debugged by 
the people who understand the areas they are in, because 2.6.x+1 has to 
start so that people who are clueless about all of the areas with 
remaining bugs don't spend their time putting more regressions into their 
submissions for 2.6.x+1.

It is also a problem because it is easily possible for a problem to exist 
in 2.6.x-rcN which can only be correctly fixed by doing intrusive things, 
but can be papered over in an obviously-safe way. (E.g., the issue with 
legacy interrupt delivery when MSI is enabled). The intrusive patch could 
easily break a bunch of unrelated stuff, so that's no good for 2.6.x-rcN, 
but papering over bugs is no good for mainline. These bugs have to be 
fixed after the split, which means that the version at the fork must 
contain the bug.

Furthermore, everybody (people reporting bugs, people fixing them, and 
people merging fixes) seem to doze off late in -rc kernels. Having an 
announcement of something with a qualitatively different version wakes 
them up.

I say have a target of no known regressions in 2.6.21.1, with 2.6.21 being 
pretty good, and don't count too much on the stability of 3-number kernel 
versions.

> And a serious delay of the next regression-merge window due to unfixed 
> regressions might even have the positive side effect of more developers 
> becoming interested in fixing the current regressions for getting their 
> shiny new regressions^Wfeatures faster into Linus' tree.

I think the "stick" can't be delaying the window, because that's too 
broad. I think it has to be making people who are needed for fixing stuff 
miss the window. People aren't going to go learn a new area of the kernel 
to resolve regressions in it, but they're more likely to keep their own 
area clean so that they get to merge every 2 months instead of every 4.

> These are just my personal opinions, and other people consider the 
> resulting 2.6.20 and 2.6.21 kernels OK.

I don't think 2.6.x can be OK, by policy. I think 2.6.20.y got to an OK 
state eventually, which is to say that there's no need now to use a 
2.6.19.y kernel. I think that 2.6.21 isn't OK yet, but I think looking for 
an OK 2.6.21-derived kernel is premature still. Ignoring the version 
scheme entirely, I think the success condition should be that the "latest 
stable version of the Linux kernel" link on www.kernel.org is 
always strictly better than all previous links in that spot, and new 
features get there eventually (ideally, within 4 months of hitting 
mainline). I think this is actually possible, although it would require 
changing the policy for this link. And I don't think it requires a change 
in what goes into Linus's git repository when.

Furthermore, I think we're a lot closer to an OK kernel derived from 
Linus's Apr 25 version than we would be if "2.6.21" had not been released 
at that point. It sounds like more items were resolved in the past few 
days than in the preceding week.

Incidentally, will you continue to track 2.6.21 regressions against 
2.6.20? You said there was at least one that you haven't sent out, and 
there's been movement on several others since your last report.

	-Daniel
*This .sig left intentionally blank*
