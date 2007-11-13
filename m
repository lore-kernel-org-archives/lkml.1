Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbXKMUsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbXKMUsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXKMUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:47:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818AbXKMUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:47:50 -0500
Date: Tue, 13 Nov 2007 12:46:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-Id: <20071113124656.3c333bdd.akpm@linux-foundation.org>
In-Reply-To: <200711131122.45950.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
	<200711121726.39263.david-b@pacbell.net>
	<20071113093414.GA5270@elte.hu>
	<200711131122.45950.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 11:22:45 -0800 David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 13 November 2007, Ingo Molnar wrote:
> > 
> > * David Brownell <david-b@pacbell.net> wrote:
> > 
> > > > > I speculate that either the design has changed (without fanfare), 
> > > > > or else that stuff is in RT kernels and has not yet gone upstream.
> > > > 
> > > > Well whatever.  We shouldn't have to resort to caller-side party 
> > > > tricks like this to get acceptable performance.
> > > 
> > > I'd be happy if, as originally presented, it were possible to just 
> > > pass a raw_spinlock_t to spin_lock_irqsave() and friends.
> > 
> > that's a spinlock type abstraction of PREEMPT_RT, not of mainline.
> 
> Any reason that stuff shouldn't move into mainline?
> 
> 
> > 	 Why do you want to use raw_spinlock_t?
> 
> Already answered elsewhere in this thread ...

Can't say I really understood the answer.  I don't think we actually know
where all of this extra time is being spent?

> I'll highlight the
> point that such bitops shouldn't be preemption points.

Disagree.  *everything* should be a preemption point.  For
internal-implementation details we do need to disable preemtion sometimes
(to prevent deadlocks and to protect per-cpu resources).  But those
preemption-off periods should be minimised.

