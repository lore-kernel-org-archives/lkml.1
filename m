Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbXAYDhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbXAYDhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 22:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXAYDhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 22:37:38 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:33435 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbXAYDhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 22:37:36 -0500
Date: Thu, 25 Jan 2007 03:57:20 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Intel PCI-E bridge ACPI resources and possibly related SATA unstability
 problems on ASUS A8Js
Message-ID: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="546507526-1972290925-1169693840=:14408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--546507526-1972290925-1169693840=:14408
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

recently I got my hands on an ASUS A8Js notebook (Core 2 Duo T7200,
Intel 945 PM PCI-E Chipset, for details see attached log). After booting 
the latest 2.6.20-rc5-git3 kernel (but the same behaviour occurs also with 
the 2.6.19.2, didn't try any other), some strange behaviour can be 
observed.

At first the following messages appear in the log:

...
[   40.303154] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   40.303157] PCI: Not using MMCONFIG.

(not sure whether this is really a problem)

...
[   40.400899] PCI: Using ACPI for IRQ routing
[   40.400902] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   40.400911] PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.3
[   40.400914] PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.3
[   40.400917] PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.3

and if I have the Kouwell 5652E SATA-II ExpressCard (with Silicon Image 
SiL 3132 controller) connected to the notebook's ExpressCard slot, also 
the following messages appear after the above ones:

[   40.400999] PCI: Cannot allocate resource region 0 of device 0000:04:00.0
[   40.401003] PCI: Cannot allocate resource region 2 of device 0000:04:00.0
[   40.401006] PCI: Cannot allocate resource region 4 of device 0000:04:00.0
...

where

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)

Both SATA controllers (the on-board using ata_piix and the ExpressCard 
using sata_sil24) are the detected

...
[   40.639495] ata_piix 0000:00:1f.2: version 2.00ac7
[   40.639500] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[   40.640063] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   40.640763] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   40.640814] ata1: SATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
[   40.641467] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
[   40.642114] scsi0 : ata_piix
[   40.853499] ata1.00: ATA-7, max UDMA/100, 234441648 sectors: LBA48 NCQ (depth 0/32)
[   40.854188] ata1.00: ata1: dev 0 multi count 16
[   40.860490] ata1.00: configured for UDMA/100
[   40.860881] scsi1 : ata_piix
[   41.025049] ATA: abnormal status 0x7F on port 0x177
[   41.045585] ATA: abnormal status 0x7F on port 0x177
[   41.231326] ata2.01: ATAPI, max UDMA/33
[   41.417213] ata2.01: configured for UDMA/33
[   41.426449] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2120B 0000 PQ: 0 ANSI: 5
[   41.436554] SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
[   41.447026] sda: Write Protect is off
[   41.457669] sda: Mode Sense: 00 3a 00 00
[   41.457693] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   41.469438] SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
[   41.481481] sda: Write Protect is off
[   41.493694] sda: Mode Sense: 00 3a 00 00
[   41.493708] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   41.507017]  sda: sda1 sda2 sda3 sda4
[   41.604667] sd 0:0:0:0: Attached scsi disk sda
[   41.622803] scsi 1:0:1:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D AS05 PQ: 0 ANSI: 5
...
[   48.817403] sata_sil24 0000:04:00.0: version 0.3
[   48.817432] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[   48.817475] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   48.817531] ata3: SATA max UDMA/100 cmd 0xFFFFC20000040000 ctl 0x0 bmdma 0x0 irq 19
[   48.817585] ata4: SATA max UDMA/100 cmd 0xFFFFC20000042000 ctl 0x0 bmdma 0x0 irq 19
[   48.817593] scsi2 : sata_sil24
[   49.068344] Bluetooth: HCI USB driver ver 2.9
[   49.142279] usbcore: registered new interface driver hci_usb
[   49.222098] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   49.222610] ata3.00: ATA-7, max UDMA/133, 156312576 sectors: LBA
[   49.222612] ata3.00: ata3: dev 0 multi count 0
[   49.223246] ata3.00: configured for UDMA/100
[   49.223260] scsi3 : sata_sil24
[   49.525900] ata4: SATA link down (SStatus 0 SControl 300)
[   49.526898] scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6Y080M0   YAR5 PQ: 0 ANSI: 5
[   49.527093] SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
[   49.527103] sdb: Write Protect is off
[   49.527105] sdb: Mode Sense: 00 3a 00 00
[   49.527269] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   49.527309] SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
[   49.527317] sdb: Write Protect is off
[   49.527319] sdb: Mode Sense: 00 3a 00 00
[   49.527337] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   49.527341]  sdb:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[   49.536071] scsi 1:0:1:0: Attached scsi generic sg1 type 5
[   49.552648]  sdb1
[   49.552700] sd 2:0:0:0: Attached scsi disk sdb
[   49.552733] sd 2:0:0:0: Attached scsi generic sg2 type 0
...

However, strange messages simillar to the following appear periodically 
(possibly a result of the system accessing the disk, but not always, when 
accessed) for both controllers

...
[  193.907771] ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  193.927526] ata2.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x25 data 8 in
[  193.927529]          res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask 0x4 (timeout)
[  201.007291] ata2: port is slow to respond, please be patient (Status 0xd0)
[  223.974196] ata2: port failed to respond (30 secs, Status 0xd0)
[  224.000456] ata2: soft resetting port
[  224.163274] ATA: abnormal status 0x7F on port 0x177
[  224.568225] ata2.01: configured for UDMA/33
[  224.568237] ata2: EH complete
[  231.828794] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[  231.849673] ata3.00: (irq_stat 0x00020002, device error via D2H FIS)
[  231.871059] ata3.00: cmd c8/00:00:08:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 131072 in
[  231.871061]          res 51/84:00:08:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[  232.217493] ata3: soft resetting port
[  232.318609] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  232.319782] ata3.00: configured for UDMA/100
[  232.319792] ata3: EH complete
[  232.340315] SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
[  232.363118] sdb: Write Protect is off
[  232.385795] sdb: Mode Sense: 00 3a 00 00
[  232.387452] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  232.470053] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
[  232.492477] ata3.00: (irq_stat 0x00020002, device error via D2H FIS)
[  232.515254] ata3.00: cmd c8/00:00:f8:16:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 131072 in
[  232.515256]          res 51/84:00:f8:16:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
[  232.864801] ata3: soft resetting port
[  232.965875] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  232.967043] ata3.00: configured for UDMA/100
[  232.967055] ata3: EH complete
[  232.988447] SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
[  233.012277] sdb: Write Protect is off
[  233.035602] sdb: Mode Sense: 00 3a 00 00
[  233.037536] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
...

Until after some seconds of accessing the disk on the external controller, 
the whole disk is shut down:

...
[  269.026999] ata3.00: limiting speed to UDMA/33
[  269.058614] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  269.090354] ata3.00: (irq_stat 0x00020002, failed to transmit command FIS)
[  269.122048] ata3.00: cmd c8/00:08:4f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
[  269.122051]          res c8/00:08:4f:00:00/00:00:00:00:00/e0 Emask 0x12 (ATA bus error)
[  269.184814] ata3: hard resetting port
[  271.414531] ata3: softreset failed (port not ready)
[  271.445584] ata3: follow-up softreset failed, retrying in 5 secs
[  276.474431] ata3: hard resetting port
[  278.805006] ata3: softreset failed (port not ready)
[  278.835656] ata3: follow-up softreset failed, retrying in 5 secs
[  283.864906] ata3: hard resetting port
[  286.094543] ata3: softreset failed (port not ready)
[  286.124723] ata3: reset failed, giving up
[  286.154334] ata3.00: disabled
[  286.183738] ata3: EH pending after completion, repeating EH (cnt=4)
[  286.294424] ata3: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0x6 frozen
[  286.324117] ata3: (irq_stat 0x00060002, failed to transmit command FIS)
[  286.874068] ata3: waiting for device to spin up (8 secs)
[  294.289524] ata3: hard resetting port
[  296.519160] ata3: softreset failed (port not ready)
[  296.519741] ata3: follow-up softreset failed, retrying in 5 secs
[  301.518100] ata3: hard resetting port
[  303.748733] ata3: softreset failed (port not ready)
[  303.748738] ata3: follow-up softreset failed, retrying in 5 secs
[  308.746700] ata3: hard resetting port
[  311.077274] ata3: softreset failed (port not ready)
[  311.077277] ata3: reset failed, giving up
[  311.077284] sd 2:0:0:0: SCSI error: return code = 0x08000002
[  311.077286] sdb: Current [descriptor]: sense key: Aborted Command
[  311.077289]     Additional sense: Scsi parity error
[  311.077294] Descriptor sense data with sense descriptors (in hex):
[  311.077296]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[  311.077302]         00 00 00 4f
[  311.077304] end_request: I/O error, dev sdb, sector 79
[  311.077314] ata3: EH complete
[  311.077320] ata3.00: detaching (SCSI 2:0:0:0)
[  311.077323] EXT3-fs: can't read group descriptor 1
[  311.174529] Synchronizing SCSI cache for disk sdb:
[  311.196553] FAILED
[  311.196555]   status = 0, message = 00, host = 4, driver = 00
[  311.196556]   <3>ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
...

I didn't manage to shut down the disk on the primary ata_piix controller 
that easily, but I guess when I'd try long and hard enough, it may suffer 
the same fate (or maybe not?).

All of this is clearly reproducible. I do not know whether this behaviour 
is somehow related to the ACPI detection problems stated at the beginning 
of the mail, or whether these are two different bugs. That's why I haven't 
reported it to bugzilla yet, because I do not know which section this or 
these (?) should belong to. But I will do so, if anyone of you shall 
kindly give me some clue for this. Also if you need any more info or 
testing, just ask.

The full system logs (and configuration) are attached.

Martin

--546507526-1972290925-1169693840=:14408
Content-Type: APPLICATION/x-bzip2; name=system-logs.tar.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0701250357200.14408@kepler.fjfi.cvut.cz>
Content-Description: full kernel logs
Content-Disposition: attachment; filename=system-logs.tar.bz2

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
xKT2Icg+cMfQnofTIshSpSxaHyJqeBJiSUiTwn8h3o/ah9IxPNJ2I4kneHEK
nSn2fOk0jhBcuHvhgYn1Fy59UjWSNkKh1MTsI65I7odZ2DdJtME/aioNsJXF
I2Rwj/GSNJyDRIrNyRBHohqxiUe3t74xjGMj6/q74c9KHi1B5ltmJvBBgbuo
A3IVz+Hmt595+tl78jYGjMkwyC46eGfquAcCngbbvq4oUu9Gu0pdCrtoKQjQ
XN7n9hpPzc/OtLnaqkcw/lhZapGKgJklA+waoZNykdmKcUxxnA+o/fl5fchQ
KCEUCBQkUKDp7meKrDAzu4ywoHd2esLI32DJIsiBieSqxjMfR0yZDGDbFhMy
pjF+zmHBgl1xFo44rfJTKoUEqKDEWNLp3Gmk8OUUQiCJChpIeVWHS0k7DN0y
uwYMGChlmjkkAHWkEZCDVFMxDoYqsUGiCqhQodgrIkPQQjGsq7syLEC8QWVb
iqtJNJrGpCTOKhuumDYu20oyUNt7YrhpnTOdGi61NKMMzi2TCAsCZ4SGjoMm
qUZaHBA1xtWsslMDEttK0Lq6oqneDWNrtrJeI3dYyRq8Ukaauy9ZqGDGJvZW
9F4oTcNC6soLorMuH5SNzjO/MxoZbF7xvw47+is/aXgLMYZDGTeCD4MautdP
2USFrY4zSmHd3sLx+NHwPWTJIEUBMkuq0O0DnQPP6u7d7i0vLP0YAHhjdNBT
mEEECkDgDJazo3fo7imn1c8Lv+9i8EMyZmKqVqi/Tc7tQyYuj4ujdiCd0Bsm
3XTP92PPqrOP9fxoXoiaiQhMFpHqptmDh2hl8U7H8oyJs1s7r2P46TVHmHaN
u+0MTr02GVSdNL1Xh9NEattDIw/T53xGO33srku6z+3Ontz6h6ikL+r/HHUI
RPN1A/6FsiUVvgpY66pOkcQpPz6aeyYx35lrCloWP4kD3oXHxwvEvep5bsby
sYNaSWXliSW0skkxZ/NPAZhi8l9MJJPGhIN/DB7fRuxVUMkHOM75u6JSOmkk
/chqkP7Y2shWOUmTbPo6svBcMcL7kumee+zbQRCkBIOklY/PYz6oX5vZz0EI
QvQz0s9zQIRc+FtEdofl/p7o+TM9ZkRgjARAIwcr5Ao4c19frotoPo8NQMzk
RzIvwrqCqw3A+c6AIiAM5ZvbdHTUz02wJEXqRSBVRonAnbZNQ5b8cSYoaHMb
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
DeivvqB1qj3BE2r+SCT+LuSKcKEhBRYb8g==

--546507526-1972290925-1169693840=:14408--
