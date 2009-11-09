Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZKIOQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZKIOQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZKIOQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:16:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:50235 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755944AbZKIOQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:16:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX190N6R1OXd0j0U3mUn2xj4BjrB1qbHU+x+MZcE2Cy
	Y2iIrbBLWEzh2K
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl>
	 <20091109120217.GB18399@elte.hu> <200911091324.37955.rjw@sisk.pl>
	 <20091109124937.GA21114@elte.hu>
	 <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 15:16:16 +0100
Message-Id: <1257776176.6365.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 15:02 +0100, Thomas Gleixner wrote:
> On Mon, 9 Nov 2009, Ingo Molnar wrote:
> > 

> > ok, then my observation should not apply.
> 
> I think it _IS_ releated because the worker_thread is CPU affine and
> the debug_smp_processor_id() check does:
> 
>     if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
> 
> which prevents that usage of smp_processor_id() in ksoftirqd and
> keventd in preempt enabled regions is warned on.
> 
> We saw exaclty the same back trace with fd21073 (sched: Fix affinity
> logic in select_task_rq_fair()).
> 
> Rafael, can you please add a printk to debug_smp_processor_id() so we
> can see on which CPU we are running ? I suspect we are on the wrong
> one.

I wonder if that's not intimately related to the problem I had, namely
newidle balancing offline CPUs as they're coming up, making a mess of
cpu enumeration.

	-Mike

