Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXIANo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXIANo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 09:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXIANoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 09:44:20 -0400
Received: from flatoutfitness.com ([66.178.130.209]:55236 "EHLO
	mail.seiner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXIANoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 09:44:19 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 09:44:19 EDT
Message-ID: <46D96637.2000601@seiner.com>
Date: Sat, 01 Sep 2007 06:16:39 -0700
From: Yan Seiner <yan@seiner.com>
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: read-only /sys/block/sda/device/queue_depth
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running into the same issue reported here:

<http://readlist.com/lists/vger.kernel.org/linux-kernel/72/361184.html>

I am using the ata_piix module.  If I read the docs correctly, I should 
be able to use ahci as well; I need to rebuild the kernel though (debian 
insists on putting ata_piix into the initrd....)

dionysus:~# ls -l /sys/block/sd[abcde]/device/queue_depth
-r--r--r-- 1 root root 4096 2007-09-01 06:00 
/sys/block/sda/device/queue_depth
-r--r--r-- 1 root root 4096 2007-09-01 06:00 
/sys/block/sdb/device/queue_depth
-r--r--r-- 1 root root 4096 2007-09-01 06:00 
/sys/block/sdc/device/queue_depth
-r--r--r-- 1 root root 4096 2007-09-01 06:00 
/sys/block/sdd/device/queue_depth
-r--r--r-- 1 root root 4096 2007-09-01 06:00 
/sys/block/sde/device/queue_depth

If I change the perms to rw, I get an Input/Output error.  AFAICT, the 
drives support queueing, but it's disabled.

dionysus:~# uname -a
Linux dionysus 2.6.22.6 #1 SMP Fri Aug 31 14:24:17 PDT 2007 x86_64 GNU/Linux

libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 
bmdma 0x000000000001f000 irq 14
ata2: SATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 
bmdma 0x000000000001f008 irq 15
ata1.00: Host Protected Area detected:
ata1.00: ATA-7: ST3400620AS, 3.AAC, max UDMA/133
ata1.00: 781420655 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.01: Host Protected Area detected:
ata1.01: ATA-7: ST3400620AS, 3.AAC, max UDMA/133
ata1.01: 781420655 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: Host Protected Area detected:
ata1.00: configured for UDMA/133
ata1.01: Host Protected Area detected:
ata1.01: configured for UDMA/133
ata2.00: ATA-7: ST3400620AS, 3.AAC, max UDMA/133
ata2.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.01: ATA-7: ST3400620AS, 3.AAC, max UDMA/133
ata2.01: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133

dionysus:~# lspci -s 00:1f.2 -vvv
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) 
Serial ATA Storage Controller IDE (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Giga-byte Technology Unknown device b002
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at f000 [size=16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

-- 
  o__
  ,>/'_          o__
  (_)\(_)        ,>/'_          o__
Yan Seiner      (_)\(_)         ,>/'_   o__     o__
Certified Personal Trainer     (_)\(_)  ,>/'_   ,>/'_
Licensed Professional Engineer         (_)\(_) (_)\(_)

Linux stuff has made big progress over the competition. When things sit and don't start right away, we have a watch, and those poor guys have to settle for an hourglass.

