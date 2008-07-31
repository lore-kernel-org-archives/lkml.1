Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYGaVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYGaVEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYGaVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:04:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24470 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753939AbYGaVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:04:15 -0400
Date: Fri, 1 Aug 2008 01:04:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: libata badness
Message-ID: <20080731210410.GA623@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:53:45PM -0500, Kumar Gala wrote:
> I'm getting the following badness with top of tree on a embedded PowerPC 
> w/a ULI 1575 bridge (M5229 IDE):
>
> 02:1f.0 IDE interface: Acer Laboratories Inc. [ALi] M5229 IDE (rev c8)

Just to be sure that I didn't break the ULi for your board, could
you try locally revert this patch:

commit 52ddd1cdc923802b224b15ba75000c6c5668227f
Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jun 12 03:04:17 2008 +0400

    powerpc/85xx/86xx: some refactoring for fsl_uli1575 code

And see if this helps?

> If you need more info let me know.
>
> - k
>
> ahci 0000:02:1f.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA 
> mode
> ahci 0000:02:1f.1: flags: ncq sntf ilck pm led clo pmp pio slum part
> ------------[ cut here ]------------
> Badness at c021e700 [verbose debug info unavailable]
> NIP: c021e700 LR: c021e6e8 CTR: c022ce90
> REGS: ef82bca0 TRAP: 0700   Not tainted  (2.6.27-rc1-00495-g33bd9fe- 
> dirty)
> MSR: 00029032 <EE,ME,IR,DR>  CR: 22044022  XER: 20000000
> TASK = ef830000[1] 'swapper' THREAD: ef82a000 CPU: 1
> GPR00: 00000001 ef82bd50 ef830000 00000000 00009032 00000000 ef0b64fc  
> 00000000
> GPR08: ef937c10 c022f93f efbfc8e0 ef900b60 22044028 fffdd3ff 0ffe8700  
> c044c17c
> GPR16: c04d52ec ef82f458 ef82f4f4 ef82f4f4 c044c234 c044c5d8 c044c5d8  
> c044c220
> GPR24: c044c218 c04d52f0 00000080 c022f940 00000000 c044c244 efbec490  
> 00000000
> NIP [c021e700] ata_host_activate+0x40/0x10c
> LR [c021e6e8] ata_host_activate+0x28/0x10c
> Call Trace:
> [ef82bd50] [c021e6e8] ata_host_activate+0x28/0x10c (unreliable)
> [ef82bd80] [c022f48c] ahci_init_one+0x8b4/0xd68
> [ef82be30] [c01b69c0] pci_device_probe+0x84/0xa8
> [ef82be50] [c01e5438] driver_probe_device+0xb4/0x1e8
> [ef82be70] [c01e55f0] __driver_attach+0x84/0x88
> [ef82be90] [c01e4ba0] bus_for_each_dev+0x5c/0xa4
> [ef82bec0] [c01e5254] driver_attach+0x24/0x34
> [ef82bed0] [c01e44b8] bus_add_driver+0x1d8/0x24c
> [ef82bef0] [c01e5810] driver_register+0x70/0x160
> [ef82bf10] [c01b6c54] __pci_register_driver+0x64/0xc4
> [ef82bf30] [c04aaa60] ahci_init+0x28/0x38
> [ef82bf40] [c048717c] do_one_initcall+0x38/0x1ac
> [ef82bfb0] [c04874e0] kernel_init+0x1f0/0x1fc
> [ef82bff0] [c0013b04] kernel_thread+0x44/0x60
> Instruction dump:
> 7cbb2b78 90010034 7cda3378 7cf93b78 7c7e1b78 4bff9dbd 7c7f1b79 408200c8
> 2f9c0000 409e002c 313bffff 7c09d910 <0f000000> 80010034 7fc3f378  
> 7f24cb78
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> ata1: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006100
> ata2: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006180
> ata3: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006200
> ata4: SATA max UDMA/133 abar m1024@0x80006000 port 0x80006280
> ata1: SATA link down (SStatus 0 SControl 300)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
