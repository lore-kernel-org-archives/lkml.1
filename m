Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbXFXBUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbXFXBUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 21:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXFXBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 21:19:59 -0400
Received: from cheetah.fastcat.org ([66.92.74.248]:56876 "EHLO
	cheetah.fastcat.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbXFXBT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 21:19:59 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2007 21:19:59 EDT
Date: Sat, 23 Jun 2007 20:52:30 -0400 (EDT)
From: "Matthew \"Cheetah\" Gabeler-Lee" <cheetah-lkmlsata@fastcat.org>
X-X-Sender: cheetah@cheetah.fastcat.org
To: linux-kernel@vger.kernel.org
Subject: Frequent SATA resets with sata_nv (fwd)
Message-ID: <alpine.DEB.0.99.0706232051520.31644@cheetah.fastcat.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please cc me on replies)

I have three samsung hdds (/sys/block/sda/device/model says SAMSUNG 
SP2504C) in a raid configuration.  My system frequently (2-3x/day) 
experiences temporary lockups, which produce messages as below in my 
dmesg/syslog.  The system recovers, but the hang is annoying to say the 
least.

All three drives are connected to sata_nv ports.  Oddly, it almost 
always happens on ata6 or ata7 (the second and third ports of that 4 
port setup on my motherboard).  There is an identical drive connected at 
ata5, but I've only once or twice seen it hit that drive.

Googling around lkml.org, I found a few threads investigating what look 
like very similar problems, some of which never seemed to find the 
solution, but one of which came up with a fairly quick answer it seemed, 
namely that the drive's NCQ implementation was horked: 
http://lkml.org/lkml/2007/4/18/32

While I don't have older logs to verify exactly when this started, it 
was fairly recent, perhaps around my 2.6.20.1 to 2.6.21.1 kernel 
upgrade.

Any other info or tests I can provide/run to help?

Syslog snippet:
Jun 21 10:35:23 cheetah kernel: ata6: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
Jun 21 10:35:24 cheetah kernel: ata6: CPB 0: ctl_flags 0x9, resp_flags 0x0
Jun 21 10:35:24 cheetah kernel: ata6: timeout waiting for ADMA IDLE, stat=0x400
Jun 21 10:35:24 cheetah kernel: ata6: timeout waiting for ADMA LEGACY, stat=0x400
Jun 21 10:35:24 cheetah kernel: ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Jun 21 10:35:24 cheetah kernel: ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
Jun 21 10:35:24 cheetah kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 21 10:35:24 cheetah kernel: ata6: soft resetting port
Jun 21 10:35:24 cheetah kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun 21 10:35:24 cheetah kernel: ata6.00: configured for UDMA/133
Jun 21 10:35:24 cheetah kernel: ata6: EH complete
Jun 21 10:35:24 cheetah kernel: SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
Jun 21 10:35:24 cheetah kernel: sdb: Write Protect is off
Jun 21 10:35:24 cheetah kernel: sdb: Mode Sense: 00 3a 00 00
Jun 21 10:35:24 cheetah kernel: SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

# lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
01:0d.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 15)
05:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6600 GT] (rev a2)

-- 
	-Cheetah
"Reality is that which, when you stop believing in it, doesn't go away".
                -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2AD1
