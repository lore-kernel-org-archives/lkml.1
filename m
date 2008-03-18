Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYCRNdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYCRNdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYCRNdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:33:21 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:51535 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbYCRNdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:33:17 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Tue, 18 Mar 2008 14:33:12 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803181159.48327.volker.armin.hemmann@tu-clausthal.de> <47DFBBE2.7050304@gmail.com>
In-Reply-To: <47DFBBE2.7050304@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803181433.12584.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 18. März 2008, Tejun Heo wrote:
>  failed message on reboots).
>
> > Of course, I booted and rebooted several times. And it stays.
> >
> > Maybe it is the hardware. But I replaced the cables already and smart
> > says the disk is ok.
>
> Does the attached patch make any difference?

patching file drivers/ata/ahci.c
Hunk #1 succeeded at 397 (offset -5 lines).
Hunk #2 succeeded at 1819 (offset -45 lines).

built&booted, same results as allways. With non-raid setting, IDENTIFY error 
on cold boot and sofreset error on reboot:
(with patch, without nosmi):

cold boot:
[   35.397857] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   36.398054] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   36.398102] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   36.398142] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   36.398343] scsi0 : ahci
[   36.398439] scsi1 : ahci
[   36.398505] scsi2 : ahci
[   36.398570] scsi3 : ahci
[   36.398659] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   36.398707] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   36.398754] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   36.398801] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   36.870357] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   66.805287] ata1.00: qc timeout (cmd 0xec)
[   66.805326] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   66.805365] ata1: failed to recover some devices, retrying in 5 secs
[   72.270071] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   72.270674] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   72.270716] ata1.00: 312581808 sectors, multi 16: LBA48
[   72.271355] ata1.00: configured for UDMA/133
[   72.742378] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   72.762946] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   72.762986] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   72.764976] ata2.00: configured for UDMA/133
[   73.074987] ata3: SATA link down (SStatus 0 SControl 300)
[   73.387641] ata4: SATA link down (SStatus 0 SControl 300)
[   73.387729] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   73.387839] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   73.387883] sd 0:0:0:0: [sda] Write Protect is off
[   73.387921] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   73.387929] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   73.387999] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   73.388042] sd 0:0:0:0: [sda] Write Protect is off
[   73.388080] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   73.388087] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   73.388136]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   73.418040] sd 0:0:0:0: [sda] Attached SCSI disk
[   73.418174] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   73.418282] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   73.418327] sd 1:0:0:0: [sdb] Write Protect is off
[   73.418365] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   73.418373] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   73.418448] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   73.418491] sd 1:0:0:0: [sdb] Write Protect is off
[   73.418529] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   73.418537] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   73.418586]  sdb: sdb1 sdb2
[   73.441032] sd 1:0:0:0: [sdb] Attached SCSI disk


reboot:
[   47.228096] ahci 0000:00:0a.0: version 3.0
[   47.228271] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   47.228315] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   47.228649] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   48.228845] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   48.228893] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   48.228932] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   48.229134] scsi0 : ahci
[   48.229230] scsi1 : ahci
[   48.229296] scsi2 : ahci
[   48.229361] scsi3 : ahci
[   48.229450] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   48.229497] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   48.229545] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   48.229592] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   53.703608] ata1: port is slow to respond, please be patient (Status 0xd0)
[   58.546416] ata1: softreset failed (device not ready)
[   58.706072] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   58.706695] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   58.706738] ata1.00: 312581808 sectors, multi 16: LBA48
[   58.707375] ata1.00: configured for UDMA/133
[   59.178379] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   59.198957] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   59.198996] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   59.200994] ata2.00: configured for UDMA/133
[   59.510988] ata3: SATA link down (SStatus 0 SControl 300)
[   59.823642] ata4: SATA link down (SStatus 0 SControl 300)
[   59.823730] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   59.823841] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   59.823885] sd 0:0:0:0: [sda] Write Protect is off
[   59.823923] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   59.823931] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   59.824001] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   59.824044] sd 0:0:0:0: [sda] Write Protect is off
[   59.824081] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   59.824089] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   59.824138]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   59.854855] sd 0:0:0:0: [sda] Attached SCSI disk
[   59.854992] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   59.855100] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   59.855145] sd 1:0:0:0: [sdb] Write Protect is off
[   59.855183] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   59.855192] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   59.855261] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   59.855304] sd 1:0:0:0: [sdb] Write Protect is off
[   59.855342] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   59.855349] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   59.855399]  sdb: sdb1 sdb2
[   59.902185] sd 1:0:0:0: [sdb] Attached SCSI disk

>
> >>> Setting AHCI in bios still results in timeouts and harddisks not found.
> >>
> >> Does pci=nomsi help?
> >
> > oh yes!
> >  It does. I changed the 'Sata operation mode' setting from 'non raid' to
> > AHCI, booted with that option:
> >
> > the most obvious change are the different interrupts: 23 instead of 315
> > (non-raid, without nosmi) or 218 (systemrescuecd 1.0, ahci setting,
> > without nosmi)

btw, with 2.6.24.3, without nosmi and my own config it stays at 315. So 
non-raid and ahci both get the same interrupt, and the same error (ahci 
always gives the IDENTIFY error, on cold boots and reboots). But non-raid 
finds the harddisks at the end, ahci does not.

>
> Yeah, that sounds about right.  Hmm... Can you post the result of "lspci
> -nn"?

lspci -nn
00:00.0 RAM memory [0500]: nVidia Corporation MCP65 Memory Controller 
[10de:0444] (rev a1)
00:01.0 ISA bridge [0601]: nVidia Corporation MCP65 LPC Bridge [10de:0441] 
(rev a2)
00:01.1 SMBus [0c05]: nVidia Corporation MCP65 SMBus [10de:0446] (rev a1)
00:01.2 RAM memory [0500]: nVidia Corporation MCP65 Memory Controller 
[10de:0445] (rev a1)
00:02.0 USB Controller [0c03]: nVidia Corporation MCP65 USB Controller 
[10de:0454] (rev a1)
00:02.1 USB Controller [0c03]: nVidia Corporation MCP65 USB Controller 
[10de:0455] (rev a1)
00:08.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI bridge [10de:0449] 
(rev a1)
00:09.0 IDE interface [0101]: nVidia Corporation MCP65 IDE [10de:0448] (rev 
a1)
00:0a.0 SATA controller [0106]: nVidia Corporation MCP65 AHCI Controller 
[10de:044d] (rev a1)
00:0b.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:045b] (rev 
a1)
00:0c.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge 
[10de:045a] (rev a1)
00:0d.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge 
[10de:0458] (rev a1)
00:0e.0 PCI bridge [0604]: nVidia Corporation MCP65 PCI Express bridge 
[10de:0459] (rev a1)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control [1022:1103]
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 01)
02:08.0 SCSI storage controller [0100]: Adaptec AHA-2944UW / AIC-7884U 
[9004:8478] (rev 01)
02:09.0 Multimedia audio controller [0401]: Creative Labs SB0400 Audigy2 Value 
[1102:0008]
04:00.0 VGA compatible controller [0300]: nVidia Corporation Unknown device 
[10de:0402] (rev a1)

Glück Auf,
Volker

