Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXBGKD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXBGKD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXBGKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:03:56 -0500
Received: from vsmtp3.tin.it ([212.216.176.223]:38528 "EHLO vsmtp3.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbXBGKDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:03:54 -0500
Date: Wed, 7 Feb 2007 11:03:26 +0100 (CET)
From: venom@sns.it
To: jgarzik@pobox.com, htejun@gmail.com, alan@red-hat.com
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new
 pata driver, NV CK804 ide controller.
In-Reply-To: <200702070119.36320.genoni@darkstar.oltrelinux.com>
Message-ID: <Pine.LNX.4.64.0702071040570.3465@DarkStar.sns.it>
References: <200702070119.36320.genoni@darkstar.oltrelinux.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I boot 2.6.20 also on a pentium4 with intel 82801EB/ER (ICH5/ICH5R) IDE 
Controller and the same pata disk.
On this controller the disk runs in DMA100 as it should, so I'm prone to 
think it is a pata_amd.c driver trouble. Should try downgrading this 
driver from version 0.2.7 to version 0.2.4?

I looked at the diff, but I do not see why the new "static int 
amd_reinit_one(struct pci_dev *pdev)" , that has inside a clear 
a if (pdev->vendor == PCI_VENDOR_ID_AMD), should have some impact on a 
nvidia controller.

suggestions?

regards

Luigi Genoni

On Wed, 7 Feb 2007, Luigi Genoni wrote:

> Date: Wed, 7 Feb 2007 01:19:36 +0100
> From: Luigi Genoni <genoni@darkstar.oltrelinux.com>
> To: linux-ide@vger.kernel.org, jgarzik@pobox.com, htejun@gmail.com,
>     alan@red-hat.com
> Cc: linux-kernel@vger.kernel.org
> Subject: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new pata
>     driver, NV CK804 ide controller.
> 
> Hi,
> since upgrading to kernel 2.6.20 my pata disk, using new pata driver, is
> initialized maximum  in DMA33 mode (and obviously performances drop
> consequently), as you can see from:
>
> pata_amd 0000:00:06.0: version 0.2.7
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
> ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
> scsi4 : pata_amd
> ata5.00: ATA-7, max UDMA/100, 156368016 sectors: LBA48
> ata5.00: ata5: dev 0 multi count 1
> ata5.00: configured for UDMA/33
> scsi5 : pata_amd
> ata6.00: ATAPI, max UDMA/33
> ata6.00: configured for UDMA/33
> scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG SP0822N  WA10 PQ: 0 ANSI:
> 5
> SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
> support DPO
> or FUA
> SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
> support DPO
> or FUA
>  sdc: sdc1 sdc2 sdc3
> sd 4:0:0:0: Attached scsi disk sdc
>
>
> while with kernel 2.6.19.X it was initialized correctly in DMA100 mode:
>
> pata_amd 0000:00:06.0: version 0.2.4
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
> ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
> scsi4 : pata_amd
> ata5.00: ATA-7, max UDMA/100, 156368016 sectors: LBA48
> ata5.00: ata5: dev 0 multi count 1
> ata5.00: configured for UDMA/100
> scsi5 : pata_amd
> ata6.00: ATAPI, max UDMA/33
> ata6.00: configured for UDMA/33
> scsi 4:0:0:0: Direct-Access     ATA     SAMSUNG SP0822N  WA10 PQ: 0 ANSI: 5
> SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: drive cache: write back
> SCSI device sdc: 156368016 512-byte hdwr sectors (80060 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 00 3a 00 00
> SCSI device sdc: drive cache: write back
>  sdc: sdc1 sdc2 sdc3
> sd 4:0:0:0: Attached scsi disk sdc
>
> I have other 2 sata disks on this system, and I have no problems with
> them. I Wonder if this is due to some controller/disk problem triggered
> just by 2.6.20 kernel (I saw there are a lot of changes into eh code),
> while 2.6.19.X and previous sees everything OK.
>
> Also forf the sata disks, in fact, I see this "doesn't support DPO or FUA"
> warning, but I have to admit I do not know which features it is referred to.
>
> This system is an Athlon64 X2 3800+ with an nvidia2 IDE controller
>
> here is the lspci -v
>
> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev
> a3)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 815a
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         Capabilities: [44] HyperTransport: Slave or Primary Interface
>         Capabilities: [e0] HyperTransport: MSI Mapping
>
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
>         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
>         Flags: bus master, 66MHz, fast devsel, latency 0
>
> 00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
>         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
>         Flags: 66MHz, fast devsel, IRQ 10
>         I/O ports at e400 [size=32]
>         I/O ports at 4c00 [size=64]
>         I/O ports at 4c40 [size=64]
>         Capabilities: [44] Power Management version 2
>
> 00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
> (prog-if 10 [OHCI])
>         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
>         Memory at d4004000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>
> 00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
> (prog-if 20 [EHCI])
>         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
>         Memory at d4005000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [44] Debug port
>         Capabilities: [80] Power Management version 2
>
> 00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio
> Controller (rev a2)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 8166
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
>         I/O ports at dc00 [size=256]
>         I/O ports at e000 [size=256]
>         Memory at d4003000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>
> 00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a
> [Master SecP PriP])
>         Subsystem: Unknown device f043:815a
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]
> [size=8]
>         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]
> [size=1]
>         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]
> [size=8]
>         [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]
> [size=1]
>         I/O ports at f000 [size=16]
>         Capabilities: [44] Power Management version 2
>
> 00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev
> f3) (prog-if 85 [Master SecO PriO])
>         Subsystem: ASUSTeK Computer Inc. Unknown device 815a
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
>         I/O ports at 09f0 [size=8]
>         I/O ports at 0bf0 [size=4]
>         I/O ports at 0970 [size=8]
>         I/O ports at 0b70 [size=4]
>         I/O ports at d800 [size=16]
>         Memory at d4002000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>
> 00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev
> f3) (prog-if 85 [Master SecO PriO])
>         Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
>         I/O ports at 09e0 [size=8]
>         I/O ports at 0be0 [size=4]
>         I/O ports at 0960 [size=8]
>         I/O ports at 0b60 [size=4]
>         I/O ports at c400 [size=16]
>         Memory at d4001000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>
> 00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if
> 01 [Subtractive decode])
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
>         I/O behind bridge: 0000a000-0000afff
>         Memory behind bridge: d2000000-d3ffffff
>         Prefetchable memory behind bridge: 88000000-880fffff
>
> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
>         Subsystem: ASUSTeK Computer Inc. Unknown device 816a
>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
>         Memory at d4000000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at b000 [size=8]
>         Capabilities: [44] Power Management version 2
>
> 00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if
> 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>         Capabilities: [40] Power Management version 2
>         Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1
> Enable+
>         Capabilities: [58] HyperTransport: MSI Mapping
>         Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Capabilities: [100] Virtual Channel
>
> 00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if
> 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         Capabilities: [40] Power Management version 2
>         Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1
> Enable+
>         Capabilities: [58] HyperTransport: MSI Mapping
>         Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Capabilities: [100] Virtual Channel
>
> 00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if
> 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         Capabilities: [40] Power Management version 2
>         Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1
> Enable+
>         Capabilities: [58] HyperTransport: MSI Mapping
>         Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Capabilities: [100] Virtual Channel
>
> 00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if
> 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 00009000-00009fff
>         Memory behind bridge: d0000000-d1ffffff
>         Prefetchable memory behind bridge:
> 00000000c0000000-00000000cff00000
>         Capabilities: [40] Power Management version 2
>         Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1
> Enable+
>         Capabilities: [58] HyperTransport: MSI Mapping
>         Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Capabilities: [100] Virtual Channel
>
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> HyperTransport Technology Configuration
>         Flags: fast devsel
>         Capabilities: [80] HyperTransport: Host or Secondary Interface
>
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Address
> Map
>         Flags: fast devsel
>
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> DRAM Controller
>         Flags: fast devsel
>
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
>         Flags: fast devsel
>
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon
> X300
> (PCIE)] (prog-if 00 [VGA])
>         Subsystem: PC Partner Limited Unknown device 1490
>         Flags: bus master, fast devsel, latency 0, IRQ 3
>         Memory at c0000000 (32-bit, prefetchable) [size=256M]
>         I/O ports at 9000 [size=256]
>         Memory at d1000000 (32-bit, non-prefetchable) [size=64K]
>         [virtual] Expansion ROM at d0000000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Express Endpoint IRQ 0
>         Capabilities: [80] Message Signalled Interrupts: 64bit+ Queue=0/0
> Enable-
>         Capabilities: [100] Advanced Error Reporting
>
> 01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
>         Subsystem: PC Partner Limited Unknown device 1491
>         Flags: fast devsel
>         Memory at d1010000 (32-bit, non-prefetchable) [disabled]
> [size=64K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Express Endpoint IRQ 0
>
> 05:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
> Controller (rev 80) (prog-if 10 [OHCI])
>         Subsystem: ASUSTeK Computer Inc. A8V Deluxe
>         Flags: bus master, stepping, medium devsel, latency 32, IRQ 19
>         Memory at d3001000 (32-bit, non-prefetchable) [size=2K]
>         I/O ports at a000 [size=128]
>         Capabilities: [50] Power Management version 2
>
> 05:04.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado]
> (rev 78)
>         Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC
> Management NIC
>         Flags: bus master, medium devsel, latency 32, IRQ 17
>         I/O ports at a400 [size=128]
>         Memory at d3000000 (32-bit, non-prefetchable) [size=128]
>         [virtual] Expansion ROM at 88000000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
>
>
> Willing to test any patch.
>
>
> thanx
>
> -------------------------------------------------------
>
