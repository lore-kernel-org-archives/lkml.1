Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXKTRMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXKTRMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXKTRM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:12:26 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:65017 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbXKTRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:12:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPKjQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 12:02:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Message-ID: <20071120170222.GB31044@Krystal>
References: <20071113185800.436425570@polymtl.ca> <200711191011.18634.rusty@rustcorp.com.au> <20071119142803.GA19301@Krystal> <200711201006.34954.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200711201006.34954.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:54:55 up 16 days, 22:00,  6 users,  load average: 0.93, 1.06,
	1.03
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tuesday 20 November 2007 01:28:03 Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > I think it would be easier to just fast-path the num_online_cpus == 1
> > > case, even if you want to keep this "update_early" interface.
> >
> > Nope, that could lead to problems. I call core_immediate_update()
> > _very_ early, before boot_cpu_init() is called.
> 
> Ah, I see the problem.  It would in fact be clearer for us to move 
> boot_cpu_init() up to just after smp_setup_processor_id() in start_kernel 
> anyway, not just for this code, but in general.
> 

Could be done.

> > Therefore, 
> > cpu_online_map is not set yet. I am not sure the benefit of using
> > num_online_cpus outweights the added fragility wrt other boot process
> > initializations.
> 
> I think it's still a win, though worth a comment that we always go via the 
> non-IPI path for the early boot case.
> 

Ok, another potential problem then :

If we fast-path the num_online_cpus == 1, then updates done after the
boot process will have to go through this code. Therefore, we would have
to disable interrupts in the early boot code.

However, I doubt it is safe to use the paravirtualized
local_irq_disable/enable before the paravirt code is executed ?

Mathieu

> Cheers,
> Rusty.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
