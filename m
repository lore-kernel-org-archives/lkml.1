Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXEJL1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXEJL1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXEJL1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:27:30 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:44490 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXEJL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:27:29 -0400
Date: Thu, 10 May 2007 07:27:28 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Mikael Pettersson <mikpe@it.uu.se>
cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
In-Reply-To: <17986.56621.521038.435167@alkaid.it.uu.se>
Message-ID: <Pine.LNX.4.64.0705100725020.31317@mtl.rackplans.net>
References: <Pine.LNX.4.64.0705091453310.18441@mtl.rackplans.net>
 <464226BD.8000602@garzik.org> <Pine.LNX.4.64.0705091741070.31317@mtl.rackplans.net>
 <17986.56621.521038.435167@alkaid.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Mikael Pettersson wrote:

> Date: Thu, 10 May 2007 10:51:57 +0200
> From: Mikael Pettersson <mikpe@it.uu.se>
> To: Gerhard Mack <gmack@innerfire.net>
> Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
> Subject: Re: [2.6.21.1] SATA freeze
> 
> Gerhard Mack writes:
>  > On Wed, 9 May 2007, Jeff Garzik wrote:
>  > > Gerhard Mack wrote:
>  > > > May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr
>  > > > 0x1800000 action 0x2 frozen
>  > > > May  9 14:51:35 mgerhard kernel: ata1.00: cmd
>  > > > 35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
>  > > > May  9 14:51:35 mgerhard kernel:          res
>  > > > 40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
>  > > > May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, please be
>  > > > patient (Status 0xd0)
>  > > > 
>  > > > Anything I can do to figgure out what's causing this?
>  > > 
>  > > Provide full lspci, dmesg, kernel config?
>  > > 
>  > Done.
> 
> Your second boot (warm or cold?)

Warm boot.

> 
>  > May  9 14:43:07 mgerhard kernel: klogd 1.4.1#20, log source = /proc/kmsg started.
>  > May  9 14:43:07 mgerhard kernel: Linux version 2.6.21.1 (root@mgerhard) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Wed May 2 20:08:35 EDT 2007
>  > May  9 14:43:07 mgerhard kernel: Command line: root=/dev/sda3 ro 
> 
> worked fine until ReiserFS's journal replay caused a single SATA exception:
> 
>  > May  9 14:43:07 mgerhard kernel: ReiserFS: sda3: There were 7 uncompleted unlinks/truncates. Completed
>  > May  9 14:43:07 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2
>  > May  9 14:43:07 mgerhard kernel: ata1.00: (BMDMA stat 0x25)
>  > May  9 14:43:07 mgerhard kernel: ata1.00: cmd 35/00:58:20:4d:23/00:01:00:00:00/e0 tag 0 cdb 0x0 data 176128 out
>  > May  9 14:43:07 mgerhard kernel:          res 51/84:28:50:4d:23/84:01:00:00:00/e0 Emask 0x10 (ATA bus error)
>  > May  9 14:43:07 mgerhard kernel: ata1: soft resetting port
>  > May  9 14:43:07 mgerhard kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>  > May  9 14:43:07 mgerhard kernel: ata1.00: configured for UDMA/100
>  > May  9 14:43:07 mgerhard kernel: ata1: EH complete
>  > May  9 14:43:07 mgerhard kernel: SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
> 
> Shortly thereafter you loaded a proprietary module

Oops thought I killed that.

> 
>  > May  9 14:43:17 mgerhard kernel: nvidia: module license 'NVIDIA' taints kernel.
>  > May  9 14:43:17 mgerhard kernel: ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
>  > May  9 14:43:17 mgerhard kernel: ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
>  > May  9 14:43:17 mgerhard kernel: PCI: Setting latency timer of device 0000:00:05.0 to 64
>  > May  9 14:43:17 mgerhard kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
> 
> and immediately there's a large number of SATA exceptions:
> 
>  > May  9 14:44:37 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2
>  > May  9 14:44:37 mgerhard kernel: ata1.00: (BMDMA stat 0x25)
>  > May  9 14:44:37 mgerhard kernel: ata1.00: cmd 35/00:00:b0:53:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
>  > May  9 14:44:37 mgerhard kernel:          res 51/84:60:50:56:c8/84:01:09:00:00/e0 Emask 0x10 (ATA bus error)
>  > May  9 14:44:37 mgerhard kernel: ata1: soft resetting port
>  > May  9 14:44:37 mgerhard kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>  > May  9 14:44:37 mgerhard kernel: ata1.00: configured for UDMA/100
> (repeated)
> 
> Please try a cold boot (so the HW is in a pristine state) without
> ever loading the nvidia module.

Cold boot cleared the drive problems.  Nvidia loaded or not has no affect 
on it at this point.


Thanks for the help.

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
