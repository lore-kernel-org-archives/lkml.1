Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbYKWPmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbYKWPmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYKWPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:42:34 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:46777 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYKWPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:42:33 -0500
Message-ID: <492979E4.1070606@lwfinger.net>
Date: Sun, 23 Nov 2008 09:42:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Yuval Hager <yuval@avramzon.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <200811221654.09399.mb@bu3sch.de> <200811231350.00207.yuval@avramzon.net> <200811231320.30289.mb@bu3sch.de>
In-Reply-To: <200811231320.30289.mb@bu3sch.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Sunday 23 November 2008 12:49:55 Yuval Hager wrote:
>> [  182.891400] ****** b43: B43_MMIO_MACCTL 0x840A0503
>> [  182.891409] ****** b43: SSB_TMSLOW 0x20150000
>> [  258.299027] irq 10: nobody cared (try booting with the "irqpoll" option)
> 
> 
> Does the kernel disable the PCI device, if it ignores the IRQ?

According to /proc/interrupts that Yuval posted earlier, IRQ 10 is not used.

# cat /proc/interrupts

           CPU0
  0:     271998   IO-APIC-edge      timer
  1:          8   IO-APIC-edge      i8042
  8:          2   IO-APIC-edge      rtc
  9:       2796   IO-APIC-fasteoi   acpi
 12:        132   IO-APIC-edge      i8042
 14:          0   IO-APIC-edge      ide0
 15:          0   IO-APIC-edge      ide1
 16:      29161   IO-APIC-fasteoi   eth0
 17:        503   IO-APIC-fasteoi   HDA Intel
 20:          0   IO-APIC-fasteoi   uhci_hcd:usb2
 21:      11085   IO-APIC-fasteoi   sata_via, ehci_hcd:usb1, uhci_hcd:usb3
 23:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 24:      28003   IO-APIC-fasteoi   b43
NMI:          0   Non-maskable interrupts
LOC:       2098   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

After the failure occurs, b43 has disappeared from the IRQ 24 list:

 24:      34154   IO-APIC-fasteoi


Larry
