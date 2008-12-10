Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYLJVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYLJVtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYLJVtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:49:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbYLJVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:49:41 -0500
Date: Wed, 10 Dec 2008 13:49:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: daumas <daumas77@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem with SI3124-based controller and SI 4726-based PMP in
 RAID10 mode
Message-Id: <20081210134938.2dbe6d21.akpm@linux-foundation.org>
In-Reply-To: <49401F04.90408@gmail.com>
References: <49401F04.90408@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-ide)

On Wed, 10 Dec 2008 13:56:52 -0600
daumas <daumas77@gmail.com> wrote:

> 
> I have a sata_sil24 problem involving a 4-port SI3124-based controller
> connected to a 3-port eSATA enclosure. Each eSATA port is an SI
> 4726-based H/W PMP. The PMPs are connected to (13) 1 TB hard drives, as
> indicated below.
> 
> PCI3124 Port 1
>   4726 (Configured in RAID10 mode)
>   4726 Port 1 => 1 TB drive
>   4726 Port 2 => 1 TB drive
>   4726 Port 3 => 1 TB drive
>   4726 Port 4 => 1 TB drive
>   4726 Port 5 => 1 TB drive
> PCI3124 Port 2
>   4726 (Configured in RAID10 mode)
>   4726 Port 1 => 1 TB drive
>   4726 Port 2 => 1 TB drive
>   4726 Port 3 => 1 TB drive
>   4726 Port 4 => 1 TB drive
>   4726 Port 5 => 1 TB drive
> PCI3124 Port 3
>   4726 (Configured in JBOD/Passthru mode)
>   4726 Port 1 => 1 TB drive
>   4726 Port 2 => 1 TB drive
>   4726 Port 3 => 1 TB drive
>   4726 Port 4 => no connection
>   4726 Port 5 => no connection
> PCI3124 Port 4 =>no connection
> 
> I am running openSuse 11.0 with a 2.6.27.7-4.1 kernel
> 
> For the 4726 PMP configured in JBOD mode, all is well, and I can see all
> 3 disks.
> 
> However, for the 4726 PMPs configured in RAID10 mode, I can see NONE of
> the disks.
> 
> As I understand it, the 4726 is a hardware-based PMP which can handle
> RAID10 by itself and thereby offload the RAID processing. I would expect
> the 3124 controller to see the drives hidden behind the 4726 as a single
> unit, but this does not happen. Instead I get the errors listed at end,
> and the RAID10 device is not 'seen' at all. (Key error of note is "both
> IDENTIFYs aborted, assuming NODEV")
> 
> JBOD is fine for host-only based RAID functionality, but I want the
> higher performance the 4726 offers for RAID10.
> Is is not possible to off-load the RAID10 function to the 4726 under linux?
> 
> Any help, workarounds (beyond strict JBOD mode) are appreciated.
> 
> Thanks!
> 
> Dec 10 11:02:23 buildhost36 sudo: e-build : TTY=pts/1 ;
> PWD=/home/e-build ; USER=root ; COMMAND=/sbin/modprobe sata_sil24
> Dec 10 11:02:23 buildhost36 kernel: sata_sil24 0000:03:03.0: version 1.1
> Dec 10 11:02:23 buildhost36 kernel: vendor=8086 device=0329
> Dec 10 11:02:23 buildhost36 kernel: vendor=8086 device=3595
> Dec 10 11:02:23 buildhost36 kernel: sata_sil24 0000:03:03.0: PCI INT A
> -> GSI 72 (level, low) -> IRQ 64
> Dec 10 11:02:23 buildhost36 kernel: sata_sil24 0000:03:03.0: Applying
> completion IRQ loss on PCI-X errata fix
> Dec 10 11:02:23 buildhost36 kernel: scsi8 : sata_sil24
> Dec 10 11:02:23 buildhost36 kernel: scsi9 : sata_sil24
> Dec 10 11:02:23 buildhost36 kernel: scsi10 : sata_sil24
> Dec 10 11:02:23 buildhost36 kernel: scsi11 : sata_sil24
> Dec 10 11:02:23 buildhost36 kernel: ata7: SATA max UDMA/100 host
> m128@0xdefffc00 port 0xdeff0000 irq 64
> Dec 10 11:02:23 buildhost36 kernel: ata8: SATA max UDMA/100 host
> m128@0xdefffc00 port 0xdeff2000 irq 64
> Dec 10 11:02:23 buildhost36 kernel: ata9: SATA max UDMA/100 host
> m128@0xdefffc00 port 0xdeff4000 irq 64
> Dec 10 11:02:23 buildhost36 kernel: ata10: SATA max UDMA/100 host
> m128@0xdefffc00 port 0xdeff6000 irq 64
> Dec 10 11:02:25 buildhost36 kernel: ata7: SATA link up 3.0 Gbps (SStatus
> 123 SControl 0)
> Dec 10 11:02:25 buildhost36 kernel: ata7.15: Port Multiplier 1.1,
> 0x1095:0x4726 r31, 3 ports, feat 0x1/0x9
> Dec 10 11:02:25 buildhost36 kernel: ata7.00: hard resetting link
> Dec 10 11:02:25 buildhost36 kernel: ata7.00: SATA link down (SStatus 4
> SControl 0)
> Dec 10 11:02:25 buildhost36 kernel: ata7.01: hard resetting link
> Dec 10 11:02:25 buildhost36 kernel: ata7.01: SATA link up 3.0 Gbps
> (SStatus 123 SControl 0)
> Dec 10 11:02:25 buildhost36 kernel: ata7.02: hard resetting link
> Dec 10 11:02:26 buildhost36 kernel: ata7.02: SATA link up 1.5 Gbps
> (SStatus 113 SControl 320)
> Dec 10 11:02:26 buildhost36 kernel: ata7.01: unsupported device, disabling
> Dec 10 11:02:26 buildhost36 kernel: ata7.01: disabled
> Dec 10 11:02:26 buildhost36 kernel: ata7.02: both IDENTIFYs aborted,
> assuming NODEV
> Dec 10 11:02:26 buildhost36 kernel: ata7: EH complete
> Dec 10 11:02:28 buildhost36 kernel: ata8: SATA link up 3.0 Gbps (SStatus
> 123 SControl 0)
> Dec 10 11:02:28 buildhost36 kernel: ata8.15: Port Multiplier 1.1,
> 0x1095:0x4726 r31, 3 ports, feat 0x1/0x9
> Dec 10 11:02:28 buildhost36 kernel: ata8.00: hard resetting link
> Dec 10 11:02:28 buildhost36 kernel: ata8.00: SATA link down (SStatus 4
> SControl 0)
> Dec 10 11:02:28 buildhost36 kernel: ata8.01: hard resetting link
> Dec 10 11:02:29 buildhost36 kernel: ata8.01: SATA link up 3.0 Gbps
> (SStatus 123 SControl 0)
> Dec 10 11:02:29 buildhost36 kernel: ata8.02: hard resetting link
> Dec 10 11:02:29 buildhost36 kernel: ata8.02: SATA link up 1.5 Gbps
> (SStatus 113 SControl 320)
> Dec 10 11:02:29 buildhost36 kernel: ata8.01: unsupported device, disabling
> Dec 10 11:02:29 buildhost36 kernel: ata8.01: disabled
> Dec 10 11:02:29 buildhost36 kernel: ata8.02: both IDENTIFYs aborted,
> assuming NODEV
> Dec 10 11:02:29 buildhost36 kernel: ata8: EH complete
> Dec 10 11:02:31 buildhost36 kernel: ata9: SATA link up 3.0 Gbps (SStatus
> 123 SControl 0)
> Dec 10 11:02:31 buildhost36 kernel: ata9.15: Port Multiplier 1.1,
> 0x1095:0x4726 r31, 7 ports, feat 0x1/0x9
> Dec 10 11:02:31 buildhost36 kernel: ata9.00: hard resetting link
> Dec 10 11:02:32 buildhost36 kernel: ata9.00: SATA link up 1.5 Gbps
> (SStatus 113 SControl 320)
> Dec 10 11:02:32 buildhost36 kernel: ata9.01: hard resetting link
> Dec 10 11:02:32 buildhost36 kernel: ata9.01: SATA link up 1.5 Gbps
> (SStatus 113 SControl 300)
> Dec 10 11:02:32 buildhost36 kernel: ata9.02: hard resetting link
> Dec 10 11:02:32 buildhost36 kernel: ata9.02: SATA link up 1.5 Gbps
> (SStatus 113 SControl 300)
> Dec 10 11:02:32 buildhost36 kernel: ata9.03: hard resetting link
> Dec 10 11:02:33 buildhost36 kernel: ata9.03: SATA link down (SStatus 0
> SControl 320)
> Dec 10 11:02:33 buildhost36 kernel: ata9.04: hard resetting link
> Dec 10 11:02:33 buildhost36 kernel: ata9.04: SATA link down (SStatus 0
> SControl 320)
> Dec 10 11:02:33 buildhost36 kernel: ata9.05: hard resetting link
> Dec 10 11:02:33 buildhost36 kernel: ata9.05: SATA link up 3.0 Gbps
> (SStatus 123 SControl 0)
> Dec 10 11:02:33 buildhost36 kernel: ata9.06: hard resetting link
> Dec 10 11:02:34 buildhost36 kernel: ata9.06: SATA link up 1.5 Gbps
> (SStatus 113 SControl 320)
> Dec 10 11:02:34 buildhost36 kernel: ata9.00: ATA-8: ST31000340AS, SD15,
> max UDMA/133
> Dec 10 11:02:34 buildhost36 kernel: ata9.00: 1953525168 sectors, multi
> 0: LBA48 NCQ (depth 31/32)
> Dec 10 11:02:34 buildhost36 kernel: ata9.00: configured for UDMA/100
> Dec 10 11:02:34 buildhost36 kernel: ata9.01: ATA-8: ST31000340AS, SD15,
> max UDMA/133
> Dec 10 11:02:34 buildhost36 kernel: ata9.01: 1953525168 sectors, multi
> 0: LBA48 NCQ (depth 31/32)
> Dec 10 11:02:34 buildhost36 kernel: ata9.01: configured for UDMA/100
> Dec 10 11:02:34 buildhost36 kernel: ata9.02: ATA-8: ST31000340AS, SD15,
> max UDMA/133
> Dec 10 11:02:34 buildhost36 kernel: ata9.02: 1953525168 sectors, multi
> 0: LBA48 NCQ (depth 31/32)
> Dec 10 11:02:34 buildhost36 kernel: ata9.02: configured for UDMA/100
> Dec 10 11:02:34 buildhost36 kernel: ata9.05: unsupported device, disabling
> Dec 10 11:02:34 buildhost36 kernel: ata9.05: disabled
> Dec 10 11:02:34 buildhost36 kernel: ata9: EH complete
> Dec 10 11:02:36 buildhost36 kernel: ata10: SATA link down (SStatus 0
> SControl 0)
> Dec 10 11:02:36 buildhost36 kernel: scsi 10:0:0:0: Direct-Access ATA
> ST31000340AS SD15 PQ: 0 ANSI: 5
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sdb:
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: [sdb] Attached SCSI disk
> Dec 10 11:02:36 buildhost36 kernel: sd 10:0:0:0: Attached scsi generic
> sg2 type 0
> Dec 10 11:02:36 buildhost36 kernel: scsi 10:1:0:0: Direct-Access ATA
> ST31000340AS SD15 PQ: 0 ANSI: 5
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sdc:
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: [sdc] Attached SCSI disk
> Dec 10 11:02:36 buildhost36 kernel: sd 10:1:0:0: Attached scsi generic
> sg3 type 0
> Dec 10 11:02:36 buildhost36 kernel: scsi 10:2:0:0: Direct-Access ATA
> ST31000340AS SD15 PQ: 0 ANSI: 5
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] 1953525168
> 512-byte hardware sectors: (1000GB/931GiB)
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Write Protect is off
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Mode Sense: 00 3a
> 00 00
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 11:02:36 buildhost36 kernel: sdd: sdd1
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: [sdd] Attached SCSI disk
> Dec 10 11:02:36 buildhost36 kernel: sd 10:2:0:0: Attached scsi generic
> sg4 type 0
> Dec 10 11:02:55 buildhost36 sshd[6534]: Accepted
> keyboard-interactive/pam for e-build from 9.65.98.119 port 34222 ssh2
> Dec 10 11:03:57 buildhost36 sshd[6566]: Accepted
> keyboard-interactive/pam for root from 9.65.98.119 port 44494 ssh2
> 
> Henri Daumas
> Global TIM Competency - Integrated Operations
> Configuration Management/Build
> 
> 

