Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbXBWUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbXBWUAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbXBWUAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:00:41 -0500
Received: from khc.piap.pl ([195.187.100.11]:50470 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624AbXBWUAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:00:40 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
	<200702212355.25601.s0348365@sms.ed.ac.uk>
	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>
	<m3slcw68vr.fsf@maximus.localdomain> <45DF3628.8060706@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 23 Feb 2007 21:00:38 +0100
In-Reply-To: <45DF3628.8060706@xs4all.nl> (Udo van den Heuvel's message of "Fri, 23 Feb 2007 19:44:56 +0100")
Message-ID: <m3irds63vd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> Description VIA Dual PCI Riser
> The EXT-PCI is a PCI riser card which expands a PCI slot into two PCI slots.
> EXT-PCI slot 1 (lower slot) uses the system resources (Device ID, INT)
> of the PCI slot of the motherboard.

Yep. ID 20, INT D (chipset POV).

> EXT-PCI slot 2 (Upper slot) uses device 19 and INT_A.

Right.

> Upper slot has the problems. TranquilPC does not even respond anymore.
> The lower slot is a copy of the normal (single) PCI slot w.r.t. devcie
> and irq, it has DN20 and irq 20.

Ok.

> dmesg links ALNKA to IRQ 20. So if ALNKA is INTA both PCI cards should
> share IRQ 20?

No. I don't exactly know what these ACPI messages show. Probably they
list some power-up state, before devices are configured. If lspci says
DN20 uses IRQ 20 and DN19 "uses" IRQ16 then that's exactly what they
should use - two different INT/IRQ signals.

If the lspci shows that DN20 uses the same IRQ as IEEE1394 controller
and that DN19 uses the same IRQ as on-board Ethernet and VGA then
that means just that: they share INTs/IRQs (this is especially true
when running in IO-APIC mode).

If lspci shows no IRQ for the device then that DN is not supported
by the BIOS.

I'd try this "aluminum film" trick. Just be careful, shorting wrong
traces can destroy the hardware. As I wrote, shorting the good ones
can make the system (temporarily) unusable.
-- 
Krzysztof Halasa
