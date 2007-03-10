Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXCJGdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXCJGdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXCJGdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:33:10 -0500
Received: from sccrmhc11.comcast.net ([204.127.200.81]:47431 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbXCJGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:33:08 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 22:33:04 -0800
Message-Id: <1173508384.3108.1.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 15:41 -0800, Davide Libenzi wrote:
> This patch introduces a new system call for timers events delivered
> though file descriptors. This allows timer event to be used with
> standard POSIX poll(2), select(2) and read(2). As a consequence of
> supporting the Linux f_op->poll subsystem, they can be used with
> epoll(2) too.
> The system call is defined as:
> 
> int timerfd(int ufd, int tmrtype, const struct timespec *utmr);
> 
> The "ufd" parameter allows for re-use (re-programming) of an existing
> timerfd w/out going through the close/open cycle (same as signalfd).
> If "ufd" is -1, s new file descriptor will be created, otherwise the
> existing "ufd" will be re-programmed.
> The "tmrtype" parameter allows to specify the timer type. The following
> values are supported:
> 
>     TFD_TIMER_REL
>         The time specified in the "utmr" parameter is a relative time
> 	from NOW.
> 
>     TFD_TIMER_ABS
>         The timer specified in the "utmr" parameter is an absolute time.
> 
>     TFD_TIMER_SEQ
>         The time specified in the "utmr" parameter is an interval at
> 	which a continuous clock rate will be generated.
> 
> The function returns the new (or same, in case "ufd" is a valid timerfd
> descriptor) file, or -1 in case of error.
> As stated before, the timerfd file descriptor supports poll(2), select(2)
> and epoll(2). When a timer event happened on the timerfd, a POLLIN mask
> will be returned.
> The read(2) call can be used, and it will return a u32 variable holding
> the number of "ticks" that happened on the interface since the last call
> to read(2). The read(2) call supportes the O_NONBLOCK flag too, and EAGAIN
> will be returned if no ticks happened.
> A quick test program, shows timerfd working correctly on my amd64 box:
> 
> http://www.xmailserver.org/timerfd-test.c
> 

Why did you ignore the existing POSIX timer API?

-- 
Nicholas Miell <nmiell@comcast.net>

