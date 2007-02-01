Return-Path: <linux-kernel-owner+w=401wt.eu-S1422779AbXBARrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779AbXBARrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422776AbXBARrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:47:48 -0500
Received: from vsmtp2.tin.it ([212.216.176.222]:62999 "EHLO vsmtp2.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXBARrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:47:48 -0500
Message-ID: <45BE4003005C2845@vsmtp2.tin.it> (added by postmaster@virgilio.it)
From: "Lapo TIN" <lapolapolapo@tin.it>
To: <linux-smp@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: smp and irq conflict
Date: Thu, 1 Feb 2007 18:46:00 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
Thread-Index: AcdGKNWOUNdIDpVaTGGEI4dxVn/13w==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,
I have a problem with IRQs.

My pc has a CPU PentiumD945 (dual core) and a 2.6.19smp kernel.
I have two video acquisition board (four bt8t8 each) in the only two pci
slots of my motherboard. Thus I have a total of 8 bttv modules that are
working together, and the /proc/interrupts is as follows:
# cat /proc/interrupts
           CPU0       CPU1
  0:      13575          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  4:         11          0   IO-APIC-edge      serial
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:      22286          0   IO-APIC-edge      ide0
 17:       7073       2097   IO-APIC-fasteoi   uhci_hcd:usb5, eth0
 18:       2525          0   IO-APIC-fasteoi   bttv0, bttv7
 19:       2829          0   IO-APIC-fasteoi   bttv1, bttv4
 20:       2526          0   IO-APIC-fasteoi   bttv2, bttv5
 21:       2226          0   IO-APIC-fasteoi   bttv3, bttv6
 22:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb4
 23:         86          0   IO-APIC-fasteoi   uhci_hcd:usb2
 24:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
NMI:          0          0
LOC:      13484      13502
ERR:          0
MIS:          0
You can see that IRQ18 is shared between bttv0 and bttv7, IRQ19 between
bttv1 and bttv4 and so on.

Sometimes it crashes. It seems a matter of conflict in IRQ.
With only one video board everything is ok, but with two, they shared irq
and something goes wrong... 
How can I tell to the kernel to not to share the IRQ for these boards ?
I think (I don't know if I'm right) that this could be the problem.

I even tried with another motherboard, and doing cat /proc/interrupts the
situation was the same, except for 'eth0' that was together with bttv0 and
bttv7... so it was even worst ! it crashes after few minutes.

I tried to read IO-APIC.txt in Documentation/i386/ folder, but I didn't
understand how to avoid the coupling of IRQ.
Thanks
Lapo


