Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZGQUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZGQUzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZGQUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:55:48 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:40841 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbZGQUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:55:48 -0400
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
From: Nathan Lynch <ntl@pobox.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>,
       stable@kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <1247849254.6522.75.camel@laptop>
References: <20090717121545.489258927@linutronix.de>
 <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins>
 <20090717152235.GA5878@count0.beaverton.ibm.com>
 <1247849254.6522.75.camel@laptop>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:55:34 -0500
Message-Id: <1247864134.17553.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 3448107A-7314-11DE-A738-F699A5B33865-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 18:47 +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-17 at 08:22 -0700, Matt Helsley wrote:
> 
> > The job scheduler in question does not use FROZEN as a transient state and
> > does not use checkpoint/restart at all since c/r is still a work in progress.

Right, the job scheduler uses the cgroup freezer as a mechanism to
preempt a low priority job for a higher priority job.  (It had used
SIGSTOP in the past.)  So in this scenario a frozen cgroup may remain in
that state for a while.  Load average is consulted as a measure of
system utilization.

> > Even when used for power management it seems wrong to count frozen tasks
> > towards the loadavg since they aren't using CPU time or waiting for IO.
> 
> You're abusing it for _WHAT_?

I think Matt was referring to system-wide suspend/resume/hibernate, not
a behavior of the job scheduler, if that's your concern.


