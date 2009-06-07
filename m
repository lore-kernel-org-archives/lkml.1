Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZFGKLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZFGKLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZFGKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:11:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZFGKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:11:41 -0400
Date: Sun, 7 Jun 2009 12:11:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, Second try
Message-ID: <20090607101136.GL31286@elte.hu>
References: <20090529083840.GA15516@omega> <20090605115410.GA16008@elte.hu> <20090605145541.GB19690@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605145541.GB19690@tango.0pointer.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lennart Poettering <mzxreary@0pointer.de> wrote:

> On Fri, 05.06.09 13:54, Ingo Molnar (mingo@elte.hu) wrote:
> 
> > 
> > 
> > * Lennart Poettering <mzxreary@0pointer.de> wrote:
> > 
> > > Why expose this via sched_setscheduler() and not other syscalls 
> > > such as prctl() or sched_setparam()?
> > > 
> > > prctl() does not take a pid parameter. Due to that it would be 
> > > impossible to modify this flag for other processes than the 
> > > current one.
> > > 
> > > The struct passed to sched_setparam() can unfortunately not be 
> > > extended without breaking compatibility, since sched_setparam() 
> > > lacks a size parameter.
> > 
> > Well, it could be extended, if we wanted to. Right now 
> > sched_priority has a valid value of 0 to 100. We could introduce 
> > a new value '-1' to mean: 'extended struct sched_param'.
> > 
> > A new getparam syscall could then be introduced - only used by 
> > new user-space.
> 
> The man page of sched_getparam() is pretty explicit in that the 
> sched_priority field of the struct must lie between 
> sched_get_priority_min() and sched_get_priority_max(). If you'd 
> overload sched_priority like this you might end up breaking 
> applications that rely on this, for example RT watchdogs that go 
> through /proc and query the scheduling parameters of all threads.

Only the new sched_gtparam syscall would do this - and that syscall 
would have to be propagated to glibc and user-space with appropriate 
care of course. (probably resulting in a separate function not a 
change/breakage of existing functionality)

Probably not worth the pain though.

	Ingo
