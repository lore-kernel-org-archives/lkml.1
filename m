Return-Path: <linux-kernel-owner+w=401wt.eu-S939287AbXGSQEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939287AbXGSQEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965022AbXGSQDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:03:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964964AbXGSQDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:03:51 -0400
Date: Thu, 19 Jul 2007 18:00:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com, efault@gmx.de,
       dmitry.adamushko@gmail.com, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
Message-ID: <20070719160025.GA31815@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain> <469F8342.7060000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F8342.7060000@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >  /*
> > - * Monotonic_clock - returns # of nanoseconds passed since time_init()
> > + * Scheduler clock - returns current time in nanosec units.
> > + * Now based on virtual cpu time to only account time the guest
> > + * was actually running.
> 
> Runn*ing*?  Does it include time the VCPU spends idle/blocked?  If 
> not, then the scheduler won't be able to tell how long a process has 
> been asleep.  Maybe this doesn't matter (I had this problem in a 
> version of Xen's sched_clock, and I can't say I saw an ill effects 
> from it).

CFS does measure time elapsed across task-sleep periods (and does 
something similar to what the old scheduler's 'sleep average' 
interactivity mechanism did), but that mechanism measures "time spent 
running during sleep", not "time spent idling".

still, CFS needs time measurement across idle periods as well, for 
another purpose: to be able to do precise task statistics for /proc. 
(for top, ps, etc.) So it's still true that sched_clock() should include 
idle periods too.

	Ingo
