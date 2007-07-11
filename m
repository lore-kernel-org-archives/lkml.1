Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbXGKRCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbXGKRCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXGKRCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:02:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:50412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXGKRCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:02:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,527,1175497200"; 
   d="scan'208";a="264954540"
Date: Wed, 11 Jul 2007 09:58:48 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: SCSI link power management patches - a question..
Message-Id: <20070711095848.f556d124.kristen.c.accardi@intel.com>
In-Reply-To: <11044.1184118159@turing-police.cc.vt.edu>
References: <11044.1184118159@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 21:42:39 -0400
Valdis.Kletnieks@vt.edu wrote:

> I refitted the 4 patches you posted to a 22-rc6-mm1 kernel, and tried it on
> my Dell Latitude D820 laptop, using the libata driver for the disk and DVD.
> I got this:
> 
> [    0.702000] scsi0 : ata_piix
> [    0.702000] scsi1 : ata_piix
> [    0.702000] ata1: SATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x
> 000000000001bfa0 irq 14
> [    0.702000] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x
> 000000000001bfa8 irq 15
> [    0.857000] ata1.00: ATA-7: ST980825AS, 8.04, max UDMA/133
> [    0.857000] ata1.00: 156301488 sectors, multi 8: LBA48 NCQ (depth 0/32)
> [    0.864000] ata1.00: configured for UDMA/133
> [    1.169000] ata2.00: ATAPI: PHILIPS DVD+/-RW SDVD8820, AD15, max UDMA/33
> [    1.342000] ata2.00: configured for UDMA/33
> ....
> [    1.342000]  sda: sda1 sda2
> [    1.433000] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.435000] scsi 1:0:0:0: CD-ROM            PHILIPS  DVD+-RW SDVD8820 AD15 PQ: 0 ANSI: 5
> [    1.454000] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
> [    1.454000] Uniform CD-ROM driver Revision: 3.20
> [    1.454000] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    1.454000] ata2.00: Unable to set Link PM policy
> 
> and /sys/class/scsi_host/host[01]/link_power_management_policy are both
> stuck at 'max_performance'.  After reading the code,it *appears* that this
> is because:
> 
> host0 - the 2 ports on the first ATA chain, and it's stuck because the DVD
> doesn't support the required power management, and *all* devices on the chain
> need to support it (as it didnt complain on ata1, the hard drive).
> 
> host1 - the second ATA chain, not connected to anything, so no PM available.
> 
> How do I double-check my analysis? Neither hdparm nor sdparm gave me anything
> on /dev/dvd that told me either way, and I'd like to verify that the base
> problem is "screwed by the hardware" before I give up....
> 
> 
> 

Hi,
I only implemented the needed support for using ALPM for the ahci driver, 
and it looks like you are using ata_piix.

Kristen
