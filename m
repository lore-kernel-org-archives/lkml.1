Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYFRW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYFRW0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYFRW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:26:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYFRW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:26:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/6] x86: add c1e aware idle function
Date: Thu, 19 Jun 2008 00:27:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20080610171639.551369443@linutronix.de> <200806190004.12235.rjw@sisk.pl> <alpine.LFD.1.10.0806190012420.3395@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0806190012420.3395@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190027.39749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 19 of June 2008, Thomas Gleixner wrote:
> On Thu, 19 Jun 2008, Rafael J. Wysocki wrote:
> > On Wednesday, 18 of June 2008, Thomas Gleixner wrote:
> > > On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:
> > > > On Wednesday, 18 of June 2008, Pavel Machek wrote:
> > > > > On Thu 2008-06-12 10:29:00, Thomas Gleixner wrote:
> > > > > > C1E on AMD machines is like C3 but without control from the OS. Up to
> > > > > > now we disabled the local apic timer for those machines as it stops
> > > > > > when the CPU goes into C1E. This excludes those machines from high
> > > > > > resolution timers / dynamic ticks, which hurts especially the X2 based
> > > > > > laptops.
> > > > > > 
> > > > > > The current boot time C1E detection has another more serious flaw:
> > > > > > some BIOSes do not enable C1E until the ACPI processor module is
> > > > > > loaded. This causes systems to stop working after that point.
> > > > > > 
> > > > > > To work nicely with C1E enabled machines we use a separate idle
> > > > > > function, which checks on idle entry whether C1E was enabled in the
> > > > > > Interrupt Pending Message MSR. This allows us to do timer broadcasting
> > > > > 
> > > > > Entering idle is quite a common operation, and reading MSR is quite
> > > > > slow. Is it possible to do better here?
> > > > > 
> > > > > What happens if ACPI BIOS toggles MSR on all cpus *while* we are
> > > > > entering idle? This seems inherently racy...
> > > 
> > > Well, on most of the machines we see the C1E bit on the first idle
> > > entry either on CPU0 or on CPU1.
> > > 
> > > I know of exactly one machine which has the C1E thing enabled late
> > > when the ACPI stuff runs.
> > >  
> > > > Yes, and that fits the picture I'm observing on the nx6325 (see the
> > > > "linux-next: Tree for June 13: IO APIC breakage on HP nx6325" thread).
> > > 
> > > Hmm, when is the C1E detected on current mainline ? Does the boot CPU
> > > have it or is it when the second CPU comes up ?
> > 
> > How can I check that?
> 
> When the boot cpu has it then it prints:
> 
> "Disabling APIC timer"

It does that.

> when the secondary CPU has it then it prints:
> 
> "AMD C1E detected late. Force timer broadcast."
> 
> Current mainline does not check for the late ACPI case so I'm pretty
> sure that on your box it is detected during early boot way before we
> can switch to highres/dyntick.

Yes, that's the case.

Thanks,
Rafael
