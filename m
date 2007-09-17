Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbXIQF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbXIQF3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 01:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXIQF3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 01:29:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbXIQF3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 01:29:00 -0400
Date: Sun, 16 Sep 2007 22:28:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: crashme fault
In-Reply-To: <20070916220643.bea3e44f.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.999.0709162224580.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
 <46EC6F2A.5090008@oracle.com> <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
 <20070916094001.d87ed0f0.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org>
 <20070916220643.bea3e44f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2007, Randy Dunlap wrote:
> 
> I'll test this overnight on 2.6.23-rc6-git2 since that was failing.
> 
> I haven't been able to reproduce the fault on 2.6.21 after several
> hours of testing.
> 
> I'll also test a microcode update to see if it helps.

Before you do the microcode update, try to see if you can bisect the place 
between 2.6.21->22 that seems to start it. Even if you don't get all the 
way, if you are confident enough about the "no error" case to be able to 
bisect it down by doing a few reboots, it will at least cut down the set 
of possible commits by roughly a factor of 2^<nr-of-bisect> events, so 
even "just" a series of 4-5 bisect things might give us more of a clue.

Of course, if it's somewhat random and timing-dependent, bisection can be 
hard (the "2^n" thing is very efficient, but it also means that a *single* 
wrong answer will totally invalidate the result, so if something isn't 
entirely reproducible, bisection often fails!)

		Linus
