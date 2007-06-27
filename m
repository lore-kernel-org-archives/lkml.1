Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXF0KQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXF0KQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXF0KQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:16:43 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:49503 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXF0KQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:16:40 -0400
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
Subject: libata-bug in 2.6.21.5 on amd64 with ali chipset
Date: Wed, 27 Jun 2007 12:16:34 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200706271216.34879.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is on an amd64 gentoo system (with march=k8 -02 msse3 -pipe as CFLAGS aka 
sane ones).

with kernel 2.6.21.5 my dvd burner locks up the computer when k3b starts.

k3b
(this is of course captured without libata)

energyman@energy ~ $ kdecore (KAction): WARNING: 
KActionCollection::KActionCollection( QObject *parent, const char *name, 
KInstance *instance )
/dev/hdc resolved to /dev/hdc
/dev/hdc is block device (0)
/dev/hdc seems to be cdrom
(K3bDevice::Device) /dev/hdc: init()
(K3bDevice::Device) /dev/hdc feature: CD Mastering
(K3bDevice::Device) /dev/hdc feature: CD Track At Once
(K3bDevice::Device) /dev/hdc feature: CD-RW Media Write Support
(K3bDevice::Device) /dev/hdc feature: DVD+R
(K3bDevice::Device) /dev/hdc feature: DVD+RW
(K3bDevice::Device) /dev/hdc feature: DVD+R Double Layer
(K3bDevice::Device) /dev/hdc feature: DVD-R/-RW Write
(K3bDevice::Device) /dev/hdc feature: Rigid Restricted Overwrite
(K3bDevice::Device) /dev/hdc: dataLen: 60
(K3bDevice::Device) /dev/hdc: checking for TAO
(K3bDevice::Device) /dev/hdc: checking for SAO
(K3bDevice::Device) /dev/hdc: checking for SAO_R96P
(K3bDevice::Device) /dev/hdc: checking for SAO_R96R
(K3bDevice::Device) /dev/hdc: checking for RAW_R16
(K3bDevice::Device) /dev/hdc: checking for RAW_R96P
(K3bDevice::Device) /dev/hdc: checking for RAW_R96R 

at this point it locks up. Everything is dead. Keyboard, mouse, - I 
have acpid running, when the pwbutton is hit, it changes to vt2 and it does 
not work too.

Without libata and the 'normal' ide drivers the burner works.

The 2.6.21.5 is patched with cfs v18 and reiser4.

ver_linux
Linux energy 2.6.21.5-cfs-v18reiser4OS #4 SMP Wed Jun 27 11:09:51 CEST 2007 
x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ AuthenticAMD GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
reiser4progs           1.0.6
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   112
Modules Loaded         w83627hf hwmon_vid i2c_isa k8temp eeprom i2c_ali1563 
snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi 
snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event 
snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep tuner bttv 
video_buf ir_common compat_ioctl32 i2c_algo_bit btcx_risc tveeprom i2c_core 
videodev v4l2_common v4l1_compat uli526x


Here is dmesg without libata:

dmesg
[    0.000000] Linux version 2.6.21.5-cfs-v18reiser4OS (root@energy) (gcc 
version 4.1.2 (Gentoo 4.1.2)) #4 SMP Wed Jun 27 11:09:51 CEST 2007
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F9A50, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFB0000, 0034 (r1 A M I  OEMRSDT   9000625 MSFT       
97)
[    0.000000] ACPI: FACP 3FFB0200, 0084 (r2 A M I  OEMFACP   9000625 MSFT       
97)
[    0.000000] ACPI: DSDT 3FFB0440, 474D (r1  939M2 939M2222      222 INTL  
2002026)
[    0.000000] ACPI: FACS 3FFC0000, 0040
[    0.000000] ACPI: APIC 3FFB0390, 0068 (r1 A M I  OEMAPIC   9000625 MSFT       
97)
[    0.000000] ACPI: MCFG 3FFB0400, 003C (r1 A M I  OEMMCFG   9000625 MSFT       
97)
[    0.000000] ACPI: OEMB 3FFC0040, 0057 (r1 A M I  AMI_OEM   9000625 MSFT       
97)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262064
[    0.000000] On node 0 totalpages: 261967
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 918 pages reserved
[    0.000000]   DMA zone: 3025 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3526 pages used for memmap
[    0.000000]   DMA32 zone: 254442 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, address 0xfec10000, GSI 24-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e8000
[    0.000000] Nosave address range: 00000000000e8000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 
40000000:bf7c0000)
[    0.000000] PERCPU: Allocating 29440 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 257467
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   31.011478] time.c: Detected 2400.133 MHz processor.
[   31.018178] Console: colour VGA+ 80x25
[   31.021154] Dentry cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   31.022169] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   31.031793] Memory: 1027876k/1048256k available (2326k kernel code, 19680k 
reserved, 699k data, 192k init)
[   31.114642] Calibrating delay using timer specific routine.. 4804.23 
BogoMIPS (lpj=8003578)
[   31.114773] Mount-cache hash table entries: 256
[   31.114909] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   31.114958] CPU: L2 Cache: 512K (64 bytes/line)
[   31.115004] CPU: Physical Processor ID: 0
[   31.115049] CPU: Processor Core ID: 0
[   31.115107] Freeing SMP alternatives: 32k freed
[   31.115173] ACPI: Core revision 20070126
[   31.150542] Using local APIC timer interrupts.
[   31.192190] result 12500708
[   31.192233] Detected 12.500 MHz APIC timer.
[   31.194603] Booting processor 1/2 APIC 0x1
[   31.204929] Initializing CPU#1
[   31.287742] Calibrating delay using timer specific routine.. 4801.88 
BogoMIPS (lpj=7999821)
[   31.287748] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   31.287750] CPU: L2 Cache: 512K (64 bytes/line)
[   31.287752] CPU: Physical Processor ID: 0
[   31.287754] CPU: Processor Core ID: 1
[   31.287820] AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 01
[   31.291037] Brought up 2 CPUs
[   31.291668] NET: Registered protocol family 16
[   31.291780] ACPI: bus type pci registered
[   31.291834] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   31.291881] PCI: Not using MMCONFIG.
[   31.291925] PCI: Using configuration type 1
[   31.793662] ACPI: Interpreter enabled
[   31.793709] ACPI: Using IOAPIC for interrupt routing
[   31.799060] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   31.799113] PCI: Probing PCI hardware (bus 00)
[   31.799373] PCI quirk: region 0800-083f claimed by ali7101 ACPI
[   31.799718] Boot video device is 0000:01:00.0
[   31.800103] PCI: Transparent bridge - 0000:00:06.0
[   31.800186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   31.800280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[   31.800336] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
[   31.800438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[   31.800501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[   31.800561] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[   31.808044] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 
*15), disabled.
[   31.808594] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 
15)
[   31.809094] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 
15), disabled.
[   31.809638] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 
15)
[   31.810140] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 
15)
[   31.810668] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 
15)
[   31.811170] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 
15)
[   31.811672] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) 
*9
[   31.812214] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 *7 10 11 12 14 
15)
[   31.812698] Linux Plug and Play Support v0.97 (c) Adam Belay
[   31.812751] pnp: PnP ACPI init
[   31.814718] pnp: PnP ACPI: found 10 devices
[   31.814871] SCSI subsystem initialized
[   31.814952] libata version 2.20 loaded.
[   31.815002] usbcore: registered new interface driver usbfs
[   31.815072] usbcore: registered new interface driver hub
[   31.815147] usbcore: registered new device driver usb
[   31.815213] PCI: Using ACPI for IRQ routing
[   31.815259] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   31.815432] pnp: 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
[   31.815482] pnp: 00:06: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   31.815541] pnp: 00:06: iomem range 0xe0000000-0xefffffff has been reserved
[   31.815591] pnp: 00:06: iomem range 0xfec10000-0xfec10fff has been reserved
[   31.815642] pnp: 00:08: ioport range 0x290-0x29f has been reserved
[   31.815692] pnp: 00:09: iomem range 0x0-0x9ffff could not be reserved
[   31.815740] pnp: 00:09: iomem range 0xc0000-0xcffff has been reserved
[   31.815788] pnp: 00:09: iomem range 0xe0000-0xfffff could not be reserved
[   31.815837] pnp: 00:09: iomem range 0x100000-0x3fffffff could not be 
reserved
[   31.816086] PCI: Bridge: 0000:00:01.0
[   31.816130]   IO window: disabled.
[   31.816175]   MEM window: f4600000-fe6fffff
[   31.816221]   PREFETCH window: 9fe00000-bfdfffff
[   31.816268] PCI: Bridge: 0000:00:02.0
[   31.816312]   IO window: disabled.
[   31.816357]   MEM window: fe700000-fe7fffff
[   31.816402]   PREFETCH window: disabled.
[   31.816452] PCI: Bridge: 0000:00:03.0
[   31.816496]   IO window: c000-cfff
[   31.816541]   MEM window: fe800000-fe8fffff
[   31.816587]   PREFETCH window: disabled.
[   31.816632] PCI: Bridge: 0000:00:05.0
[   31.816676]   IO window: disabled.
[   31.816722]   MEM window: fe900000-fe9fffff
[   31.816769]   PREFETCH window: disabled.
[   31.816816] PCI: Bridge: 0000:00:06.0
[   31.816900] Time: acpi_pm clocksource has been installed.
[   31.816907]   IO window: d000-dfff
[   31.816981]   MEM window: fea00000-feafffff
[   31.817028]   PREFETCH window: bfe00000-bfefffff
[   31.817087] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, low) -> 
IRQ 29
[   31.817177] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   31.817183] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, low) -> 
IRQ 34
[   31.817272] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   31.817278] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 39 (level, low) -> 
IRQ 39
[   31.817367] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   31.817373] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   31.817379] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   31.817404] NET: Registered protocol family 2
[   31.850218] IP route cache hash table entries: 32768 (order: 6, 262144 
bytes)
[   31.850474] TCP established hash table entries: 131072 (order: 9, 3145728 
bytes)
[   31.852214] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   31.852828] TCP: Hash tables configured (established 131072 bind 65536)
[   31.852878] TCP reno registered
[   31.861091] Total HugeTLB memory allocated, 0
[   31.861234] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   31.861399] io scheduler noop registered
[   31.861452] io scheduler cfq registered (default)
[   31.920279] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   31.920301] assign_interrupt_mode Found MSI capability
[   31.920370] Allocate Port Service[0000:00:01.0:pcie00]
[   31.920425] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   31.920447] assign_interrupt_mode Found MSI capability
[   31.920507] Allocate Port Service[0000:00:02.0:pcie00]
[   31.920559] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   31.920581] assign_interrupt_mode Found MSI capability
[   31.920642] Allocate Port Service[0000:00:03.0:pcie00]
[   31.920808] input: Power Button (FF) as /class/input/input0
[   31.920855] ACPI: Power Button (FF) [PWRF]
[   31.920979] input: Power Button (CM) as /class/input/input1
[   31.921026] ACPI: Power Button (CM) [PWRB]
[   31.923045] Real Time Clock Driver v1.12ac
[   31.923183] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, 
margin is 60 seconds).
[   31.923244] Hangcheck: Using get_cycles().
[   31.923290] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing disabled
[   31.923732] tun: Universal TUN/TAP device driver, 1.6
[   31.923778] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   31.923849] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   31.923898] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[   31.923982] ALI15X3: IDE controller at PCI slot 0000:00:12.0
[   31.924037] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 19 (level, low) -> 
IRQ 19
[   31.924133] ALI15X3: chipset revision 199
[   31.924177] ALI15X3: not 100% native mode: will probe irqs later
[   31.924233]     ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, 
hdb:pio
[   31.924359]     ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:DMA, 
hdd:pio
[   31.930608] Probing IDE interface ide0...
[   32.203232] hda: SAMSUNG SP1213N, ATA DISK drive
[   32.842165] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   32.842276] Probing IDE interface ide1...
[   33.541215] hdc: _NEC DVD_RW ND-3500AG, ATAPI CD/DVD-ROM drive
[   34.180147] ide1 at 0x170-0x177,0x376 on irq 15
[   34.181036] hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, 
UDMA(33)
[   34.181330] Uniform CD-ROM driver Revision: 3.20
[   34.182616] ahci 0000:03:00.0: version 2.1
[   34.182634] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 35 (level, low) -> 
IRQ 35
[   35.181899] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   35.181906] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 
impl SATA mode
[   35.181966] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part
[   35.182128] ata1: SATA max UDMA/133 cmd 0xffffc20000010100 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 35
[   35.182197] scsi0 : ahci
[   35.661175] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   35.661704] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   35.661753] ata1.00: 312581808 sectors, multi 16: LBA48
[   35.662332] ata1.00: configured for UDMA/133
[   35.662443] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   35.662571] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   35.662626] sda: Write Protect is off
[   35.662670] sda: Mode Sense: 00 3a 00 00
[   35.662680] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   35.662770] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   35.662823] sda: Write Protect is off
[   35.662867] sda: Mode Sense: 00 3a 00 00
[   35.662877] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   35.662939]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   35.695642] sd 0:0:0:0: Attached scsi disk sda
[   35.695739] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   35.695809] usbmon: debugfs is not available
[   35.695894] ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> 
IRQ 23
[   35.695996] ehci_hcd 0000:00:13.3: EHCI Host Controller
[   35.696079] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus 
number 1
[   35.696166] ehci_hcd 0000:00:13.3: debug port 1
[   35.717748] ehci_hcd 0000:00:13.3: irq 23, io mem 0xfebff800
[   35.717798] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   35.717955] usb usb1: configuration #1 chosen from 1 choice
[   35.718030] hub 1-0:1.0: USB hub found
[   35.718081] hub 1-0:1.0: 8 ports detected
[   35.820990] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) 
Driver
[   35.821015] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 20 (level, low) -> 
IRQ 20
[   35.821112] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   35.821185] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus 
number 2
[   35.821255] ohci_hcd 0000:00:13.0: irq 20, io mem 0xfebfe000
[   35.876242] usb usb2: configuration #1 chosen from 1 choice
[   35.876316] hub 2-0:1.0: USB hub found
[   35.876367] hub 2-0:1.0: 3 ports detected
[   35.977414] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 21 (level, low) -> 
IRQ 21
[   35.977510] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   35.977581] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus 
number 3
[   35.977650] ohci_hcd 0000:00:13.1: irq 21, io mem 0xfebfd000
[   36.032676] usb usb3: configuration #1 chosen from 1 choice
[   36.032749] hub 3-0:1.0: USB hub found
[   36.032799] hub 3-0:1.0: 3 ports detected
[   36.047207] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   36.133843] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 22 (level, low) -> 
IRQ 22
[   36.133939] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   36.134009] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 4
[   36.134078] ohci_hcd 0000:00:13.2: irq 22, io mem 0xfebfc000
[   36.173332] usb 1-2: configuration #1 chosen from 1 choice
[   36.189114] usb usb4: configuration #1 chosen from 1 choice
[   36.189187] hub 4-0:1.0: USB hub found
[   36.189237] hub 4-0:1.0: 3 ports detected
[   36.639686] usb 3-2: new full speed USB device using ohci_hcd and address 2
[   36.789547] usb 3-2: configuration #1 chosen from 1 choice
[   36.795500] hub 3-2:1.0: USB hub found
[   36.798469] hub 3-2:1.0: 4 ports detected
[   37.126978] usb 3-2.4: new low speed USB device using ohci_hcd and address 
3
[   37.233880] usb 3-2.4: configuration #1 chosen from 1 choice
[   37.246974] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   37.247025] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on 
usb-0000:00:13.1-2.4
[   37.247150] usbcore: registered new interface driver usbhid
[   37.247197] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   37.247293] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   37.247341] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   37.249559] serio: i8042 KBD port at 0x60,0x64 irq 1
[   37.249609] serio: i8042 AUX port at 0x60,0x64 irq 12
[   37.249742] mice: PS/2 mouse device common for all mice
[   37.249925] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed 
Mar 14 07:25:50 2007 UTC).
[   37.249986] ALSA device list:
[   37.250029]   No soundcards found.
[   37.250079] TCP cubic registered
[   37.250139] NET: Registered protocol family 1
[   37.250186] NET: Registered protocol family 17
[   37.250251] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 
4600+ processors (version 2.00.00)
[   37.250301] powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xa
[   37.250349] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xa
[   37.250396] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xc
[   37.250443] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xe
[   37.250490] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
[   37.272262] input: AT Translated Set 2 keyboard as /class/input/input3
[   37.479899] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   37.479952] ReiserFS: sda3: using ordered data mode
[   37.489478] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   37.491058] ReiserFS: sda3: checking transaction log (sda3)
[   39.690102] ReiserFS: sda3: replayed 23 transactions in 2 seconds
[   39.708142] ReiserFS: sda3: Using r5 hash to sort names
[   39.708244] VFS: Mounted root (reiserfs filesystem) readonly.
[   39.708329] Freeing unused kernel memory: 192k freed
[   44.803849] ReiserFS: sda3: switching to journaled data mode
[   45.128392] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   45.128489] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 17 (level, low) -> 
IRQ 17
[   45.150141] eth0: ULi M5263 at pci0000:00:11.0, 00:13:8f:3f:bf:15, irq 17.
[   45.161611] Linux video capture interface: v2.00
[   45.206693] bttv: driver version 0.9.17 loaded
[   45.206699] bttv: using 16 buffers with 2080k (520 pages) each for capture
[   45.206752] bttv: Bt8xx card found (0).
[   45.206764] ACPI: PCI Interrupt 0000:05:06.0[A] -> GSI 21 (level, low) -> 
IRQ 21
[   45.206775] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 32, 
mmio: 0xbfeff000
[   45.206783] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra 
TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[   45.206814] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   46.207294] bttv0: tea5757: read timeout
[   46.207298] bttv0: using tuner=5
[   46.207302] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[   46.207996] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   46.208680] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   46.209362] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   46.227156] tuner 0-0060: All bytes are equal. It is not a TEA5767
[   46.227159] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   46.227184] tuner 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   46.227187] tuner 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   46.237515] bttv0: registered device video0
[   46.237532] bttv0: registered device vbi0
[   46.561296] reiser4: sda5: found disk format 4.0.0.
[   51.889654] reiser4: sda6: found disk format 4.0.0.
[   53.356148] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   56.785962] ACPI: PCI Interrupt 0000:05:07.0[A] -> GSI 22 (level, low) -> 
IRQ 22
[   56.789505] Audigy2 value: Special config.
[   58.721882] ali1563_smbus 0000:00:07.0: Found ALi1563 SMBus at 0x0400
[   62.069863] nvidia: module license 'NVIDIA' taints kernel.
[   62.325143] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 25 (level, low) -> 
IRQ 25
[   62.325251] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   62.325470] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed 
Jun 13 16:33:22 PDT 2007
[   64.651268] uli526x: eth0 NIC Link is Up 100 Mbps Full duplex
[  474.068401] kio_http_cache_[3979] general protection rip:3625ff3099 
rsp:7fff43165b00 error:0

(I forgot the ide disk driver... since hda/sdb doesn't contain any important 
stuff I did not realize it, until I wrote this).

Without nvidia loaded, the lockup happens too.


and here with libata (only the sata/pata part):

[   37.093860] ahci 0000:03:00.0: version 2.1
[   37.093882] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 35 (level, low) -> 
IRQ 35
[   38.095223] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   38.095230] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 
impl SATA mode
[   38.095291] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part
[   38.095474] ata1: SATA max UDMA/133 cmd 0xffffc20000010100 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 35
[   38.095542] scsi0 : ahci
[   38.574508] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.575032] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   38.575081] ata1.00: 312581808 sectors, multi 16: LBA48
[   38.575656] ata1.00: configured for UDMA/133
[   38.581899] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   38.582029] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   38.582083] sda: Write Protect is off
[   38.582128] sda: Mode Sense: 00 3a 00 00
[   38.582139] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   38.582238] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   38.582291] sda: Write Protect is off
[   38.582335] sda: Mode Sense: 00 3a 00 00
[   38.582346] SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   38.582407]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   38.612174] sd 0:0:0:0: Attached scsi disk sda
[   38.612270] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   38.612376] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 19 (level, low) -> 
IRQ 19
[   38.612508] ata2: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 
0x00000000000103f6 bmdma 0x000000000001ff00 irq 14
[   38.612597] ata3: PATA max UDMA/133 cmd 0x0000000000010170 ctl 
0x0000000000010376 bmdma 0x000000000001ff08 irq 15
[   38.612677] scsi1 : pata_ali
[   38.771081] ata2.00: ATA-7: SAMSUNG SP1213N, TL100-23, max UDMA/100
[   38.771129] ata2.00: 234493056 sectors, multi 16: LBA48
[   38.777736] ata2.00: configured for UDMA/100
[   38.777782] scsi2 : pata_ali
[   39.090598] ata3.00: ATAPI, max UDMA/33
[   39.250355] ata3.00: configured for UDMA/33
[   39.250438] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SP1213N  TL10 
PQ: 0 ANSI: 5
[   39.250560] SCSI device sdb: 234493056 512-byte hdwr sectors (120060 MB)
[   39.250613] sdb: Write Protect is off
[   39.250658] sdb: Mode Sense: 00 3a 00 00
[   39.250668] SCSI device sdb: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   39.250752] SCSI device sdb: 234493056 512-byte hdwr sectors (120060 MB)
[   39.250805] sdb: Write Protect is off
[   39.250849] sdb: Mode Sense: 00 3a 00 00
[   39.250859] SCSI device sdb: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   39.250920]  sdb: sdb1 sdb3 sdb4 < sdb5 sdb6 >
[   39.295852] sd 1:0:0:0: Attached scsi disk sdb
[   39.295944] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   39.297782] scsi 2:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 
PQ: 0 ANSI: 5
[   39.299671] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   39.299720] Uniform CD-ROM driver Revision: 3.20
[   39.299798] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   39.299849] sr 2:0:0:0: Attached scsi generic sg2 type 5

lspci:
00:00.0 Host bridge: ALi Corporation M1695 K8 Northbridge [PCI Express and 
HyperTransport]
00:01.0 PCI bridge: ALi Corporation PCI Express Root Port
00:02.0 PCI bridge: ALi Corporation PCI Express Root Port
00:03.0 PCI bridge: ALi Corporation PCI Express Root Port
00:04.0 Host bridge: ALi Corporation M1689 K8 Northbridge [Super K8 Single 
Chip]
00:05.0 PCI bridge: ALi Corporation AGP8X Controller
00:06.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge
00:07.0 ISA bridge: ALi Corporation M1563 HyperTransport South Bridge (rev 70)
00:07.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
00:11.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated 
ethernet. (rev 40)
00:12.0 IDE interface: ALi Corporation M5229 IDE (rev c7)
00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation NV43 [GeForce 6600] (rev 
a2)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller
05:05.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
05:06.0 Multimedia video controller: Brooktree Corporation Bt848 Video Capture 
(rev 12)
05:07.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value

It has worked in the past. I will try different kernels in the next 24hours.

If you need more info, please tell me so. And please cc me - I am not 
subscribed.
Glück Auf
Volker
