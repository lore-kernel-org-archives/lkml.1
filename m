Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXGMFoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXGMFoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXGMFoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:44:46 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27429 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXGMFop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:44:45 -0400
Date: Thu, 12 Jul 2007 23:16:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IRQ problem with IO-APIC and plx9056-based data capture board
In-reply-to: <fa./9tH2heH0uDqxsn6huoSdfG/KVs@ifi.uio.no>
To: Brett Boren <brett.boren@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46970AAB.8050102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./9tH2heH0uDqxsn6huoSdfG/KVs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brett Boren wrote:
> I have a plx9056-based data capture board that works with the winXP
> drivers (based off of the win32 plx sdk) but does not work with the
> linux driver provided to me. The board constitently gets 0xa (IRQ 10)
> in the INTERRUPT_LINE register but the IO-APIC reports IRQ 49 to the

You should not be looking at PCI_INTERRUPT_LINE at all. That is set by 
the BIOS and applies only for XT-PIC interrupt routing, not for IOAPIC. 
It is not necessarily relevant to the interrupt numbers used by Linux at 
all.

> kernel. To add to the confusion when an interrupt is triggered it
> arrives on IRQ 17 causing an irq disable. When run with `noapic` on
> the kernel bootline a consistent irq 10 is observed and the driver
> behaves correctly. When `irqpoll` is given the driver behaves
> correctly(kernel complains about irq 10 being the registered irq
> handler) though it causes other kernel problems. The following options
> have been tried in isolation with no success: pci=nommconf; pci=conf2
> (noboot); acpi=bigsmp; pci=routeirq (kernel output changes, but no
> change in behavior); pci=noacpi acpi=noirq (seems identical to
> pci=routeirq); acpi=irq_balance; apic=debug.
> 
> I'm running primarily in a Dell precision 370n workstation with 3
> PCI-X slots. The irq reported in by the IO-APIC changes depending on
> which slot I plug it in.
> 
> Slot       INTERRUPT_LINE     IO-APIC        Observed
> 1           10                            49                 17
> 2           10                            53                 17
> 3           9                              26                 18
> 
> The same general behavior has been observed in _every_ linux machine
> I've been able to plug this card into that had an IO-APIC. These were
> mostly Intel chipsets but I 've also had it in a Tyan 8-proc AMD board
> with a Nvidia chipset with the same interrupt issues.
> 
> I see two problems: first, the INTERRUPT_LINE register on the card is
> not consistent with either the APIC reported irq or the actual irq.
> Second, that the IO_APIC, which is supposed to maintain a mapping of
> its pins to a particular irq, is inconsistent in what IRQ is reported
> for a particular pin (different slots result in different irqs
> reported, but still actually use irq 17).
> 
> I'm not a LKML subscriber so please CC to brett.boren_at_gmail_dot_com.

You should only be using the interrupt which is listed in the irq member 
of the struct pci_dev for your device. Likely if you do that your 
problems will go away.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

