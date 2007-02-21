Return-Path: <linux-kernel-owner+w=401wt.eu-S1422767AbXBUSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422767AbXBUSZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422768AbXBUSZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:25:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:21023 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422767AbXBUSZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:25:31 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172081931.25076.95.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 10:23:20 -0800
Message-Id: <1172082200.8577.56.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 19:18 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 09:38 -0800, Daniel Walker wrote:
> > > > 
> > > > Could be the switch over then which confuses the NMI . 
> > > 
> > > Why? The switch just stops the PIT/HPET. It does not fiddle with IO_APIC
> > > and friends at all.
> > 
> > I'm not an expert on the io-apic, but the check_timer() function seemed
> > to assume IRQ0 was happening regularly ..
> 
> Again: 
> 
> check_timer() is called _BEFORE_ we even touch the local APIC timers. At
> this point PIT/HPET _IS_ firing IRQ0 with HZ frequency.

Right, but eventually there isn't a regular timer interrupt through the
io-apic. I don't think in the past IRQ0 stops without the system
crashing, so check_timer() could assume the timer (IRQ0) is _always_
regular.

do you know what the requirement are for routing the NMI through the
io-apic? 

> > Well, I'm pretty sure it's HRT, cause in prior versions this only
> > happened when HRT is enabled. Then you guys went to the lapic all the
> > time, and now this is happening all the time ..
> 
> The NMI is stuck:
> 
>                 if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
>                         printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
>                                 cpu,
>                                 prev_nmi_count[cpu],
>                                 nmi_count(cpu));
> 
> This has nothing to do with jiffies.

I think it has to do with IRQ0 . Did I mention this doesn't happen in
2.6.20 .

> There have been a bunch of changes in arch/i386/kernel/nmi.c as well. 
> 
> > You can't reproduce this?
> 
> Nope.

Do you use nmi_watchdog=1 ?

Daniel

