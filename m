Return-Path: <linux-kernel-owner+w=401wt.eu-S1764882AbXG2Qri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764882AbXG2Qri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764091AbXG2QrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:47:17 -0400
Received: from 83-216-141-215.markhi700.adsl.metronet.co.uk ([83.216.141.215]:4753
	"EHLO mx.hindley.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763873AbXG2QrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:47:15 -0400
Date: Sun, 29 Jul 2007 17:47:11 +0100
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] [REGRESSION] 2.6.23-rc1: uhci_hcd. irq 4: nobody cared
Message-ID: <20070729164711.GA4178@hindley.uklinux.net>
References: <20070729130105.GB27939@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Mark Hindley <mark@hindley.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:19:47AM -0400, Alan Stern wrote:
> On Sun, 29 Jul 2007, Mark Hindley wrote:
> 
> > Hi,
> > 
> > I have just tried 2.6.23-rc1 on my Acer Aspire 1350.
> > 
> > On boot I get the following error as the uhci_hcd module is loaded:
> > 
> > Jul 28 18:23:20 mercury kernel: ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKA] -> GSI 4 (level, low) -> IRQ 4
> > Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: UHCI Host Controller
> > Jul 28 18:23:20 mercury kernel: uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
> > Jul 28 18:23:20 mercury kernel: irq 4: nobody cared (try booting with the "irqpoll" option)
> 
> Did it work okay with older kernels?  What does /proc/interrupts say in 
> both 2.6.23-rc1 and in a working kernel?

No boot error with 2.6.22.1.

On 2.6.22.1:
           CPU0       
  0:      12312    XT-PIC-XT        timer
  1:        286    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  4:        434    XT-PIC-XT        uhci_hcd:usb2, via@pci:0000:01:00.0
  5:       2000    XT-PIC-XT        yenta, uhci_hcd:usb3, wifi0
  6:          3    XT-PIC-XT        floppy
  7:          3    XT-PIC-XT        parport0
  8:          4    XT-PIC-XT        rtc
  9:          0    XT-PIC-XT        uhci_hcd:usb4, VIA82XX-MODEM, VIA8233
 10:        843    XT-PIC-XT        acpi
 11:          0    XT-PIC-XT        ehci_hcd:usb1
 12:        123    XT-PIC-XT        i8042
 14:      10951    XT-PIC-XT        ide0
 15:         53    XT-PIC-XT        ide1
NMI:        770 
LOC:     120091 
ERR:          0
MIS:          0

On 2.6.23-rc1:
           CPU0       
  0:       8616    XT-PIC-XT        timer
  1:        183    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  4:       8233    XT-PIC-XT        uhci_hcd:usb1, via@pci:0000:01:00.0
  5:       4948    XT-PIC-XT        uhci_hcd:usb2, yenta, wifi0
  6:          3    XT-PIC-XT        floppy
  7:         22    XT-PIC-XT        parport0
  8:          4    XT-PIC-XT        rtc
  9:          0    XT-PIC-XT        uhci_hcd:usb3, VIA82XX-MODEM, VIA8233
 10:        854    XT-PIC-XT        acpi
 11:          0    XT-PIC-XT        ehci_hcd:usb4
 12:        123    XT-PIC-XT        i8042
 14:      12202    XT-PIC-XT        ide0
 15:         53    XT-PIC-XT        ide1
NMI:        809 
LOC:     150284 
ERR:          1
MIS:          0

Mark
