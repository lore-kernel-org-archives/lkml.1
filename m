Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbXK2KUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbXK2KUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbXK2KUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:20:25 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:58417 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773AbXK2KUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:20:23 -0500
From: Frans Pop <elendil@planet.nl>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Trailing periods in kernel messages (was: [PATCH 6/6] tick: add a missing dot in prink)
Date: Thu, 29 Nov 2007 11:20:18 +0100
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org
References: <474E6BD0.20103@cn.fujitsu.com> <E1IxfE8-0000Sr-9w@faramir.fjphome.nl> <474E8669.6060409@cn.fujitsu.com>
In-Reply-To: <474E8669.6060409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711291120.19595.elendil@planet.nl>
X-OriginalArrivalTime: 29 Nov 2007 10:20:21.0931 (UTC) FILETIME=[72D4EFB0:01C83271]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007, Li Zefan wrote:
> Frans Pop wrote:
> > Li Zefan wrote:
> >> Add a missing '.' in prink information.
> >> -			printk(" no tick device\n");
> >> +			printk(" no tick device.\n");
> >
> > I wonder if that is correct. CodingStyle says:
> >                 Chapter 13: Printing kernel messages
> >    [...]
> >    Kernel messages do not have to be terminated with a period.
> >
> > I personally think that rule could be made a bit stricter as for
> > example dmesg output currently looks fairly inconsistent with some
> > messages terminated with a period while most messages are not and have
> > been wondering if I should file patches to _remove_ periods.
> >
> > Maybe the rule should be changed to:
> >    Kernel messages should not be terminated with a period, unless a
> >    single message contains multiple sentences.
> > ?
>
> But why a kernel message should not be terminated with a period?

Exactly because kernel messages are in general _not_ sentences.
IMO trailing periods

> It does no harm at all.

Well, for one it needlessly increases the size of log files.
It also IMO just looks weird to have a trailing period only for some 
messages and it certainly is completely inappropriate for messages like:
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[...]
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 7F6FDE48, 0058 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)

If I look at my current dmesg output, *only* 16 out of 543 line have a 
trailing period, and in almost all cases they just looks out of place. See 
some examples at the bottom of this mail.

> And if the message is a complete sentence, it's grammatical correct to
> terminated with a period. 

Exactly why I make an exception for those in my proposal.

> I think CodingStyle just says an ending period is not mandatory. It does
> not discourage the ending period.

I feel that to improve consistency the CodingStyle should be clear about 
when a period should and should not be used.


Some examples of IMO unneeded/inconsistent use of trailing periods:
Entering add_active_range(0, 521983, 521984) 3 entries of 3200 used
end_pfn_map = 521984
DMI 2.3 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[...]
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
[...]
hpet clockevent registered
TSC calibrated against HPET
time.c: Detected 3199.880 MHz processor.
Console: colour dummy device 80x25
[...]
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[...]
pnp: the driver 'i8042 kbd' has been unregistered
pnp: the driver 'i8042 aux' has been unregistered
PNP: No PS/2 controller found. Probing ports directly.
[...]
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI-GART: No AMD northbridge found.

The last example shows the inconsistency very well. And in this case the 
second line could easily be "reduced" to a regular message by using a 
semicolon instead of a period between the "sentences".
This is already being done in a number of other messages, for example:
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx

So I'd suggest to change those last three lines to (including some textual 
improvements):
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq"; if that helps, please 
post a report
PCI-GART: No AMD northbridge found
