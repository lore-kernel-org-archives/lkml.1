Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXBWSpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXBWSpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbXBWSpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:45:00 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1605 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbXBWSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:44:59 -0500
Message-ID: <45DF3628.8060706@xs4all.nl>
Date: Fri, 23 Feb 2007 19:44:56 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>	<20070221224027.GK22464@csclub.uwaterloo.ca>	<200702212355.25601.s0348365@sms.ed.ac.uk>	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl> <m3slcw68vr.fsf@maximus.localdomain>
In-Reply-To: <m3slcw68vr.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> I will try a different case with a different dual PCI riser card soon.
>> This Morex riser has DN20-31 or so, so more options.
> 
> OTOH I wonder how do they use DN 21-31? The board uses lines AD11 to AD31
> (21 lines) for selecting devices #0 - #20. 32-bit PCI bus has only 32
> address/data lines :-)
> 
> Perhaps they mean AD20-AD31 lines = device #9 - #0x14=20? If that is
> the case, you can try:
> - their "DN30" = device 0x13 = 19, which is apparently what the VIA riser
>   card does,
> - their "DN21" = device 0xA = 10, which could work as well.
> 
> I'm afraid both would require (different) soldering.

My dmesg says:

ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.

lspci -v says:

00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1155
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdffb000 (32-bit, non-prefetchable) [size=512]

Does this provide additional info to you?

http://www.itx-warehouse.co.uk/Product.aspx?ProductID=410 says:

Description VIA Dual PCI Riser
The EXT-PCI is a PCI riser card which expands a PCI slot into two PCI slots.
EXT-PCI slot 1 (lower slot) uses the system resources (Device ID, INT)
of the PCI slot of the motherboard.
EXT-PCI slot 2 (Upper slot) uses device 19 and INT_A.

Upper slot has the problems. TranquilPC does not even respond anymore.
The lower slot is a copy of the normal (single) PCI slot w.r.t. devcie
and irq, it has DN20 and irq 20.
dmesg links ALNKA to IRQ 20. So if ALNKA is INTA both PCI cards should
share IRQ 20?

