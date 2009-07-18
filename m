Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZGSAGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZGSAGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 20:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZGSAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 20:06:07 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:61499 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZGSAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 20:06:07 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 20:06:07 EDT
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
In-Reply-To: <1247921791.6597.5.camel@laptop>
References: <20090717121545.489258927@linutronix.de>
 <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins>
 <20090717152235.GA5878@count0.beaverton.ibm.com>
 <1247849254.6522.75.camel@laptop>
 <1247864134.17553.30.camel@localhost.localdomain>
 <1247921791.6597.5.camel@laptop>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 18:59:55 -0500
Message-Id: <1247961595.5256.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 20A4DE8E-73F7-11DE-8A1C-AEF1826986A2-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 14:56 +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-17 at 15:55 -0500, Nathan Lynch wrote:
> > On Fri, 2009-07-17 at 18:47 +0200, Peter Zijlstra wrote:
> > > On Fri, 2009-07-17 at 08:22 -0700, Matt Helsley wrote:
> > > 
> > > > The job scheduler in question does not use FROZEN as a transient state and
> > > > does not use checkpoint/restart at all since c/r is still a work in progress.
> > 
> > Right, the job scheduler uses the cgroup freezer as a mechanism to
> > preempt a low priority job for a higher priority job.  (It had used
> > SIGSTOP in the past.)  So in this scenario a frozen cgroup may remain in
> > that state for a while.  Load average is consulted as a measure of
> > system utilization.
> 
> I think that this is an utterly broken use for it, if you want something
> like that make a signal cgroup or something and deliver SIGSTOP to all
> of them.
> 
> In other words, why is the freezer any better than the SIGSTOP approach?

Documentation/cgroups/freezer-subsystem.txt happens to document this use
case and the disadvantages of SIGSTOP/SIGCONT.  Does that change your
opinion at all?


> > > > Even when used for power management it seems wrong to count frozen tasks
> > > > towards the loadavg since they aren't using CPU time or waiting for IO.
> > > 
> > > You're abusing it for _WHAT_?
> > 
> > I think Matt was referring to system-wide suspend/resume/hibernate, not
> > a behavior of the job scheduler, if that's your concern.
> 
> I understood he referred to the crazy use-case you mentioned above, IMHO
> frozen should be a temporary state used for things like
> snapshot/migrate.

But snapshot (or checkpoint) and migration aren't possible with mainline
at this time.  As far as I know, the use case to which you object is the
primary use of the cgroup freezer on production systems.


