Return-Path: <linux-kernel-owner+w=401wt.eu-S965532AbXG2WvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbXG2WvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964950AbXG2WvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:51:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3920 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750873AbXG2WvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:51:01 -0400
Date: Sun, 29 Jul 2007 18:50:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Hindley <mark@hindley.org.uk>
cc: linux-kernel@vger.kernel.org, <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] [REGRESSION] 2.6.23-rc1: uhci_hcd. irq 4:
 nobody cared
In-Reply-To: <20070729164711.GA4178@hindley.uklinux.net>
Message-ID: <Pine.LNX.4.44L0.0707291844001.22168-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Mark Hindley wrote:

> On Sun, Jul 29, 2007 at 11:19:47AM -0400, Alan Stern wrote:
> > On Sun, 29 Jul 2007, Mark Hindley wrote:
> > 
> > > Hi,
> > > 
> > > I have just tried 2.6.23-rc1 on my Acer Aspire 1350.
> > > 
> > > On boot I get the following error as the uhci_hcd module is loaded:
> > > 
> > > Jul 28 18:23:20 mercury kernel: ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 4 (level, low) -> IRQ 4
> > > Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: UHCI Host Controller
> > > Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
> > > Jul 28 18:23:20 mercury kernel: irq 4: nobody cared (try booting with the "irqpoll" option)
> > 
> > Did it work okay with older kernels?  What does /proc/interrupts say in 
> > both 2.6.23-rc1 and in a working kernel?
> 
> No boot error with 2.6.22.1.
> 
> On 2.6.22.1:
>            CPU0       
>   0:      12312    XT-PIC-XT        timer
>   1:        286    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   4:        434    XT-PIC-XT        uhci_hcd:usb2, via@pci:0000:01:00.0
>   5:       2000    XT-PIC-XT        yenta, uhci_hcd:usb3, wifi0
>   6:          3    XT-PIC-XT        floppy
>   7:          3    XT-PIC-XT        parport0
>   8:          4    XT-PIC-XT        rtc
>   9:          0    XT-PIC-XT        uhci_hcd:usb4, VIA82XX-MODEM, VIA8233
>  10:        843    XT-PIC-XT        acpi
>  11:          0    XT-PIC-XT        ehci_hcd:usb1
>  12:        123    XT-PIC-XT        i8042
>  14:      10951    XT-PIC-XT        ide0
>  15:         53    XT-PIC-XT        ide1
> NMI:        770 
> LOC:     120091 
> ERR:          0
> MIS:          0
> 
> On 2.6.23-rc1:
>            CPU0       
>   0:       8616    XT-PIC-XT        timer
>   1:        183    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   4:       8233    XT-PIC-XT        uhci_hcd:usb1, via@pci:0000:01:00.0
>   5:       4948    XT-PIC-XT        uhci_hcd:usb2, yenta, wifi0
>   6:          3    XT-PIC-XT        floppy
>   7:         22    XT-PIC-XT        parport0
>   8:          4    XT-PIC-XT        rtc
>   9:          0    XT-PIC-XT        uhci_hcd:usb3, VIA82XX-MODEM, VIA8233
>  10:        854    XT-PIC-XT        acpi
>  11:          0    XT-PIC-XT        ehci_hcd:usb4
>  12:        123    XT-PIC-XT        i8042
>  14:      12202    XT-PIC-XT        ide0
>  15:         53    XT-PIC-XT        ide1
> NMI:        809 
> LOC:     150284 
> ERR:          1
> MIS:          0

No significant differences.  :-(

Well, about all I can suggest is bisection.  And don't assume that this 
problem was caused by a change to the USB stack.  It could be a change 
in the interrupt-handling core or a change to the driver for one of the 
other devices sharing the IRQ.

It might even be caused by a change in the order the modules are 
loaded, which has nothing to do with the kernel directly.  In fact, it 
might be worth checking this possibility first.  For example, it's 
clear that 2.6.22 loaded ehci-hcd before uhci-hcd whereas 2.6.23-rc1 
did the reverse.  And yenta vs. uhci-hcd is different.

Alan Stern

