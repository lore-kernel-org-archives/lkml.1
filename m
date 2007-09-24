Return-Path: <linux-kernel-owner+w=401wt.eu-S1764700AbXIXQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764700AbXIXQ7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbXIXQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:59:10 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:52648 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762170AbXIXQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:59:08 -0400
Date: Mon, 24 Sep 2007 12:59:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: MAX_LOCKDEP_SUBCLASSES too low in 2.6.23-rc7-mm1
Message-ID: <20070924165903.GA24220@Krystal>
References: <20070924160358.GA19736@Krystal> <20070924183759.085d901c@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924183759.085d901c@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:57:00 up 56 days, 17:15,  4 users,  load average: 7.62, 3.93, 1.98
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 24 Sep 2007 12:03:58 -0400 Mathieu Desnoyers
> <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Ingo,
> > 
> > I got the following printk when booting 2.6.23-rc7-mm1 :
> > 
> > BUG: MAX_LOCKDEP_SUBCLASSES too low!
> > turning off the locking correctness validator.
> > 
> > Is it known/correct situation ?
> 
> Known, bug in r/o mounts code:
> 
> > static void lock_and_coalesce_cpu_mnt_writer_counts(void)
> > {
> > 	int cpu;
> > 	struct mnt_writer *cpu_writer;
> > 
> > 	for_each_possible_cpu(cpu) {
> > 		cpu_writer = &per_cpu(mnt_writers, cpu);
> > 		spin_lock_nested(&cpu_writer->lock, 42);
> > 		                                   ^^^^
> > 

How could the Ultimate Answer be wrong ? ;)

Cheers,

Mathieu

> > What the heck is going on? Given that MAX_LOCKDEP_SUBCLASSES is only 8,
> > this reliably turns off lockdep at boot.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
