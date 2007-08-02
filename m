Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbXHBKsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbXHBKsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXHBKsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:48:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29129 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXHBKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NEPNJRGeLOQHIRRVnfnINbC/YzCZ0KlhzoTtYLzzwPK3MjfUaclTOX9lWAiAjrnfmrJx6ddga2JMEm0w2x6T2kq1XCQcH3IMAXSzfaqBSfaP2J2Dft/UWZt3mT7GzYpAjFn2i6CwEklzeZnOKj5L8uNq6KhHeoiTPQjTVHDgMbI=
Message-ID: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>
Date: Thu, 2 Aug 2007 11:48:05 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: ICH8 CF timeout (regression)...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing timeouts with libata when reading from a compact
flash card connected to onboard IDE. Reproducible with 2.6.20, 2.6.22,
2.6.23-rc1, with both short cable and a on-mobo CF socket on a x86-64
Core2Duo.

Sometimes (~7%), we see some EH and the interface stablises, then the
system continues to work as expected [1] (35MB/s DMA from the CF), but
most of the time, it goes nowhere [2].

When running with legacy ATA support, the system consistently works
fine (but without DMA). CF [3] and controller [4] info supplied.

I'll grab kernel logs from the legacy ATA boot; what else can help
debug this issue? No problem testing patches too.

Daniel

--- [1]

[    0.000000] Linux version 2.6.22-8-generic (buildd@yellow) (gcc
version 4.1.3 20070629 (prerelease) (Ubuntu 4.1.2-13ubuntu2)) #1 SMP
Thu Jul 12 16:09:47 GMT 2007
...
[   23.987509] ata_piix 0000:00:1f.2: version 2.11
[   23.987514] ata_piix 0000:00:1f.2: MAP [ IDE IDE -- -- ]
[   23.987835] scsi0 : ata_piix
[   23.987903] scsi1 : ata_piix
[   23.987960] ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x000000000001f800 irq 14
[   23.988015] ata2: SATA max UDMA/133 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x000000000001f808 irq 15
[   24.306364] ata2.00: CFA: SanDisk SDCFX-4096, HDX 4.04, max UDMA/66
[   24.306408] ata2.00: 8027712 sectors, multi 0: LBA
[   24.306446] ata2.00: applying bridge limits
[   24.306971] ata2.00: configured for UDMA/66
[   24.307086] scsi 1:0:0:0: Direct-Access     ATA      SanDisk
SDCFX-40 HDX  PQ: 0 ANSI: 5
[   24.311383] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   24.311435] sd 1:0:0:0: [sda] Write Protect is off
[   24.311474] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.311487] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   24.311585] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   24.311634] sd 1:0:0:0: [sda] Write Protect is off
[   24.311673] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.311685] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   24.311740]  sda: sda1 sda2 sda3
[   24.312962] sd 1:0:0:0: [sda] Attached SCSI removable disk
[   24.316318] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   24.350048] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[   24.350097] ata2.00: (BMDMA stat 0x24)
[   24.350142] ata2.00: cmd c8/00:07:d2:b7:72/00:00:00:00:00/e0 tag 0
cdb 0x0 data 3584 in
[   24.350144]          res 51/84:00:d8:b7:72/00:00:00:00:00/e0 Emask
0x10 (ATA bus error)
[   24.350266] ata2: soft resetting port
[   24.508020] ata2.00: configured for UDMA/66
[   24.508068] ata2: EH complete
[   24.509290] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   24.509572] sd 1:0:0:0: [sda] Write Protect is off
[   24.509612] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.509974] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   24.539976] EXT3-fs: mounted filesystem with ordered data mode.
[   24.552259] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[   24.552307] ata2.00: (BMDMA stat 0x24)
[   24.552351] ata2.00: cmd c8/00:08:59:13:00/00:00:00:00:00/e0 tag 0
cdb 0x0 data 4096 in
[   24.552354]          res 51/84:00:60:13:00/00:00:00:00:00/e0 Emask
0x10 (ATA bus error)
[   24.552473] ata2: soft resetting port
[   24.712647] ata2.00: configured for UDMA/66
[   24.712687] ata2: EH complete
[   24.713173] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   24.713462] sd 1:0:0:0: [sda] Write Protect is off
[   24.713505] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.713769] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   24.726935] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[   24.726983] ata2.00: (BMDMA stat 0x24)
[   24.727028] ata2.00: cmd c8/00:20:01:c4:06/00:00:00:00:00/e0 tag 0
cdb 0x0 data 16384 in
[   24.727031]          res 51/84:00:20:c4:06/00:00:00:00:00/e0 Emask
0x10 (ATA bus error)
[   24.727151] ata2: soft resetting port
[   24.881089] ata2.00: configured for UDMA/66
[   24.881128] ata2: EH complete
[   24.881944] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   24.882420] sd 1:0:0:0: [sda] Write Protect is off
[   24.882463] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.884157] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   24.886454] ata2.00: limiting speed to UDMA/44:PIO4
[   24.886497] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[   24.886542] ata2.00: (BMDMA stat 0x24)
[   24.886586] ata2.00: cmd c8/00:90:71:c4:06/00:00:00:00:00/e0 tag 0
cdb 0x0 data 73728 in
[   24.886588]          res 51/84:00:00:c5:06/00:00:00:00:00/e0 Emask
0x10 (ATA bus error)
[   24.886705] ata2: soft resetting port
[   25.041843] ata2.00: configured for UDMA/44
[   25.041882] ata2: EH complete
[   25.044050] sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
[   25.045202] sd 1:0:0:0: [sda] Write Protect is off
[   25.045241] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   25.045880] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
<continues to boot and work fine from here>

--- [2]

Linux version 2.6.23-rc1-101 (root@x1) (gcc version 4.1.3 20070718
(prerelease) (Ubuntu 4.1.2-14ubuntu1)) #1 Wed Aug 1 23:03:47 BST 2007
...
ata_piix 0000:00:1f.2: MAP [ IDE IDE -- -- ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6
bmdma 0x000000000001f800 irq 14
ata2: SATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376
bmdma 0x000000000001f808 irq 15
ata2.00: CFA: SanDisk SDCFX-4096, HDX 4.04, max UDMA/66
ata2.00: 8027712 sectors, multi 0: LBA
ata2.00: applying bridge limits
ata2.00: configured for UDMA/66
scsi 1:0:0:0: Direct-Access     ATA      SanDisk SDCFX-40 HDX  PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sda] 8027712 512-byte hardware sectors (4110 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda:<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for UDMA/66
ata2: EH complete
<repeats>
ata2.00: limiting speed to UDMA/44:PIO4
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for UDMA/44
ata2: EH complete
<epeats>
sd 1:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 1:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 00
sd 1:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for UDMA/44
ata2: EH complete
ata2.00: limiting speed to UDMA/33:PIO4
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2.00: configured for UDMA/33
ata2: EH complete

--- [3]

# hdparm -i /dev/sda
/dev/sda:

 Model=SanDisk SDCFX-4096                      , FwRev=HDX 4.04,
SerialNo=    116802D2807J3335
 Config={ HardSect NotMFM Removeable DTR>10Mbs nonMagnetic }
 RawCHS=7964/16/63, TrkSize=0, SectSize=576, ECCbytes=4
 BuffType=DualPort, BuffSize=1kB, MaxMultSect=4, MultSect=?0?
 CurCHS=7964/16/63, CurSects=8027712, LBA=yes, LBAsects=8027712
 IORDY=no, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 *udma3 udma4
 AdvancedPM=no WriteCache=disabled
 Drive conforms to: Unspecified:  ATA/ATAPI-4

 * signifies the current active mode

# hdparm -I /dev/sda
/dev/sda:

CompactFlash ATA device, with removable media
	Model Number:       SanDisk SDCFX-4096
	Serial Number:      116802D2807J3335
	Firmware Revision:  HDX 4.04
Standards:
	Supported: 4
	Likely used: 4
Configuration:
	Logical		max	current
	cylinders	7964	7964
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:    8027712
	LBA    user addressable sectors:    8027712
	device size with M = 1024*1024:        3919 MBytes
	device size with M = 1000*1000:        4110 MBytes (4 GB)
Capabilities:
	LBA, IORDY(may be)(cannot be disabled)
	Standby timer values: spec'd by Vendor
	R/W multiple sector transfer: Max = 4	Current = 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 *udma3 udma4
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	    	Write cache
	   *	CFA feature set
	   *	CFA advanced modes: pio5 *pio6

--- [4]

# lspci -vvv
00:1f.2 IDE interface: Intel Corporation Mobile SATA IDE Controller
(rev 03) (prog-if 80 [Master])
	Subsystem: Intel Corporation Mobile SATA IDE Controller
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f800 [size=16]
	Region 5: I/O ports at f700 [size=16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
-- 
Daniel J Blueman
