Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbYD3Ni1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbYD3Ni1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYD3NiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:38:18 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:43124 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbYD3NiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:38:17 -0400
Date: Wed, 30 Apr 2008 15:38:24 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080430133824.GC18711@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu> <20080428092513.495378af.akpm@linux-foundation.org> <20080429175419.6c8a0ebf@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429175419.6c8a0ebf@strauss.suse.de>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 05:54:19PM +0200, Bernhard Walle wrote:

> Hm ..., can you mail /proc/interrupts of the affected system? According
> to the HPET specification 

The Intel box:

           CPU0       CPU1       
  0:      27346      29145   IO-APIC-edge      timer
  1:        842        819   IO-APIC-edge      i8042
  4:          2          2   IO-APIC-edge    
  6:          0          3   IO-APIC-edge      floppy
  8:          2          3   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 14:         36         36   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         71         71   IO-APIC-fasteoi   uhci_hcd:usb5, HDA Intel
 17:      49357      47537   IO-APIC-fasteoi   ata_piix
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:          0          0   IO-APIC-fasteoi   rtl
 23:         28         29   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
380:        332        338   PCI-MSI-edge      mobo
NMI:        645        573   Non-maskable interrupts
LOC:      58828      55631   Local timer interrupts
RES:      78518      83802   Rescheduling interrupts
CAL:        477        492   function call interrupts
TLB:       1079       1084   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

The AMD box:

           CPU0       
  0:         36   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  3:          3   IO-APIC-edge    
  4:          2   IO-APIC-edge    
  6:          3   IO-APIC-edge      floppy
  7:          1   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 14:         53   IO-APIC-edge      pata_amd
 15:         73   IO-APIC-edge      pata_amd
 17:          0   IO-APIC-fasteoi   sata_sil
 18:          3   IO-APIC-fasteoi   firewire_ohci
 19:          0   IO-APIC-fasteoi   saa7134[0], saa7134[0]
 20:        424   IO-APIC-fasteoi   ehci_hcd:usb2
 21:        481   IO-APIC-fasteoi   ohci_hcd:usb1
 22:      19744   IO-APIC-fasteoi   sata_nv, nvidia
 23:      13590   IO-APIC-fasteoi   sata_nv, NVidia CK804
283:          1   PCI-MSI-edge      marvel
NMI:          0   Non-maskable interrupts
LOC:      11801   Local timer interrupts
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
SPU:          0   Spurious interrupts
ERR:          1

> Can you try that patch and see if the IRQ handler is really called
> repeatedly in that case?

Unfortunately I won't have time today and will be traveling till the end
of the week. I'll give it a shot next week.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
