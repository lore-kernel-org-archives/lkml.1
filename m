Return-Path: <linux-kernel-owner+w=401wt.eu-S1763023AbYAQW4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763023AbYAQW4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761957AbYAQWx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:53:56 -0500
Received: from gw.goop.org ([64.81.55.164]:37963 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761915AbYAQWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:53:53 -0500
Message-ID: <478FDC52.5010002@goop.org>
Date: Thu, 17 Jan 2008 14:53:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: Debug warning: early ioremap leak of 2 areas detected.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this when doing a test boot of a current x86 kernel under kvm.

(qemu) Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1877 SMP PREEMPT Thu Jan 17 14:30:30 PST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 0000000030000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
767MB LOWMEM available.
Scan SMP from ffd00000 [00000000] for 1024 bytes.
Scan SMP from ffd00c00 [0009fc00] for 1024 bytes.
Scan SMP from ffd00000 [000f0000] for 65536 bytes.
Scan SMP from ffd00c00 [0009fc00] for 1024 bytes.
NX (Execute Disable) protection: active
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   196592
  HighMem    196592 ->   196592
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   196592
DMI not present or invalid.
ACPI: RSDP 000FAE40, 0014 (r0 QEMU  )
ACPI: RSDT 2FFF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 2FFF002C, 0074 (r2 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 2FFF0100, 0909 (r1   BXPC   BXDSDT        1 INTL 20061109)
ACPI: FACS 2FFF00C0, 0040
ACPI: APIC 2FFF0A10, 0040 (r1 QEMU   QEMUAPIC        1 QEMU        1)
ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
ACPI: Disabling ACPI support
Allocating PCI resources starting at 40000000 (gap: 30000000:cffc0000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e8000
swsusp: Registered nosave memory region: 00000000000e8000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195057
Kernel command line: console=ttyS0 root=/dev/sda1 early_ioremap_debug
Found and enabled local APIC!
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.783 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 774124k/786368k available (2829k kernel code, 11688k reserved, 1066k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff80000 - 0xfffff000   ( 508 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf0800000 - 0xff9fe000   ( 241 MB)
    lowmem  : 0xc0000000 - 0xefff0000   ( 767 MB)
      .init : 0xc04d4000 - 0xc0517000   ( 268 kB)
      .data : 0xc03c3669 - 0xc04cdff8   (1066 kB)
      .text : 0xc0100000 - 0xc03c3669   (2829 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Prune to be done here. max_low_pfn 196592
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 3700.98 BogoMIPS (lpj=7401964)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
x86 PAT enabled: cpu 0, old 0x0, new 0x1040600010406
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 15k freed
CPU0: AMD QEMU Virtual CPU version 0.9.0 stepping 03
SMP motherboard not detected.
Brought up 1 CPUs
net_namespace: 64 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
No dock devices found.
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
PCI: PCI BIOS revision 2.10 entry at 0xfa8b0, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
PCI quirk: region b000-b03f claimed by PIIX4 ACPI
PCI quirk: region b100-b10f claimed by PIIX4 SMB
PCI: Using IRQ router PIIX/ICH [8086/7000] at 0000:00:01.0
Time: tsc clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
Total HugeTLB memory allocated, 0
SGI XFS with no debug enabled
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
PCI: PIIX3: Enabling Passive Release on 0000:00:01.0
Activating ISA DMA hang workarounds.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread EF820000 could not acquire Mutex [1] [20070126]
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
early_ioremap(2fff0a10, 00000040) [1] => Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #1877
 [<c04e3913>] early_ioremap+0x49/0x157
 [<c0117057>] __acpi_map_table+0x2f/0x31
 [<c0279459>] acpi_os_map_memory+0x1a/0x1c
 [<c028b4fc>] acpi_tb_verify_table+0x20/0x4d
 [<c028acea>] acpi_get_table+0x4a/0x91
 [<c04ec303>] acpi_processor_init+0x35/0xcf
 [<c04d44b8>] kernel_init+0x14f/0x2a5
 [<c0107c12>] ? ret_from_fork+0x6/0x1c
 [<c04d4369>] ? kernel_init+0x0/0x2a5
 [<c04d4369>] ? kernel_init+0x0/0x2a5
 [<c01089f3>] kernel_thread_helper+0x7/0x10
 =======================
00000a10 + ffd40000
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
8139too Fast Ethernet driver 0.9.28
8139too 0000:00:03.0: This (id 10ec:8139 rev 20) is an enhanced 8139C+ chip
8139too 0000:00:03.0: Use the "8139cp" driver for improved performance and stability.
PCI: Found IRQ 11 for device 0000:00:03.0
eth0: RealTek RTL8139 at 0xd000, 52:54:00:12:34:56, IRQ 11
Driver 'sd' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
ata1.00: ATA-7: QEMU HARDDISK, 0.9.0, max UDMA/100
ata1.00: 8388608 sectors, multi 16: LBA48 
ata1.00: configured for MWDMA2
ata2.00: ATAPI: QEMU CD-ROM, 0.9.0, max UDMA/100
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.9. PQ: 0 ANSI: 5
usbmon: debugfs is not available
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
/home/jeremy/hg/xen/paravirt/linux/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Debug warning: early ioremap leak of 2 areas detected.
please boot with early_ioremap_debug and report the dmesg.
------------[ cut here ]------------
WARNING: at /home/jeremy/hg/xen/paravirt/linux/arch/x86/mm/ioremap_32.c:346 check_early_ioremap_leak+0x33/0x3d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #1877
 [<c01284f4>] warn_on_slowpath+0x41/0x51
 [<c0128a7c>] ? __call_console_drivers+0x4e/0x5a
 [<c03c23ba>] ? _spin_lock_irqsave+0x27/0x41
 [<c03c26e9>] ? _spin_unlock_irqrestore+0x1b/0x2f
 [<c0128cb4>] ? release_console_sem+0x1a0/0x1a8
 [<c01290d3>] ? vprintk+0x2a0/0x2ee
 [<c01290d3>] ? vprintk+0x2a0/0x2ee
 [<c024848b>] ? __next_cpu+0x15/0x25
 [<c03c23ba>] ? _spin_lock_irqsave+0x27/0x41
 [<c031cbe7>] ? unlock_policy_rwsem_write+0x2c/0x2e
 [<c031cc21>] ? __cpufreq_remove_dev+0x38/0x19a
 [<c0129136>] ? printk+0x15/0x17
 [<c04e36dc>] check_early_ioremap_leak+0x33/0x3d
 [<c04d44b8>] kernel_init+0x14f/0x2a5
 [<c0107c12>] ? ret_from_fork+0x6/0x1c
 [<c04d4369>] ? kernel_init+0x0/0x2a5
 [<c04d4369>] ? kernel_init+0x0/0x2a5
 [<c01089f3>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace fbb24127d6bef602 ]---
Using IPI No-Shortcut mode
registered taskstats version 1
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 268k freed


