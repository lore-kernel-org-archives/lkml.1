Return-Path: <linux-kernel-owner+w=401wt.eu-S970072AbXEHXdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970072AbXEHXdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967977AbXEHXde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:33:34 -0400
Received: from simmts7.bellnexxia.net ([206.47.199.165]:44924 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967944AbXEHXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:33:32 -0400
Message-ID: <464108CC.3060604@gmail.com>
Date: Tue, 08 May 2007 20:33:32 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <4640FE35.2070605@gmail.com> <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 8 May 2007, Kevin Winchester wrote:
>
>   
>> x86_64 UP Athlon64 I get a crash on boot using SLUB.  Switching to SLAB makes
>> it go away.  I don't have a serial console, so the best I have is a digital
>> photo of as many lines as my VGA console was able to get (60 or so).  Is there
>> a better way to capture the oops output so that the full trace canbe seen?
>>
>> http://picasaweb.google.com/kjwinchester/Linux/photo#5061982383505227842
>>     
>
> It fails to create a slab. There should be some of message above what I 
> can see that would indicate what went wrong.
>
> Please try to reboot and specify "slub_debug" as a kernel parameter. If it 
> boots then send us the kernel log output. Must have something to do with 
> how the scsi slab is created in scsi_setup_command_freelist.
>
>   
Here's the dmesg of the slub_debug run, I'll try the patch next:

[    0.000000] Linux version 2.6.21-mm1 (kevin@kevin) (gcc version 4.1.2 
(Gentoo 4.1.2)) #2 PREEMPT Tue May 8 20:13:55 ADT 2007
[    0.000000] Command line: root=/dev/sda3 slub_debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  BIOS-e820: 000000001fef0000 - 000000001fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fef3000 - 000000001ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of 
256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F77D0, 0014 (r0 VIAK8T)
[    0.000000] ACPI: RSDT 1FEF3040, 0034 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: FACP 1FEF30C0, 0074 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: DSDT 1FEF3180, 4F8A (r1 VIAK8T AWRDACPI     1000 
MSFT  100000E)
[    0.000000] ACPI: FACS 1FEF0000, 0040
[    0.000000] ACPI: BOOT 1FEF8180, 0028 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: SSDT 1FEF82C0, 00B5 (r1 PTLTD  POWERNOW        1  
LTP        1)
[    0.000000] ACPI: APIC 1FEF8200, 0068 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of 
256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   130800
[    0.000000] On node 0 totalpages: 130703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1380 pages reserved
[    0.000000]   DMA zone: 2563 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1732 pages used for memmap
[    0.000000]   DMA32 zone: 124972 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 
1ff00000:ded00000)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 127535
[    0.000000] Kernel command line: root=/dev/sda3 slub_debug
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)
[    0.000000] time.c: Detected 1838.876 MHz processor.
[    0.002000] Console: colour VGA+ 80x25
[    0.003000] Dentry cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 6, 262144 
bytes)
[    0.004000] Checking aperture...
[    0.004000] CPU 0: aperture @ e0000000 size 128 MB
[    0.009000] Memory: 508904k/523200k available (3277k kernel code, 
13572k reserved, 1276k data, 192k init)
[    0.009000] SLUB: Genslabs=18, HWalign=64, Order=0-4, MinObjects=16, 
Processors=1, Nodes=1
[    0.070000] Calibrating delay using timer specific routine.. 3680.22 
BogoMIPS (lpj=1840114)
[    0.070000] Mount-cache hash table entries: 256
[    0.070000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.070000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.070000] CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
[    0.070000] ACPI: Core revision 20070126
[    0.096000] Using local APIC timer interrupts.
[    0.096000] result 12769979
[    0.096000] Detected 12.769 MHz APIC timer.
[    0.097068] NET: Registered protocol family 16
[    0.097396] ACPI: bus type pci registered
[    0.097473] PCI: Using configuration type 1
[    0.127304] ACPI: Interpreter enabled
[    0.127378] ACPI: (supports S0 S3 S4 S5)
[    0.127761] ACPI: Using IOAPIC for interrupt routing
[    0.150607] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.151910] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.355844] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
[    0.356922] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[    0.357985] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 6 7 10 11 12)
[    0.358904] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.359872] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.360824] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.361875] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 *10 11 12)
[    0.362722] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[    0.363880] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[    0.364681] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[    0.365481] ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
[    0.366441] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[    0.366843] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.366936] pnp: PnP ACPI init
[    0.367021] ACPI: bus type pnp registered
[    0.376845] pnp: PnP ACPI: found 8 devices
[    0.376916] ACPI: ACPI bus type pnp unregistered
[    0.377352] SCSI subsystem initialized
[    0.377465] libata version 2.20 loaded.
[    0.377631] usbcore: registered new interface driver usbfs
[    0.377814] usbcore: registered new interface driver hub
[    0.378010] usbcore: registered new device driver usb
[    0.378174] PCI: Using ACPI for IRQ routing
[    0.378247] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[    0.378358] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
[    0.378642] agpgart: Detected AGP bridge 0
[    0.382360] agpgart: AGP aperture is 128M @ 0xe0000000
[    0.382603] pnp: 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.382680] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
[    0.382757] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[    0.382834] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
[    0.382924] pnp: 00:02: ioport range 0x4000-0x407f has been reserved
[    0.383000] pnp: 00:02: ioport range 0x5000-0x500f has been reserved
[    0.383332] Time: tsc clocksource has been installed.
[    0.384295] PCI: Bridge: 0000:00:01.0
[    0.384368]   IO window: c000-cfff
[    0.384440]   MEM window: f8000000-f80fffff
[    0.384513]   PREFETCH window: e8000000-f7ffffff
[    0.384595] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.384613] NET: Registered protocol family 2
[    0.393352] IP route cache hash table entries: 4096 (order: 3, 32768 
bytes)
[    0.393504] TCP established hash table entries: 16384 (order: 6, 
262144 bytes)
[    0.393732] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.393881] TCP: Hash tables configured (established 16384 bind 16384)
[    0.393955] TCP reno registered
[    0.396803] Simple Boot Flag at 0x37 set to 0x80
[    0.414156] NTFS driver 2.1.28 [Flags: R/O].
[    0.415118] io scheduler noop registered
[    0.415589] io scheduler cfq registered (default)
[    0.415738] Boot video device is 0000:01:00.0
[    0.415922] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.416187] radeonfb: Found Intel x86 BIOS ROM Image
[    0.416260] radeonfb: Retrieved PLL infos from BIOS
[    0.416336] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=200.00 
Mhz, System=166.00 MHz
[    0.416439] radeonfb: PLL min 20000 max 40000
[    0.492812] i2c-adapter i2c-1: unable to read EDID block.
[    0.611591] i2c-adapter i2c-1: unable to read EDID block.
[    0.730382] i2c-adapter i2c-1: unable to read EDID block.
[    0.849225] i2c-adapter i2c-3: unable to read EDID block.
[    0.968016] i2c-adapter i2c-3: unable to read EDID block.
[    1.086804] i2c-adapter i2c-3: unable to read EDID block.
[    1.339657] radeonfb: Monitor 1 type CRT found
[    1.339728] radeonfb: EDID probed
[    1.339797] radeonfb: Monitor 2 type no found
[    1.340307] radeonfb (0000:01:00.0): ATI Radeon Yd
[    1.340776] input: Power Button (FF) as 
/devices/acpi_system:00/button_power:00/input/input0
[    1.340883] ACPI: Power Button (FF) [PWRF]
[    1.341151] input: Power Button (CM) as 
/devices/acpi_system:00/device:00/PNP0C0C:00/input/input1
[    1.341256] ACPI: Power Button (CM) [PWRB]
[    1.351006] Real Time Clock Driver v1.12ac
[    1.351206] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 
soft_margin=60 sec (nowayout= 0)
[    1.351310] Linux agpgart interface v0.102 (c) Dave Jones
[    1.351528] [drm] Initialized drm 1.1.0 20060810
[    1.351836] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[    1.351915] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 
seconds, margin is 60 seconds).
[    1.352019] Hangcheck: Using get_cycles().
[    1.352090] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing disabled
[    1.353376] loop: module loaded
[    1.353621] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[    1.353925] VIA Networking Velocity Family Gigabit Ethernet Adapter 
Driver Ver. 1.14
[    1.354027] Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
[    1.354100] Copyright (c) 2004 Red Hat Inc.
[    1.354188] ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[    1.355212] eth0: VIA Networking Velocity Family Gigabit Ethernet Adapter
[    1.355288] eth0: Ethernet Address: 00:50:8D:D1:28:BB
[    1.365842] PPP generic driver version 2.4.2
[    1.366088] PPP MPPE Compression module registered
[    1.366168] *** SLUB kmalloc-256: Poison check 
failed@0xffff810001bdecd0 slab 0xffff810001061890
[    1.366273]     offset=3280 flags=0x40000000000040c2 inuse=10 
freelist=0xffff810001bdecd0
[    1.366376]   Bytes b4 0xffff810001bdecc0:  6a 71 fb ff 00 00 00 00 
5a 5a 5a 5a 5a 5a 5a 5a jqûÿ....ZZZZZZZZ
[    1.367129]     Object 0xffff810001bdecd0:  80 b7 b1 01 00 81 ff ff 
6b 6b 6b 6b 6b 6b 6b 6b .·±...ÿÿkkkkkkkk
[    1.367881]     Object 0xffff810001bdece0:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.368632]     Object 0xffff810001bdecf0:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.369384]     Object 0xffff810001bded00:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.370135]     Object 0xffff810001bded10:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.371376]     Object 0xffff810001bded20:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.372128]     Object 0xffff810001bded30:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.372879]     Object 0xffff810001bded40:  6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    1.373631]    Redzone 0xffff810001bdedd0:  bb bb bb bb bb bb bb 
bb                         »»»»»»»»       
[    1.374382] FreePointer 0xffff810001bdedd8 -> 0xffff810001bdee18
[    1.374455] Last alloc: cryptomgr_notify+0x28/0x190 jiffies_ago=0 
cpu=0 pid=1
[    1.374611] Last free : cryptomgr_probe+0x85/0xb0 jiffies_ago=0 cpu=0 
pid=405
[    1.374764]     Filler 0xffff810001bdee10:  5a 5a 5a 5a 5a 5a 5a 
5a                         ZZZZZZZZ       
[    1.375514]
[    1.375514] Call Trace:
[    1.375653]  [<ffffffff80277e63>] object_err+0x113/0x1b0
[    1.375728]  [<ffffffff80278195>] check_object+0x105/0x2d0
[    1.375802]  [<ffffffff802797b4>] slab_alloc+0x484/0x560
[    1.375878]  [<ffffffff80358ec1>] kobject_uevent_env+0xd1/0x540
[    1.375954]  [<ffffffff802798b2>] kmem_cache_zalloc+0x22/0x50
[    1.376029]  [<ffffffff80358ec1>] kobject_uevent_env+0xd1/0x540
[    1.376105]  [<ffffffff802c9e0d>] sysfs_create_dir+0x2d/0x80
[    1.376179]  [<ffffffff803581da>] kobject_get+0x1a/0x30
[    1.376253]  [<ffffffff80358454>] kobject_shadow_add+0xd4/0x220
[    1.376328]  [<ffffffff8035933b>] kobject_uevent+0xb/0x10
[    1.376403]  [<ffffffff8035872e>] kobject_register+0x4e/0x50
[    1.376479]  [<ffffffff803f9cf8>] bus_add_driver+0x88/0x1d0
[    1.376554]  [<ffffffff803fab4a>] driver_register+0x4a/0x80
[    1.376630]  [<ffffffff803674ee>] __pci_register_driver+0x5e/0xb0
[    1.376706]  [<ffffffff80695d41>] tulip_init+0x31/0x40
[    1.376783]  [<ffffffff8067d664>] kernel_init+0xc4/0x2a0
[    1.376857]  [<ffffffff802080aa>] __switch_to+0x2a/0x2d0
[    1.376932]  [<ffffffff8020a5d8>] child_rip+0xa/0x12
[    1.377006]  [<ffffffff8067d5a0>] kernel_init+0x0/0x2a0
[    1.377080]  [<ffffffff8020a5ce>] child_rip+0x0/0x12
[    1.377151]
[    1.377221] @@@ SLUB kmalloc-256: Restoring Poison (0x6b) from 
0xffff810001bdecd0-0xffff810001bdedce
[    1.377326] @@@ SLUB kmalloc-256: Restoring Poison (0xa5) from 
0xffff810001bdedcf-0xffff810001bdedcf
[    1.377430] @@@ SLUB: kmalloc-256 slab 0xffff810001061890. Marking 
all objects used.
[    1.377995] pata_via 0000:00:0f.1: version 0.3.1
[    1.378810] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[    1.378886] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 
20 (level, low) -> IRQ 20
[    1.379581] scsi0 : pata_via
[    1.379826] scsi1 : pata_via
[    1.380030] ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 
0x00000000000103f6 bmdma 0x000000000001e300 irq 14
[    1.380136] ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 
0x0000000000010376 bmdma 0x000000000001e308 irq 15
[    1.834983] ata1.00: ATAPI, max UDMA/33
[    1.835057] ata1.01: ATAPI, max UDMA/33
[    1.991702] ata1.00: configured for UDMA/33
[    2.148426] ata1.01: configured for UDMA/33
[    2.302264] ata2.00: ata_hpa_resize 1: sectors = 156301488, 
hpa_sectors = 156301488
[    2.302366] ata2.00: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
[    2.302441] ata2.00: 156301488 sectors, multi 16: LBA
[    2.305250] ata2.00: ata_hpa_resize 1: sectors = 156301488, 
hpa_sectors = 156301488
[    2.305354] ata2.00: configured for UDMA/100
[    2.306110] scsi 0:0:0:0: CD-ROM            COMPAQ   DVD-ROM DRD8120B 
1.10 PQ: 0 ANSI: 5
[    2.309751] sr0: scsi3-mmc drive: 0x/40x cd/rw xa/form2 cdda tray
[    2.309827] Uniform CD-ROM driver Revision: 3.20
[    2.310066] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.310292] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.310663] scsi 0:0:1:0: CD-ROM            HL-DT-ST CD-RW GCE-8525B  
1.03 PQ: 0 ANSI: 5
[    2.314520] sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
[    2.314762] sr 0:0:1:0: Attached scsi CD-ROM sr1
[    2.314991] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.315204] scsi 1:0:0:0: Direct-Access     ATA      WDC WD800JB-00JJ 
05.0 PQ: 0 ANSI: 5
[    2.315584] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    2.315679] sd 1:0:0:0: [sda] Write Protect is off
[    2.315751] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.315791] sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.315983] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    2.316077] sd 1:0:0:0: [sda] Write Protect is off
[    2.316149] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.316187] sd 1:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.316322]  sda: sda1 sda2 sda3
[    2.324886] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.325179] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    2.325428] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, 
low) -> IRQ 21
[    2.325589] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    2.325805] ehci_hcd 0000:00:10.4: new USB bus registered, assigned 
bus number 1
[    2.325988] ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8120000
[    2.326065] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    2.326260] usb usb1: new device found, idVendor=0000, idProduct=0000
[    2.326334] usb usb1: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.326409] usb usb1: Product: EHCI Host Controller
[    2.326480] usb usb1: Manufacturer: Linux 2.6.21-mm1 ehci_hcd
[    2.326553] usb usb1: SerialNumber: 0000:00:10.4
[    2.327044] usb usb1: configuration #1 chosen from 1 choice
[    2.327262] hub 1-0:1.0: USB hub found
[    2.327345] hub 1-0:1.0: 8 ports detected
[    2.427957] USB Universal Host Controller Interface driver v3.0
[    2.428316] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, 
low) -> IRQ 21
[    2.428466] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    2.428654] uhci_hcd 0000:00:10.0: new USB bus registered, assigned 
bus number 2
[    2.428783] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e400
[    2.428977] usb usb2: new device found, idVendor=0000, idProduct=0000
[    2.429051] usb usb2: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.429125] usb usb2: Product: UHCI Host Controller
[    2.429197] usb usb2: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.429269] usb usb2: SerialNumber: 0000:00:10.0
[    2.429650] usb usb2: configuration #1 chosen from 1 choice
[    2.429858] hub 2-0:1.0: USB hub found
[    2.429939] hub 2-0:1.0: 2 ports detected
[    2.530746] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, 
low) -> IRQ 21
[    2.530894] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    2.531081] uhci_hcd 0000:00:10.1: new USB bus registered, assigned 
bus number 3
[    2.531205] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e500
[    2.531387] usb usb3: new device found, idVendor=0000, idProduct=0000
[    2.531461] usb usb3: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.531535] usb usb3: Product: UHCI Host Controller
[    2.531641] usb usb3: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.531713] usb usb3: SerialNumber: 0000:00:10.1
[    2.532094] usb usb3: configuration #1 chosen from 1 choice
[    2.532308] hub 3-0:1.0: USB hub found
[    2.532390] hub 3-0:1.0: 2 ports detected
[    2.632574] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, 
low) -> IRQ 21
[    2.632721] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    2.632915] uhci_hcd 0000:00:10.2: new USB bus registered, assigned 
bus number 4
[    2.633039] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e600
[    2.633233] usb usb4: new device found, idVendor=0000, idProduct=0000
[    2.633307] usb usb4: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.633381] usb usb4: Product: UHCI Host Controller
[    2.633455] usb usb4: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.633528] usb usb4: SerialNumber: 0000:00:10.2
[    2.633957] usb usb4: configuration #1 chosen from 1 choice
[    2.634171] hub 4-0:1.0: USB hub found
[    2.634251] hub 4-0:1.0: 2 ports detected
[    2.734386] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, 
low) -> IRQ 21
[    2.734533] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    2.734736] uhci_hcd 0000:00:10.3: new USB bus registered, assigned 
bus number 5
[    2.734861] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e700
[    2.735046] usb usb5: new device found, idVendor=0000, idProduct=0000
[    2.735120] usb usb5: new device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.735195] usb usb5: Product: UHCI Host Controller
[    2.735269] usb usb5: Manufacturer: Linux 2.6.21-mm1 uhci_hcd
[    2.735341] usb usb5: SerialNumber: 0000:00:10.3
[    2.735720] usb usb5: configuration #1 chosen from 1 choice
[    2.735939] hub 5-0:1.0: USB hub found
[    2.736019] hub 5-0:1.0: 2 ports detected
[    2.836216] Initializing USB Mass Storage driver...
[    2.942850] usb 2-1: new low speed USB device using uhci_hcd and 
address 2
[    3.112715] usb 2-1: new device found, idVendor=045e, idProduct=00b0
[    3.112789] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[    3.112864] usb 2-1: Product: Microsoft® Digital Media Pro Keyboard
[    3.112937] usb 2-1: Manufacturer: Microsoft
[    3.113318] usb 2-1: configuration #1 chosen from 1 choice
[    3.321189] usb 2-2: new low speed USB device using uhci_hcd and 
address 3
[    3.481073] usb 2-2: new device found, idVendor=046d, idProduct=c00c
[    3.481146] usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
[    3.481221] usb 2-2: Product: USB Mouse
[    3.481291] usb 2-2: Manufacturer: Logitech
[    3.481664] usb 2-2: configuration #1 chosen from 1 choice
[    4.106830] usbcore: registered new interface driver usb-storage
[    4.106904] USB Mass Storage support registered.
[    4.107391] PNP: No PS/2 controller found. Probing ports directly.
[    4.109683] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.109892] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.110210] mice: PS/2 mouse device common for all mice
[    4.110740] i2c /dev entries driver
[    4.112017] w83627hf: Found W83627HF chip at 0x290
[    4.440112] w83627hf w83627hf.656: Enabling temp2, readings might not 
make sense
[    4.440738] w83627hf w83627hf.656: Enabling temp3, readings might not 
make sense
[    4.462425] abituguru: testing bank1 sensor 0
[    4.482547] abituguru:   alarm not raised during volt sensor test
[    4.532969] abituguru:   found temp sensor
[    4.533687] abituguru: testing bank1 sensor 1
[    4.553404] abituguru:   alarm not raised during volt sensor test
[    4.603879] abituguru:   found temp sensor
[    4.604618] abituguru: testing bank1 sensor 3
[    4.625864] abituguru:   found volt sensor
[    4.626594] abituguru: testing bank1 sensor 4
[    4.647805] abituguru:   found volt sensor
[    4.648529] abituguru: testing bank1 sensor 10
[    4.669819] abituguru:   found volt sensor
[    4.670540] abituguru: testing bank1 sensor 8
[    4.691760] abituguru:   found volt sensor
[    4.692428] abituguru: testing bank1 sensor 14
[    4.712674] abituguru:   found volt sensor
[    4.713344] abituguru: testing bank1 sensor 2
[    4.733655] abituguru:   found volt sensor
[    4.734375] abituguru: testing bank1 sensor 9
[    4.755599] abituguru:   found volt sensor
[    4.756266] abituguru: testing bank1 sensor 6
[    4.776567] abituguru:   found volt sensor
[    4.777238] abituguru: testing bank1 sensor 5
[    4.797523] abituguru:   found volt sensor
[    4.798145] abituguru: testing bank1 sensor 11
[    4.818504] abituguru:   found volt sensor
[    4.819238] abituguru: testing bank1 sensor 15
[    4.839925] abituguru:   alarm not raised during volt sensor test
[    4.890394] abituguru:   found temp sensor
[    4.891126] abituguru: testing bank1 sensor 13
[    4.912337] abituguru:   found volt sensor
[    4.912959] abituguru: testing bank1 sensor 7
[    4.933733] abituguru:   alarm not raised during volt sensor test
[    4.983643] abituguru:   alarm not raised during temp sensor test
[    4.984368] abituguru: testing bank1 sensor 12
[    5.004655] abituguru:   alarm not raised during volt sensor test
[    5.054517] abituguru:   alarm not raised during temp sensor test
[    5.054970] abituguru: detecting number of fan sensors
[    5.054973] abituguru:   bank2 sensor 5 does not seem to be a fan 
sensor: the threshold (0) is below the minimum (5)
[    5.054975] abituguru:  found: 5 fan sensors
[    5.054983] abituguru: detecting number of PWM outputs
[    5.054985] abituguru:   pwm channel 3 does not seem to be a pwm 
channel: settings[0] = C9
[    5.054987] abituguru:  found: 3 PWM outputs
[    5.054993] abituguru: found Abit uGuru
[    5.069732] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input2
[    5.069979] input: USB HID v1.11 Keyboard [Microsoft Microsoft® 
Digital Media Pro Keyboard] on usb-0000:00:10.0-1
[    5.098547] input: Microsoft Microsoft® Digital Media Pro Keyboard as 
/devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.1/input/input3
[    5.098808] input: USB HID v1.11 Device [Microsoft Microsoft® Digital 
Media Pro Keyboard] on usb-0000:00:10.0-1
[    5.113573] input: Logitech USB Mouse as 
/devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input4
[    5.113927] input: USB HID v1.10 Mouse [Logitech USB Mouse] on 
usb-0000:00:10.0-2
[    5.114113] usbcore: registered new interface driver usbhid
[    5.114188] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    5.114308] Advanced Linux Sound Architecture Driver Version 
1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[    5.115146] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, 
low) -> IRQ 22
[    5.115434] PCI: Setting latency timer of device 0000:00:11.5 to 64
[    5.630247] ALSA device list:
[    5.630318]   #0: VIA 8237 with ALC658D at 0xd800, irq 22
[    5.630514] oprofile: using NMI interrupt.
[    5.630589] GRE over IPv4 tunneling driver
[    5.630911] TCP cubic registered
[    5.631193] NET: Registered protocol family 1
[    5.631268] NET: Registered protocol family 17
[    5.631344] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ 
processors (version 2.00.00)
[    5.631590] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x6
[    5.631663] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
[    5.668896] kjournald starting.  Commit interval 5 seconds
[    5.668979] EXT3-fs: mounted filesystem with ordered data mode.
[    5.669080] VFS: Mounted root (ext3 filesystem) readonly.
[    5.669203] Freeing unused kernel memory: 192k freed
[    8.343399] EXT3 FS on sda3, internal journal
[    8.615366] Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 
across:1004052k
[   19.798004] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[   19.798018] agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
[   19.798068] agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[   20.007479] Velocity is AUTO mode
[   20.072792] [drm] Setting GART location based on new memory map
[   20.072949] [drm] Loading R200 Microcode
[   20.073014] [drm] writeback test succeeded in 1 usecs
[   23.324658] eth0: Link autonegation speed 100M bps full duplex

