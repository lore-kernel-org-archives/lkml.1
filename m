Return-Path: <linux-kernel-owner+w=401wt.eu-S936096AbXG0GYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096AbXG0GYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXG0GXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:23:53 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:53928 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbXG0GXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:23:52 -0400
Date: Thu, 26 Jul 2007 23:23:43 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
Message-ID: <20070727062343.GC15408@plap.qlogic.org>
References: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <1185487419.7134.485.camel@bluto.andrew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185487419.7134.485.camel@bluto.andrew>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Jul 2007 06:23:00.0174 (UTC) FILETIME=[947286E0:01C7D016]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Andrew Patterson wrote:

> On Thu, 2007-07-26 at 15:36 +0200, Ulrich Windl wrote:
> > Hi,
> > 
> > I have a question: The Qlogic ISP2422 chip is said to handle PCI-X 266MHz. So does 
> > the HP Itanium2 server rx6600. Basically that was the reason to select that 
> > server. The FC-HBA is in a 266 MHz capable slot. However when booting SLES10 SP1 
> > for IA64, the logs say:

There's a mixup here in terminology...  The QLA2460 card which you
have does in fact support 'PCI-X 266'...

> > <6>QLogic Fibre Channel HBA Driver
> > <6>GSI 49 (level, low) -> CPU 3 (0x0300) vector 51
> > <6>ACPI: PCI Interrupt 0000:0f:01.0[A] -> GSI 49 (level, low) -> IRQ 51
> > <6>qla2xxx 0000:0f:01.0: Found an ISP2422, irq 51, iobase 0xc0000000b0040000
> > [...]
> > <6>qla2xxx 0000:0f:01.0: LOOP UP detected (4 Gbps).
> > <6>qla2xxx 0000:0f:01.0: Topology - (F_Port), Host Loop address 0x0
> > <6>scsi0 : qla2xxx
> > <6>qla2xxx 0000:0f:01.0:
> > <4> QLogic Fibre Channel HBA Driver: 8.01.07-k3
> > <4>  QLogic HP AB378-60001 -
> > <4>  ISP2422: PCI-X Mode 2 (133 MH4.00.26 [IP]  @ 0000:0f:01.0 hdma+, host#=0, 
> > fw=4.00.26 [IP]

The 33/66/100/133 values refer to the bus-clock speed at which the
card is operating.  As is seen here (although a bit truncated --
separate issue, I'll try to see if I can reproduce this on one of my
HPQ rigs), the card is inserted into a PCI-X Mode-2 capable 133MHz
(bus clock) slot.  When operating under this mode, each data-phase
between two devices is divided into 2 sub-phases, effectively doubling
the transfer-data-rate to 266Mhz.

> > <5>  Vendor: HP        Model: HSV200            Rev: 6100
> > <5>  Type:   RAID                               ANSI SCSI revision: 02
> > <5> 0:0:0:0: Attached scsi generic sg0 type 12
> > 
> > Now does Linux support the speed of 266 MHz, and is it just displayed incorrectly, 
> > or doesn't Linux support the speed of 266MHz yet?
> 
> This is a bug in the driver.  The lookup table only goes to 133 MHz.
> 
> static char *pci_bus_modes[] = {
>                 "33", "66", "100", "133",
> 
> The same problem exists in the scsi_misc tree.

Regards,
Andrew Vasquez
