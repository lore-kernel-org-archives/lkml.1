Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXD1WLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXD1WLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXD1WLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:11:07 -0400
Received: from www.osadl.org ([213.239.205.134]:50374 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161205AbXD1WLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:11:05 -0400
Subject: Re: High Resolution Timer DOS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4633C269.9050806@free.fr>
References: <4633C269.9050806@free.fr>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 00:13:09 +0200
Message-Id: <1177798389.7646.320.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 23:53 +0200, matthieu castet wrote:
> Hi,
> 
> some programs need to do some short of busyloop. It was often 
> implemented as :
> 
> while (1) {
> 	if (can_do_stuff) {
> 		do_stuff();
> 	}
> 	else
> 		//sleep a very short of time
> 		usleep(1);
> }
> 
> usleep(1) or equivalent where used instead of sched_yield, because of 
> some priority issue. IIRC doing sched_yield, make the process appears 
> like an interactive process, so it has better priority and get call more 
> often.
> 
> But now if high res timer are enabled, these programs while cause 
> something like a DOS : the context switch per second will be bigger than 
> 500 000 and the cpu usage will be very high.

Well, it is not really a DoS. The rescheduling of the process is limited
by the scheduler and the available CPU time (depending on the number of
runnable tasks in the system).

>From the spec:

Implementations may place limitations on the granularity of timer
values. For each interval timer, if the requested timer value requires a
finer granularity than the implementation supports, the actual timer
value shall be rounded up to the next supported value.

The !HIGHRES enabled kernel rounds this up to the HZ interval, the
HIGHRES enabled kernel grants the request for this short sleep.

The program gets what it asked for: a stupid sleep value.

	tglx


