Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYGQQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYGQQs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYGQQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:48:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbYGQQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:48:18 -0400
Date: Thu, 17 Jul 2008 09:47:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Short update and pause in 2.6.27 merge window
Message-ID: <alpine.LFD.1.10.0807170919370.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is just a quick note to let people know that I'll be off for an 
extended weekend starting later today, so the next few days will be very 
quiet from a merge standpoint.

Feel free to send the merge requests, just don't get worried when I don't 
act on them ;)

(There's also a few merge requests that I didn't act on yet just because I 
wanted to take a closer look - but if you're worried about it there is 
nothing wrong with re-sending it. I _do_ just drop requests in the 
bottomless pit that is my mailbox at times)

We seem to be roughly half-way through the merge window, judging purely by 
number of commits, although part of my calculations there is that I'm 
actually hoping/expecting that because a number of people are on vacation 
etc, this merge window might be smaller than some of the other recent ones 
(2.6.25-rc1 in particular was huge).

In the last couple of days I _have_ merged 50+ trees, and while there's 
been some 'heated discussion' about some of them (you know who you are ;), 
I'm hoping that we're actually in reasonably good shape even though it's 
in the middle of the merge window, and that people will test out the 
snapshot kernels even though I'm not ready to do a -rc1 release.

So go out and test.

The fact that much of it has been in linux-next may or may not have 
helped, but it definitely meant that people knew of _some_ problems early. 
Let's see how people feel about that after the whole release is done, but 
it certainly doesn't seem to have hurt.

My personal favorite merge is the BKL pushdown, which while not likely to 
matter hugely in practice for lots of people is nice to finally see. We 
kind of dropped the ball on the BKL once it got to be small enough that it 
wasn't very high on peoples radar any more. Now the most noticeable user 
of the BKL in "core" kernel code seems to be fs/locks.c.

Hint, hint. I think somebody had some patches for that one too. Matthew?

But we've had lots of other things (in fact, the BKL changes ended up 
being much smaller than I expected), and the dirstat so far is

	   4.7% arch/arm/
	   3.3% arch/mips/
	   3.5% arch/ppc/platforms/
	  14.9% arch/ppc/
	   3.3% arch/x86/
	  29.3% arch/
	   8.3% drivers/char/drm/
	   9.3% drivers/char/
	   7.3% drivers/gpu/drm/
	   7.3% drivers/gpu/
	   3.3% drivers/s390/
	  10.4% drivers/usb/misc/
	   6.0% drivers/usb/serial/
	  17.2% drivers/usb/
	  45.0% drivers/
	   7.1% firmware/
	   4.3% fs/ubifs/
	   5.0% fs/
	   6.7% include/
	   3.3% sound/

where some of those percentages are a bit misleading (the "gpu" part, for 
example, goes away if you enable renames, since that was all really just 
moving files around from drivers/char/ - but at the same time it's one of 
the things people may notice more, so I chose the non-rename version of 
dirstat on purpose).

No network or driver core/USB merges yet (the USB stuff in the dirstat is 
from the ARM, BKL and firmware merges) so there are complete big 
subsystems lacking still, but it would be good to have people test the 
things we _have_ merged.

			Linus

PS. And to get wider distribution for this message: Digg users - you're 
all a bunch of Wanking Walruses. And you can quote me on that.
