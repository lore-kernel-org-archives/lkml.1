Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYEHXMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYEHXMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYEHXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:12:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:14133 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYEHXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tUQAc3+kpLFSUadVQnyKu2bCiJEm1htJa11j4UJcN8mMnGQyNlIZiGcZrXc04/F4WzwC1is6GGn9XL0O5Qn9lrAmaiZT/qLUKSff/NP1yJUoJ3Ayj5e//pD2/cSekdDFy+zR+tskhSVVDlnqDIhvt/f+jyOrgIwhwKm3dgivWnM=
Date: Fri, 9 May 2008 01:12:27 +0200
From: Karol Lewandowski <lmctlx@gmail.com>
To: ibm-acpi-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Message-ID: <20080508231227.GA9157@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my Thinkpad T21 executing:

 # echo 7 blink > /proc/acpi/ibm/led

on kernel afa26be86b65a7183ceac29bdf1f51d6fc6932f0 (few comits after
rc1) results in following oops:

BUG: unable to handle kernel paging request at d08ed000
IP: [<d08e3534>] :thinkpad_acpi:led_set_status+0xac/0xc3
*pde = 0f81c067 *pte = 00000000 
Oops: 0002 [#1] PREEMPT 
Modules linked in: nfs lockd nfs_acl sunrpc ipv6 autofs4 nls_iso8859_1 dm_snapshot dm_mirror dm_log thinkpad_acpi hwmon backlight led_class nvram fuse irtty_sir sir_dev irda parport_pc parport snd_cs46xx snd_seq_midi snd_rawmidi rt2500pci rt2x00pci rt2x00lib snd_ac97_codec uhci_hcd eeprom_93cx6 ac97_bus

Pid: 2113, comm: bash Not tainted (2.6.26-rc1-bizet #4)
EIP: 0060:[<d08e3534>] EFLAGS: 00010246 CPU: 0
EIP is at led_set_status+0xac/0xc3 [thinkpad_acpi]
EAX: 00000000 EBX: 00000080 ECX: cf801150 EDX: 00000000
ESI: 00000001 EDI: 00000005 EBP: d08ec660 ESP: cefa1f1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process bash (pid: 2113, ti=cefa1000 task=cf9a91c0 task.ti=cefa1000)
Stack: cfa92588 fffffff4 d08e5028 cfa9258e 00000007 cfa92588 d08e5433 08e9cc08 
       d08e53d1 cefcbe80 08e9cc08 fffffffb c0190dc7 d08ec660 cec7b840 c0190da2 
       cefcbe80 c018d5a5 cefa1fa0 00000005 08e9cc08 cefcbe80 08e9cc08 c018d528 
Call Trace:
 [<d08e5028>] led_write+0x83/0xa1 [thinkpad_acpi]
 [<d08e5433>] dispatch_procfs_write+0x62/0x7f [thinkpad_acpi]
 [<d08e53d1>] dispatch_procfs_write+0x0/0x7f [thinkpad_acpi]
 [<c0190dc7>] proc_file_write+0x25/0x2e
 [<c0190da2>] proc_file_write+0x0/0x2e
 [<c018d5a5>] proc_reg_write+0x7d/0x90
 [<c018d528>] proc_reg_write+0x0/0x90
 [<c015ed04>] vfs_write+0x83/0xf6
 [<c015f192>] sys_write+0x3c/0x63
 [<c0103721>] sysenter_past_esp+0x6a/0x91
 =======================
Code: eb 25 ff 34 b5 f0 54 8e d0 53 68 f8 59 8e d0 6a 00 6a 00 ff 35 ec cd 8e d0 e8 65 ec ff ff 83 c4 18 85 c0 74 0f eb 14 85 c0 75 14 <89> 34 9d 00 ce 8e d0 eb 0b b8 fb ff ff ff eb 04 31 c0 eb ec 5b 
EIP: [<d08e3534>] led_set_status+0xac/0xc3 [thinkpad_acpi] SS:ESP 0068:cefa1f1c
---[ end trace b17012c606d1f702 ]---


Hopefully relevant data from my .config:

 # egrep -i '(acpi|thinkpad|led)' .config

CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=m
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_PNPACPI=y
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_BAY=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_ATA_ACPI=y
CONFIG_PATA_ACPI=y
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_RT2500PCI_LEDS is not set
# CONFIG_RT61PCI_LEDS is not set
# CONFIG_RT2500USB_LEDS is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
# LED drivers
# CONFIG_LEDS_CLEVO_MAIL is not set
# LED Triggers
# CONFIG_LEDS_TRIGGERS is not set


I haven't seen any relevant changes in drivers/misc/thinkpad_acpi.c up
to 3de2403e6659d71b36ec820dc9b942762ddfe6eb, so I guess it's unfixed
in newer kernels.

(Please keep Cc to me.)

Thanks.


Full dmesg:

Initializing cgroup subsys cpu
Linux version 2.6.26-rc1-bizet (karol@bizet) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #4 PREEMPT Sun May 4 01:07:36 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fffec00 (ACPI data)
 BIOS-e820: 000000000fffec00 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
CPU and/or kernel does not support PAT.
255MB LOWMEM available.
Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65520
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    65520
On node 0 totalpages: 65520
  DMA zone: 36 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4060 pages, LIFO batch:0
  Normal zone: 539 pages used for memmap
  Normal zone: 60885 pages, LIFO batch:15
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F7120, 0014 (r0 PTLTD )
ACPI: RSDT 0FFF4C5D, 002C (r1 PTLTD    RSDT    6041160  LTP        0)
ACPI: FACP 0FFFEB65, 0074 (r1 IBM    TP-T21    6041160             0)
ACPI: DSDT 0FFF4C89, 9EDC (r1 IBM    TP-T21    6041160 MSFT  100000C)
ACPI: FACS 0FFFF000, 0040
ACPI: BOOT 0FFFEBD9, 0027 (r1 PTLTD  $SBFTBL$  6041160  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 20000000 (gap: 10000000:eff80000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64945
Kernel command line: root=/dev/sda3 ro resume=/dev/sda1 
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01242000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0490000 soft=c048f000
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 341.754 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 255080k/262080k available (2233k kernel code, 6504k reserved, 1196k data, 196k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xd0800000 - 0xfffb3000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
      .init : 0xc045b000 - 0xc048c000   ( 196 kB)
      .data : 0xc032e42d - 0xc0459528   (1196 kB)
      .text : 0xc0100000 - 0xc032e42d   (2233 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 690.23 BogoMIPS (lpj=3451189)
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Pentium III (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080321
ACPI: setting ELCR to 0200 (from 0800)
net_namespace: 624 bytes
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=7
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:07.3: PIIX4 devres C PIO at 15e8-15ef
pci 0000:00:07.3: PIIX4 devres I PIO at 03f0-03f7
pci 0000:00:07.3: PIIX4 devres J PIO at 002e-002f
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PSER] (on)
ACPI: Power Resource [PSIO] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff could not be reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xd0000-0xcffff could not be reserved
system 00:00: iomem range 0xd4000-0xd3fff could not be reserved
system 00:00: iomem range 0xd8000-0xd7fff could not be reserved
system 00:00: iomem range 0xdc000-0xdbfff could not be reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:00: iomem range 0xec000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0xfffffff could not be reserved
system 00:00: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:02: ioport range 0x1000-0x103f has been reserved
system 00:02: ioport range 0x1040-0x104f has been reserved
system 00:02: ioport range 0xfe00-0xfe0f has been reserved
system 00:09: ioport range 0x15e0-0x15ef has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xf0000000-0xf7ffffff
  PREFETCH window: disabled.
PCI: Bus 2, cardbus bridge: 0000:00:02.0
  IO window: 0x00001400-0x000014ff
  IO window: 0x00001c00-0x00001cff
  PREFETCH window: 0x20000000-0x23ffffff
  MEM window: 0x24000000-0x27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:02.1
  IO window: 0x00002000-0x000020ff
  IO window: 0x00002400-0x000024ff
  PREFETCH window: 0x28000000-0x2bffffff
  MEM window: 0x2c000000-0x2fffffff
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x35 set to 0x1
Machine check exception polling timer started.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 498 for ipc namespace c043d020
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:03.0: Firmware left e100 interrupts enabled; disabling
pci 0000:01:00.0: Boot video device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
Console: switching to colour frame buffer device 80x30
fb0: VGA16 VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery absent)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM0] (29 C)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
brd: module loaded
loop: module loaded
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
e100: eth0: e100_probe: addr 0xe8120000, irq 11, MAC addr 00:10:a4:89:e8:84
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:07.1: version 2.12
scsi0 : ata_piix
scsi1 : ata_piix
Switched to high resolution mode on CPU 0
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1850 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1858 irq 15
ata1.00: ATA-7: SAMSUNG HM060HC, YJ100-19, max UDMA/100
ata1.00: 117231408 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/33
Clocksource tsc unstable (delta = 238950046 ns)
ata2.00: ATA-4: IBM-DARA-215000, GL5CA5AA, max UDMA/66
ata2.00: 29498112 sectors, multi 16: LBA 
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM060HC  YJ10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 117231408 512-byte hardware sectors (60022 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117231408 512-byte hardware sectors (60022 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
 sda2: <bsd: sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      IBM-DARA-215000  GL5C PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 29498112 512-byte hardware sectors (15103 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 29498112 512-byte hardware sectors (15103 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
Yenta: CardBus bridge found at 0000:00:02.0 [1014:0130]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0x00001000, devctl 0x66
Yenta: ISA IRQ mask 0x04f8, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:02.1 [1014:0130]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0x00001000, devctl 0x66
Yenta: ISA IRQ mask 0x04f8, PCI irq 11
Socket status: 30000020
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.16.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Marking TSC unstable due to: TSC halts in idle.
pccard: CardBus card inserted into slot 1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00001860
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-rc1-bizet uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
parport_pc 00:0d: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
NET: Registered protocol family 23
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
nsc_ircc_open(), can't get iobase of 0x2f8
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
nsc_ircc_open(), can't get iobase of 0x2f8
nsc-ircc 00:0e: disabled
rt2500pci 0000:06:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:06:00.0 to 64
phy0 -> rt2500pci_validate_eeprom: EEPROM recovery - NIC: 0xfff0
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003, rev: 00000004.
phy0: Selected rate control algorithm 'pid'
Adding 514040k swap on /dev/sda1.  Priority:-1 extents:1 across:514040k
EXT3 FS on sda3, internal journal
fuse init (API version 7.9)
Non-volatile memory driver v1.2
thinkpad_acpi: ThinkPad ACPI Extras v0.20
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS KZET34WW (1.16 ), EC unknown
Registered led device: tpacpi::thinklight
thinkpad_acpi: another device driver is already handling bay events
thinkpad_acpi: disabling subdriver bay
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
input: ThinkPad Extra Buttons as /class/input/input5
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2.
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:0b:6b:4f:0f:4f
wlan0: RX authentication from 00:0b:6b:4f:0f:4f (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:0b:6b:4f:0f:4f
wlan0: authentication frame received from 00:0b:6b:4f:0f:4f, but not in authenticate state - ignored
wlan0: authentication frame received from 00:0b:6b:4f:0f:4f, but not in authenticate state - ignored
wlan0: RX AssocResp from 00:0b:6b:4f:0f:4f (capab=0x421 status=0 aid=1)
wlan0: associated
wlan0: failed to set TX queue parameters for queue 2
wlan0: failed to set TX queue parameters for queue 3
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2.
wlan0: switched to short barker preamble (BSSID=00:0b:6b:4f:0f:4f)
wlan0: association frame received from 00:0b:6b:4f:0f:4f, but not in associate state - ignored
wlan0: authentication frame received from 00:0b:6b:4f:0f:4f, but not in authenticate state - ignored
wlan0: association frame received from 00:0b:6b:4f:0f:4f, but not in associate state - ignored
wlan0: authentication frame received from 00:0b:6b:4f:0f:4f, but not in authenticate state - ignored
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
wlan0: no IPv6 routers present
BUG: unable to handle kernel paging request at d08ed000
IP: [<d08e3534>] :thinkpad_acpi:led_set_status+0xac/0xc3
*pde = 0f81c067 *pte = 00000000 
Oops: 0002 [#1] PREEMPT 
Modules linked in: nfs lockd nfs_acl sunrpc ipv6 autofs4 nls_iso8859_1 dm_snapshot dm_mirror dm_log thinkpad_acpi hwmon backlight led_class nvram fuse irtty_sir sir_dev irda parport_pc parport snd_cs46xx snd_seq_midi snd_rawmidi rt2500pci rt2x00pci rt2x00lib snd_ac97_codec uhci_hcd eeprom_93cx6 ac97_bus

Pid: 2113, comm: bash Not tainted (2.6.26-rc1-bizet #4)
EIP: 0060:[<d08e3534>] EFLAGS: 00010246 CPU: 0
EIP is at led_set_status+0xac/0xc3 [thinkpad_acpi]
EAX: 00000000 EBX: 00000080 ECX: cf801150 EDX: 00000000
ESI: 00000001 EDI: 00000005 EBP: d08ec660 ESP: cefa1f1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process bash (pid: 2113, ti=cefa1000 task=cf9a91c0 task.ti=cefa1000)
Stack: cfa92588 fffffff4 d08e5028 cfa9258e 00000007 cfa92588 d08e5433 08e9cc08 
       d08e53d1 cefcbe80 08e9cc08 fffffffb c0190dc7 d08ec660 cec7b840 c0190da2 
       cefcbe80 c018d5a5 cefa1fa0 00000005 08e9cc08 cefcbe80 08e9cc08 c018d528 
Call Trace:
 [<d08e5028>] led_write+0x83/0xa1 [thinkpad_acpi]
 [<d08e5433>] dispatch_procfs_write+0x62/0x7f [thinkpad_acpi]
 [<d08e53d1>] dispatch_procfs_write+0x0/0x7f [thinkpad_acpi]
 [<c0190dc7>] proc_file_write+0x25/0x2e
 [<c0190da2>] proc_file_write+0x0/0x2e
 [<c018d5a5>] proc_reg_write+0x7d/0x90
 [<c018d528>] proc_reg_write+0x0/0x90
 [<c015ed04>] vfs_write+0x83/0xf6
 [<c015f192>] sys_write+0x3c/0x63
 [<c0103721>] sysenter_past_esp+0x6a/0x91
 =======================
Code: eb 25 ff 34 b5 f0 54 8e d0 53 68 f8 59 8e d0 6a 00 6a 00 ff 35 ec cd 8e d0 e8 65 ec ff ff 83 c4 18 85 c0 74 0f eb 14 85 c0 75 14 <89> 34 9d 00 ce 8e d0 eb 0b b8 fb ff ff ff eb 04 31 c0 eb ec 5b 
EIP: [<d08e3534>] led_set_status+0xac/0xc3 [thinkpad_acpi] SS:ESP 0068:cefa1f1c
---[ end trace b17012c606d1f702 ]---


.
