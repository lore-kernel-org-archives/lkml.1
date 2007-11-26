Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbXKZCjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbXKZCjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 21:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXKZCiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 21:38:51 -0500
Received: from joe.tiscali.it ([213.205.33.54]:35115 "EHLO joe.tiscali.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbXKZCiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 21:38:50 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 21:38:50 EST
Date: Mon, 26 Nov 2007 03:33:13 +0100
From: cecco <f.cecco77@tiscali.it>
To: linux-kernel@vger.kernel.org
Subject: irq on nforce4 and realtek RTL8168B
Message-Id: <20071126033313.57bca420.f.cecco77@tiscali.it>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a ASUS A6T with nforce4 and realtek RTL8111/8168B
ethernet. I am testing kernel 2.6.24-rc3-git1 on this
notebook and I have noticed strange behaviour with irq.
I pass hpet=force and acpi_use_timer_override to enable
apic, otherwise timer cpu interrupt is in old XT-PIC mode.
Unfortunately, irq balancing on turion X2 doesn't work
very well and there are extra timers interrupt. Realtek
RTL8168B shares irq 17 with nvidia 7600 go card and it is
not very good, infact if I don't use pci=nomsi option,
Realtek RTL8168B is up but doesn't transmit any packet. I
have following situation interrupt without pci=nomsi:

             CPU0       CPU1       
  0:         57      29452   IO-APIC-edge      timer
  1:          0        331   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge    
  8:          0          2   IO-APIC-edge      rtc
  9:        180        193   IO-APIC-fasteoi   acpi
 12:       8291        133   IO-APIC-edge      i8042
 14:          2       2810   IO-APIC-edge      libata
 15:       5186       2646   IO-APIC-edge      libata
 17:          0        683   IO-APIC-fasteoi   nvidia
 18:          0          2   IO-APIC-fasteoi   ohci1394
 19:          1         45   IO-APIC-fasteoi   ohci_hcd:usb1
 20:          0          0   IO-APIC-fasteoi   sdhci:slot0
 21:          0        292   IO-APIC-fasteoi   HDA Intel
221:          0          0   PCI-MSI-edge      eth1
NMI:          0          0   Non-maskable interrupts
LOC:      29452          8   Local timer interrupts
RES:       2799       4491   Rescheduling interrupts
CAL:        128        102   function call interrupts
TLB:        354        247   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0

Besides, these problems on irq seem to break lapic with
no_hz. I don't get a working suspend memory for irq fault, 
the notebook doesn't reboot after the suspend memory.
Unfortunately, the  bios is very buggy and I believe ASUS
has to behave better with linux users. 
I invite ASUS,AMD,NVIDIA and  REALTEK manifacturers to 
offer a better support for linux, and to not violate
standard ACPI specifics.  I wish to be personally CC'ed the
answers/comments posted to the list in response to my
posting.

Thanks

Best Regards

Francesco
