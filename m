Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZGRM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZGRM6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZGRM6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:58:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZGRM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:58:48 -0400
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
From: Peter Zijlstra <peterz@infradead.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>,
       stable@kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <1247864134.17553.30.camel@localhost.localdomain>
References: <20090717121545.489258927@linutronix.de>
	 <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins>
	 <20090717152235.GA5878@count0.beaverton.ibm.com>
	 <1247849254.6522.75.camel@laptop>
	 <1247864134.17553.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 14:56:31 +0200
Message-Id: <1247921791.6597.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 15:55 -0500, Nathan Lynch wrote:
> On Fri, 2009-07-17 at 18:47 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-07-17 at 08:22 -0700, Matt Helsley wrote:
> > 
> > > The job scheduler in question does not use FROZEN as a transient state and
> > > does not use checkpoint/restart at all since c/r is still a work in progress.
> 
> Right, the job scheduler uses the cgroup freezer as a mechanism to
> preempt a low priority job for a higher priority job.  (It had used
> SIGSTOP in the past.)  So in this scenario a frozen cgroup may remain in
> that state for a while.  Load average is consulted as a measure of
> system utilization.

I think that this is an utterly broken use for it, if you want something
like that make a signal cgroup or something and deliver SIGSTOP to all
of them.

In other words, why is the freezer any better than the SIGSTOP approach?

> > > Even when used for power management it seems wrong to count frozen tasks
> > > towards the loadavg since they aren't using CPU time or waiting for IO.
> > 
> > You're abusing it for _WHAT_?
> 
> I think Matt was referring to system-wide suspend/resume/hibernate, not
> a behavior of the job scheduler, if that's your concern.

I understood he referred to the crazy use-case you mentioned above, IMHO
frozen should be a temporary state used for things like
snapshot/migrate.

I'm still very tempted to plain simply revert that original patch.

