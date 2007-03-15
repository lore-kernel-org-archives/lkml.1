Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXCOFY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXCOFY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXCOFY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:24:27 -0400
Received: from ozlabs.org ([203.10.76.45]:36523 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965430AbXCOFYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:24:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17912.55404.556847.350399@cargo.ozlabs.ibm.com>
Date: Thu, 15 Mar 2007 16:23:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
       Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
In-Reply-To: <45F84E39.7030507@goop.org>
References: <45F6D1D0.6080905@goop.org>
	<1173816769.22180.14.camel@localhost>
	<45F70A71.9090205@goop.org>
	<1173821224.1416.24.camel@dwalker1>
	<45F71EA5.2090203@goop.org>
	<45F74515.7010808@vmware.com>
	<45F77C27.8090604@goop.org>
	<45F846AB.6060200@vmware.com>
	<45F84E39.7030507@goop.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge writes:

> Sure.  But on a given machine, the CPUs are likely to be closely enough
> matched that a cycle on one CPU is more or less equivalent to a cycle on
> another CPU.  The fact that a cycle represents a different amount of

A cycle on one thread of a machine with SMT/hyperthreading when the
other thread is idle *isn't* equivalent to a cycle when the other
thread is busy.  We run into this on POWER5, where we have hardware
that counts cycles when each of the two threads in each core gets to
dispatch instructions (on each cycle, one thread or the other gets to
dispatch).  That helps but still doesn't give a totally accurate
estimate of how much computation a given process has managed to do.

> Not at all.  You might have an unimportant but cpu-bound process which
> doesn't merit increasing the cpu speed, but should also be scheduled
> properly compared to other processes.  I often nice my kernel builds
> (which cpufreq takes as a hint to not ramp up the cpu speed) on my
> laptop so to save power.

Just as a side note - that's probably actually a bad strategy; you
almost certainly consume less total energy by running the cpu at full
speed until the build is done and then going to the deepest sleep mode
you can achieve.

> That's true.  But this is a case of the left brain not talking to the
> right brain: cpufreq might decide to slow a cpu down, but the scheduler
> doesn't take that into account.  Making the timebase of sched_clock
> reflect the current cpu speed (or more specifically, the integral of the
> cpu speed over a time interval) is a good way of communicating between
> the two subsystems.

What was the original proposal?  I came into this discussion late...

Paul.
