Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXK0Oak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXK0Oak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXK0Oac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:30:32 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4994 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbXK0Oac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:30:32 -0500
Date: Tue, 27 Nov 2007 09:28:26 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@redhat.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071127142826.GB31376@hmsreliant.think-freely.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711271445.56792.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:45:56PM +0100, Andi Kleen wrote:
> his is any less reliable that what we have currently.
> > 
> > It doesn't make things more reliable, and it adds code to a code path
> > that already has to much code to be solid reliable (thus your
> > problem). 
> > 
> > Putting the system back in PIC legacy mode on the kexec on panic path
> > was supposed to be a short term hack until we could remove the need
> > by always deliver interrupts in apic mode.
> > 
> > If you can't root cause your problem and figure out how the apics
> > are misconfigured for legacy mode
> 
> Probably legacy mode always routes to CPU #0. Makes sense and is
> not really a misconfiguration of legacy mode.
> 
> But if CPU #0 has interrupts disabled no interrupts get delivered.
> 
> So choices are:
> - Move to CPU #0
> - Do not use legacy mode during shutdown.
> - Or do not rely on interrupts after enabling legacy mode
> - Or do not disable interrupts on the other CPUs when they're
> halted.
> 
> First and last option are probably unreliable for the kdump case.
> Second or third sound best. 
> 

Not sure if this is applicable, but I assume not relying on interrupts in legacy
mode would be equivalent to specifying irqpoll on the kdump kernel command line?
If so, there seems to be a problem with that solution, as doing so still results
in the same hang on the system in question.


As for solution 2, that brings me to my previous question.  Is that really as
simple as just not moving the apic to legacy mode?  It would seem some
additional programming would be in order to route the interrupt in question to
the proper cpu.

Regards
Neil

> I suspect the real fix would be to enable IOAPIC mode really
> early and never use the timers in legacy mode. Then the kdump
> kernel wouldn't care about the legacy mode pointing to the wrong CPU.
> 
> IIrc Eric even had  a patch for that a long time ago, but it broke some 
> things so it wasn't included. But perhaps it should be revisited.
> 
> -Andi
