Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZKIOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZKIOZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZKIOZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:25:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZKIOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:25:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 15:27:12 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain> <1257776176.6365.8.camel@marge.simson.net>
In-Reply-To: <1257776176.6365.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091527.12249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Mike Galbraith wrote:
> On Mon, 2009-11-09 at 15:02 +0100, Thomas Gleixner wrote:
> > On Mon, 9 Nov 2009, Ingo Molnar wrote:
> > > 
> 
> > > ok, then my observation should not apply.
> > 
> > I think it _IS_ releated because the worker_thread is CPU affine and
> > the debug_smp_processor_id() check does:
> > 
> >     if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
> > 
> > which prevents that usage of smp_processor_id() in ksoftirqd and
> > keventd in preempt enabled regions is warned on.
> > 
> > We saw exaclty the same back trace with fd21073 (sched: Fix affinity
> > logic in select_task_rq_fair()).
> > 
> > Rafael, can you please add a printk to debug_smp_processor_id() so we
> > can see on which CPU we are running ? I suspect we are on the wrong
> > one.
> 
> I wonder if that's not intimately related to the problem I had, namely
> newidle balancing offline CPUs as they're coming up, making a mess of
> cpu enumeration.

Very likely.  What did you do to fix it?

Rafael
