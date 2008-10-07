Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYJGILU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYJGILU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 04:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYJGILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 04:11:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:42056 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYJGILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 04:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Vv8q1WzsM89cmeGS1xCauIrCEtKjyryAoTBP3yYzMyzKtGgTsYNTfMHqeCyp5UKtTn
         X3vBiEmsd+iKKPzE2rso77qrCN7V8ehWU8j8I5C+S1uL1hLeJKKvxkqNWEh7wgrKgt/h
         /NJaHNg4iJvUcRVAQnOaPqoC2AhCOpFlbD6uo=
Message-ID: <48EB1993.1030606@panasas.com>
Date: Tue, 07 Oct 2008 10:10:59 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: lists@ku-gbr.de
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom>
In-Reply-To: <20081007060357.GA16761@anita.doom>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 07, 2008, 8:04 +0200, Konstantin Kletschke <lists@ku-gbr.de> wrote:
> Am 2008-10-07 10:02 +0900 schrieb Tejun Heo:
> 
>> Hmm... strange.  Can you please try the attached patch?  It's basically
>> the same with a bit more debug information.
> 
> No Problem.
> 
> I had difficulties to cold boot the machine today, I had to powercycle a
> lot. Then I applied the patch and it bootet immediately:
> 
> sata_nv 0000:00:0a.0: version 3.5
> ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
> sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
> sata_nv 0000:00:0a.0: setting latency timer to 64
> scsi0 : sata_nv
> scsi1 : sata_nv
> ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
> ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
> ata1: hard resetting link
> XXX CLASSIFY 01:00:00
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
> ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> ata2: hard resetting link
> ata2: SATA link down (SStatus 0 SControl 300)
> ata2: EH complete
> isa bounce pool size: 16 pages
> scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
> sd 0:0:0:0: [sda] Attached SCSI disk
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> TCP cubic registered
> NET: Registered protocol family 17
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> VFS: Mounted root (xfs filesystem) readonly.
> Freeing unused kernel memory: 220k freed
> 
> 
> Then I switched off and smoked a cigarette, booting then lasted a bit longer:

See, cigarettes are bad for you(r computer) ;-)

Benny

> 
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: SRST failed (errno=-16)
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1: link online but device misclassified, retrying
> ata1: hard resetting link
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: SRST failed (errno=-16)
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1: link online but device misclassified, retrying
> ata1: hard resetting link
> XXX CLASSIFY 01:00:00
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
> ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> ata2: hard resetting link
> ata2: SATA link down (SStatus 0 SControl 300)
> ata2: EH complete
> isa bounce pool size: 16 pages
> scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
> sd 0:0:0:0: [sda] Attached SCSI disk
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> TCP cubic registered
> NET: Registered protocol family 17
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> VFS: Mounted root (xfs filesystem) readonly.
> Freeing unused kernel memory: 220k freed
> 
> 
> Konsti
> 

