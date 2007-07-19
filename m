Return-Path: <linux-kernel-owner+w=401wt.eu-S965789AbXGSTUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965789AbXGSTUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXGSTUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:20:03 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:28857 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765193AbXGSTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:20:00 -0400
Subject: Re: [PATCH] virtual sched_clock() for s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
In-Reply-To: <20070719160025.GA31815@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain>
	 <469F8342.7060000@goop.org>  <20070719160025.GA31815@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 19:20:21 +0000
Message-Id: <1184872821.5516.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 18:00 +0200, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > >  /*
> > > - * Monotonic_clock - returns # of nanoseconds passed since time_init()
> > > + * Scheduler clock - returns current time in nanosec units.
> > > + * Now based on virtual cpu time to only account time the guest
> > > + * was actually running.
> > 
> > Runn*ing*?  Does it include time the VCPU spends idle/blocked?  If 
> > not, then the scheduler won't be able to tell how long a process has 
> > been asleep.  Maybe this doesn't matter (I had this problem in a 
> > version of Xen's sched_clock, and I can't say I saw an ill effects 
> > from it).

No, it does not include idle time, if we're going idle the cpu timer
gets stopped.

> CFS does measure time elapsed across task-sleep periods (and does 
> something similar to what the old scheduler's 'sleep average' 
> interactivity mechanism did), but that mechanism measures "time spent 
> running during sleep", not "time spent idling".
> 
> still, CFS needs time measurement across idle periods as well, for 
> another purpose: to be able to do precise task statistics for /proc. 
> (for top, ps, etc.) So it's still true that sched_clock() should include 
> idle periods too.

I'm not sure, s390 already has an implemetation for precise accounting
in the architecture code, does CFS also improve accounting data? 

Jan

