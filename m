Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbXLJB6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbXLJB6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXLJB6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:58:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbXLJB6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:58:36 -0500
Date: Sun, 9 Dec 2007 17:57:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-Reply-To: <20071209220132.53268368@the-village.bc.nu>
Message-ID: <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu> <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
 <20071209220132.53268368@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Dec 2007, Alan Cox wrote:
> 
> The one off regression is probably not one off, but this is IDE so
> actually its quite probable its a single broken firmware. 
>
> The alternative is that you cripple just about every user of various
> other standards compliant devices and controllers whose hardware we
> finally fixed.

Alan, you're so full of shit that it's not even funny.

Have you even *read* the thread?

Tejun already reported that this apparently gets fixed _properly_ with the 
more extensive cleanups and fixes that are pending for 2.6.25.

In other words, the stuff you call so critically important (yet we've been 
able to live without it until now!) is apparently simply NOT YET READY. 
It's breaking things.

In this case, Tejun seems to be right on the money.  I also agree 100% 
with him when he says

   "Blacklist takes time to develop and temporary blacklist for just one
    release doesn't sound like a good idea."

because if we create some blacklist for that one reported device, not only 
is it likely going to be wrong (it's almost never just one firmware or one 
chip that has a particular issue), but we tend to create thee blacklists 
and later realize that we shouldn't have blacklisted things at all, we 
should just have done things differently.

For examples of that, see the NCQ blacklist that was just _us_ doing 
things wrong (over-reacting to things we shouldn't care about), and 
there's currently another totally unrelated discussion on a very similar 
thing wrt libata and the ACPI startup commands for an unused controller 
port.

> Finally you need to remember that the 'regression' is caused by the fact
> we now do the _right_ thing both in terms of 'old IDE' and specs.

.. and what the hell does that matter? If the code doesn't work, it 
doesn't work, and you might as well point to some random scribblings done 
by a three-year-old on toilet paper rather than any "specs".

Real life matters more. Regressions matter more.

We apparently do have a full fix, but it seems to be too invasive for 
2.6.24, which means that the thing that currently DOES NOT WORK and 
causes regressions should be reverted, so that 2.6.24 is at least no worse 
than 2.6.23 (and all earlier kernels) in this respect.

And then we should just hope that the more complete fix that Tejun has 
doesn't cause any issues on its own. I would suggest that if you care so 
deeply about this issue, you press Fedora into putting Tejun's tree into 
Fedora testing, and get that thing tested out extensively.

So the fact is, we have a way forward, but we should *not* take steps 
backwards just because you want to push something out that isn't quite 
ready. We should revert the change that causes the current trouble, safe 
in the knowledge (or at least "strong hope") that we have a way forward 
that makes *both* 2.6.24 and 2.6.25 be continual improvements.

We used to allow regressions. It was really painful. It's hard to debug 
things when things sometimes break. It's much better to have a nice 
constant monotonic improvement.

It's better for users, but it's much better also for developers, even if 
you may be frustrated right now because some new code effectively gets 
shut down until it works for everybody.

		Linus
