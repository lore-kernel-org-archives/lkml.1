Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYGaUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYGaUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYGaUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:25:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:47103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYGaUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:25:15 -0400
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <836C281D-4D3A-4547-98D9-143A690698AF@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ben Dooks <ben-linux@fluff.org>
In-Reply-To: <20080731190259.GJ26938@trinity.fluff.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: libata badness
Date: Thu, 31 Jul 2008 15:24:31 -0500
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org> <20080731190259.GJ26938@trinity.fluff.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31, 2008, at 2:02 PM, Ben Dooks wrote:

> On Thu, Jul 31, 2008 at 01:53:45PM -0500, Kumar Gala wrote:
>> I'm getting the following badness with top of tree on a embedded
>> PowerPC w/a ULI 1575 bridge (M5229 IDE):
>>
>> 02:1f.0 IDE interface: Acer Laboratories Inc. [ALi] M5229 IDE (rev  
>> c8)
>>
>> If you need more info let me know.
>>
>> - k
>>
>> ahci 0000:02:1f.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl
>> SATA mode
>> ahci 0000:02:1f.1: flags: ncq sntf ilck pm led clo pmp pio slum part
>> ------------[ cut here ]------------
>> Badness at c021e700 [verbose debug info unavailable]
>
> it would be helpful to compile a kernel with verbose fault information
> turned on.

Doesn't seem to provide too much more info on ppc.  just says the file/ 
line number of the badness.

>> NIP: c021e700 LR: c021e6e8 CTR: c022ce90
>> REGS: ef82bca0 TRAP: 0700   Not tainted  (2.6.27-rc1-00495-g33bd9fe-
>> dirty)
>> MSR: 00029032 <EE,ME,IR,DR>  CR: 22044022  XER: 20000000
>> TASK = ef830000[1] 'swapper' THREAD: ef82a000 CPU: 1
>> GPR00: 00000001 ef82bd50 ef830000 00000000 00009032 00000000 ef0b64fc
>> 00000000
>> GPR08: ef937c10 c022f93f efbfc8e0 ef900b60 22044028 fffdd3ff 0ffe8700
>> c044c17c
>> GPR16: c04d52ec ef82f458 ef82f4f4 ef82f4f4 c044c234 c044c5d8 c044c5d8
>> c044c220
>> GPR24: c044c218 c04d52f0 00000080 c022f940 00000000 c044c244 efbec490
>> 00000000
>> NIP [c021e700] ata_host_activate+0x40/0x10c
>> LR [c021e6e8] ata_host_activate+0x28/0x10c
>> Call Trace:
>> [ef82bd50] [c021e6e8] ata_host_activate+0x28/0x10c (unreliable)
>> [ef82bd80] [c022f48c] ahci_init_one+0x8b4/0xd68
>> [ef82be30] [c01b69c0] pci_device_probe+0x84/0xa8
>> [ef82be50] [c01e5438] driver_probe_device+0xb4/0x1e8
>> [ef82be70] [c01e55f0] __driver_attach+0x84/0x88
>> [ef82be90] [c01e4ba0] bus_for_each_dev+0x5c/0xa4
>> [ef82bec0] [c01e5254] driver_attach+0x24/0x34
>> [ef82bed0] [c01e44b8] bus_add_driver+0x1d8/0x24c
>> [ef82bef0] [c01e5810] driver_register+0x70/0x160
>> [ef82bf10] [c01b6c54] __pci_register_driver+0x64/0xc4
>> [ef82bf30] [c04aaa60] ahci_init+0x28/0x38
>> [ef82bf40] [c048717c] do_one_initcall+0x38/0x1ac
>> [ef82bfb0] [c04874e0] kernel_init+0x1f0/0x1fc
>> [ef82bff0] [c0013b04] kernel_thread+0x44/0x60
>> Instruction dump:
>> 7cbb2b78 90010034 7cda3378 7cf93b78 7c7e1b78 4bff9dbd 7c7f1b79  
>> 408200c8
>> 2f9c0000 409e002c 313bffff 7c09d910 <0f000000> 80010034 7fc3f378
>> 7f24cb78
>> scsi0 : ahci
>> scsi1 : ahci
>> scsi2 : ahci
>> scsi3 : ahci
>> ata1: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006100
>> ata2: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006180
>> ata3: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006200
>> ata4: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006280
>> ata1: SATA link down (SStatus 0 SControl 300)
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata3: SATA link down (SStatus 0 SControl 300)
>> ata4: SATA link down (SStatus 0 SControl 300)
>> scsi4 : pata_ali
>> scsi5 : pata_ali
>> ata5: PATA max UDMA/133 cmd 0x1200 ctl 0x1208 bmdma 0x1220
>> ata6: PATA max UDMA/133 cmd 0x1210 ctl 0x1218 bmdma 0x1228
>
> Looks like you're running into the same problem as I did, with the
> fact that the M5529 is in native mode, but doesn't have any IRQ
> available. Do you know if the bridge chip in it is in routes the
> IRQs internally?

They are routed via an i8259 in the bridge.

- k

