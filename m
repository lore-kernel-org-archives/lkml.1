Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbXGSPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbXGSPaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765495AbXGSPaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:30:04 -0400
Received: from gw.goop.org ([64.81.55.164]:49075 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbXGSPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:30:00 -0400
Message-ID: <469F8342.7060000@goop.org>
Date: Thu, 19 Jul 2007 08:29:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jan Glauber <jang@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       vatsa@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
References: <1184842661.6546.14.camel@localhost.localdomain>
In-Reply-To: <1184842661.6546.14.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Glauber wrote:
> This patch introduces a cpu time clock for s390 (only ticking
> if the virtual cpu is running) and bases the s390 implementation
> of sched_clock() on it.
>
> The times lice length on a virtual cpu can be anything
> between the calculated time slice and zero. In reality
> this doesn't seem to be problem, since the scheduler is fair
> enough to not let a single process starve but the current
> implementation can lead to inefficient short time slices.
>
> By providing a 'virtual' sched_clock() we guarantee that a
> process can get its time slice regardless of scheduling
> decisions from the hypervisor.
>
> Patch applies to 2.6.22 git and works fine with CFS.
>   

The Xen sched_clock implementation is very similar, and it seems to work
well.

>  /*
> - * Monotonic_clock - returns # of nanoseconds passed since time_init()
> + * Scheduler clock - returns current time in nanosec units.
> + * Now based on virtual cpu time to only account time the guest
> + * was actually running.
>   

Runn*ing*?  Does it include time the VCPU spends idle/blocked?  If not,
then the scheduler won't be able to tell how long a process has been
asleep.  Maybe this doesn't matter (I had this problem in a version of
Xen's sched_clock, and I can't say I saw an ill effects from it).

    J
