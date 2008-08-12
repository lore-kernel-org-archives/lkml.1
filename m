Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYHLMhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYHLMhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYHLMhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:37:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59902 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYHLMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pgZFU224NFO1k7UpJVZ7dqpwb9h4YDVYYsCI3fWvr9K63zSyXxOSIyOPz27vjoElXM
         OmjcUBkTDb+fp5lzrrQ7BRLUBUNN7M6O2iXfB9qGOQKHXvvMboGAObD+ZuIu80RFlCSl
         tiiCnVknI0sM5fvbqNYYKG1oKy1DAfsliqpok=
Message-ID: <64bb37e0808120537qff93841xa657b46f6b36ddcd@mail.gmail.com>
Date: Tue, 12 Aug 2008 14:37:16 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc2:stall while mounting root fs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

twice while booting 2.6.27-rc2 my system stalled after printing
"Mounting root..." until I hit a key.
I did not see this with 2.6.27-rc1.

The system is booted via an initial ramdisk, because the root fs is
encrypted on a RAID5 consisting of 3 sata drives, two on sata_sil24
and one on sata_nv.

The second time, I uses SysRq+P,Q,W to dump some state. The SysRq keys
did not resume the boot, only after hitting enter the system continued
to start normally.

>From dmesg:
[    2.419290] Driver 'sd' needs updating - please use bus_type methods
... hmm, I wonder about that message since 2.6.25-rc1.
[    2.425724] sata_sil24 0000:04:00.0: version 1.1
[    2.425733] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
19 (level, low) -> IRQ 19
[    2.434312] sata_sil24 0000:04:00.0: setting latency timer to 64
[    2.434516] scsi0 : sata_sil24
[    2.437770] scsi1 : sata_sil24
[    2.440960] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 19
[    2.448280] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 19
[    4.669977] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    4.720898] ata1.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    4.727291] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.779208] ata1.00: configured for UDMA/100
[    6.999936] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    7.047297] ata2.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    7.053678] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.105605] ata2.00: configured for UDMA/100
[    7.110011] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    7.118315] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    7.125482] sd 0:0:0:0: [sda] Write Protect is off
[    7.130286] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.130309] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.139410] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    7.146573] sd 0:0:0:0: [sda] Write Protect is off
[    7.151382] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.151404] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.160465]  sda: sda1 sda2
[    7.177737] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.182534] scsi 1:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    7.190822] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    7.197978] sd 1:0:0:0: [sdb] Write Protect is off
[    7.202784] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.202806] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.211899] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    7.219053] sd 1:0:0:0: [sdb] Write Protect is off
[    7.223859] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.223881] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.232941]  sdb: sdb1 sdb2
[    7.254957] sd 1:0:0:0: [sdb] Attached SCSI disk
-> two drives on sata_sil24
[    7.259749] sata_nv 0000:00:05.0: version 3.5
[    7.260082] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    7.265849] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23
(level, low) -> IRQ 23
[    7.274126] sata_nv 0000:00:05.0: Using SWNCQ mode
[    7.278959] sata_nv 0000:00:05.0: setting latency timer to 64
[    7.279090] scsi2 : sata_nv
[    7.282070] scsi3 : sata_nv
[    7.285098] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 23
[    7.291987] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 23
[    7.799921] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.865011] ata3.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
[    7.871379] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.939965] ata3.00: configured for UDMA/133
[    8.300216] ata4: SATA link down (SStatus 0 SControl 300)
[    8.305457] scsi 2:0:0:0: Direct-Access     ATA      MAXTOR
STM332082 3.AA PQ: 0 ANSI: 5
[    8.313772] sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[    8.320934] sd 2:0:0:0: [sdc] Write Protect is off
[    8.325734] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.325756] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.334850] sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[    8.342007] sd 2:0:0:0: [sdc] Write Protect is off
[    8.346810] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.346832] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.355890]  sdc: sdc1 sdc2
[    8.380642] sd 2:0:0:0: [sdc] Attached SCSI disk
-> the third drive on sata_nv.
The other five ports of the MCP55 are empty.
[    8.385663] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    8.391430] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22
(level, low) -> IRQ 22
[    8.399708] sata_nv 0000:00:05.1: Using SWNCQ mode
[    8.404535] sata_nv 0000:00:05.1: setting latency timer to 64
[    8.404661] scsi4 : sata_nv
[    8.407624] scsi5 : sata_nv
[    8.410653] ata5: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xb800 irq 22
[    8.417798] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb808 irq 22
[    8.780208] ata5: SATA link down (SStatus 0 SControl 300)
[    9.140201] ata6: SATA link down (SStatus 0 SControl 300)
[    9.145664] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    9.151437] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21
(level, low) -> IRQ 21
[    9.159720] sata_nv 0000:00:05.2: Using SWNCQ mode
[    9.164549] sata_nv 0000:00:05.2: setting latency timer to 64
[    9.164681] scsi6 : sata_nv
[    9.167661] scsi7 : sata_nv
[    9.170678] ata7: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xac00 irq 21
[    9.177825] ata8: SATA max UDMA/133 cmd 0xb080 ctl 0xb000 bmdma 0xac08 irq 21
[    9.540011] ata7: SATA link down (SStatus 0 SControl 300)
[    9.900006] ata8: SATA link down (SStatus 0 SControl 300)
[    9.906117] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[    9.911887] ohci1394 0000:05:08.0: PCI INT A -> Link[LNKA] -> GSI
16 (level, low) -> IRQ 16
[    9.970435] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
MMIO=[effff800-efffffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    9.982381] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
[    9.988193] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
[    9.993965] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI
20 (level, low) -> IRQ 20
[   10.002333] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   10.002336] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   10.007651] ehci_hcd 0000:00:02.1: new USB bus registered, assigned
bus number 1
[   10.015085] ehci_hcd 0000:00:02.1: debug port 1
[   10.019636] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[   10.019652] ehci_hcd 0000:00:02.1: irq 20, io mem 0xefaebc00
[   10.049632] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   10.057229] usb usb1: configuration #1 chosen from 1 choice
[   10.062883] hub 1-0:1.0: USB hub found
[   10.066652] hub 1-0:1.0: 10 ports detected
[   10.279780] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.286576] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.293812] usb usb1: Product: EHCI Host Controller
[   10.298700] usb usb1: Manufacturer: Linux 2.6.27-rc2 ehci_hcd
[   10.304462] usb usb1: SerialNumber: 0000:00:02.1
[   10.309151] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
(OHCI) Driver
[   10.309440] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[   10.315202] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI
23 (level, low) -> IRQ 23
[   10.323577] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   10.323579] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   10.328870] ohci_hcd 0000:00:02.0: new USB bus registered, assigned
bus number 2
[   10.336294] ohci_hcd 0000:00:02.0: irq 23, io mem 0xefaf8000
[   10.401704] usb usb2: configuration #1 chosen from 1 choice
[   10.407335] hub 2-0:1.0: USB hub found
[   10.411111] hub 2-0:1.0: 10 ports detected
[   10.629687] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   10.636487] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.643722] usb usb2: Product: OHCI Host Controller
[   10.648611] usb usb2: Manufacturer: Linux 2.6.27-rc2 ohci_hcd
[   10.654373] usb usb2: SerialNumber: 0000:00:02.0
[   10.659067] USB Universal Host Controller Interface driver v3.0
[   10.665642] Initializing USB Mass Storage driver...
[   10.809875] usb 2-9: new low speed USB device using ohci_hcd and address 2
[   11.027992] usb 2-9: configuration #1 chosen from 1 choice
[   11.031548] usb 2-9: New USB device found, idVendor=062a, idProduct=0000
[   11.038268] usb 2-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   11.048732] usbcore: registered new interface driver usb-storage
[   11.054758] USB Mass Storage support registered.
[   11.059436] usbcore: registered new interface driver libusual
[   11.065313] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[   11.071623] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.076611] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.081813] mice: PS/2 mouse device common for all mice
[   11.179971] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[   11.296603] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000c4c261]
[   11.405259] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   11.500219] I2O subsystem v1.325
[   11.503466] i2o: max drivers = 8
[   11.507036] i2c /dev entries driver
[   11.514019] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2a00
[   11.519966] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2a80
[   11.526036] md: raid1 personality registered for level 1
[   11.700851] raid6: int64x1   2614 MB/s
[   11.870843] raid6: int64x2   3289 MB/s
[   12.040852] raid6: int64x4   3153 MB/s
[   12.210837] raid6: int64x8   2266 MB/s
[   12.380838] raid6: sse2x1    3565 MB/s
[   12.550830] raid6: sse2x2    4779 MB/s
[   12.720833] raid6: sse2x4    4952 MB/s
[   12.724598] raid6: using algorithm sse2x4 (4952 MB/s)
[   12.729666] md: raid6 personality registered for level 6
[   12.734989] md: raid5 personality registered for level 5
[   12.740315] md: raid4 personality registered for level 4
[   12.745760] device-mapper: uevent: version 1.0.3
[   12.750515] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[   12.759030] EDAC MC: Ver: 2.1.0 Aug  7 2008
[   12.763415] cpuidle: using governor ladder
[   12.767524] cpuidle: using governor menu
[   12.771535] Advanced Linux Sound Architecture Driver Version 1.0.17.
[   12.777956] Error: Driver 'pcspkr' is already registered, aborting...
[   12.784742] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
[   12.790506] Bt87x 0000:05:06.1: PCI INT A -> Link[LNKC] -> GSI 19
(level, low) -> IRQ 19
[   12.798767] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[   12.805511] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
[   12.811274] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI
22 (level, low) -> IRQ 22
[   12.819738] HDA Intel 0000:00:06.1: setting latency timer to 64
[   12.931140] ALSA device list:
[   12.934121]   #0: HDA NVidia at 0xefafc000 irq 22
[   12.938836]   #1: Brooktree Bt878 at 0xeeffe000, irq 19
[   12.944407] Initializing XFRM netlink socket
[   12.948693] NET: Registered protocol family 17
[   12.953167] NET: Registered protocol family 15
[   12.957917] RPC: Registered udp transport module.
[   12.962640] RPC: Registered tcp transport module.
[   12.964171] powernow-k8: Found 2 Dual-Core AMD Opteron(tm)
Processor 2218 processors (4 cpu cores) (version 2.20.00)
[   12.977992] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[   12.983674] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[   12.989343] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[   12.994930] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[   13.000520] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[   13.006191] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[   13.012294] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[   13.017972] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[   13.023648] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[   13.029231] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[   13.034828] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[   13.040498] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[   13.046651] Freeing unused kernel memory: 1212k freed
-> boot script from the ramdisk is started here.
[   14.495018] Clocksource tsc unstable (delta = -296207582 ns)
[   34.127150] md: Autodetecting RAID arrays.
[   34.213453] md: Scanned 5 and added 5 devices.
[   34.213458] md: autorun ...
[   34.213462] md: considering sdc2 ...
[   34.213474] md:  adding sdc2 ...
[   34.213481] md:  adding sdb2 ...
[   34.213487] md: sdb1 has different UUID to sdc2
[   34.213494] md:  adding sda2 ...
[   34.213500] md: sda1 has different UUID to sdc2
[   34.213505] md: created md1
[   34.213508] md: bind<sda2>
[   34.213537] md: bind<sdb2>
[   34.213551] md: bind<sdc2>
[   34.213564] md: running: <sdc2><sdb2><sda2>
[   34.228888] raid5: device sdc2 operational as raid disk 2
[   34.228894] raid5: device sdb2 operational as raid disk 1
[   34.228898] raid5: device sda2 operational as raid disk 0
[   34.230051] raid5: allocated 3218kB for md1
[   34.230054] raid5: raid level 5 set md1 active with 3 out of 3
devices, algorithm 2
[   34.230058] RAID5 conf printout:
[   34.230060]  --- rd:3 wd:3
[   34.230063]  disk 0, o:1, dev:sda2
[   34.230065]  disk 1, o:1, dev:sdb2
[   34.230068]  disk 2, o:1, dev:sdc2
-> RAID5 starts correctly with all drives
[   34.235227] md1: bitmap initialized from disk: read 10/10 pages, set 60 bits
[   34.235230] created bitmap (145 pages) for device md1
[   34.252736] md: considering sdb1 ...
[   34.252748] md:  adding sdb1 ...
[   34.252757] md:  adding sda1 ...
[   34.253619] md: created md0
[   34.253622] md: bind<sda1>
[   34.253639] md: bind<sdb1>
[   34.253652] md: running: <sdb1><sda1>
[   34.268991] raid1: raid set md0 active with 2 out of 2 mirrors
[   34.292814] md0: bitmap initialized from disk: read 10/10 pages, set 0 bits
[   34.292818] created bitmap (150 pages) for device md0
-> md0 is later only used for swap
[   34.320274] md: ... autorun DONE.
-> here I'm entering the luks password
[   42.940761] Filesystem "dm-0": Disabling barriers, trial barrier write failed
[   42.956907] XFS mounting filesystem dm-0
-> mounting starts, normally this needs less that a tenth of a second.
[   59.719168] SysRq : Show Regs
[   59.722210] CPU 3:
[   59.722213] Modules linked in:
[   59.722216] Pid: 0, comm: swapper Not tainted 2.6.27-rc2 #2
[   59.722218] RIP: 0010:[<ffffffff802139cf>]  [<ffffffff802139cf>]
default_idle+0x4f/0x60
[   59.722230] RSP: 0018:ffff88007ffcfee8  EFLAGS: 00000246
[   59.722232] RAX: ffff88007ffcffd8 RBX: ffff88007ffcfee8 RCX: 00000000c0010055
[   59.722234] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff807d35f0
[   59.722235] RBP: ffffffff80a683a0 R08: 0000000000000000 R09: 0000000000000000
[   59.722237] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8062e20f
[   59.722239] R13: ffff88007ffcfe68 R14: 0000000df382a400 R15: ffffffff80a683a0
[   59.722241] FS:  0000000001d1b870(0000) GS:ffff88011ff3c200(0000)
knlGS:0000000000000000
[   59.722243] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   59.722244] CR2: 0000000000418008 CR3: 0000000000201000 CR4: 00000000000006e0
[   59.722246] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.722248] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   59.722249]
[   59.722250] Call Trace:
[   59.722254]  [<ffffffff802139cd>] ? default_idle+0x4d/0x60
[   59.722257]  [<ffffffff80213a18>] ? c1e_idle+0x38/0x100
[   59.722260]  [<ffffffff8020a256>] ? cpu_idle+0x66/0xc0
[   59.722262]
[   67.854287] SysRq : Show Pending Timers
[   67.858178] Timer List Version: v0.3
[   67.858179] HRTIMER_MAX_CLOCK_BASES: 2
[   67.858180] now at 67854461680 nsecs
[   67.858181]
[   67.858182] cpu: 0
[   67.858183]  clock 0:
[   67.858185]   .index:      0
[   67.858186]   .resolution: 1 nsecs
[   67.858186]   .get_time:   ktime_get_real
[   67.858193]   .offset:     1218541241000000000 nsecs
[   67.858194] active timers:
[   67.858196]  clock 1:
[   67.858197]   .index:      1
[   67.858198]   .resolution: 1 nsecs
[   67.858199]   .get_time:   ktime_get
[   67.858201]   .offset:     0 nsecs
[   67.858202] active timers:
[   67.858203]  #0: <ffff88011ffa7bd8>, tick_sched_timer, S:01,
tick_nohz_stop_sched_tick, swapper/0
[   67.858212]  # expires at 70030000000 nsecs [in 2175538320 nsecs]
[   67.858214]   .expires_next   : 70030000000 nsecs
[   67.858215]   .hres_active    : 1
[   67.858216]   .nr_events      : 637
[   67.858218]   .nohz_mode      : 2
[   67.858219]   .idle_tick      : 66050000000 nsecs
[   67.858220]   .tick_stopped   : 1
[   67.858221]   .idle_jiffies   : 4294943900
[   67.858222]   .idle_calls     : 787
[   67.858223]   .idle_sleeps    : 228
[   67.858224]   .idle_entrytime : 67382234960 nsecs
[   67.858226]   .idle_waketime  : 67382229560 nsecs
[   67.858227]   .idle_exittime  : 66040020720 nsecs
[   67.858228]   .idle_sleeptime : 64070906520 nsecs
[   67.858230]   .last_jiffies   : 4294944034
[   67.858231]   .next_jiffies   : 4294944299
[   67.858232]   .idle_expires   : 70030000000 nsecs
[   67.858233] jiffies: 4294944081
[   67.858234]
[   67.858235] cpu: 1
[   67.858236]  clock 0:
[   67.858237]   .index:      0
[   67.858238]   .resolution: 1 nsecs
[   67.858239]   .get_time:   ktime_get_real
[   67.858241]   .offset:     1218541241000000000 nsecs
[   67.858242] active timers:
[   67.858243]  clock 1:
[   67.858244]   .index:      1
[   67.858245]   .resolution: 1 nsecs
[   67.858246]   .get_time:   ktime_get
[   67.858248]   .offset:     0 nsecs
[   67.858249] active timers:
[   67.858250]  #0: <ffff88011ffa7bd8>, tick_sched_timer, S:01,
tick_nohz_stop_sched_tick, swapper/0
[   67.858255]  # expires at 10737461460000000 nsecs [in
10737393605538320 nsecs]
[   67.858257]   .expires_next   : 10737461460000000 nsecs
[   67.858258]   .hres_active    : 1
[   67.858259]   .nr_events      : 602
[   67.858260]   .nohz_mode      : 2
[   67.858261]   .idle_tick      : 43231250000 nsecs
[   67.858262]   .tick_stopped   : 1
[   67.858263]   .idle_jiffies   : 4294941618
[   67.858265]   .idle_calls     : 1484
[   67.858266]   .idle_sleeps    : 257
[   67.858267]   .idle_entrytime : 67408620000 nsecs
[   67.858268]   .idle_waketime  : 67408616560 nsecs
[   67.858270]   .idle_exittime  : 43204130360 nsecs
[   67.858271]   .idle_sleeptime : 66778850400 nsecs
[   67.858272]   .last_jiffies   : 4294944036
[   67.858273]   .next_jiffies   : 5368683442
[   67.858274]   .idle_expires   : 10737461460000000 nsecs
[   67.858276] jiffies: 4294944081
[   67.858276]
[   67.858277] cpu: 2
[   67.858278]  clock 0:
[   67.858279]   .index:      0
[   67.858280]   .resolution: 1 nsecs
[   67.858281]   .get_time:   ktime_get_real
[   67.858283]   .offset:     1218541241000000000 nsecs
[   67.858284] active timers:
[   67.858285]  clock 1:
[   67.858286]   .index:      1
[   67.858287]   .resolution: 1 nsecs
[   67.858288]   .get_time:   ktime_get
[   67.858290]   .offset:     0 nsecs
[   67.858291] active timers:
[   67.858292]  #0: <ffff88011ffa7bd8>, tick_sched_timer, S:01,
tick_nohz_stop_sched_tick, swapper/0
[   67.858297]  # expires at 313030000000 nsecs [in 245175538320 nsecs]
[   67.858298]   .expires_next   : 313030000000 nsecs
[   67.858299]   .hres_active    : 1
[   67.858301]   .nr_events      : 291
[   67.858302]   .nohz_mode      : 2
[   67.858303]   .idle_tick      : 43212500000 nsecs
[   67.858304]   .tick_stopped   : 1
[   67.858305]   .idle_jiffies   : 4294941616
[   67.858306]   .idle_calls     : 508
[   67.858307]   .idle_sleeps    : 195
[   67.858308]   .idle_entrytime : 67408521000 nsecs
[   67.858310]   .idle_waketime  : 67408516080 nsecs
[   67.858311]   .idle_exittime  : 43205221160 nsecs
[   67.858312]   .idle_sleeptime : 66662104240 nsecs
[   67.858313]   .last_jiffies   : 4294944036
[   67.858314]   .next_jiffies   : 4294968599
[   67.858316]   .idle_expires   : 313030000000 nsecs
[   67.858317] jiffies: 4294944081
[   67.858318]
[   67.858318] cpu: 3
[   67.858319]  clock 0:
[   67.858320]   .index:      0
[   67.858321]   .resolution: 1 nsecs
[   67.858322]   .get_time:   ktime_get_real
[   67.858324]   .offset:     1218541241000000000 nsecs
[   67.858325] active timers:
[   67.858326]  clock 1:
[   67.858327]   .index:      1
[   67.858328]   .resolution: 1 nsecs
[   67.858329]   .get_time:   ktime_get
[   67.858331]   .offset:     0 nsecs
[   67.858332] active timers:
[   67.858333]  #0: <ffff88011ffa7bd8>, tick_sched_timer, S:01,
tick_nohz_stop_sched_tick, swapper/0
[   67.858338]  # expires at 67920000000 nsecs [in 65538320 nsecs]
[   67.858339]   .expires_next   : 67920000000 nsecs
[   67.858340]   .hres_active    : 1
[   67.858342]   .nr_events      : 679
[   67.858343]   .nohz_mode      : 2
[   67.858344]   .idle_tick      : 67823750000 nsecs
[   67.858345]   .tick_stopped   : 1
[   67.858346]   .idle_jiffies   : 4294944078
[   67.858347]   .idle_calls     : 2434
[   67.858348]   .idle_sleeps    : 601
[   67.858349]   .idle_entrytime : 67821654840 nsecs
[   67.858350]   .idle_waketime  : 67850565040 nsecs
[   67.858352]   .idle_exittime  : 67821651200 nsecs
[   67.858353]   .idle_sleeptime : 65557525360 nsecs
[   67.858354]   .last_jiffies   : 4294944078
[   67.858355]   .next_jiffies   : 4294944088
[   67.858356]   .idle_expires   : 67920000000 nsecs
[   67.858357] jiffies: 4294944081
[   67.858359]
[   67.858360]
[   67.858360] Tick Device: mode:     1
[   67.858362] Clock Event Device: hpet
[   67.858363]  max_delta_ns:   85899346200
[   67.858365]  min_delta_ns:   1920
[   67.858366]  mult:           107374182
[   67.858367]  shift:          32
[   67.858368]  mode:           3
[   67.858369]  next_event:     9223372036854775807 nsecs
[   67.858370]  set_next_event: hpet_legacy_next_event
[   67.858374]  set_mode:       hpet_legacy_set_mode
[   67.858376]  event_handler:  tick_handle_oneshot_broadcast
[   67.858379] tick_broadcast_mask: 00000000
[   67.858381] tick_broadcast_oneshot_mask: 00000000
[   67.858382]
[   67.858383]
[   67.858384] Tick Device: mode:     1
[   67.858384] Clock Event Device: lapic
[   67.858386]  max_delta_ns:   671088187
[   67.858387]  min_delta_ns:   1199
[   67.858388]  mult:           53687121
[   67.858389]  shift:          32
[   67.858390]  mode:           3
[   67.858391]  next_event:     70030000000 nsecs
[   67.858392]  set_next_event: lapic_next_event
[   67.858395]  set_mode:       lapic_timer_setup
[   67.858397]  event_handler:  hrtimer_interrupt
[   67.858399]
[   67.858399] Tick Device: mode:     1
[   67.858401] Clock Event Device: lapic
[   67.858402]  max_delta_ns:   671088187
[   67.858403]  min_delta_ns:   1199
[   67.858404]  mult:           53687121
[   67.858405]  shift:          32
[   67.858406]  mode:           3
[   67.858407]  next_event:     10737461460000000 nsecs
[   67.858408]  set_next_event: lapic_next_event
[   67.858410]  set_mode:       lapic_timer_setup
[   67.858412]  event_handler:  hrtimer_interrupt
[   67.858414]
[   67.858414] Tick Device: mode:     1
[   67.858415] Clock Event Device: lapic
[   67.858417]  max_delta_ns:   671088187
[   67.858418]  min_delta_ns:   1199
[   67.858419]  mult:           53687121
[   67.858420]  shift:          32
[   67.858421]  mode:           3
[   67.858422]  next_event:     313030000000 nsecs
[   67.858423]  set_next_event: lapic_next_event
[   67.858425]  set_mode:       lapic_timer_setup
[   67.858427]  event_handler:  hrtimer_interrupt
[   67.858429]
[   67.858430] Tick Device: mode:     1
[   67.858430] Clock Event Device: lapic
[   67.858432]  max_delta_ns:   671088187
[   67.858433]  min_delta_ns:   1199
[   67.858434]  mult:           53687121
[   67.858435]  shift:          32
[   67.858436]  mode:           3
[   67.858437]  next_event:     67920000000 nsecs
[   67.858438]  set_next_event: lapic_next_event
[   67.858440]  set_mode:       lapic_timer_setup
[   67.858441]  event_handler:  hrtimer_interrupt
[   67.858443]
[   70.186548] SysRq : Show Blocked State
[   70.190344]   task                        PC stack   pid father
[   70.190358] md1_raid5     D ffff88007d53bd00     0   968      2
[   70.190361]  ffff88007d53bcf0 0000000000000046 ffff88011d11b080
ffff88011d11b080
[   70.190364]  0000000000000001 ffffffff80a64000 ffffffff80a6c540
ffffffff80a6c540
[   70.190367]  ffffffff80a6c540 ffffffff80a6c540 ffffffff80a6c540
ffffffff80a6c540
[   70.190369] Call Trace:
[   70.190374]  [<ffffffff80529d9b>] md_super_wait+0xbb/0xe0
[   70.190377]  [<ffffffff80257140>] ? autoremove_wake_function+0x0/0x40
[   70.190380]  [<ffffffff80533ee0>] bitmap_unplug+0x1b0/0x1c0
[   70.190384]  [<ffffffff805249be>] raid5d+0xde/0x540
[   70.190388]  [<ffffffff8024ba3a>] ? del_timer_sync+0x1a/0x30
[   70.190390]  [<ffffffff8052a134>] md_thread+0x54/0x140
[   70.190392]  [<ffffffff80257140>] ? autoremove_wake_function+0x0/0x40
[   70.190394]  [<ffffffff8052a0e0>] ? md_thread+0x0/0x140
[   70.190396]  [<ffffffff80256d59>] kthread+0x49/0x80
[   70.190399]  [<ffffffff8020c989>] child_rip+0xa/0x11
[   70.190401]  [<ffffffff8020bfcc>] ? restore_args+0x0/0x30
[   70.190403]  [<ffffffff80256d10>] ? kthread+0x0/0x80
[   70.190405]  [<ffffffff8020c97f>] ? child_rip+0x0/0x11
[   70.190406]
[   70.190408] mount         D 0000000000000200     0  1086      1
[   70.190410]  ffff88007d539918 0000000000000082 0000000000000000
0000000000000001
[   70.190413]  0000000000000086 ffffffff80a64000 ffffffff80a6c540
ffffffff80a6c540
[   70.190416]  ffffffff80a6c540 ffffffff80a6c540 ffffffff80a6c540
ffffffff80a6c540
[   70.190418] Call Trace:
[   70.190422]  [<ffffffff8062c55d>] schedule_timeout+0x8d/0xd0
[   70.190428]  [<ffffffff803c9268>] ? blk_unplug+0x38/0x70
[   70.190431]  [<ffffffff803ca7c4>] ? submit_bio+0x64/0x100
[   70.190433]  [<ffffffff8062cee0>] __down+0x70/0xb0
[   70.190435]  [<ffffffff8025b776>] down+0x46/0x50
[   70.190439]  [<ffffffff803a2c12>] xfs_buf_iowait+0x22/0x60
[   70.190444]  [<ffffffff8039e0b8>] xfs_bwrite+0x98/0xf0
[   70.190449]  [<ffffffff8038de4c>] xlog_bwrite+0x7c/0xd0
[   70.190451]  [<ffffffff8038ecdb>] xlog_write_log_records+0x19b/0x270
[   70.190454]  [<ffffffff8038ee5d>] xlog_clear_stale_blocks+0xad/0x190
[   70.190457]  [<ffffffff8038ff58>] xlog_find_tail+0x398/0x410
[   70.190459]  [<ffffffff8025b667>] ? down_trylock+0x37/0x50
[   70.190462]  [<ffffffff8038ffe9>] xlog_recover+0x19/0x90
[   70.190464]  [<ffffffff80388df9>] xfs_log_mount+0x149/0x160
[   70.190467]  [<ffffffff80392b6c>] xfs_mountfs+0x34c/0x710
[   70.190472]  [<ffffffff80376e60>] ? xfs_fstrm_free_func+0x0/0xa0
[   70.190474]  [<ffffffff8039ea0e>] ? kmem_zalloc+0x2e/0x40
[   70.190476]  [<ffffffff80393766>] ? xfs_mru_cache_create+0x126/0x160
[   70.190480]  [<ffffffff803ab33d>] xfs_fs_fill_super+0x25d/0x420
[   70.190485]  [<ffffffff802b78ab>] get_sb_bdev+0x13b/0x170
[   70.190487]  [<ffffffff803ab0e0>] ? xfs_fs_fill_super+0x0/0x420
[   70.190491]  [<ffffffff8028baf6>] ? kstrdup+0x56/0x70
[   70.190493]  [<ffffffff803a8783>] xfs_fs_get_sb+0x13/0x20
[   70.190496]  [<ffffffff802b6f79>] vfs_kern_mount+0x79/0x170
[   70.190499]  [<ffffffff802b70de>] do_kern_mount+0x4e/0x110
[   70.190503]  [<ffffffff802d1154>] do_new_mount+0x94/0xc0
[   70.190505]  [<ffffffff802d17dd>] do_mount+0x23d/0x260
[   70.190507]  [<ffffffff8020bfcc>] ? restore_args+0x0/0x30
[   70.190512]  [<ffffffff8062ff26>] ? bad_gs+0x12b1/0x265b
[   70.190514]  [<ffffffff802d18b8>] sys_mount+0xb8/0xf0
[   70.190516]  [<ffffffff8062ddba>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[   70.190518]  [<ffffffff8020ba3b>] system_call_fastpath+0x16/0x1b
[   70.190520]
[   70.190523] Sched Debug Version: v0.07, 2.6.27-rc2 #2
[   70.190525] now at 70186.846320 msecs
[   70.190527]   .sysctl_sched_latency                    : 60.000000
[   70.190528]   .sysctl_sched_min_granularity            : 12.000000
[   70.190530]   .sysctl_sched_wakeup_granularity         : 15.000000
[   70.190532]   .sysctl_sched_child_runs_first           : 0.000001
[   70.190533]   .sysctl_sched_features                   : 6911
[   70.190535]
[   70.190535] cpu#0, 2599.995 MHz
[   70.190537]   .nr_running                    : 0
[   70.190538]   .load                          : 0
[   70.190539]   .nr_switches                   : 1589
[   70.190541]   .nr_load_updates               : 704
[   70.190542]   .nr_uninterruptible            : -5
[   70.190543]   .jiffies                       : 4294944314
[   70.190545]   .next_balance                  : 4294.942301
[   70.190546]   .curr->pid                     : 0
[   70.190548]   .clock                         : 70025.047782
[   70.190549]   .cpu_load[0]                   : 0
[   70.190550]   .cpu_load[1]                   : 0
[   70.190551]   .cpu_load[2]                   : 0
[   70.190553]   .cpu_load[3]                   : 0
[   70.190554]   .cpu_load[4]                   : 0
[   70.190556]
[   70.190556] cfs_rq[0]:
[   70.190557]   .exec_clock                    : 3869.141389
[   70.190560]   .MIN_vruntime                  : 0.000001
[   70.190561]   .min_vruntime                  : 1688857888.055753
[   70.190563]   .max_vruntime                  : 0.000001
[   70.190564]   .spread                        : 0.000000
[   70.190565]   .spread0                       : 0.000000
[   70.190566]   .nr_running                    : 0
[   70.190568]   .load                          : 0
[   70.190569]   .yld_exp_empty                 : 0
[   70.190570]   .yld_act_empty                 : 0
[   70.190571]   .yld_both_empty                : 0
[   70.190573]   .yld_count                     : 0
[   70.190574]   .sched_switch                  : 0
[   70.190575]   .sched_count                   : 1622
[   70.190576]   .sched_goidle                  : 681
[   70.190577]   .ttwu_count                    : 908
[   70.190579]   .ttwu_local                    : 327
[   70.190580]   .bkl_count                     : 552
[   70.190581]   .nr_spread_over                : 46
[   70.190583]
[   70.190583] rt_rq[0]:
[   70.190584]   .rt_nr_running                 : 0
[   70.190586]   .rt_throttled                  : 0
[   70.190587]   .rt_time                       : 0.000000
[   70.190588]   .rt_runtime                    : 950.000000
[   70.190590]
[   70.190590] runnable tasks:
[   70.190591]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   70.190592] ----------------------------------------------------------------------------------------------------------
[   70.190599]
[   70.190599] cpu#1, 2599.995 MHz
[   70.190600]   .nr_running                    : 0
[   70.190601]   .load                          : 0
[   70.190603]   .nr_switches                   : 2832
[   70.190604]   .nr_load_updates               : 621
[   70.190605]   .nr_uninterruptible            : -278
[   70.190606]   .jiffies                       : 4294944314
[   70.190608]   .next_balance                  : 4294.941618
[   70.190609]   .curr->pid                     : 0
[   70.190611]   .clock                         : 43216.262908
[   70.190612]   .cpu_load[0]                   : 0
[   70.190613]   .cpu_load[1]                   : 0
[   70.190614]   .cpu_load[2]                   : 3
[   70.190616]   .cpu_load[3]                   : 27
[   70.190617]   .cpu_load[4]                   : 64
[   70.190618]
[   70.190619] cfs_rq[1]:
[   70.190620]   .exec_clock                    : 255.791897
[   70.190621]   .MIN_vruntime                  : 0.000001
[   70.190623]   .min_vruntime                  : 281509622.588824
[   70.190624]   .max_vruntime                  : 0.000001
[   70.190625]   .spread                        : 0.000000
[   70.190627]   .spread0                       : -1407348265.466929
[   70.190628]   .nr_running                    : 0
[   70.190629]   .load                          : 0
[   70.190630]   .yld_exp_empty                 : 0
[   70.190631]   .yld_act_empty                 : 0
[   70.190633]   .yld_both_empty                : 0
[   70.190634]   .yld_count                     : 0
[   70.190635]   .sched_switch                  : 0
[   70.190637]   .sched_count                   : 2868
[   70.190638]   .sched_goidle                  : 1233
[   70.190639]   .ttwu_count                    : 1043
[   70.190640]   .ttwu_local                    : 512
[   70.190641]   .bkl_count                     : 41
[   70.190643]   .nr_spread_over                : 13
[   70.190644]
[   70.190644] rt_rq[1]:
[   70.190645]   .rt_nr_running                 : 0
[   70.190647]   .rt_throttled                  : 0
[   70.190648]   .rt_time                       : 0.000000
[   70.190649]   .rt_runtime                    : 950.000000
[   70.190651]
[   70.190651] runnable tasks:
[   70.190652]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   70.190653] ----------------------------------------------------------------------------------------------------------
[   70.190657]
[   70.190657] cpu#2, 2599.995 MHz
[   70.190658]   .nr_running                    : 0
[   70.190659]   .load                          : 0
[   70.190660]   .nr_switches                   : 563
[   70.190662]   .nr_load_updates               : 290
[   70.190663]   .nr_uninterruptible            : -9
[   70.190664]   .jiffies                       : 4294944314
[   70.190666]   .next_balance                  : 4294.941618
[   70.190667]   .curr->pid                     : 0
[   70.190668]   .clock                         : 43212.743039
[   70.190669]   .cpu_load[0]                   : 0
[   70.190671]   .cpu_load[1]                   : 0
[   70.190672]   .cpu_load[2]                   : 0
[   70.190673]   .cpu_load[3]                   : 0
[   70.190674]   .cpu_load[4]                   : 0
[   70.190675]
[   70.190676] cfs_rq[2]:
[   70.190677]   .exec_clock                    : 188.213008
[   70.190678]   .MIN_vruntime                  : 0.000001
[   70.190680]   .min_vruntime                  : 1328.846430
[   70.190681]   .max_vruntime                  : 0.000001
[   70.190682]   .spread                        : 0.000000
[   70.190684]   .spread0                       : -1688856559.209323
[   70.190685]   .nr_running                    : 0
[   70.190686]   .load                          : 0
[   70.190688]   .yld_exp_empty                 : 0
[   70.190689]   .yld_act_empty                 : 0
[   70.190690]   .yld_both_empty                : 0
[   70.190691]   .yld_count                     : 0
[   70.190693]   .sched_switch                  : 0
[   70.190694]   .sched_count                   : 586
[   70.190695]   .sched_goidle                  : 275
[   70.190696]   .ttwu_count                    : 289
[   70.190698]   .ttwu_local                    : 79
[   70.190699]   .bkl_count                     : 115
[   70.190700]   .nr_spread_over                : 1
[   70.190701]
[   70.190702] rt_rq[2]:
[   70.190703]   .rt_nr_running                 : 0
[   70.190704]   .rt_throttled                  : 0
[   70.190705]   .rt_time                       : 0.000000
[   70.190707]   .rt_runtime                    : 950.000000
[   70.190708]
[   70.190709] runnable tasks:
[   70.190709]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   70.190711] ----------------------------------------------------------------------------------------------------------
[   70.190714]
[   70.190715] cpu#3, 2599.995 MHz
[   70.190716]   .nr_running                    : 1
[   70.190717]   .load                          : 3121
[   70.190718]   .nr_switches                   : 5704
[   70.190719]   .nr_load_updates               : 692
[   70.190721]   .nr_uninterruptible            : 294
[   70.190722]   .jiffies                       : 4294944314
[   70.190723]   .next_balance                  : 4294.943292
[   70.190724]   .curr->pid                     : 0
[   70.190726]   .clock                         : 70186.547162
[   70.190727]   .cpu_load[0]                   : 0
[   70.190728]   .cpu_load[1]                   : 0
[   70.190730]   .cpu_load[2]                   : 0
[   70.190731]   .cpu_load[3]                   : 0
[   70.190732]   .cpu_load[4]                   : 0
[   70.190733]
[   70.190733] cfs_rq[3]:
[   70.190735]   .exec_clock                    : 1528.730403
[   70.190736]   .MIN_vruntime                  : 281053093.163474
[   70.190738]   .min_vruntime                  : 281053153.007862
[   70.190739]   .max_vruntime                  : 281053093.163474
[   70.190740]   .spread                        : 0.000000
[   70.190742]   .spread0                       : -1407804735.047891
[   70.190743]   .nr_running                    : 1
[   70.190744]   .load                          : 3121
[   70.190745]   .yld_exp_empty                 : 0
[   70.190747]   .yld_act_empty                 : 0
[   70.190748]   .yld_both_empty                : 0
[   70.190749]   .yld_count                     : 0
[   70.190750]   .sched_switch                  : 0
[   70.190751]   .sched_count                   : 5734
[   70.190753]   .sched_goidle                  : 2222
[   70.190754]   .ttwu_count                    : 3025
[   70.190755]   .ttwu_local                    : 1870
[   70.190756]   .bkl_count                     : 73
[   70.190757]   .nr_spread_over                : 19
[   70.190759]
[   70.190759] rt_rq[3]:
[   70.190760]   .rt_nr_running                 : 0
[   70.190761]   .rt_throttled                  : 0
[   70.190762]   .rt_time                       : 0.000000
[   70.190764]   .rt_runtime                    : 950.000000
[   70.190765]
[   70.190766] runnable tasks:
[   70.190766]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   70.190767] ----------------------------------------------------------------------------------------------------------
[   70.190770]         events/3    18 281053093.163474       213   115
281053093.163474         0.382413     69347.112586
[   70.190775]
-> hitting enter seems to cure the stall
[   73.303649] ata3: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[   73.303651] ata3: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[   73.303652]   dhfis 0x1 dmafis 0x1 sdbfis 0x0
[   73.303654] ata3: ATA_REG 0x40 ERR_REG 0x0
[   73.303656] ata3: tag : dhfis dmafis sdbfis sacitve
[   73.303658] ata3: tag 0x0: 1 1 0 1
[   73.303670] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x1800000
action 0x6 frozen
[   73.303674] ata3: SError: { LinkSeq TrStaTrns }
[   73.303679] ata3.00: cmd 61/08:00:11:d6:42/00:00:25:00:00/40 tag 0
ncq 4096 out
[   73.303680]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   73.303682] ata3.00: status: { DRDY }
[   73.303692] ata3: hard resetting link
[   73.653653] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   73.800638] ata3.00: configured for UDMA/133
[   73.800646] ata3: EH complete
[   73.800718] sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[   73.800734] sd 2:0:0:0: [sdc] Write Protect is off
[   73.800736] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   73.800762] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   74.053525] ata3: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[   74.053527] ata3: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[   74.053528]   dhfis 0x1 dmafis 0x1 sdbfis 0x0
[   74.053530] ata3: ATA_REG 0x41 ERR_REG 0x0
[   74.053531] ata3: tag : dhfis dmafis sdbfis sacitve
[   74.053533] ata3: tag 0x0: 1 1 0 1
[   74.053540] ata3.00: exception Emask 0x1 SAct 0x1 SErr 0x1c00000
action 0x6 frozen
[   74.053541] ata3.00: Ata error. fis:0x21
[   74.053543] ata3: SError: { Handshk LinkSeq TrStaTrns }
[   74.053547] ata3.00: cmd 61/c0:00:c1:27:37/00:00:13:00:00/40 tag 0
ncq 98304 out
[   74.053548]          res 41/00:00:c1:27:37/00:00:13:00:00/40 Emask
0x1 (device error)
[   74.053550] ata3.00: status: { DRDY ERR }
[   74.053554] ata3: hard resetting link
[   74.397397] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   74.550343] ata3.00: configured for UDMA/133
[   74.550352] ata3: EH complete
[   74.550414] sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[   74.550428] sd 2:0:0:0: [sdc] Write Protect is off
[   74.550429] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   74.550451] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   74.636270] Ending clean XFS mount for filesystem: dm-0
-> the system now boots normally, autodetecting starts loading modules
from the encrypted fs:
[   78.202125] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   78.202176] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   78.202220] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   78.255396] pata_amd 0000:00:04.0: version 0.3.10
[   78.255469] pata_amd 0000:00:04.0: setting latency timer to 64
[   78.255593] scsi8 : pata_amd
[   78.255747] scsi9 : pata_amd
[   78.258154] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   78.258158] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   78.425049] ata10: port disabled. ignoring.
[   78.751687] usbcore: registered new interface driver hiddev
[   78.751035] input: HID 062a:0000 as
/devices/pci0000:00/0000:00:02.0/usb2/2-9/2-9:1.0/input/input4
[   78.878924] input,hidraw0: USB HID v1.10 Mouse [HID 062a:0000] on
usb-0000:00:02.0-9
[   78.878960] usbcore: registered new interface driver usbhid
[   78.878965] usbhid: v2.6:USB HID core driver
[...]

I did not see any other errors from this drive.

Anything else I should try, to get more information about this?

Torsten
