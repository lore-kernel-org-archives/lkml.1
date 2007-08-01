Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbXHAPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbXHAPoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXHAPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:44:06 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1120 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbXHAPoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:44:05 -0400
Date: Wed, 1 Aug 2007 17:44:17 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801135949.GA10839@elte.hu>
Message-ID: <Pine.LNX.4.64.0708011622400.1817@scrub.home>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu>
 <Pine.LNX.4.64.0708011346510.1817@scrub.home> <20070801135949.GA10839@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> > > in that case 'top' accounting symptoms similar to the above are not 
> > > due to the scheduler starvation you suspected, but due the effect of 
> > > a low-resolution scheduler clock and a tightly coupled 
> > > timer/scheduler tick to it.
> > 
> > Well, it magnifies the rounding problems in CFS.
> 
> why do you say that? 2.6.22 behaves similarly with a low-res 
> sched_clock(). This has nothing to do with 'rounding problems'!
> 
> i tried your fl.c and if sched_clock() is high-resolution it's scheduled 
> _perfectly_ by CFS:
> 
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   5906 mingo     20   0  1576  244  196 R 71.2  0.0   0:30.11 l
>   5909 mingo     20   0  1844  344  260 S  9.6  0.0   0:04.02 lt
>   5907 mingo     20   0  1844  508  424 S  9.5  0.0   0:04.01 lt
>   5908 mingo     20   0  1844  344  260 S  9.5  0.0   0:04.02 lt
> 
> if sched_clock() is low-resolution then indeed the 'lt' tasks will 
> "hide":
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2366 mingo     20   0  1576  248  196 R 99.9  0.0   0:07.95 loop_silent
>     1 root      20   0  2132  636  548 S  0.0  0.0   0:04.64 init
> 
> but that's nothing new. CFS cannot conjure up time measurement methods 
> that do not exist. If you have a low-res clock and if you create an app 
> that syncs precisely to the tick of that clock via timers that run off 
> that exact tick then there's nothing the scheduler can do about it. It 
> is false to charachterise this as 'sleeper starvation' or 'rounding 
> error' like you did. No amount of rounding logic can create a 
> high-resolution clock out of thin air.

Please calm down. You apparantly already get worked up about one of the 
secondary problems. I didn't say 'sleeper starvation' or 'rounding 
error', these are your words and it's your perception of what I said.

sched_clock() can have a low resolution, which can be a problem for the 
scheduler. This is all this program demonstrates. If and how this problem 
should be solved is a completely different issue, about which I haven't 
said anything yet and since it's not that important right now I'll leave 
it at that for now.

bye, Roman
