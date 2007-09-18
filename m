Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbXIROJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbXIROJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXIROJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:09:15 -0400
Received: from crawleyone.elekta.com ([193.235.128.13]:4371 "EHLO
	crawleyone.elekta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXIROJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:09:14 -0400
In-Reply-To: <Pine.LNX.4.61.0709180955360.6632@chaos.analogic.com>
Subject: Re: PCI Interrupt
To: "Linux kernel" <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 6.5.1 January 21, 2004
Message-ID: <OF8D17B2FD.EFB025F4-ON8025735A.004DB087-8025735A.004DB743@elekta.com>
From: Duncan.Perrett@elekta.com
Date: Tue, 18 Sep 2007 15:08:46 +0100
X-MIMETrack: Serialize by Router on CrawleyOne/Servers/Elekta(Release 6.5.1|January 21, 2004) at
 09/18/2007 03:09:14 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver already does that ...

result =
        request_irq(irq, can_pci_interrupt, SA_INTERRUPT | SA_SHIRQ,
                    pDevice->au8IrqName, pDevice);


Any other ideas?

Duncan



                                                                           
             "linux-os \(Dick                                              
             Johnson\)"                                                    
             <linux-os@analogi                                          To 
             c.com>                    <Duncan.Perrett@elekta.com>         
                                                                        cc 
             18/09/2007 14:57          "Linux kernel"                      
                                       <linux-kernel@vger.kernel.org>      
                                                                   Subject 
             Please respond to         Re: PCI Interrupt                   
             "linux-os \(Dick                                              
                Johnson\)"                                                 
             <linux-os@analogi                                             
                  c.com>                                                   
                                                                           
                                                                           





On Tue, 18 Sep 2007 Duncan.Perrett@elekta.com wrote:

>
> I have a CAN PCI card installed on my Ubuntu box.
> I understand that PCI interrupts should be level rather than edge
> triggered.
>
> The output of cat /proc/interrupts is :-
>
>           CPU0
>  0:    1614601    IO-APIC-edge  timer
>  1:        164    IO-APIC-edge  i8042
>  8:          3    IO-APIC-edge  rtc
>  9:          1   IO-APIC-level  acpi
> 12:          0    IO-APIC-edge  CAN-ACx-PCI_01
> 14:      65786    IO-APIC-edge  ide0
> 169:       3220   IO-APIC-level  eth0, i915@pci:0000:00:02.0
> 177:      46459   IO-APIC-level  eth1
> 209:          0   IO-APIC-level  uhci_hcd:usb3, eth2
> 217:          2   IO-APIC-level  uhci_hcd:usb1, ehci_hcd:usb4
> 225:        697   IO-APIC-level  uhci_hcd:usb2
> NMI:          0
> LOC:    1614399
> ERR:          0
> MIS:          0
>
> You see that irq 12 CAN-ACx-PCI_01 is edge triggered.
> Is there any way of forcing the BIOS to see the interrupt as a
> level-triggered one?

It's done in the driver. IRQ12 can be shared, so the driver
needs to request the IRQ as a shared interrupt.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be
privileged.  Any review, retransmission, dissemination, or other use of
this information by persons or entities other than the intended recipient
is prohibited.  If you are not the intended recipient, please notify
Analogic Corporation immediately - by replying to this message or by
sending an email to DeliveryErrors@analogic.com - and destroy all copies of
this information, including any attachments, without reading or disclosing
them.

Thank you.




*******************Internet Email Confidentiality Footer*******************
The contents of this e-mail message (including any attachments hereto) are
confidential to and are intended to be conveyed for the use of the
recipient to whom it is addressed only. If you receive this transmission in
error, please notify the sender of this immediately and delete the message
from your system. Any distribution, reproduction or use of this message by
someone other than recipient is not authorized and may be unlawful.
Elekta Limited is a company registered in England and Wales whose
registered number is 3244454 and whose registered address is Linac House,
Fleming Way, Crawley, West Sussex, RH10 9RR

