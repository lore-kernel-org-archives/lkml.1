Return-Path: <linux-kernel-owner+w=401wt.eu-S936276AbXGZWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936276AbXGZWH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934278AbXGZWHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:07:52 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:60559 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbXGZWHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:07:52 -0400
Subject: Re: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
From: Andrew Patterson <andrew.patterson@hp.com>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 16:03:38 -0600
Message-Id: <1185487419.7134.485.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 15:36 +0200, Ulrich Windl wrote:
> Hi,
> 
> I have a question: The Qlogic ISP2422 chip is said to handle PCI-X 266MHz. So does 
> the HP Itanium2 server rx6600. Basically that was the reason to select that 
> server. The FC-HBA is in a 266 MHz capable slot. However when booting SLES10 SP1 
> for IA64, the logs say:
> 
> <6>QLogic Fibre Channel HBA Driver
> <6>GSI 49 (level, low) -> CPU 3 (0x0300) vector 51
> <6>ACPI: PCI Interrupt 0000:0f:01.0[A] -> GSI 49 (level, low) -> IRQ 51
> <6>qla2xxx 0000:0f:01.0: Found an ISP2422, irq 51, iobase 0xc0000000b0040000
> [...]
> <6>qla2xxx 0000:0f:01.0: LOOP UP detected (4 Gbps).
> <6>qla2xxx 0000:0f:01.0: Topology - (F_Port), Host Loop address 0x0
> <6>scsi0 : qla2xxx
> <6>qla2xxx 0000:0f:01.0:
> <4> QLogic Fibre Channel HBA Driver: 8.01.07-k3
> <4>  QLogic HP AB378-60001 -
> <4>  ISP2422: PCI-X Mode 2 (133 MH4.00.26 [IP]  @ 0000:0f:01.0 hdma+, host#=0, 
> fw=4.00.26 [IP]
> <5>  Vendor: HP        Model: HSV200            Rev: 6100
> <5>  Type:   RAID                               ANSI SCSI revision: 02
> <5> 0:0:0:0: Attached scsi generic sg0 type 12
> 
> Now does Linux support the speed of 266 MHz, and is it just displayed incorrectly, 
> or doesn't Linux support the speed of 266MHz yet?

This is a bug in the driver.  The lookup table only goes to 133 MHz.

static char *pci_bus_modes[] = {
                "33", "66", "100", "133",

The same problem exists in the scsi_misc tree.

> "lspci -v" says:
> 0f:01.0 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA 
> (rev 02)
>         Subsystem: Hewlett-Packard Company Unknown device 12d6
>         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 51
>         I/O ports at 6000 [size=256]
>         Memory at b0040000 (64-bit, non-prefetchable) [size=4K]
>         Expansion ROM at b0000000 [disabled] [size=256K]
>         Capabilities: [44] Power Management version 2
>         Capabilities: [4c] PCI-X non-bridge device
>         Capabilities: [64] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 
> Enable-
>         Capabilities: [74] Vital Product Data
> 

lspci only tells you capabilities, not the speed that the card is
running at.  I think you have to query the PCI bridge chipset to get
this information.  I have run a proprietary tool on this configuration
that does this and confirmed that the card is indeed running at 266 MHz.

> Please CC: any replies to my address as I'm not subscribed to the kernel list.
> 
> Regards,
> Ulrich Windl

Andrew

-- 
Andrew Patterson
Hewlett-Packard Company

