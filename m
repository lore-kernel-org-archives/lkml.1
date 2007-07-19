Return-Path: <linux-kernel-owner+w=401wt.eu-S939171AbXGSPi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939171AbXGSPi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094AbXGSPiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:38:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58923 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765639AbXGSPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:38:49 -0400
Date: Thu, 19 Jul 2007 21:18:20 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
Message-ID: <20070719154820.GM2216@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1184842661.6546.14.camel@localhost.localdomain> <469F8342.7060000@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F8342.7060000@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 08:29:06AM -0700, Jeremy Fitzhardinge wrote:
> > - * Monotonic_clock - returns # of nanoseconds passed since time_init()
> > + * Scheduler clock - returns current time in nanosec units.
> > + * Now based on virtual cpu time to only account time the guest
> > + * was actually running.
> >   
> 
> Runn*ing*?  Does it include time the VCPU spends idle/blocked?  If not,
> then the scheduler won't be able to tell how long a process has been
> asleep.

Good point ..

I think we need a measure of both virtual and real time here - 
virtual for accounting task-execution time and real for
accounting sleep (and perhaps rq-wait?) time.

>  Maybe this doesn't matter (I had this problem in a version of
> Xen's sched_clock, and I can't say I saw an ill effects from it).

I guess it will show up as some corner case behaviour, which people are
yet to discover on virtual env.

-- 
Regards,
vatsa
