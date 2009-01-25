Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZAYCNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZAYCNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 21:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZAYCNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 21:13:32 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:49844 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689AbZAYCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 21:13:30 -0500
Subject: Re: [RT] [RFC] simple SMI detector
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Jon Masters <jcm@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Lee Revell <rlrevell@joe-job.com>,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
	 <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
	 <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
Content-Type: text/plain
Organization: Novell
Date: Sun, 25 Jan 2009 13:12:45 +1100
Message-Id: <1232849565.29318.112.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 19:57 -0500, Jon Masters wrote:
> On Sat, 2009-01-24 at 17:30 +0100, Thomas Gleixner wrote:
> > On Fri, 23 Jan 2009, Lee Revell wrote:
> > > 
> > > FYI the RTAI project has a patch to allow disabling of SMI:
> > > 
> > > https://listas.upv.es/pipermail/rtlinuxgpl/2007-April/000609.html
> > 
> > FYI, this patch should be removed from the internet archives and the
> > author should be made liable for the damage which can happen when
> > innocent users try to use it for fixing things which simply can not be
> > fixed.

(given an arbitrary existing hardware platform)

Note however, that in many cases, it is possible - by system vendors -
to modify / update firmware and BIOS implementations.

> 
> Well, we disagree on the remedy there (I personally thing "caveat
> emptor", although European law might well differ in that regard), but I
> think a warning is very much called for, especially where end users are
> concerned. Let's be sure those following along the LKML archives
> understand something:
> 
> 1). You (the end user) don't want to disable SMIs on existing systems.
> 2). Doing so might prevent thermal management software, system
> management software, BIOS implemented fixes, and other components from
> operating.
> 3). BIOS vendors might need to be encouraged to reduce SMI overhead.
> Once systems have been designed to rely on lots of SMI overhead, the
> game has already been lost. No amount of user fiddling will adequately
> fix that.
> 

4. Disabling SMIs and mucking with BIOS code may void your warranty,
cause your circuit breakers to trip, and could interfere with the
operation of your toaster.

> What we are interested in doing with things like smi_detector is
> noticing when there is substantial overhead, so that we can politely ask
> the vendors involved to implement alternative SMI handlers that have
> less of a hit on RT performance - the only real solution involving no
> SMIs is more expensive hardware with dedicated system management/thermal
> management processors.

Some SMI implementations involve dedicated, "embedded" auxiliary
processors and associated firmware, 
others simply exist as BIOS-level implementations.

When the effect of SMI execution governs worst-case task-level or IRQ
latencies on a hardware platform, you may indeed be using the wrong
hardware.

Hardware is subject to the market-driven process, admittedly in some
cases costly, cumbersome and difficult for those constrained by existing
installations and supply-side arrangements.

Latency-friendly SMI implementations may be found in some systems, and
not so much in others.

It should be up to the promotional divisions of the particular hardware
suppliers to assess the market pressure, and to report the performance
advantages of their specific systems.

Worst-case cpu-offlining and other execution-inhibiting system-level
latencies should be required as part of RFP by customers of systems
targeted for real-time, low-latency, and HPC applications.

I envision documentation of these specs, in a similar fashion to the
manner in which CPU clock-cycles are documented for specific instruction
executions - for those systems eligible (certified?) for low-latency
operation.

Broader SMP arrays combined with leveling-off CPU speed, cycle
management seems to be moving back to the fore-front on systems
architecture and design.


> 
> > >> .... disabled SMIs with RTAI code the latencies of cyclictest were
> > >> good, but after about 20 minutes my system stopped working and now
> > >> it does not even boot anymore. :( Any hint?
> > >
> > > Yeah. Buy a new CPU. You deep-fried your P4 because you disabled the
> > > thermal protection.
> > 
> > Aside of this worst case scenario, disabling SMIs is problematic as
> > SMI is used to emulate devices, to fix chip bugs and necessary for
> > enhanced features.
> > 
> > The only reasonable thing you can do on a SMI plagued system is to
> > identify the device which makes use of SMIs. Legacy ISA devices and
> > USB are usually good candidates. If that does not help, don't use it
> > for real-time :)
> 
> Indeed. This is why I wrote an smi_detector that sits in kernel space
> and can be reasonably sure measured discrepancies are attributable to
> SMI behavior. We want to log and detect such things before RT systems
> are deployed, not have users actively trying to work around SMI overhead
> after the fact.
> 


Enterprise Distros (IMO) bear the responsibility to raise awareness of
these issues, and stand firm to relentlessly call for open specs and
open implementation.

Providing benchmarking tools is definitely an excellent step in that
direction (imo) - thanks.

Regards,

Sven


> Jon.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

