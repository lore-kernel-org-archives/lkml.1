Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYC3TJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYC3TJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYC3TJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:09:27 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:39676 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYC3TJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:09:25 -0400
From: Chr <chunkeey@web.de>
To: linux-kernel@vger.kernel.org
Subject: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Sun, 30 Mar 2008 21:09:22 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iV+7H1WVuw9wCmJ"
Message-Id: <200803302109.22219.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+gZkrS1r0M6G9STGPW0WVC+1T3mhFDIdh4uKPT
	fmcXmcTx/ZTbP3dX8PjlvxQL+yl4ZCa6+JJ3txnPzk6VFuTOBx
	NfKSOylsM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_iV+7H1WVuw9wCmJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Ever since I went to the new 2.6.25-rcX, I encountered lots of random
system freezes after about 2 or 3 hours of uptime... but until now, 
I couldn't _catch_ them, since the system
(AMD Athlon 4200+ X2 (Manchester) / nforce 4 SLI / x86_64) went
straight into oblivion (nothing on the serial console or anywhere else,
heck I couldn't even hit reset, It didn't POST anymore)

So. take a look at stuck_task... that's best backtrace I could get...
(I have other logs too. (Task-list / Lockdep / ... ) but it's too much
and I hope the _logs_ are already enough.

BTW: I noticed that the clock seems to jump forward and backwards.
Is this because the CPU-Cores aren't syncronized? (And why are they
out of sync?)

(And yes, 2.6.24.4 is fine... even hpet works there without any
rtc: lost 14 interrupts)

cat /proc/interrupts
           CPU0       CPU1
  0:         51          0    XT-PIC-XT        timer
  1:         43      22170   IO-APIC-edge      i8042
  4:          0          1   IO-APIC-edge
  6:          0          5   IO-APIC-edge      floppy
  7:          1          0   IO-APIC-edge      parport0
  8:          0        199   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 14:          0          0   IO-APIC-edge      pata_amd
 15:          0          0   IO-APIC-edge      pata_amd
 16:         82      51311   IO-APIC-fasteoi   firewire_ohci, EMU10K1
 17:          0         50   IO-APIC-fasteoi   firewire_ohci, eth1
 18:         12       4862   IO-APIC-fasteoi   nvidia
 20:        421     304857   IO-APIC-fasteoi   eth0
 21:         57      33025   IO-APIC-fasteoi   ohci_hcd:usb1
 22:        185      12275   IO-APIC-fasteoi   sata_nv
 23:        276      83270   IO-APIC-fasteoi   sata_nv, ehci_hcd:usb2
NMI:          0          0   Non-maskable interrupts
LOC:     339847     307599   Local timer interrupts
RES:     126709      38837   Rescheduling interrupts
CAL:        605       1054   function call interrupts
TLB:       1513       3813   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1

--Boundary-00=_iV+7H1WVuw9wCmJ
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg-bootlog"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-bootlog"

[    0.605408] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.610325] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    0.616700] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[    0.624190] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    0.631312] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.634324] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
[    0.642706] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    0.650411] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.657417] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[    0.664255] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.672093] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.678312] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.685716] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    0.692663] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.696078] pnp: PnP ACPI init
[    0.700068] ACPI: bus type pnp registered
[    0.713296] pnp: PnP ACPI: found 13 devices
[    0.716049] ACPI: ACPI bus type pnp unregistered
[    0.720229] SCSI subsystem initialized
[    0.724161] libata version 3.00 loaded.
[    0.724307] PCI: Using ACPI for IRQ routing
[    0.728050] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.752050] hpet clockevent registered
[    0.752050] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.753401] hpet0: 3 32-bit timers, 25000000 Hz
[    0.757174] ACPI: RTC can wake from S4
[    0.760058] Switched to high resolution mode on CPU 0
[    0.636155] Switched to high resolution mode on CPU 1
[    0.780054] system 00:01: ioport range 0x4000-0x407f has been reserved
[    0.780057] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    0.784057] system 00:01: ioport range 0x4400-0x447f has been reserved
[    0.788058] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    0.792058] system 00:01: ioport range 0x4800-0x487f has been reserved
[    0.796058] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    0.800060] system 00:01: iomem range 0x0-0x0 could not be reserved
[    0.804067] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.808059] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.812059] system 00:02: ioport range 0x290-0x297 has been reserved
[    0.816075] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.820070] system 00:0c: iomem range 0xf0000-0xf3fff could not be reserved
[    0.824060] system 00:0c: iomem range 0xf4000-0xf7fff could not be reserved
[    0.828060] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.832061] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.836061] system 00:0c: iomem range 0x7fff0000-0x7fffffff could not be reserved
[    0.840061] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[    0.844063] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.848062] system 00:0c: iomem range 0x100000-0x7ffeffff could not be reserved
[    0.852062] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.856062] system 00:0c: iomem range 0xfee00000-0xfeefffff could not be reserved
[    0.860062] system 00:0c: iomem range 0xfefff000-0xfeffffff has been reserved
[    0.864062] system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved
[    0.868063] system 00:0c: iomem range 0xfff90000-0xfffbffff has been reserved
[    0.872063] system 00:0c: iomem range 0xfffed000-0xfffeffff has been reserved
[    0.877102] PCI: Bridge: 0000:00:09.0
[    0.880064]   IO window: a000-afff
[    0.884066]   MEM window: 0xd4000000-0xd5ffffff
[    0.888065]   PREFETCH window: disabled.
[    0.892066] PCI: Bridge: 0000:00:0b.0
[    0.896064]   IO window: disabled.
[    0.900066]   MEM window: disabled.
[    0.904066]   PREFETCH window: disabled.
[    0.908067] PCI: Bridge: 0000:00:0c.0
[    0.912065]   IO window: disabled.
[    0.916067]   MEM window: disabled.
[    0.920067]   PREFETCH window: disabled.
[    0.924069] PCI: Bridge: 0000:00:0d.0
[    0.928066]   IO window: disabled.
[    0.932068]   MEM window: disabled.
[    0.936068]   PREFETCH window: disabled.
[    0.940070] PCI: Bridge: 0000:00:0e.0
[    0.944068]   IO window: 9000-9fff
[    0.948069]   MEM window: 0xd0000000-0xd3ffffff
[    0.952069]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[    0.956076] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    0.956089] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.956100] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.956111] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.956122] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.956138] NET: Registered protocol family 2
[    1.004070] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    1.008427] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.014415] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    1.025177] TCP: Hash tables configured (established 262144 bind 65536)
[    1.028103] TCP reno registered
[    1.044077] Unpacking initramfs... done
[    1.189439] Freeing initrd memory: 4656k freed
[    1.188762] VFS: Disk quotas dquot_6.5.1
[    1.189798] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.194550] fuse init (API version 7.9)
[    1.198114] JFS: nTxBlock = 8192, nTxLock = 65536
[    1.208192] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.209654] io scheduler noop registered
[    1.213709] io scheduler anticipatory registered (default)
[    1.217699] pci 0000:00:00.0: Enabling HT MSI Mapping
[    1.241641] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    1.241657] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    1.245646] pci 0000:00:0b.0: Linking AER extended capability
[    1.249656] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    1.253654] pci 0000:00:0c.0: Found enabled HT MSI Mapping
[    1.257646] pci 0000:00:0c.0: Linking AER extended capability
[    1.261657] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    1.265655] pci 0000:00:0d.0: Found enabled HT MSI Mapping
[    1.269646] pci 0000:00:0d.0: Linking AER extended capability
[    1.273658] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    1.277655] pci 0000:00:0e.0: Found enabled HT MSI Mapping
[    1.281647] pci 0000:00:0e.0: Linking AER extended capability
[    1.285675] pci 0000:01:00.0: Boot video device
[    1.285840] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    1.285875] assign_interrupt_mode Found MSI capability
[    1.289676] Allocate Port Service[0000:00:0b.0:pcie00]
[    1.289753] Allocate Port Service[0000:00:0b.0:pcie03]
[    1.289871] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    1.289905] assign_interrupt_mode Found MSI capability
[    1.293672] Allocate Port Service[0000:00:0c.0:pcie00]
[    1.293746] Allocate Port Service[0000:00:0c.0:pcie03]
[    1.297733] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    1.297767] assign_interrupt_mode Found MSI capability
[    1.301671] Allocate Port Service[0000:00:0d.0:pcie00]
[    1.301754] Allocate Port Service[0000:00:0d.0:pcie03]
[    1.301879] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    1.301913] assign_interrupt_mode Found MSI capability
[    1.305672] Allocate Port Service[0000:00:0e.0:pcie00]
[    1.305750] Allocate Port Service[0000:00:0e.0:pcie03]
[    1.305995] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.309711] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.313804] input: Power Button (FF) as /class/input/input0
[    1.317678] ACPI: Power Button (FF) [PWRF]
[    1.321779] input: Power Button (CM) as /class/input/input1
[    1.325651] ACPI: Power Button (CM) [PWRB]
[    1.330048] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.333751] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.381650] Real Time Clock Driver v1.12ac
[    1.381845] Linux agpgart interface v0.103
[    1.385654] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[    1.389874] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.394432] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.397990] isa bounce pool size: 16 pages
[    1.401687] Floppy drive(s): fd0 is 1.44M
[    1.431547] FDC 0 is a post-1991 82077
[    1.435778] loop: module loaded
[    1.439648] Driver 'sd' needs updating - please use bus_type methods
[    1.443615] Driver 'sr' needs updating - please use bus_type methods
[    1.447796] sata_nv 0000:00:07.0: version 3.5
[    1.448272] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    1.451560] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 23
[    1.459552] sata_nv 0000:00:07.0: Using ADMA mode
[    1.463631] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    1.463840] scsi0 : sata_nv
[    1.467713] scsi1 : sata_nv
[    1.471776] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 23
[    1.475554] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 23
[    2.090406] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.255723] ata1.00: ATAPI: TSSTcorpCD/DVDW SH-S183L, SB00, max UDMA/33
[    2.255727] ata1.00: applying bridge limits
[    2.431991] ata1.00: configured for UDMA/33
[    2.903284] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.806091] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.806096] ata2.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    2.820431] ata2.00: configured for UDMA/133
[    2.825918] scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S183L SB00 PQ: 0 ANSI: 5
[    2.828452] ata1: DMA mask 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
[    2.844743] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.844748] Uniform CD-ROM driver Revision: 3.20
[    2.848979] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.849216] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.853148] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    2.856752] ata2: DMA mask 0xFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    2.861081] sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.864770] sd 1:0:0:0: [sda] Write Protect is off
[    2.868748] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.868789] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.873094] sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.876769] sd 1:0:0:0: [sda] Write Protect is off
[    2.880749] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.880790] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.884766]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    2.933280] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.936108] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.940528] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
[    2.943963] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 (level, low) -> IRQ 22
[    2.955956] sata_nv 0000:00:08.0: Using ADMA mode
[    2.960005] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    2.960131] scsi2 : sata_nv
[    2.964098] scsi3 : sata_nv
[    2.967375] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 22
[    2.967960] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 22
[    3.639970] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.454286] ata3.00: HPA detected: current 488395055, native 488397168
[    3.454292] ata3.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
[    3.458289] ata3.00: 488395055 sectors, multi 1: LBA48 
[    3.470751] ata3.00: configured for UDMA/133
[    4.147817] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.157219] ata4.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
[    4.157224] ata4.00: 490234752 sectors, multi 1: LBA48 NCQ (depth 1)
[    4.171356] ata4.00: configured for UDMA/133
[    3.976657] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500KS-00M 02.0 PQ: 0 ANSI: 5
[    3.976664] ata3: DMA mask 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    3.980893] sd 2:0:0:0: [sdb] 488395055 512-byte hardware sectors (250058 MB)
[    3.984683] sd 2:0:0:0: [sdb] Write Protect is off
[    3.988661] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.988702] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.992752] sd 2:0:0:0: [sdb] 488395055 512-byte hardware sectors (250058 MB)
[    3.996683] sd 2:0:0:0: [sdb] Write Protect is off
[    4.000661] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.000703] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.004663]  sdb: sdb1 sdb2
[    4.014513] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.017484] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    4.021523] scsi 3:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
[    4.025338] ata4: DMA mask 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    4.029551] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
[    4.033356] sd 3:0:0:0: [sdc] Write Protect is off
[    4.037336] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.037376] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.041417] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors (251000 MB)
[    4.045356] sd 3:0:0:0: [sdc] Write Protect is off
[    4.049337] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.049377] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.053338]  sdc: sdc1
[    4.062864] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.063014] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    4.067063] pata_amd 0000:00:06.0: version 0.3.10
[    4.067125] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    4.067195] scsi4 : pata_amd
[    4.070997] scsi5 : pata_amd
[    4.075227] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    4.078868] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    4.416726] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    4.416736] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    4.421261] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.424989] mice: PS/2 mouse device common for all mice
[    4.457886] input: AT Translated Set 2 keyboard as /class/input/input2
[    4.477912] input: PC Speaker as /class/input/input3
[    4.497937] rtc_cmos: probe of 00:04 failed with error -16
[    4.498073] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
[    4.501953] md: linear personality registered for level -1
[    4.505940] md: raid0 personality registered for level 0
[    4.509941] md: raid1 personality registered for level 1
[    4.514076] device-mapper: uevent: version 1.0.3
[    4.518077] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    4.522049] EDAC MC: Ver: 2.1.0 Mar 29 2008
[    4.526185] cpuidle: using governor ladder
[    4.529943] cpuidle: using governor menu
[    4.534120] oprofile: using NMI interrupt.
[    4.538789] TCP cubic registered
[    4.542053] NET: Registered protocol family 1
[    4.545970] NET: Registered protocol family 17
[    4.549963] NET: Registered protocol family 15
[    4.554393] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    4.557957] Freeing unused kernel memory: 264k freed
[    5.453810] usbcore: registered new interface driver usbfs
[    5.457053] usbcore: registered new interface driver hub
[    5.461061] usbcore: registered new device driver usb
[    5.125737] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    5.129289] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
[    5.132808] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[    5.140803] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    5.492607] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.665814] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:15:f2:50:c1:ef
[    5.665821] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[    6.031627] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
[    6.031639] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 20 (level, low) -> IRQ 20
[    6.039643] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    6.039647] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    6.045098] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    6.047689] ehci_hcd 0000:00:02.1: debug port 1
[    6.051634] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    6.051652] ehci_hcd 0000:00:02.1: irq 20, io mem 0xfeb00000
[    6.075634] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.080202] usb usb1: configuration #1 chosen from 1 choice
[    6.083805] hub 1-0:1.0: USB hub found
[    6.087729] hub 1-0:1.0: 10 ports detected
[    5.867634] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    5.871410] ACPI: PCI Interrupt 0000:05:06.2[B] -> ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
[    6.205591] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
[    6.205591] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    6.205591] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    6.205591] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    6.205591] ohci_hcd 0000:00:02.0: irq 23, io mem 0xd6003000
[    5.875402] Link [APC2] -> GSI 17 (level, low) -> IRQ 17
[    6.261605] usb usb2: configuration #1 chosen from 1 choice
[    6.261655] hub 2-0:1.0: USB hub found
[    6.265620] hub 2-0:1.0: 10 ports detected
[    5.954491] firewire_ohci: Added fw-ohci device 0000:05:06.2, OHCI version 1.10
[    5.954893] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[    5.958501] ACPI: PCI Interrupt 0000:05:0b.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
[    6.041492] firewire_ohci: Added fw-ohci device 0000:05:0b.0, OHCI version 1.10
[    6.422109] ACPI: PCI Interrupt 0000:05:0c.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
[    6.429041] skge 1.13 addr 0xd5014000 irq 17 chip Yukon-Lite rev 9
[    6.433669] skge eth1: addr 00:15:f2:50:d7:70
[    6.538574] md: md0 stopped.
[    6.177148] md: bind<sdc1>
[    6.179951] md: bind<sda3>
[    6.187657] raid1: raid set md0 active with 2 out of 2 mirrors
[    6.651951] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    6.803647] usb 1-3: configuration #1 chosen from 1 choice
[    6.458356] firewire_core: created device fw0: GUID 00023c015112bb16, S400
[    6.550553] firewire_core: created device fw1: GUID 0011d800007ab4d6, S400
[    6.706950] usb 2-2: new low speed USB device using ohci_hcd and address 2
[    6.881906] usb 2-2: configuration #1 chosen from 1 choice
[    7.277468] Initializing USB Mass Storage driver...
[    7.279564] scsi6 : SCSI emulation for USB Mass Storage devices
[    7.287549] usbcore: registered new interface driver usb-storage
[    7.289715] USB Mass Storage support registered.
[    6.928773] usb-storage: device found at 3
[    6.928773] usb-storage: waiting for device to settle before scanning
[    6.932887] input: Western Digital External HDD as /class/input/input4
[    6.934938] input,hidraw0: USB HID v1.11 Device [Western Digital External HDD] on usb-0000:00:02.1-3
[    6.951377] input: Logitech USB Receiver as /class/input/input5
[    6.976045] input,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-2
[    6.996455] input: Logitech USB Receiver as /class/input/input6
[    7.021296] input,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.0-2
[    7.021332] usbcore: registered new interface driver usbhid
[    7.025301] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   11.921331] scsi 6:0:0:0: Direct-Access     WD       2500JS External  106a PQ: 0 ANSI: 4
[   11.939160] sd 6:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
[   11.942473] sd 6:0:0:0: [sdd] Write Protect is off
[   11.943579] sd 6:0:0:0: [sdd] Mode Sense: 11 00 00 00
[   11.943582] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[   11.955161] sd 6:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
[   11.958536] sd 6:0:0:0: [sdd] Write Protect is off
[   11.959581] sd 6:0:0:0: [sdd] Mode Sense: 11 00 00 00
[   11.959583] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[   11.963581]  sdd: sdd1
[   11.968564] sd 6:0:0:0: [sdd] Attached SCSI disk
[   11.968638] sd 6:0:0:0: Attached scsi generic sg4 type 0
[   11.979982] usb-storage: device scan complete
[   67.432221] ReiserFS: dm-5: found reiserfs format "3.6" with standard journal
[   67.432378] ReiserFS: dm-5: using ordered data mode
[   67.452106] ReiserFS: dm-5: journal params: device dm-5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   67.456714] ReiserFS: dm-5: checking transaction log (dm-5)
[   88.747260] ReiserFS: dm-5: replayed 723 transactions in 14 seconds
[   88.779399] ReiserFS: dm-5: Using r5 hash to sort names
[   92.506218] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   92.509664] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   92.693297] parport_pc 00:09: reported by Plug and Play ACPI
[   92.693822] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   93.067467] ACPI: PCI Interrupt 0000:05:06.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
[   93.079989] Installing spdif_bug patch: Audigy 2 ZS [SB0350]
[  102.633998] it87: Found IT8712F chip at 0x290, revision 7
[  102.634011] it87: in3 is VCC (+5V)
[  102.638001] it87: in7 is VCCH (+5V Stand-By)
[  102.642097] it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
[  102.678211] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (2 cpu cores) (version 2.20.00)
[   96.210136] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
[   96.210140] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xa
[   96.214140] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xc
[   96.218140] powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
[  141.740697] ReiserFS: dm-13: found reiserfs format "3.6" with standard journal
[  141.740721] ReiserFS: dm-13: using ordered data mode
[  141.773961] ReiserFS: dm-13: journal params: device dm-13, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[  141.775508] ReiserFS: dm-13: checking transaction log (dm-13)
[  141.917594] ReiserFS: dm-13: Using r5 hash to sort names
[  133.669410] Adding 2000084k swap on /dev/mapper/sda2_crypt.  Priority:-1 extents:1 across:2000084k
[  137.733298] NET: Registered protocol family 10
[  149.699559] lp0: using parport0 (interrupt-driven).
[  149.701951] lp0: console ready
[  149.734970] ppdev: user-space parallel port driver
[  153.591107] Clocksource tsc unstable (delta = -90906073 ns)
[  172.006108] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[  175.233381] Bluetooth: Core ver 2.11
[  175.242749] NET: Registered protocol family 31
[  175.244699] Bluetooth: HCI device and connection manager initialized
[  175.248851] Bluetooth: HCI socket layer initialized
[  175.289903] Bluetooth: L2CAP ver 2.9
[  175.292135] Bluetooth: L2CAP socket layer initialized
[  175.315643] Bluetooth: RFCOMM socket layer initialized
[  175.318242] Bluetooth: RFCOMM TTY layer initialized
[  175.322232] Bluetooth: RFCOMM ver 1.8
[  169.236205] ip_tables: (C) 2000-2006 Netfilter Core Team
[  301.292141] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[  301.295601] ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[  318.463318] p54: LM86 firmware
[  318.463324] p54: FW rev 2.7.0.0 - Softmac protocol 4.1
[  319.449440] phy0: Selected rate control algorithm 'pid'

--Boundary-00=_iV+7H1WVuw9wCmJ
Content-Type: text/plain;
  charset="us-ascii";
  name="stuck_task"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stuck_task"

[ 5214.923278] SysRq : Show Regs
[ 5214.926537] CPU 0:
[ 5214.928843] Modules linked in: p54pci p54common mac80211 arc4 ecb cfg80211 tcp_diag inet_diag xt_multiport iptable_filter ip_tables x_tables rfcomm l2cap bluetooth ppdev lp cpufreq_powersave cpufreq_conservative ipv6 cpufreq_ondemand cpufreq_userspace powernow_k8 it87 hwmon_vid firewire_sbp2 snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep parport_pc parport k8temp snd hwmon soundcore i2c_nforce2 i2c_core evdev usbhid usb_storage dm_mirror dm_snapshot skge firewire_ohci firewire_core ohci_hcd ehci_hcd forcedeth usbcore [last unloaded: mac80211]
[ 5215.002056] Pid: 4766, comm: hddtemp Not tainted 2.6.25-rc7-wl #7
[ 5215.008417] RIP: 0010:[<ffffffff80217d9e>]  [<ffffffff80217d9e>] __smp_call_function_mask+0x9f/0xc5
[ 5215.018010] RSP: 0018:ffff81007830bbd8  EFLAGS: 00000297
[ 5215.023591] RAX: 00000000000008fd RBX: 0000000000000001 RCX: 0000000000000000
[ 5215.030999] RDX: 0101010101010101 RSI: 0000000000000000 RDI: 0000000000000002
[ 5215.038398] RBP: 0000000000000000 R08: cf3cf3cf3cf3cf3d R09: 0000000000000000
[ 5215.045798] R10: 0000000000000001 R11: 0000000000000001 R12: 0101010101010101
[ 5215.053200] R13: ffff810080971000 R14: ffff81007830a000 R15: 0000000000000001
[ 5215.060609] FS:  00007f7b8afbf6e0(0000) GS:ffffffff80636000(0000) knlGS:0000000000000000
[ 5215.069197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5215.075210] CR2: 00007f90f817bf30 CR3: 0000000000201000 CR4: 00000000000006e0
[ 5215.082619] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5215.090018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5215.097419] 
[ 5215.097420] Call Trace:
[ 5215.101875]  [<ffffffff80217d8f>] __smp_call_function_mask+0x90/0xc5
[ 5215.108493]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
[ 5215.114422]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
[ 5215.120348]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
[ 5215.126276]  [<ffffffff80217e0d>] smp_call_function_mask+0x49/0x61
[ 5215.132723]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
[ 5215.138649]  [<ffffffff802339a3>] on_each_cpu+0x10/0x2c
[ 5215.144135]  [<ffffffff8029fb4b>] kill_bdev+0x1e/0x33
[ 5215.149456]  [<ffffffff802a01da>] __blkdev_put+0x4f/0x128
[ 5215.155124]  [<ffffffff8027dd93>] __fput+0xa1/0x164
[ 5215.160272]  [<ffffffff8027b67d>] filp_close+0x5d/0x65
[ 5215.165679]  [<ffffffff80231072>] put_files_struct+0x66/0xc4
[ 5215.171607]  [<ffffffff802323ea>] do_exit+0x245/0x64c
[ 5215.176925]  [<ffffffff80238b94>] __dequeue_signal+0xff/0x159
[ 5215.182941]  [<ffffffff80232867>] do_group_exit+0x76/0x93
[ 5215.188606]  [<ffffffff8023a0fd>] get_signal_to_deliver+0x2b9/0x2e5
[ 5215.195141]  [<ffffffff8020a466>] do_notify_resume+0xaf/0x7e0
[ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86
[ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86
--Boundary-00=_iV+7H1WVuw9wCmJ--
