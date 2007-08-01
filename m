Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbXHARs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbXHARs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbXHARss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:48:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34187 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXHARsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:48:47 -0400
Date: Wed, 1 Aug 2007 19:48:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801174844.GA20713@one.firstfloor.org>
References: <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume that what Roman hit was that he had explicitly disabled the TSC 
> because of TSC instability with the "notsc" kernel command line. Which 
> disabled is *entirely*.

It might just have been cpufreq. That nearly hits everybody with cpufreq
unless you have a pstate invariant TSC; and that's pretty much
always the case on older laptops.

It used to not be that drastic, but since i386 switched to the
generic clock frame work it is like that :/

> These days, of course, we should notice it on our own, and just switch 
> away from the TSC as a reliable clock-source, but still allow it to be 
> used for the cases where absolute accuracy is not a big issue.

The rewritten sched_clock() i still have queued does just that. I planned
to submit it for .23, but then during later in deepth testing
on my machine park I found a show stopper that I couldn't fix on time.
Hopefully for .24

-Andi
