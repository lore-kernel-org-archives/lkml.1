Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXFDQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXFDQxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXFDQxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:53:11 -0400
Received: from dsl-mtryl-66-18-218-115-cgy.nucleus.com ([66.18.218.115]:56910
	"HELO schaus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757077AbXFDQxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:53:09 -0400
Message-ID: <46644372.4080009@schaus.ca>
Date: Mon, 04 Jun 2007 10:53:06 -0600
From: Cameron Schaus <cam@schaus.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Cameron Schaus <cam@schaus.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel assertion (BUG) on 2.6.20-1-2316 FC5
References: <20070531171236.GA23024@schaus.ca>
In-Reply-To: <20070531171236.GA23024@schaus.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cameron Schaus wrote:
> I am seeing the following kernel assertion (BUG) trip whenever I run a
> set of RPM commands.  It is 100% reproducible, and occurs on a machine
> running vmware.
>
> The kernel is a FC5 2.6.20-1-2316 kernel recompiled to disable
> CONFIG_DEBUG_SPINLOCK and CONFIG_DEBUG_SPINLOCK_SLEEP.
>   
I have seen the same BUG on a real machine, running the above kernel.

Can anyone shed any light on why this kernel BUG is being hit?  This 
problem happens frequently on this hardware.  A dmesg will follow the 
kernel BUG report.

Thanks,
Cam

list_del corruption. next->prev should be c1308018, but was 00000001
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:72!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /block/hdc/hdc1/size
Modules linked in: ipt_REDIRECT iptable_nat nf_nat ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables nf_conntrack_ftp nf_conntrack_ipv4
nf_conntrack nfnetlink bridge ipv6 dm_mirror dm_mod video sbs i2c_ec dock
button battery asus_acpi
backlight ac lp parport_pc parport floppy ata_piix libata scsi_mod e100 mii
uhci_hcd ehci_hcd iTCO_wdt iTCO_vendor_support i2c_i810 i2c_algo_bit i2c_i801
i2c_core pcspkr ext3 jbd
CPU:    0
EIP:    0060:[<c04e990e>]    Not tainted VLI
EFLAGS: 00010096   (2.6.20-1.2322wecansmp #1)
EIP is at list_del+0x42/0x5d
eax: 00000048   ebx: 00000001   ecx: 00000086   edx: 00000000
esi: c06c177c   edi: 0000000a   ebp: c06c0680   esp: e0d4cca4
ds: 007b   es: 007b   ss: 0068
Process java (pid: 2368, ti=e0d4c000 task=e25ee3f0 task.ti=e0d4c000)
Stack: c0679633 c1308018 00000001 c1308018 c0455fad 00000000 c1308000 c06c0680
       00000246 c06c0700 00000004 c04567bf 00000001 00000044 f7f27b30 00000001
       00000000 00020050 c06c2b98 00000000 00cf1881 0000001f 00000001 00000000
Call Trace:
 [<c0455fad>] __rmqueue+0x32/0xa2
 [<c04567bf>] get_page_from_freelist+0xfe/0x2a6
 [<c04569c0>] __alloc_pages+0x59/0x29b
 [<c0452686>] find_lock_page+0x1a/0x77
 [<c0453141>] find_or_create_page+0x4f/0x86
 [<c048a55c>] __getblk+0x174/0x277
 [<c047524a>] do_lookup+0x4f/0x140
 [<f890550b>] ext3_getblk+0x114/0x254 [ext3]
 [<f8906390>] ext3_bread+0x19/0x76 [ext3]
 [<f89096d8>] htree_dirblock_to_tree+0x27/0x122 [ext3]
 [<f8909836>] ext3_htree_fill_tree+0x63/0x1ba [ext3]
 [<c047774f>] do_path_lookup+0x172/0x1c2
 [<f8911a06>] ext3_permission+0x0/0xa [ext3]
 [<c04754c5>] permission+0xc8/0xdb
 [<f8902ba3>] ext3_readdir+0x1d4/0x5e9 [ext3]
 [<c04e8ef7>] copy_to_user+0x2d/0x42
 [<c0471b0f>] cp_new_stat64+0xfc/0x10e
 [<c04794dc>] filldir64+0x0/0xc5
 [<c04720e7>] sys_fstat64+0x1e/0x23
 [<c04796bd>] vfs_readdir+0x63/0x8d
 [<c04794dc>] filldir64+0x0/0xc5
 [<c047974a>] sys_getdents64+0x63/0xa5
 [<c0403f34>] syscall_call+0x7/0xb
 =======================
Code: 24 e5 95 67 c0 e8 c6 d4 f3 ff 0f 0b eb fe 8b 10 8b 5a 04 39 c3 74 18 89
5c 24 08 89 44 24 04 c7 04 24 33 96 67 c0 e8 a5 d4 f3 ff <0f> 0b eb fe 89 4a 04
89 11 c7 40 04 00 02 20 00 c7 00 00 01 10
EIP: [<c04e990e>] list_del+0x42/0x5d SS:ESP 0068:e0d4cca4

Dmesg:
Linux version 2.6.20-1.2322wecansmp (root@vegas) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Tue May 29 15:50:29 MDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 00000000000a0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003f6f0000 end: 000000003f7f0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003f7f0000 size: 0000000000003000 end: 000000003f7f3000 type: 4
copy_e820_map() start: 000000003f7f3000 size: 000000000000d000 end: 000000003f800000 type: 3
copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
 BIOS-e820: 000000003f7f0000 - 000000003f7f3000 (ACPI NVS)
 BIOS-e820: 000000003f7f3000 - 000000003f800000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
119MB HIGHMEM available.
896MB LOWMEM available.
Using x86 segment limits to approximate NX protection
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   260080
early_node_map[1] active PFN ranges
    0:        0 ->   260080
DMI 2.2 present.
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
Allocating PCI resources starting at 40000000 (gap: 3f800000:bf400000)
Detected 2791.189 MHz processor.
Built 1 zonelists.  Total pages: 258049
Kernel command line: ro root=LABEL=/ console=ttyS0,9600 console=tty1                     
Found and enabled local APIC!
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0764000 soft=c0744000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1025684k/1040320k available (2165k kernel code, 13932k reserved, 899k data, 236k init, 122816k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0704000 - 0xc073f000   ( 236 kB)
      .data : 0xc061d6e2 - 0xc06fe494   ( 899 kB)
      .text : 0xc0400000 - 0xc061d6e2   (2165 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5584.36 BogoMIPS (lpj=2792183)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Hyper-Threading is disabled
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20060707
ACPI: setting ELCR to 0200 (from 1e20)
CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
SMP motherboard not detected.
Brought up 1 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb230, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
0000:00:1f.1: trying to change BAR2 from 0000 to 0170
0000:00:1f.1: trying to change BAR3 from 0000 to 0374
PCI: Firmware left 0000:01:04.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:01:05.0 e100 interrupts enabled, disabling
PCI: Firmware left 0000:01:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:0b: ioport range 0x400-0x4bf could not be reserved
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: ec000000-edffffff
  PREFETCH window: 40000000-400fffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 903k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1180951380.711:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key FA613C3CC4C4EF16
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Fan [FAN] (on)
ACPI Exception (acpi_processor-0677): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Thermal Zone [THRM] (40 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 845G Chipset.
agpgart: Detected 8060K stolen memory.
agpgart: AGP aperture is 128M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:pio
hdc: SAMSUNG SP0842N, ATA DISK drive
hdc: hw_config=600b
hdc: hw_config=600b
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 512KiB
hdc: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63<6>hdc: hw_config=600b
, UDMA(100)
hdc: cache flushes supported
 hdc: hdc1
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
ACPI: (supports<6>Time: tsc clocksource has been installed.
 S0 S1 S4 S5)
Freeing unused kernel memory: 236k freed
Write protecting the kernel read-only data: 594k
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1180951385.297:2): selinux=0 auid=4294967295
audit(1180973012.561:3): dev=eth1 prom=256 old_prom=0 auid=4294967295
audit(1180973012.652:4): dev=eth0 prom=256 old_prom=0 auid=4294967295
Bridge firewalling registered
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8127 buckets, 65016 max)
audit(1180973015.152:5): dev=bridge prom=256 old_prom=0 auid=4294967295
ip_tables: (C) 2000-2006 Netfilter Core Team


