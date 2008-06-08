Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYFHL45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYFHL45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbYFHL4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:56:50 -0400
Received: from mail.memset.com ([89.200.136.113]:41773 "EHLO mail.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762AbYFHL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:56:49 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 07:56:49 EDT
Date: Sun, 8 Jun 2008 12:35:27 +0100
From: Nick Craig-Wood <nick@craig-wood.com>
To: linux-kernel@vger.kernel.org
Subject: libata.force=1.5Gbps doesn't seem to work
Message-ID: <20080608113527.GA5105@craig-wood.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since I changed to AHCI (by fiddling with random options in the
BIOS) my external SATA drive is being run at 3.0 Gbps.  However it
doesn't seem reliable at that - maybe the cable is too long. (It is
probably about 80cm in total - one standard SATA cable going to the
case and another from the case to the drive).

I read in Documentation/kernel-parameters.txt that a command line of

  libata.force=1.5Gbps

Should force all my SATA disks to 1.5 Gbps.

However this doesn't seem to work.

Edited highlights of dmesg - note the selection of 3.0 Gbps for ata6 -
that is what I'm trying to avoid.

[    1.087690] SCSI subsystem initialized
[    1.091690] libata version 3.00 loaded.
[    2.241029] ahci 0000:00:1f.2: version 3.0
[    3.300329] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    3.300366] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part
[    3.309764] scsi0 : ahci
[    3.309764] scsi1 : ahci
[    3.309764] scsi2 : ahci
[    3.309764] scsi3 : ahci
[    3.309764] scsi4 : ahci
[    3.309764] scsi5 : ahci
[    3.309764] ata1: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106100 irq 218
[    3.309764] ata2: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106180 irq 218
[    3.309764] ata3: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106200 irq 218
[    3.309764] ata4: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106280 irq 218
[    3.309764] ata5: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106300 irq 218
[    3.309764] ata6: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106380 irq 218
[    3.845799] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.847892] ata1.00: HPA detected: current 586112591, native 586114704
[    3.847926] ata1.00: ATA-7: Maxtor 7L300S0, BANC1E00, max UDMA/133
[    3.847959] ata1.00: 586112591 sectors, multi 0: LBA48 NCQ (not used)
[    3.850048] ata1.00: configured for UDMA/133
[    4.343265] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.345363] ata2.00: ATA-7: Maxtor 7B300S0, BANC1B70, max UDMA/133
[    4.345395] ata2.00: 586114704 sectors, multi 0: LBA48 NCQ (not used)
[    4.344422] ata2.00: configured for UDMA/133
[    4.667268] ata3: SATA link down (SStatus 0 SControl 300)
[    4.987268] ata4: SATA link down (SStatus 0 SControl 300)
[    5.307259] ata5: SATA link down (SStatus 0 SControl 300)
[    5.791265] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)    <--- 1.5 Gbps desired here!
[    5.695773] ata6.00: ATA-7: ST3250620NS,     3BKH, max UDMA/133
[    5.695773] ata6.00: 488281250 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.827259] ata6.00: configured for UDMA/133
[    5.827259] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 7L300S0   BANC PQ: 0 ANSI: 5
[    5.827259] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 7B300S0   BANC PQ: 0 ANSI: 5
[    5.827259] scsi 5:0:0:0: Direct-Access     ATA      ST3250620NS      n/a  PQ: 0 ANSI: 5
[    6.899647] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    6.899684] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part
[    6.903618] scsi6 : ahci
[    6.903618] scsi7 : ahci
[    6.903618] ata7: SATA max UDMA/133 abar m8192@0xfb000000 port 0xfb000100 irq 19
[    6.903618] ata8: SATA max UDMA/133 abar m8192@0xfb000000 port 0xfb000180 irq 19
[    7.219641] ata7: SATA link down (SStatus 0 SControl 300)
[    7.539656] ata8: SATA link down (SStatus 0 SControl 300)
[    7.777106] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.797106] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.821107] sd 5:0:0:0: [sdc] Attached SCSI disk

$ cat /proc/cmdline
root=/dev/md0 panic=60 combined_mode=libata libata.atapi_enabled=1 libata.force=1.5Gbps ro

This is with a 2.6.26-rc5 + latest git

$ git-describe
v2.6.26-rc5-159-gaab2545

Thanks in advance for any help!

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
