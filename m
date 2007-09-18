Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXIROgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXIROgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbXIROgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:36:33 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2679 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbXIROgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:36:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 18 Sep 2007 14:34:09.0392 (UTC) FILETIME=[F95D1700:01C7FA00]
Content-class: urn:content-classes:message
Subject: Re: PCI Interrupt
Date: Tue, 18 Sep 2007 10:34:55 -0400
Message-ID: <Pine.LNX.4.61.0709181028270.6702@chaos.analogic.com>
In-Reply-To: <OF8D17B2FD.EFB025F4-ON8025735A.004DB087-8025735A.004DB743@elekta.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PCI Interrupt
Thread-Index: Acf6APlkGdQ3fGwWQUiGrBwws3/G1g==
References: <OF8D17B2FD.EFB025F4-ON8025735A.004DB087-8025735A.004DB743@elekta.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: <Duncan.Perrett@elekta.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Sep 2007 Duncan.Perrett@elekta.com wrote:

> The driver already does that ...
>
> result =
>        request_irq(irq, can_pci_interrupt, SA_INTERRUPT | SA_SHIRQ,
>                    pDevice->au8IrqName, pDevice);
>
>
> Any other ideas?
>
> Duncan
>
>
>             "linux-os \(Dick
>             Johnson\)"
>             <linux-os@analogi                                          To
>             c.com>                    <Duncan.Perrett@elekta.com>
>                                                                        cc
>             18/09/2007 14:57          "Linux kernel"
>                                       <linux-kernel@vger.kernel.org>
>                                                                   Subject
>             Please respond to         Re: PCI Interrupt
>             "linux-os \(Dick
>                Johnson\)"
>             <linux-os@analogi
>                  c.com>
>
> On Tue, 18 Sep 2007 Duncan.Perrett@elekta.com wrote:
>
>>
>> I have a CAN PCI card installed on my Ubuntu box.
>> I understand that PCI interrupts should be level rather than edge
>> triggered.
>>
>> The output of cat /proc/interrupts is :-
>>
>>           CPU0
>>  0:    1614601    IO-APIC-edge  timer
>>  1:        164    IO-APIC-edge  i8042
>>  8:          3    IO-APIC-edge  rtc
>>  9:          1   IO-APIC-level  acpi
>> 12:          0    IO-APIC-edge  CAN-ACx-PCI_01
>> 14:      65786    IO-APIC-edge  ide0
>> 169:       3220   IO-APIC-level  eth0, i915@pci:0000:00:02.0
>> 177:      46459   IO-APIC-level  eth1
>> 209:          0   IO-APIC-level  uhci_hcd:usb3, eth2
>> 217:          2   IO-APIC-level  uhci_hcd:usb1, ehci_hcd:usb4
>> 225:        697   IO-APIC-level  uhci_hcd:usb2
>> NMI:          0
>> LOC:    1614399
>> ERR:          0
>> MIS:          0
>>
>> You see that irq 12 CAN-ACx-PCI_01 is edge triggered.
>> Is there any way of forcing the BIOS to see the interrupt as a
>> level-triggered one?
>
> It's done in the driver. IRQ12 can be shared, so the driver
> needs to request the IRQ as a shared interrupt.
>
>
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
> My book : http://www.AbominableFirebug.com/
> _

Okay, then in the BIOS, make sure that IRQ12 is not assigned to
a specific device. In other words, set it to PnP (if available).
As you well know, PCI requires sharable interrupts and edges
are not sharable so something is broken. As a last resort,
move your PCI board to abother slot which should pick up another
interrupt, which may not be broken. If that doesn't work, see
if a new BIOS is available for download.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
