Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbXIXS53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbXIXS53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbXIXS5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:57:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbXIXS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:57:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Mon, 24 Sep 2007 21:11:06 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709241718.23526.rjw@sisk.pl> <1190652380.4035.236.camel@chaos>
In-Reply-To: <1190652380.4035.236.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709242111.07806.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 September 2007 18:46, Thomas Gleixner wrote:
> On Mon, 2007-09-24 at 17:18 +0200, Rafael J. Wysocki wrote:
> > > > Well, "noacpi" seems to be a synonym for "pci=noacpi".
> > > > 
> > > > Anyway, it causes acpi_disable_pci() to be executed, which according to
> > > > Documentation/kernel-parameters.txt means "Do not use ACPI for IRQ routing or
> > > > for PCI scanning" (it works like this on x86_64 too, although the doc says it's
> > > > x86_32-specific).
> > > 
> > > Hrm. The local apic timer calibration does not use anything which is
> > > related to interrupts, but if we use the local APIC timer we switch off
> > > PIT.
> > > 
> > > Can you boot Linus latest (w/o hrt patches) and add "apicmaintimer" to
> > > the kernel command line please ?
> > 
> > Works, dmesg attached.
> 
> /me scratches head

Retested.

> We know, that
> - disabling local apic timers work

This works reproducibly accross the board.

> - local apic timers (which turn off PIT) work. when noacpiFSCKEDPARSING

This stopped working, although it evidently worked yesterday (wtf?).

There seems to be a history effect in the box, to make things more
"interesting".

> is given on the kernel command line.
> 
> I have no clue, what might be the difference of noacpiFSCKEDPARSING. The
> boot log is not giving any hint at all.
> 
> acpi_disable_pci() sets acpi_pci_disabled and acpi_noirq to 1.
> 
> What happens, if you set "acpi=noirq" instead ?

That obviously doesn't help.

I think the only solid data point so far is that "noapictimer" makes the box
boot.

Greetings,
Rafael
