Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbXCSEhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbXCSEhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 00:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXCSEhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 00:37:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:38850 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXCSEhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 00:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qGmudqPOuW2Jhs7vTCYDZ5iEg5HLdQ+YIi7WLluKDLWlnxzrwfBvdE8dyOil8ZP7FCEL1AeOyt8Ets2lV0wxCpQzKTgONorZh2ImduSX0cHsqIA6OgPV5ub7qOFBME44PxU60OjQlX91qy2pggL5RAgs9brPAs8JTB/IjNml/+M=
Message-ID: <45FE137D.8000300@gmail.com>
Date: Mon, 19 Mar 2007 13:37:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <00f401c7694d$81a80920$2101a8c0@donald>
In-Reply-To: <00f401c7694d$81a80920$2101a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Doh ! Got that :
> 
> ....
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
> ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
> ata1: SATA max UDMA/133 cmd 0xffffc2000008e900 ctl 0x0000000000000000 bmdma
> 0x0000000000000000 irq 504
> ata2: SATA max UDMA/133 cmd 0xffffc2000008e980 ctl 0x0000000000000000 bmdma
> 0x0000000000000000 irq 504
> ata3: SATA max UDMA/133 cmd 0xffffc2000008ea00 ctl 0x0000000000000000 bmdma
> 0x0000000000000000 irq 504
> ata4: SATA max UDMA/133 cmd 0xffffc2000008ea80 ctl 0x0000000000000000 bmdma
> 0x0000000000000000 irq 504
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-6: External Disk 0, RGL10364, max UDMA/133
> ata2.00: 1 sectors, multi 1: LBA48 
> ata2.00: configured for UDMA/133
[--snip--]
> scsi 1:0:0:0: Direct-Access     ATA      External Disk 0  RGL1 PQ: 0 ANSI: 5
> SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
> sdb: Write Protect is off
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
> SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
> sdb: Write Protect is off
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
>  sdb:<3>irq 504: nobody cared (try booting with the "irqpoll" option)
> 
> Call Trace:
>  <IRQ>  [<ffffffff802b0245>] __report_bad_irq+0x35/0x90
>  [<ffffffff802b04ba>] note_interrupt+0x21a/0x270
>  [<ffffffff802b128f>] handle_edge_irq+0x10f/0x150
>  [<ffffffff8026f3eb>] do_IRQ+0x7b/0xf0
>  [<ffffffff80259e70>] mwait_idle+0x0/0x50
>  [<ffffffff802612d1>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff8042bff0>] vgacon_cursor+0x0/0x1d0
>  [<ffffffff80259eb6>] mwait_idle+0x46/0x50
>  [<ffffffff8024aebc>] cpu_idle+0x5c/0xa0
>  [<ffffffff808b984a>] start_kernel+0x2aa/0x2c0
>  [<ffffffff808b9176>] _sinittext+0x176/0x180
> 
> handlers:
> [<ffffffff804e1c90>] (ahci_interrupt+0x0/0x590)
> Disabling IRQ #504
>  unknown partition table
> sd 1:0:0:0: Attached scsi disk sdb
> sd 1:0:0:0: Attached scsi generic sg1 type 0
> scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
> SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
> sdc: Write Protect is off
> 
> 
> and though it said :
>  sdb:<3>irq 504: nobody cared (try booting with the "irqpoll" option)
> I _am_ booting with the irqpoll option !

Oh... that's just weird.  It seems you'll have to continue boot with the
timeouts for the time being.  Sorry about that.

-- 
tejun
