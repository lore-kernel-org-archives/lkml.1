Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbYBLVCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbYBLVCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764906AbYBLVCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:02:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:49231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764885AbYBLVCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:02:38 -0500
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Tim Ellis <tim@ngndg.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 08:02:09 +1100
Message-Id: <1202850129.7410.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 15:58 +0000, Tim Ellis wrote:

> This change causes attached drives to no longer be detected and  
> function on the PowerPC Buffalo Linkstation machines:
> 
> <7>pata_sil680 0000:00:0c.0: version 0.4.8
> <6>sil680: 133MHz clock.
> <6>scsi0 : pata_sil680
> <6>scsi1 : pata_sil680
> <6>ata1: PATA max UDMA/133 irq 18
> <6>ata2: PATA max UDMA/133 irq 18
> 
> If I roll back this driver to before this change with 2.6.24.2 it works:

Hrm... and we need those patches for blades that have a sil680
controller with no working PIO on the PCI host...

That's strange though. Somebody with knowledge of that HW (or specs) who
can spot something ? Could it be an issue with timing ?

I don't have HW access to this machine. If somebody could send one to me
I could do more investigation.

Ben.

> <7>pata_sil680 0000:00:0c.0: version 0.4.7
> <6>sil680: 133MHz clock.
> <6>scsi0 : pata_sil680
> <6>scsi1 : pata_sil680
> <6>ata1: PATA max UDMA/133 cmd 0xbffed0 ctl 0xbffed8 bmdma 0xbffef0  
> irq 18
> <6>ata2: PATA max UDMA/133 cmd 0xbffee0 ctl 0xbffee8 bmdma 0xbffef8  
> irq 18
> <6>ata1.00: ATA-6: WDC WD3200JB-00KFA0, 08.05J08, max UDMA/100
> <6>ata1.00: 625142448 sectors, multi 0: LBA48
> <6>ata1.00: configured for UDMA/100
> <5>scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200JB-00K 08.0 PQ:  
> 0 ANSI: 5
> <5>sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> <5>sd 0:0:0:0: [sda] Write Protect is off
> <7>sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> <5>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,  
> doesn't support DPO or FUA
> <5>sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> <5>sd 0:0:0:0: [sda] Write Protect is off
> <7>sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> <5>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,  
> doesn't support DPO or FUA
> <6> sda: sda1 sda2 sda3 sda4
> <5>sd 0:0:0:0: [sda] Attached SCSI disk
> <5>sd 0:0:0:0: Attached scsi generic sg0 type 0
> 
> I have ensured the other sil680 driver is not enabled!

