Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbXLINKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbXLINKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXLINJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:09:52 -0500
Received: from echo.digadd.de ([195.47.195.234]:55627 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812AbXLINJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:09:51 -0500
X-Greylist: delayed 2287 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 08:09:50 EST
Message-ID: <475BE037.5080400@digadd.de>
Date: Sun, 09 Dec 2007 15:31:51 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071120)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Marvell 88SE6141 (88SE614x) support
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to get the 88SE6141 on my Asus M2N32 WS Professional working.
lspci shows this:
08:00.0 SATA controller: Marvell Technology Group Ltd. 88SE614x SATA II
PCI-E controller (rev 01)
or 08:00.0 0106: 11ab:6141 (rev 01) with -n.

Seeing the post on
http://www.nabble.com/kernel-support-for-Marvell-88SE614x-chipset-t2544905.html
I tried adding

{ PCI_VDEVICE(MARVELL, 0x6141), board_ahci_mv },        /* 6141 */

to drivers/ata/ahci.c - this is the result:

[267730.714613] ahci 0000:08:00.0: version 2.3
[267730.714636] ACPI: PCI Interrupt 0000:08:00.0[A] -> Link [APC7] ->
GSI 16 (level, low) -> IRQ 16
[267730.714775] ahci 0000:08:00.0: controller can't do NCQ, turning off
CAP_NCQ
[267730.714782] ahci 0000:08:00.0: MV_AHCI HACK: port_map 0 -> 0
[267730.714784] ahci 0000:08:00.0: nr_ports (5) and implemented port map
(0xf) don't match
[267731.720228] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 5 ports 3
Gbps 0xf impl SATA mode
[267731.720234] ahci 0000:08:00.0: flags: 64bit stag nz only pmp slum part
[267731.720239] PCI: Setting latency timer of device 0000:08:00.0 to 64
[267731.720631] scsi16 : ahci
[267731.720729] scsi17 : ahci
[267731.720798] scsi18 : ahci
[267731.720862] scsi19 : ahci
[267731.720884] ata17: SATA max UDMA/133 cmd 0xffffc20000034100 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 16
[267731.720889] ata18: SATA max UDMA/133 cmd 0xffffc20000034180 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 16
[267731.720893] ata19: SATA max UDMA/133 cmd 0xffffc20000034200 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 16
[267731.720897] ata20: SATA max UDMA/133 cmd 0xffffc20000034280 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 16
[267732.196138] ata17: SATA link up 1.5 Gbps (SStatus 113 SControl 113)
[267732.247987] ata17.00: ATA-7: ST3500641AS, 3.AAJ, max UDMA/133
[267732.247993] ata17.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
0/32)
[267732.314605] ata17.00: configured for UDMA/133
[267732.628071] ata18: SATA link down (SStatus 0 SControl 0)
[267732.940025] ata19: SATA link down (SStatus 0 SControl 0)
[267733.251979] ata20: SATA link down (SStatus 0 SControl 0)
[267733.252145] scsi 16:0:0:0: Direct-Access     ATA      ST3500641AS
   3.AA PQ: 0 ANSI: 5
[267733.252791] sd 16:0:0:0: [sdi] 976773168 512-byte hardware sectors
(500108 MB)
[267733.252891] sd 16:0:0:0: [sdi] Write Protect is off
[267733.252894] sd 16:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[267733.252958] sd 16:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[267733.253047] sd 16:0:0:0: [sdi] 976773168 512-byte hardware sectors
(500108 MB)
[267733.253091] sd 16:0:0:0: [sdi] Write Protect is off
[267733.253094] sd 16:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[267733.253185] sd 16:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[267733.253191]  sdi: sdi1 sdi2
[267733.270707] sd 16:0:0:0: [sdi] Attached SCSI disk
[267733.270741] sd 16:0:0:0: Attached scsi generic sg8 type 0

I actually can use the disk. Just formatted the disk, and testing with
some data. Only thing is the number of ports, worrying me a bit: ahci
0000:08:00.0: nr_ports (5) and implemented port map (0xf) don't match.
Also there is supposedly an IDE port on that chip as well that might not
work with this particular setup.

Regards,
Chris
