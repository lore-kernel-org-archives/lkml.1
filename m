Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZFNMfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZFNMfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZFNMfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:35:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:54891 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759187AbZFNMe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:34:58 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX18xrJEu4+8xbLON+4dwYnE+Drt6/YsQDGkkgg+zM6
	MWB5eww7sbf8+4
Date: Sun, 14 Jun 2009 14:37:08 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614143708.32ec250c@pluto-lenny.milky.way>
In-Reply-To: <200906141415.16949.rjw@sisk.pl>
References: <20090614120950.116536fa@pluto-lenny.milky.way>
	<200906141400.27331.rjw@sisk.pl>
	<alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
	<200906141415.16949.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 14:15:16 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 14 June 2009, Thomas Gleixner wrote:
> > On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:
> > > Evidently, the change of the interrupt handling during suspend-resume,
> > > commit 2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7 (PM: Rework handling of
> > > interrupts during suspend-resume) broke resume (specifically, the enabling of
> > > nonboot CPUs) on the Benjamin's machine, but only if MSI support is enabled.
> > > Also, resume works if suspend_device_irqs() and resume_device_irqs() in
> > > drivers/base/power/main.c are commented out.
> > > 
> > > Is there anything the MSI code does in __enable_irq() and/or __disable_irq()
> > > that might cause this problem to appear?
> > 
> > Not that I'm aware of. Which of the devices is using MSI ? Have to
> > tried to skip only the MSI ones in suspend/resume_device_irqs() ?
> 
> Good idea.
> 
> Benjamin, please send /proc/interrupts from your system.

I guess it does not matter if from 2.6.29.2 or from 2.6.30. This 
is from 2.6.29.2 with CONFIG_PCI_MSI set:

           CPU0       CPU1       
  0:         42          1   IO-APIC-edge      timer
  1:          0         81   IO-APIC-edge      i8042
  6:          0          5   IO-APIC-edge      floppy
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 14:          0        328   IO-APIC-edge      ide0
 15:          0          0   IO-APIC-edge      ide1
 16:          2        408   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb3, HDA Intel
 17:          0          3   IO-APIC-fasteoi   ehci_hcd:usb2
 18:          0          0   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:          0         17   IO-APIC-fasteoi   ehci_hcd:usb4, HDA Intel
 24:       4830          0  HPET_MSI-edge      hpet2
 26:          0        135   PCI-MSI-edge      eth0
 27:          0       2855   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:         42       5070   Local timer interrupts
RES:       2634       2170   Rescheduling interrupts
CAL:         72        104   Function call interrupts
TLB:        367        198   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

I am going to compile 2.6.30 with CONFIG_PCI_MSI again to ensure 
it is the same, but that will take some time.


Benjamin
