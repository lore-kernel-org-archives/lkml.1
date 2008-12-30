Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYL3R15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYL3R15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYL3R1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:27:47 -0500
Received: from main.gmane.org ([80.91.229.2]:53967 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYL3R1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:27:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Different IRQ mapping from 2.6.27->2.6.28?
Date: Tue, 30 Dec 2008 11:27:32 -0600
Message-ID: <495A5A04.2070502@shaw.ca>
References: <alpine.DEB.1.10.0812300714190.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <alpine.DEB.1.10.0812300714190.11356@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Had a quick question, prior to 2.6.28 the 915 controller always shared 
> irq 16
> with the 3ware controller and possibly usb.
> 
> $ cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:        829          0          0          0   IO-APIC-edge      timer
>   1:          2          0          0          0   IO-APIC-edge      i8042
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          4          0          0          0   IO-APIC-edge      i8042
>  16:     426034     626134    1351627    1342735   IO-APIC-fasteoi   
> 3w-9xxx, uhci_hcd:usb3
>  17:          0          0          0          0   IO-APIC-fasteoi   
> pata_marvell
>  18:          0          0          0          0   IO-APIC-fasteoi   
> ehci_hcd:usb1, uhci_hcd:usb7
>  19:       1375        341          0          0   IO-APIC-fasteoi   
> ohci1394, uhci_hcd:usb6
>  21:     297232    2133384     741689    1238741   IO-APIC-fasteoi   
> uhci_hcd:usb4, eth1
>  22:     205140     294852    1063046     234799   IO-APIC-fasteoi   HDA 
> Intel, eth2
>  23:     332083    3050489          0          0   IO-APIC-fasteoi   
> ehci_hcd:usb2, uhci_hcd:usb5
> 375:     376161    1019158     163030      68967   PCI-MSI-edge      ahci
> 376:      56580    2533694     390596    2673511   PCI-MSI-edge      eth0
> 377:          0          0          0          0   PCI-MSI-edge      
> i915@pci:0000:00:02.0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:  213813409  215685728  213463846  214264243   Local timer interrupts
> RES:      62066      64812      41593      54593   Rescheduling interrupts
> CAL:       1425       1476       1445        606   Function call interrupts
> TLB:      96105      94258     117036     107468   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC 
> interrupts
> SPU:          0          0          0          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> I was curious if this change had something to do with it?
> 
> From:
> http://kernelnewbies.org/LinuxChanges?action=print
> i915: Add support for MSI and interrupt mitigation. (commit), disable 
> MSI on GM965 (errata says it doesn't work) (commit)
> 
> Are there any pros or cons having the device mapped to the PCI-MSI-edge vs.
> sitting on a regular IRQ?  I am trying to understand the differences here,
> thanks!

It's better to have devices on MSI interrupts because the interrupt 
source is always unambiguous (interrupts are never shared), among a few 
other reasons..

