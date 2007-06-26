Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXFZFnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXFZFnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFZFnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:43:35 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55378 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXFZFne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:43:34 -0400
Date: Tue, 26 Jun 2007 08:43:31 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc6: NMI oops and long pauses during boot
Message-ID: <Pine.SOC.4.64.0706260833480.19044@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I compiled 2.6.22-rc6 yesterday and testbooted it.

First boot hung with oops/bug dump. I did not have a camera ready but it 
was an oops-like dump that included die_nmi or something similar about 
NMI.

Second boot booted fine until INIT had started and then came a long 
pause (tens of seconds). When I pressed Ctrl-Alt-Del it became alive and 
continued the bootup until it noticed the Ctrl-Alt-Del.

Third boot was similar but the pause appeared before INIT: line and 
after mounting root and writeprotecting kernel text and readonly 
data. Ctrl-Alt-Del revived it again.

Fourth boot went OK up until chronyd was started.

When I got to chronyd startup, it waited for a long time again (tried 
this 2 times). This usually only happens because of network problems, 
this time I did not see any network problems here but there might still 
be one somewhere. So this does not have to be because of kernel - just 
mentioned it for completeness.

/proc/interrupts:
           CPU0       
  0:         53    XT-PIC-XT        timer
  1:       3477    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  6:          5    XT-PIC-XT        floppy
  7:          1    XT-PIC-XT        parport0
  8:          1    XT-PIC-XT        rtc
  9:          4    XT-PIC-XT        acpi, Intel 82801BA-ICH2
 10:          0    XT-PIC-XT        uhci_hcd:usb2
 11:      49627    XT-PIC-XT        uhci_hcd:usb1, eth0, r128@pci:0000:02:00.0
 12:       8825    XT-PIC-XT        i8042
 14:      20284    XT-PIC-XT        libata
 15:      11801    XT-PIC-XT        libata
NMI:        206 
LOC:      91773 
ERR:          0
MIS:          0

lspci:
00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82815 815 Chipset AGP Bridge (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 02)
00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC) (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 (rev 02)
00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB (Hub #1) (rev 02)
00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus (rev 02)
00:1f.4 USB Controller: Intel Corporation 82801BA/BAM USB (Hub #2) (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97 Audio (rev 02)
01:08.0 Ethernet controller: Intel Corporation 82801BA/BAM/CA/CAM Ethernet Controller (rev 01)
02:00.0 VGA compatible controller: ATI Technologies Inc Rage 128 RF/SG AGP

cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Celeron (Coppermine)
stepping	: 10
cpu MHz		: 897.152
cache size	: 128 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1795.59
clflush size	: 32



dmesg:
Linux version 2.6.22-rc6 (mroos@rhn) (gcc version 4.1.3 20070601 (prerelease) (Debian 4.1.2-12)) #392 PREEMPT Mon Jun 25 10:02:02 EEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffc0000 (usable)
 BIOS-e820: 000000001ffc0000 - 000000001fff8000 (ACPI data)
 BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Entering add_active_range(0, 0, 131008) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131008
early_node_map[1] active PFN ranges
    0:        0 ->   131008
On node 0 totalpages: 131008
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125921 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FF980, 0014 (r0 AMI   )
ACPI: RSDT 1FFF0000, 0028 (r1 D815EA D815EEA2 20021106 MSFT     1011)
ACPI: FACP 1FFF1000, 0074 (r1 D815EA EA81510A 20021106 MSFT     1011)
ACPI: DSDT 1FFE0000, 30E4 (r1 D815E2 EA81520A       23 MSFT  100000B)
ACPI: FACS 1FFF8000, 0040
ACPI: PM-Timer IO Port: 0x408
Allocating PCI resources starting at 30000000 (gap: 20000000:dfb80000)
Built 1 zonelists.  Total pages: 129985
Kernel command line: root=/dev/sda3 ro nmi_watchdog=1 lapic
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c040a000 soft=c0409000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 897.152 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515648k/524032k available (1914k kernel code, 7952k reserved, 994k data, 172k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffc0000   ( 511 MB)
      .init : 0xc03d9000 - 0xc0404000   ( 172 kB)
      .data : 0xc02de9bb - 0xc03d74c4   ( 994 kB)
      .text : 0xc0100000 - 0xc02de9bb   (1914 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1795.59 BogoMIPS (lpj=3591181)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 128K
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel Celeron (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Firmware left 0000:01:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0c: iomem range 0x100000-0x1fffffff could not be reserved
pnp: 00:0c: iomem range 0x0-0x0 could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: ff900000-ff9fffff
  PREFETCH window: eea00000-f6afffff
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: ff800000-ff8fffff
  PREFETCH window: ee900000-ee9fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:02:00.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PBTN]
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel i815 Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
[drm] Initialized drm 1.1.0 20060810
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
parport0: Printer, Hewlett-Packard HP LaserJet 1100
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNKE] -> GSI 11 (level, low) -> IRQ 11
e100: eth0: e100_probe: addr 0xff8ff000, irq 11, MAC addr 00:03:47:A4:64:D5
ata_piix 0000:00:1f.1: version 2.11
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: ATA-6: ST380011A, 3.06, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata1.00: configured for UDMA/100
Switched to high resolution mode on CPU 0
ata2.00: ATAPI: CDU5211, YYS2, max UDMA/33, CDB intr
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            SONY     CDU5211          YYS2 PQ: 0 ANSI: 5
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
input: PC Speaker as /class/input/input3
input: ImExPS/2 Logitech Wheel Mouse as /class/input/input4
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Testing NMI watchdog ... OK.
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 172k freed
Write protecting the kernel text: 1916k
Write protecting the kernel read-only data: 831k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.2 to 64
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: irq 11, io base 0x0000ef40
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.4[C] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1f.4 to 64
uhci_hcd 0000:00:1f.4: UHCI Host Controller
uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1f.4: irq 10, io base 0x0000ef80
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:1f.5 to 64
intel8x0_measure_ac97_clock: measured 55878 usecs
intel8x0: clocking to 41158
Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 across:1004052k
EXT3 FS on sda3, internal journal
NTFS driver 2.1.28 [Flags: R/W MODULE].
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
smsc47m1: Found SMSC LPC47M10x/LPC47M112/LPC47M13x
fuse init (API version 7.8)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
aoe: AoE v32 initialised.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
eth0: no IPv6 routers present
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[drm] Initialized r128 2.5.0 20030725 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
agpgart: Putting AGP V2 device at 0000:02:00.0 into 2x mode

-- 
Meelis Roos (mroos@linux.ee)
