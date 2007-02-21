Return-Path: <linux-kernel-owner+w=401wt.eu-S1422754AbXBUSNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754AbXBUSNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422756AbXBUSNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:13:47 -0500
Received: from www.osadl.org ([213.239.205.134]:46392 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422755AbXBUSNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:13:46 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172079523.8577.48.camel@imap.mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 19:18:51 +0100
Message-Id: <1172081931.25076.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 09:38 -0800, Daniel Walker wrote:
> > > 
> > > Could be the switch over then which confuses the NMI . 
> > 
> > Why? The switch just stops the PIT/HPET. It does not fiddle with IO_APIC
> > and friends at all.
> 
> I'm not an expert on the io-apic, but the check_timer() function seemed
> to assume IRQ0 was happening regularly ..

Again: 

check_timer() is called _BEFORE_ we even touch the local APIC timers. At
this point PIT/HPET _IS_ firing IRQ0 with HZ frequency.

> Well, I'm pretty sure it's HRT, cause in prior versions this only
> happened when HRT is enabled. Then you guys went to the lapic all the
> time, and now this is happening all the time ..

The NMI is stuck:

                if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
                        printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
                                cpu,
                                prev_nmi_count[cpu],
                                nmi_count(cpu));

This has nothing to do with jiffies.

There have been a bunch of changes in arch/i386/kernel/nmi.c as well. 

> You can't reproduce this?

Nope.

Also all my machines emit something like:
"ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])"

In your boot log nothing to see.

	tglx


