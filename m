Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbXIXQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbXIXQto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763877AbXIXQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:46:24 -0400
Received: from www.osadl.org ([213.239.205.134]:39432 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763417AbXIXQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:46:23 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709241718.23526.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709241552.32567.rjw@sisk.pl> <1190643831.4035.209.camel@chaos>
	 <200709241718.23526.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 18:46:20 +0200
Message-Id: <1190652380.4035.236.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 17:18 +0200, Rafael J. Wysocki wrote:
> > > Well, "noacpi" seems to be a synonym for "pci=noacpi".
> > > 
> > > Anyway, it causes acpi_disable_pci() to be executed, which according to
> > > Documentation/kernel-parameters.txt means "Do not use ACPI for IRQ routing or
> > > for PCI scanning" (it works like this on x86_64 too, although the doc says it's
> > > x86_32-specific).
> > 
> > Hrm. The local apic timer calibration does not use anything which is
> > related to interrupts, but if we use the local APIC timer we switch off
> > PIT.
> > 
> > Can you boot Linus latest (w/o hrt patches) and add "apicmaintimer" to
> > the kernel command line please ?
> 
> Works, dmesg attached.

/me scratches head

We know, that
- disabling local apic timers work
- local apic timers (which turn off PIT) work. when noacpiFSCKEDPARSING
is given on the kernel command line.

I have no clue, what might be the difference of noacpiFSCKEDPARSING. The
boot log is not giving any hint at all.

acpi_disable_pci() sets acpi_pci_disabled and acpi_noirq to 1.

What happens, if you set "acpi=noirq" instead ?

	tglx








