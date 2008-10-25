Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYJYLht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYJYLht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYJYLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:37:38 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:49032 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYJYLhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:37:36 -0400
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 07:37:35 EDT
Message-ID: <4903004D.2050904@vc.cvut.cz>
Date: Sat, 25 Oct 2008 04:17:33 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.17) Gecko/20080829 Iceape/1.1.12 (Debian-1.1.12-1)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Paul Mundt <lethal@linux-sh.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk> <20081024071608.GA3879@linux-sh.org> <20081024072428.GP22217@kernel.dk> <873aimv0v8.fsf@denkblock.local> <20081024084818.GB22217@kernel.dk>
In-Reply-To: <20081024084818.GB22217@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Oct 24 2008, Elias Oltmanns wrote:
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>> From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
>>> From: Jens Axboe <jens.axboe@oracle.com>
>>> Date: Fri, 24 Oct 2008 09:22:42 +0200
>>> Subject: [PATCH] libata: fix bug with non-ncq devices
>>>
>>> The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable
>> Wouldn't that be commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e?
> 
> Yes that is correct, the other commit is actually a private one in my
> tree for other libata changes. Updated patch below, thanks for checking!
> 
> From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 24 Oct 2008 09:22:42 +0200
> Subject: [PATCH] libata: fix bug with non-ncq devices

Hello,
   this fixes my DVD, but unfortunately NCQ devices connected to PMP are 
still dead - apparently as soon as mount() tries to do serious I/O on 
the drive.  Backing out both post-2.6.28-rc1 fix as well as your 
original change brings storage back.  I suspect that problem is that 
with PMP same tag cannot be (should not be?  must not be?) used on 
multiple devices behind PMP - and before your change tags were allocated 
per-port, while now they are allocated per-device.
							Petr

P.S.: And disk connected to port #0 required poweroff/poweron cycle to 
get back to life.



Oct 25 02:21:54 gwy kernel: sata_sil24 0000:05:00.0: version 1.1
Oct 25 02:21:54 gwy kernel: ACPI: PCI Interrupt Link [APC5] enabled at 
IRQ 16
Oct 25 02:21:54 gwy kernel: sata_sil24 0000:05:00.0: PCI INT A -> 
Link[APC5] -> GSI 16 (level, low) -> IRQ 16
Oct 25 02:21:54 gwy kernel: sata_sil24 0000:05:00.0: setting latency 
timer to 64
Oct 25 02:21:54 gwy kernel: scsi6 : sata_sil24
Oct 25 02:21:54 gwy kernel: scsi7 : sata_sil24
Oct 25 02:21:54 gwy kernel: ata7: SATA max UDMA/100 host m128@0xfdaff000 
port 0xfdaf8000 irq 16
Oct 25 02:21:54 gwy kernel: ata8: SATA max UDMA/100 host m128@0xfdaff000 
port 0xfdafa000 irq 16
Oct 25 02:21:54 gwy kernel: ata8: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:21:54 gwy kernel: ata8.15: Port Multiplier 1.1, 0x1095:0x3726 
r23, 6 ports, feat 0x1/0x9
Oct 25 02:21:54 gwy kernel: ata8.00: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.00: SATA link up 3.0 Gbps (SStatus 123 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.01: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.02: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.03: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.04: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.04: SATA link down (SStatus 0 SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.05: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.00: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:21:54 gwy kernel: ata8.15: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:21:54 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:21:54 gwy kernel: ata8.00: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.00: SATA link up 3.0 Gbps (SStatus 123 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.01: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.02: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.03: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.05: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.00: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:21:54 gwy kernel: ata8.15: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:21:54 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:21:54 gwy kernel: ata8.00: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.00: SATA link up 3.0 Gbps (SStatus 123 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.01: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.02: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.03: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.04: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.04: SATA link down (SStatus 0 SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.05: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.00: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:21:54 gwy kernel: ata8.00: failed to recover link after 3 
tries, disabling
Oct 25 02:21:54 gwy kernel: ata8.15: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:21:54 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:21:54 gwy kernel: ata8.01: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.02: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.03: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:21:54 gwy kernel: ata8.05: hard resetting link
Oct 25 02:21:54 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:21:54 gwy kernel: ata8.01: ATA-7: Hitachi HDS721010KLA330, 
GKAOA70M, max UDMA/133
Oct 25 02:21:54 gwy kernel: ata8.01: 1953525168 sectors, multi 16: LBA48 
NCQ (depth 31/32)
Oct 25 02:21:54 gwy kernel: ata8.01: configured for UDMA/100
Oct 25 02:21:54 gwy kernel: ata8.02: ATA-7: Hitachi HDS721010KLA330, 
GKAOA70F, max UDMA/133
Oct 25 02:21:54 gwy kernel: ata8.02: 1953525168 sectors, multi 16: LBA48 
NCQ (depth 31/32)
Oct 25 02:21:54 gwy kernel: ata8.02: configured for UDMA/100
Oct 25 02:21:54 gwy kernel: ata8.03: ATA-7: Hitachi HDS721010KLA330, 
GKAOA70M, max UDMA/133
Oct 25 02:21:54 gwy kernel: ata8.03: 1953525168 sectors, multi 16: LBA48 
NCQ (depth 31/32)
Oct 25 02:21:54 gwy kernel: ata8.03: configured for UDMA/100
Oct 25 02:21:54 gwy kernel: ata8: EH complete
Oct 25 02:21:54 gwy kernel: scsi 7:1:0:0: Direct-Access     ATA 
Hitachi HDS72101 GKAO PQ: 0 ANSI: 5
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel:  sdh: sdh1
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: [sdh] Attached SCSI disk
Oct 25 02:21:54 gwy kernel: sd 7:1:0:0: Attached scsi generic sg9 type 0
Oct 25 02:21:54 gwy kernel: scsi 7:2:0:0: Direct-Access     ATA 
Hitachi HDS72101 GKAO PQ: 0 ANSI: 5
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel:  sdi: sdi1
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: [sdi] Attached SCSI disk
Oct 25 02:21:54 gwy kernel: sd 7:2:0:0: Attached scsi generic sg10 type 0
Oct 25 02:21:54 gwy kernel: scsi 7:3:0:0: Direct-Access     ATA 
Hitachi HDS72101 GKAO PQ: 0 ANSI: 5
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Write Protect is off
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:21:54 gwy kernel:  sdj: sdj1
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: [sdj] Attached SCSI disk
Oct 25 02:21:54 gwy kernel: sd 7:3:0:0: Attached scsi generic sg11 type 0
Oct 25 02:23:09 gwy kernel: ata8.03: exception Emask 0x10 SAct 0x0 SErr 
0x4010000 action 0xf
Oct 25 02:23:09 gwy kernel: ata8.03: SError: { PHYRdyChg DevExch }
Oct 25 02:23:09 gwy kernel: ata8.00: failed to read SCR 2 (Emask=0x40)
Oct 25 02:23:09 gwy kernel: ata8.00: COMRESET failed (errno=-5)
Oct 25 02:23:09 gwy kernel: ata8.00: failed to write SCR 1 (Emask=0x40)
Oct 25 02:23:09 gwy kernel: ata8.00: failed to clear SError.N (errno=-5)
Oct 25 02:23:09 gwy kernel: ata8.15: hard resetting link
Oct 25 02:23:11 gwy kernel: ata8.15: SATA link down (SStatus 0 SControl 0)
Oct 25 02:23:14 gwy kernel: ata8.15: failed to read PMP GSCR[0] (Emask=0x1)
Oct 25 02:23:14 gwy kernel: ata8.15: PMP revalidation failed (errno=-5)
Oct 25 02:23:16 gwy kernel: ata8.15: hard resetting link
Oct 25 02:23:18 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:23:18 gwy kernel: ata8.01: hard resetting link
Oct 25 02:23:19 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:19 gwy kernel: ata8.02: hard resetting link
Oct 25 02:23:19 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:19 gwy kernel: ata8.03: hard resetting link
Oct 25 02:23:20 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:20 gwy kernel: ata8.04: hard resetting link
Oct 25 02:23:20 gwy kernel: ata8.04: SATA link down (SStatus 0 SControl 320)
Oct 25 02:23:20 gwy kernel: ata8.05: hard resetting link
Oct 25 02:23:21 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:23:21 gwy kernel: ata8.01: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:23:21 gwy kernel: ata8.01: revalidation failed (errno=-5)
Oct 25 02:23:23 gwy kernel: ata8.15: hard resetting link
Oct 25 02:23:23 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:23:25 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:23:26 gwy kernel: ata8.01: hard resetting link
Oct 25 02:23:26 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:26 gwy kernel: ata8.02: hard resetting link
Oct 25 02:23:26 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:26 gwy kernel: ata8.03: hard resetting link
Oct 25 02:23:27 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:27 gwy kernel: ata8.05: hard resetting link
Oct 25 02:23:27 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:23:27 gwy kernel: ata8.01: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:23:27 gwy kernel: ata8.01: revalidation failed (errno=-5)
Oct 25 02:23:30 gwy kernel: ata8.15: hard resetting link
Oct 25 02:23:30 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:23:33 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:23:33 gwy kernel: ata8.01: hard resetting link
Oct 25 02:23:33 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:33 gwy kernel: ata8.02: hard resetting link
Oct 25 02:23:34 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:34 gwy kernel: ata8.03: hard resetting link
Oct 25 02:23:34 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:34 gwy kernel: ata8.04: hard resetting link
Oct 25 02:23:34 gwy kernel: ata8.04: SATA link down (SStatus 0 SControl 320)
Oct 25 02:23:34 gwy kernel: ata8.05: hard resetting link
Oct 25 02:23:35 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:23:35 gwy kernel: ata8.01: configured for UDMA/100
Oct 25 02:23:35 gwy kernel: ata8.02: failed to IDENTIFY (I/O error, 
err_mask=0x11)
Oct 25 02:23:35 gwy kernel: ata8.02: revalidation failed (errno=-5)
Oct 25 02:23:38 gwy kernel: ata8.15: hard resetting link
Oct 25 02:23:38 gwy kernel: ata8: controller in dubious state, 
performing PORT_RST
Oct 25 02:23:40 gwy kernel: ata8.15: SATA link up 3.0 Gbps (SStatus 123 
SControl 0)
Oct 25 02:23:40 gwy kernel: ata8.01: hard resetting link
Oct 25 02:23:40 gwy kernel: ata8.01: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:40 gwy kernel: ata8.02: hard resetting link
Oct 25 02:23:41 gwy kernel: ata8.02: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:41 gwy kernel: ata8.03: hard resetting link
Oct 25 02:23:41 gwy kernel: ata8.03: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Oct 25 02:23:41 gwy kernel: ata8.05: hard resetting link
Oct 25 02:23:42 gwy kernel: ata8.05: SATA link up 1.5 Gbps (SStatus 113 
SControl 320)
Oct 25 02:23:42 gwy kernel: ata8.01: configured for UDMA/100
Oct 25 02:23:42 gwy kernel: ata8.02: configured for UDMA/100
Oct 25 02:23:42 gwy kernel: ata8.03: configured for UDMA/100
Oct 25 02:23:42 gwy kernel: ata8.15: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0x9 t4
Oct 25 02:23:42 gwy kernel: ata8.15: irq_stat 0x00060002
Oct 25 02:23:42 gwy kernel: ata8: EH complete
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:1:0:0: [sdh] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:2:0:0: [sdi] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] 1953525168 512-byte 
hardware sectors: (1000GB/931GiB)
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Write Protect is off
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 25 02:23:42 gwy kernel: sd 7:3:0:0: [sdj] Write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Oct 25 02:23:51 gwy kernel: kjournald starting.  Commit interval 5 seconds
Oct 25 02:23:51 gwy kernel: EXT3 FS on sdi1, internal journal
Oct 25 02:23:51 gwy kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Oct 25 02:23:51 gwy kernel: kjournald starting.  Commit interval 5 seconds
Oct 25 02:23:51 gwy kernel: EXT3 FS on sdh1, internal journal
Oct 25 02:23:51 gwy kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Oct 25 02:23:51 gwy kernel: kjournald starting.  Commit interval 5 seconds
Oct 25 02:23:51 gwy kernel: EXT3 FS on sdj1, internal journal
Oct 25 02:23:51 gwy kernel: EXT3-fs: mounted filesystem with ordered 
data mode.


