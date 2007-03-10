Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXCJVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXCJVGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbXCJVGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:06:18 -0500
Received: from sccrmhc13.comcast.net ([63.240.77.83]:54426 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXCJVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:06:17 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
	 <1173556374.2958.12.camel@entropy>
	 <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 13:01:13 -0800
Message-Id: <1173560473.2958.23.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 12:41 -0800, Davide Libenzi wrote:
> On Sat, 10 Mar 2007, Nicholas Miell wrote:
> 
> > Try reading the timer_create man page.
> > 
> > In short, you're limited to a single clock, so you can't set timers
> > based on wall-clock time (subject to NTP correction), monotomic time
> > (not subject to NTP, will not ever go backwards or skip ticks), the
> > high-res versions of the previous two clocks, per-thread or per-process
> > CPU usage time, or any other clocks that may get introduced in the
> > future.
> 
> One timer per fd yes. So?

I never complained about one timer per fd (although, now that you
mention it, that would get a bit excessive if you have thousands of
outstanding timers).

> The real-time and monotonic selection can be added. 

IOW, the timerfd patch is not suitable for inclusion as-is. (While
you're at it, you should probably add a flags argument for future
expansion.)

> If you look at the posix timers code, that's a bunch of code over the real 
> meat of it, that is hrtimer.c. The timerfd interface goes straight to 
> that, without adding yet another meaning to the sigevent structure,

That's what the sigevent structure is for -- to describe how events
should be signaled to userspace, whether by signal delivery, thread
creation, or queuing to event completion ports. If if you think
extending it would be bad, I can show you the line in POSIX where it
encourages the contrary.

>  and 
> yet another case inside the posix timers trigger functions. That will be 
> as unstandard as timerfd is, and even more, since you cannot use that 
> interface and hope to be portable in any case.

If Linux were to do a wholesale theft of the Solaris interface (warts
and all), you'd be portable (and, now that I think of it, more
efficient).

Two major unixes using the same interface would probably make it a
shoe-in for the next POSIX, too. (c.f. openat(2) and friends)

> On top of that, handing over files to the posix timers will creates 
> problems with references kept around.
> The timerfd code is just a *really* thin layer (if you exclude the 
> includes, the structure definitions and the fd setup code, there's 
> basically *nothing*) over hrtimer.c and does not mess up with other kernel 
> code in any way, and offers the same functionalities. I'd like to keep it 
> that way.

-- 
Nicholas Miell <nmiell@comcast.net>

