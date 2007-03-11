Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbXCKXNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbXCKXNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXCKXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:13:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32864 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599AbXCKXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:13:38 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Mar 2007 16:13:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
In-Reply-To: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
Message-ID: <Pine.LNX.4.64.0703111610360.4936@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Davide Libenzi wrote:

> This patch introduces a new system call for timers events delivered
> though file descriptors. This allows timer event to be used with
> standard POSIX poll(2), select(2) and read(2). As a consequence of
> supporting the Linux f_op->poll subsystem, they can be used with
> epoll(2) too.
> The system call is defined as:
> 
> int timerfd(int ufd, int clockid, int tmrtype, const struct timespec *utmr);
> 
> The "ufd" parameter allows for re-use (re-programming) of an existing
> timerfd w/out going through the close/open cycle (same as signalfd).
> If "ufd" is -1, s new file descriptor will be created, otherwise the
> existing "ufd" will be re-programmed.
> The "clockid" parameter is either CLOCK_MONOTONIC or CLOCK_REALTIME.
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

Duh! Forgot to update the documenation. Now timerfd() gets an itimerspec.
For TFD_TIMER_REL only the it_interval is valid, and it's the relative 
time. For TFD_TIMER_ABS, only the it_value is valid, and that the expiry 
absolute time. For TFD_TIMER_SEQ, it_value tells when the first tick 
should be generated, and it_interval tells the period of the following 
ticks.



- Davide

