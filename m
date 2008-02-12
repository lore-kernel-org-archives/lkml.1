Return-Path: <linux-kernel-owner+w=401wt.eu-S1763050AbYBLQmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763050AbYBLQmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759183AbYBLQly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:41:54 -0500
Received: from mailout13.yourhostingaccount.com ([65.254.253.110]:56137 "EHLO
	mailout13.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314AbYBLQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:41:53 -0500
X-Greylist: delayed 2578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 11:41:53 EST
X-EN-OrigOutIP: 10.1.18.10
X-EN-IMPSID: ofyh1Y0040D2B7u0000000
Message-Id: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
From: Tim Ellis <tim@ngndg.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
Date: Tue, 12 Feb 2008 15:58:08 +0000
Cc: jeff@garzik.org, benh@kernel.crashing.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-Mailer: Apple Mail (2.915)
X-EN-UserInfo: b8ae887d91300d60195f6ea73d56f3bc:43527cee0c82d0ab5dc2dc3726f6afdf
X-EN-AuthUser: tim@ngndg.com
X-EN-OrigIP: 82.34.50.106
X-EN-OrigHost: 82-34-50-106.cable.ubr02.chel.blueyonder.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This change causes attached drives to no longer be detected and  
function on the PowerPC Buffalo Linkstation machines:

<7>pata_sil680 0000:00:0c.0: version 0.4.8
<6>sil680: 133MHz clock.
<6>scsi0 : pata_sil680
<6>scsi1 : pata_sil680
<6>ata1: PATA max UDMA/133 irq 18
<6>ata2: PATA max UDMA/133 irq 18

If I roll back this driver to before this change with 2.6.24.2 it works:

<7>pata_sil680 0000:00:0c.0: version 0.4.7
<6>sil680: 133MHz clock.
<6>scsi0 : pata_sil680
<6>scsi1 : pata_sil680
<6>ata1: PATA max UDMA/133 cmd 0xbffed0 ctl 0xbffed8 bmdma 0xbffef0  
irq 18
<6>ata2: PATA max UDMA/133 cmd 0xbffee0 ctl 0xbffee8 bmdma 0xbffef8  
irq 18
<6>ata1.00: ATA-6: WDC WD3200JB-00KFA0, 08.05J08, max UDMA/100
<6>ata1.00: 625142448 sectors, multi 0: LBA48
<6>ata1.00: configured for UDMA/100
<5>scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200JB-00K 08.0 PQ:  
0 ANSI: 5
<5>sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
<5>sd 0:0:0:0: [sda] Write Protect is off
<7>sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,  
doesn't support DPO or FUA
<5>sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
<5>sd 0:0:0:0: [sda] Write Protect is off
<7>sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,  
doesn't support DPO or FUA
<6> sda: sda1 sda2 sda3 sda4
<5>sd 0:0:0:0: [sda] Attached SCSI disk
<5>sd 0:0:0:0: Attached scsi generic sg0 type 0

I have ensured the other sil680 driver is not enabled!
