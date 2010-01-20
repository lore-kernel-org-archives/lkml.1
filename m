Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113Ab0ATPkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab0ATPkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340Ab0ATPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:40:11 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34413 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab0ATPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:40:06 -0500
Date: Wed, 20 Jan 2010 10:40:05 -0500
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
	(which 2.6.26 did not see) on Geode LX/CS5536.
Message-ID: <20100120154005.GB24307@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on upgrading from 2.6.26 to 2.6.32 on our router, and I am
now seeing some strange IRQ errors on boot when the EHCI and OHCI drivers
load for USB.  2.6.26 never complained.  It appears to be working just
fine with both kernels, but the errors are rather concerning to see.
Perhaps I have to fix something in the PCI setup of the system.

Here is the dmesg from booting 2.6.32:

[    0.000000] Linux version 2.6.32-trunk-gx1 (Debian 2.6.32-4RR4) (lennartsorensen@ruggedcom.com) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 Tue Jan 19 17:05:27 EST 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fae6c00 (usable)
[    0.000000]  BIOS-e820: 000000000fae6c00 - 000000000fae8c00 (ACPI data)
[    0.000000]  BIOS-e820: 000000000fae8c00 - 000000000fae9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000000fae9000 - 0000000010000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.1 present.
[    0.000000] last_pfn = 0xfae6 max_arch_pfn = 0x100000
[    0.000000] initial memory mapped : 0 - 00800000
[    0.000000] init_memory_mapping: 0000000000000000-000000000fae6000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 000f800000 page 2M
[    0.000000]  000f800000 - 000fae6000 page 4k
[    0.000000] kernel direct mapping tables up to fae6000 @ 7000-c000
[    0.000000] 250MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fae6000
[    0.000000]   low ram: 0 - 0fae6000
[    0.000000]   node 0 low ram: 00000000 - 0fae6000
[    0.000000]   node 0 bootmap 00001000 - 00002f60
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 000fae6000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00004b1eec]    TEXT DATA BSS ==> [0000100000 - 00004b1eec]
[    0.000000]   #2 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #3 [00004b2000 - 00004b4133]              BRK ==> [00004b2000 - 00004b4133]
[    0.000000]   #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #5 [0000001000 - 0000003000]          BOOTMAP ==> [0000001000 - 0000003000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0000fae6
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0000fae6
[    0.000000] On node 0 totalpages: 64131
[    0.000000] free_area_init_node: node 0, pgdat c040f900, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3965 pages, LIFO batch:0
[    0.000000]   Normal zone: 470 pages used for memmap
[    0.000000]   Normal zone: 59664 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] No local APIC present or hardware disabled
[    0.000000] APIC: disable apic facility
[    0.000000] nr_irqs_gsi: 16
[    0.000000] Allocating PCI resources starting at 10000000 (gap: 10000000:eff00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 63629
[    0.000000] Kernel command line: root=/dev/sda3 ro console=ttyS0,38400 
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 250392k/256920k available (2290k kernel code, 6016k reserved, 865k data, 212k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa5000 - 0xfffff000   ( 360 kB)
[    0.000000]     vmalloc : 0xd02e6000 - 0xfffa3000   ( 764 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfae6000   ( 250 MB)
[    0.000000]       .init : 0xc0415000 - 0xc044a000   ( 212 kB)
[    0.000000]       .data : 0xc033c99d - 0xc0414e88   ( 865 kB)
[    0.000000]       .text : 0xc0100000 - 0xc033c99d   (2290 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c03e6000 soft=c03e7000
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 499.905 MHz processor.
[    0.003009] Calibrating delay loop (skipped), value calculated using timer frequency.. 999.81 BogoMIPS (lpj=499905)
[    0.005061] Mount-cache hash table entries: 512
[    0.007222] CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
[    0.008011] CPU: L2 Cache: 128K (32 bytes/line)
[    0.009031] Performance Events: no PMU driver, software events only.
[    0.011005] CPU: Geode(TM) Integrated Processor by AMD PCS stepping 02
[    0.014010] Checking 'hlt' instruction... OK.
[    0.022593] NET: Registered protocol family 16
[    0.025558] PCI: PCI BIOS revision 2.10 entry at 0xede09, last bus=1
[    0.026006] PCI: Using configuration type 1 for base access
[    0.033309] bio: create slab <bio-0> at 0
[    0.035339] SCSI subsystem initialized
[    0.036097] libata version 3.00 loaded.
[    0.037068] usbcore: registered new interface driver usbfs
[    0.038152] usbcore: registered new interface driver hub
[    0.039170] usbcore: registered new device driver usb
[    0.041077] PCI: Probing PCI hardware
[    0.042008] PCI: Probing PCI hardware (bus 00)
[    0.047859] pci 0000:00:01.1: reg 10 32bit mmio: [0xe0000000-0xe00fffff]
[    0.048325] pci 0000:00:01.1: reg 14 32bit mmio: [0xe0100000-0xe0103fff]
[    0.048772] pci 0000:00:01.1: reg 18 32bit mmio: [0xe0104000-0xe0107fff]
[    0.049219] pci 0000:00:01.1: reg 1c 32bit mmio: [0xe0108000-0xe010bfff]
[    0.049666] pci 0000:00:01.1: reg 20 32bit mmio: [0xe010c000-0xe010ffff]
[    0.052540] pci 0000:00:01.2: reg 10 32bit mmio: [0xe0110000-0xe0113fff]
[    0.056383] pci 0000:00:0d.0: reg 10 io port: [0xf800-0xf8ff]
[    0.056412] pci 0000:00:0d.0: reg 14 32bit mmio: [0xe0114000-0xe01140ff]
[    0.056480] pci 0000:00:0d.0: supports D1 D2
[    0.056499] pci 0000:00:0d.0: PME# supported from D1 D2 D3hot
[    0.057006] pci 0000:00:0d.0: PME# disabled
[    0.059434] pci 0000:00:0f.0: reg 10 io port: [0xf400-0xf407]
[    0.059882] pci 0000:00:0f.0: reg 14 io port: [0xf000-0xf0ff]
[    0.060431] pci 0000:00:0f.0: reg 18 io port: [0xec00-0xec3f]
[    0.060879] pci 0000:00:0f.0: reg 1c io port: [0xe800-0xe81f]
[    0.061326] pci 0000:00:0f.0: reg 20 io port: [0xe400-0xe47f]
[    0.061770] pci 0000:00:0f.0: reg 24 io port: [0x9c40-0x9c7f]
[    0.065863] pci 0000:00:0f.2: reg 20 io port: [0xdc00-0xdc0f]
[    0.068862] pci 0000:00:0f.3: reg 10 io port: [0xd800-0xd87f]
[    0.073448] pci 0000:00:0f.4: reg 10 32bit mmio: [0xe0115000-0xe0115fff]
[    0.078215] pci 0000:00:0f.5: reg 10 32bit mmio: [0xe0116000-0xe0116fff]
[    0.083004] pci 0000:00:0f.6: reg 10 32bit mmio: [0xe0118000-0xe0119fff]
[    0.086206] pci 0000:00:11.0: supports D1 D2
[    0.086224] pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot
[    0.087000] pci 0000:00:11.0: PME# disabled
[    0.088113] pci 0000:01:04.0: reg 10 io port: [0xcc00-0xcc1f]
[    0.089009] pci 0000:01:04.0: reg 14 32bit mmio: [0xe0200000-0xe020001f]
[    0.089068] pci 0000:01:04.0: reg 30 32bit mmio pref: [0xff000000-0xff0fffff]
[    0.089121] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    0.090001] pci 0000:01:04.0: PME# disabled
[    0.092036] pci 0000:01:05.0: reg 10 io port: [0xc800-0xc81f]
[    0.092066] pci 0000:01:05.0: reg 14 32bit mmio: [0xe0200020-0xe020003f]
[    0.092125] pci 0000:01:05.0: reg 30 32bit mmio pref: [0xff000000-0xff0fffff]
[    0.092178] pci 0000:01:05.0: PME# supported from D0 D3hot D3cold
[    0.093000] pci 0000:01:05.0: PME# disabled
[    0.094059] pci 0000:01:06.0: reg 10 io port: [0xc400-0xc41f]
[    0.094090] pci 0000:01:06.0: reg 14 32bit mmio: [0xe0200040-0xe020005f]
[    0.094149] pci 0000:01:06.0: reg 30 32bit mmio pref: [0xff000000-0xff0fffff]
[    0.094202] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    0.095000] pci 0000:01:06.0: PME# disabled
[    0.096063] pci 0000:01:07.0: reg 10 io port: [0xc000-0xc01f]
[    0.096093] pci 0000:01:07.0: reg 14 32bit mmio: [0xe0200060-0xe020007f]
[    0.096152] pci 0000:01:07.0: reg 30 32bit mmio pref: [0xff000000-0xff0fffff]
[    0.096205] pci 0000:01:07.0: PME# supported from D0 D3hot D3cold
[    0.097000] pci 0000:01:07.0: PME# disabled
[    0.098043] pci 0000:01:08.0: reg 10 32bit mmio: [0xe0208000-0xe020ffff]
[    0.098178] pci 0000:00:11.0: bridge io port: [0xc000-0xcfff]
[    0.098203] pci 0000:00:11.0: bridge 32bit mmio: [0xe0200000-0xe02fffff]
[    0.098232] pci 0000:00:11.0: bridge 64bit mmio pref: [0xc0000000-0xc03fffff]
[    0.102066] pci 0000:00:0f.0: default IRQ router [1022:2090]
[    0.106541] Switching to clocksource tsc
[    0.113836] pci 0000:01:04.0: BAR 6: no parent found for of device [0xff000000-0xff0fffff]
[    0.138667] pci 0000:01:05.0: BAR 6: no parent found for of device [0xff000000-0xff0fffff]
[    0.163455] pci 0000:01:06.0: BAR 6: no parent found for of device [0xff000000-0xff0fffff]
[    0.188231] pci 0000:01:07.0: BAR 6: no parent found for of device [0xff000000-0xff0fffff]
[    0.213052] pci 0000:00:11.0: PCI bridge, secondary bus 0000:01
[    0.230809] pci 0000:00:11.0:   IO window: 0xc000-0xcfff
[    0.246748] pci 0000:00:11.0:   MEM window: 0xe0200000-0xe02fffff
[    0.265025] pci 0000:00:11.0:   PREFETCH window: 0x000000c0000000-0x000000c03fffff
[    0.287742] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.287765] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.287789] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.287812] pci_bus 0000:01: resource 1 mem: [0xe0200000-0xe02fffff]
[    0.287837] pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xc03fffff]
[    0.288010] NET: Registered protocol family 2
[    0.301604] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.323998] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.345350] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[    0.364802] TCP: Hash tables configured (established 8192 bind 8192)
[    0.383854] TCP reno registered
[    0.393550] NET: Registered protocol family 1
[    0.407870] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.431494] scx200: NatSemi SCx200 Driver
[    0.444207] audit: initializing netlink socket (disabled)
[    0.460452] type=2000 audit(1263941917.460:1): initialized
[    0.494338] msgmni has been set to 489
[    0.506469] alg: No test for stdrng (krng)
[    0.518820] io scheduler noop registered
[    0.530601] io scheduler deadline registered (default)
[    0.546964] AMD Geode RNG detected
[    0.557369] Serial: 8250/16550 driver, 36 ports, IRQ sharing enabled
[    0.576716] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    0.595571] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.614060] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[    0.639598] pata_cs5536 0000:00:0f.2: setting latency timer to 64
[    0.639925] scsi0 : pata_cs5536
[    0.649786] scsi1 : pata_cs5536
[    0.659466] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xdc00 irq 14
[    0.680362] ata2: DUMMY
[    0.689752] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.709928] ehci_hcd 0000:00:0f.5: setting latency timer to 64
[    0.710048] ehci_hcd 0000:00:0f.5: EHCI Host Controller
[    0.725795] ehci_hcd 0000:00:0f.5: new USB bus registered, assigned bus number 1
[    1.662227] irq 5: nobody cared (try booting with the "irqpoll" option)
[    1.662321] Pid: 1, comm: swapper Not tainted 2.6.32-trunk-gx1 #1
[    1.662321] Call Trace:
[    1.662321]  [<c033a2c6>] ? printk+0x18/0x1a
[    1.662321]  [<c0160757>] __report_bad_irq+0x27/0x90
[    1.662321]  [<c015f2a8>] ? handle_IRQ_event+0x58/0x140
[    1.662321]  [<c016091e>] note_interrupt+0x15e/0x1a0
[    1.662321]  [<c0161110>] ? handle_level_irq+0x0/0xc0
[    1.662321]  [<c016119b>] handle_level_irq+0x8b/0xc0
[    1.662321]  <IRQ>  [<c01047c9>] ? do_IRQ+0x39/0xb0
[    1.662321]  [<c0122fcf>] ? wake_up_process+0xf/0x20
[    1.662321]  [<c01327e8>] ? process_timeout+0x8/0x10
[    1.662321]  [<c01033c9>] ? common_interrupt+0x29/0x30
[    1.662321]  [<c012b605>] ? __do_softirq+0x35/0x150
[    1.662321]  [<c012b5d0>] ? __do_softirq+0x0/0x150
[    1.662321]  <IRQ>  [<c012b4b5>] ? irq_exit+0x65/0x90
[    1.662321]  [<c01047d2>] ? do_IRQ+0x42/0xb0
[    1.662321]  [<c01033c9>] ? common_interrupt+0x29/0x30
[    1.662321]  [<c016007b>] ? __setup_irq+0x25b/0x2c0
[    1.662321]  [<c015ff37>] ? __setup_irq+0x117/0x2c0
[    1.662321]  [<c016016d>] ? request_threaded_irq+0x8d/0x190
[    1.662321]  [<c0295bb0>] ? usb_hcd_irq+0x0/0x70
[    1.662321]  [<c0160204>] ? request_threaded_irq+0x124/0x190
[    1.662321]  [<c0296558>] ? usb_add_hcd+0x238/0x5f0
[    1.662321]  [<c02b4cfd>] ? pcibios_set_master+0x7d/0xa0
[    1.662321]  [<c02a2c2a>] ? usb_hcd_pci_probe+0x14a/0x2e0
[    1.662321]  [<c024d34e>] ? local_pci_probe+0xe/0x10
[    1.662321]  [<c024d4b0>] ? pci_device_probe+0x60/0x80
[    1.662321]  [<c02679a2>] ? driver_probe_device+0x62/0x160
[    1.662321]  [<c024d32d>] ? pci_match_device+0x9d/0xb0
[    1.662321]  [<c0267b21>] ? __driver_attach+0x81/0x90
[    1.662321]  [<c026722b>] ? bus_for_each_dev+0x5b/0x80
[    1.662321]  [<c024d3f0>] ? pci_device_remove+0x0/0x40
[    1.662321]  [<c0267859>] ? driver_attach+0x19/0x20
[    1.662321]  [<c0267aa0>] ? __driver_attach+0x0/0x90
[    1.662321]  [<c0266b87>] ? bus_add_driver+0x1e7/0x2b0
[    1.662321]  [<c024d3f0>] ? pci_device_remove+0x0/0x40
[    1.662321]  [<c0267da5>] ? driver_register+0x75/0x160
[    1.662321]  [<c02c7d59>] ? netdev_boot_base+0x59/0x80
[    1.662321]  [<c024d6a9>] ? __pci_register_driver+0x39/0xb0
[    1.662321]  [<c042be32>] ? ehci_hcd_init+0x0/0x6f
[    1.662321]  [<c042be92>] ? ehci_hcd_init+0x60/0x6f
[    1.662321]  [<c0101023>] ? do_one_initcall+0x23/0x1a0
[    1.662321]  [<c0415245>] ? kernel_init+0xae/0x105
[    1.662321]  [<c0415197>] ? kernel_init+0x0/0x105
[    1.662321]  [<c0103597>] ? kernel_thread_helper+0x7/0x10
[    1.662321] handlers:
[    1.662321] [<c0295bb0>] (usb_hcd_irq+0x0/0x70)
[    1.662321] Disabling IRQ #5
[    2.386332] ehci_hcd 0000:00:0f.5: irq 5, io mem 0xe0116000
[    2.406834] ata1.00: CFA: SG9CF1GSME4I, 20071016, max UDMA/100
[    2.424328] ata1.00: 1989792 sectors, multi 0: LBA 
[    2.439061] ata1.00: limited to UDMA/33 due to 40-wire cable
[    2.456942] ehci_hcd 0000:00:0f.5: USB 0.0 started, EHCI 1.00
[    2.474750] usb usb1: configuration #1 chosen from 1 choice
[    2.491879] hub 1-0:1.0: USB hub found
[    2.503160] hub 1-0:1.0: 4 ports detected
[    2.515972] ata1.00: configured for UDMA/33
[    2.528857] scsi 0:0:0:0: Direct-Access     ATA      SG9CF1GSME4I     2007 PQ: 0 ANSI: 5
[    2.553415] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.572557] ohci_hcd 0000:00:0f.4: setting latency timer to 64
[    2.572678] ohci_hcd 0000:00:0f.4: OHCI Host Controller
[    2.588383] ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 2
[    3.615449] irq 5: nobody cared (try booting with the "irqpoll" option)
[    3.616013] Pid: 1, comm: swapper Not tainted 2.6.32-trunk-gx1 #1
[    3.616013] Call Trace:
[    3.616013]  [<c033a2c6>] ? printk+0x18/0x1a
[    3.616013]  [<c0160757>] __report_bad_irq+0x27/0x90
[    3.616013]  [<c015f2a8>] ? handle_IRQ_event+0x58/0x140
[    3.616013]  [<c016091e>] note_interrupt+0x15e/0x1a0
[    3.616013]  [<c0161110>] ? handle_level_irq+0x0/0xc0
[    3.616013]  [<c016119b>] handle_level_irq+0x8b/0xc0
[    3.616013]  <IRQ>  [<c01047c9>] ? do_IRQ+0x39/0xb0
[    3.616013]  [<c0140a49>] ? hrtimer_run_pending+0x29/0xa0
[    3.616013]  [<c01033c9>] ? common_interrupt+0x29/0x30
[    3.616013]  [<c012b605>] ? __do_softirq+0x35/0x150
[    3.616013]  [<c012b5d0>] ? __do_softirq+0x0/0x150
[    3.616013]  <IRQ>  [<c012b4b5>] ? irq_exit+0x65/0x90
[    3.616013]  [<c01047d2>] ? do_IRQ+0x42/0xb0
[    3.616013]  [<c01033c9>] ? common_interrupt+0x29/0x30
[    3.616013]  [<c015007b>] ? ftrace_raw_event_module_put+0x1b/0xd0
[    3.616013]  [<c0240000>] ? string+0xd0/0xe0
[    3.616013]  [<c015ff37>] ? __setup_irq+0x117/0x2c0
[    3.616013]  [<c016016d>] ? request_threaded_irq+0x8d/0x190
[    3.616013]  [<c0295bb0>] ? usb_hcd_irq+0x0/0x70
[    3.616013]  [<c0160204>] ? request_threaded_irq+0x124/0x190
[    3.616013]  [<c0296558>] ? usb_add_hcd+0x238/0x5f0
[    3.616013]  [<c02b4cfd>] ? pcibios_set_master+0x7d/0xa0
[    3.616013]  [<c02a2c2a>] ? usb_hcd_pci_probe+0x14a/0x2e0
[    3.616013]  [<c024d34e>] ? local_pci_probe+0xe/0x10
[    3.616013]  [<c024d4b0>] ? pci_device_probe+0x60/0x80
[    3.616013]  [<c02679a2>] ? driver_probe_device+0x62/0x160
[    3.616013]  [<c024d32d>] ? pci_match_device+0x9d/0xb0
[    3.616013]  [<c0267b21>] ? __driver_attach+0x81/0x90
[    3.616013]  [<c026722b>] ? bus_for_each_dev+0x5b/0x80
[    3.616013]  [<c024d3f0>] ? pci_device_remove+0x0/0x40
[    3.616013]  [<c0267859>] ? driver_attach+0x19/0x20
[    3.616013]  [<c0267aa0>] ? __driver_attach+0x0/0x90
[    3.616013]  [<c0266b87>] ? bus_add_driver+0x1e7/0x2b0
[    3.616013]  [<c024d3f0>] ? pci_device_remove+0x0/0x40
[    3.616013]  [<c0267da5>] ? driver_register+0x75/0x160
[    3.616013]  [<c01ecc23>] ? sysfs_add_file+0x13/0x20
[    3.616013]  [<c024d6a9>] ? __pci_register_driver+0x39/0xb0
[    3.616013]  [<c042bea1>] ? ohci_hcd_mod_init+0x0/0x53
[    3.616013]  [<c042bee5>] ? ohci_hcd_mod_init+0x44/0x53
[    3.616013]  [<c0101023>] ? do_one_initcall+0x23/0x1a0
[    3.616013]  [<c0415245>] ? kernel_init+0xae/0x105
[    3.616013]  [<c0415197>] ? kernel_init+0x0/0x105
[    3.616013]  [<c0103597>] ? kernel_thread_helper+0x7/0x10
[    3.616013] handlers:
[    3.616013] [<c0295bb0>] (usb_hcd_irq+0x0/0x70)
[    3.616013] [<c0295bb0>] (usb_hcd_irq+0x0/0x70)
[    3.616013] Disabling IRQ #5
[    4.357580] Clocksource tsc unstable (delta = 942844741 ns)
[    4.374367] ohci_hcd 0000:00:0f.4: irq 5, io mem 0xe0115000
[    4.391282] Switching to clocksource pit
[    4.403779] sd 0:0:0:0: [sda] 1989792 512-byte logical blocks: (1.01 GB/971 MiB)
[    4.404145] sd 0:0:0:0: [sda] Write Protect is off
[    4.405549] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.405651] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.406534]  sda: sda1 sda2 sda3
[    4.413570] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.485425] usb usb2: configuration #1 chosen from 1 choice
[    4.486443] hub 2-0:1.0: USB hub found
[    4.487760] hub 2-0:1.0: 4 ports detected
[    4.489189] i2c /dev entries driver
[    4.493997] TCP cubic registered
[    4.495706] Using IPI Shortcut mode
[    4.504397] kjournald starting.  Commit interval 5 seconds
[    4.505936] EXT3-fs: mounted filesystem with ordered data mode.
[    4.507733] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    4.508633] Freeing unused kernel memory: 212k freed
[    4.603932] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    4.997985] usb 1-3: configuration #1 chosen from 1 choice
[    7.059347] cs5535_gpio: base=0xf000 mask=0xb00fc66 major=254
[    7.157060] 8139too Fast Ethernet driver 0.9.28
[    7.386860] Initializing USB Mass Storage driver...
[    7.527547] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    7.528663] rtc0: alarms up to one day, 114 bytes nvram
[    7.653436] scsi2 : SCSI emulation for USB Mass Storage devices
[    7.658523] usbcore: registered new interface driver usb-storage
[    7.659566] USB Mass Storage support registered.
[    7.661619] usb-storage: device found at 2
[    7.661636] usb-storage: waiting for device to settle before scanning
[    8.008151] geode-aes: GEODE AES engine enabled.
[    8.011292] eth0: RealTek RTL8139 at 0xd03a4000, 00:01:c0:02:7e:df, IRQ 10
[    8.186887] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    8.188395] pcnet32: PCnet/FAST+ 79C972 at 0xcc00, 00:0a:dc:10:a9:28
[    8.191060]     tx_start_pt(0x0c00):~220 bytes, BCR18(98e0):BurstWrEn BurstRdEn DWordIO NoUFlow 
[    8.197945]     SRAMSIZE=0x1700, SRAM_BND=0x0800, assigned IRQ 11.
[    8.201460] pcnet32: Found PHY 0022:1613 at address 0.
[    8.204284] pcnet32: Found PHY 0022:1613 at address 30.
[    8.204985] pcnet32: Using PHY at address 30.  Ignoring extra PHY addresses.
[    8.208145] pcnet32: PCnet/FAST+ 79C972 at 0xc800, 00:0a:dc:10:a9:29
[    8.209811]     tx_start_pt(0x0c00):~220 bytes, BCR18(98e0):BurstWrEn BurstRdEn DWordIO NoUFlow 
[    8.216696]     SRAMSIZE=0x1700, SRAM_BND=0x0800, assigned IRQ 10.
[    8.220103] pcnet32: Found PHY 0022:1613 at address 0.
[    8.221902] pcnet32: Found PHY 0022:1613 at address 30.
[    8.222605] pcnet32: Using PHY at address 30.  Ignoring extra PHY addresses.
[    8.225796] pcnet32: PCnet/FAST+ 79C972 at 0xc400, 00:0a:dc:10:a9:2a
[    8.227458]     tx_start_pt(0x0c00):~220 bytes, BCR18(98e0):BurstWrEn BurstRdEn DWordIO NoUFlow 
[    8.234341]     SRAMSIZE=0x1700, SRAM_BND=0x0800, assigned IRQ 11.
[    8.237752] pcnet32: Found PHY 0022:1613 at address 0.
[    8.240604] pcnet32: Found PHY 0022:1613 at address 30.
[    8.242339] pcnet32: Using PHY at address 30.  Ignoring extra PHY addresses.
[    8.245627] pcnet32: PCnet/FAST+ 79C972 at 0xc000, 00:0a:dc:10:a9:2b
[    8.248323]     tx_start_pt(0x0c00):~220 bytes, BCR18(98e0):BurstWrEn BurstRdEn DWordIO NoUFlow 
[    8.256197]     SRAMSIZE=0x1700, SRAM_BND=0x0800, assigned IRQ 10.
[    8.258607] pcnet32: Found PHY 0022:1613 at address 0.
[    8.261469] pcnet32: Found PHY 0022:1613 at address 30.
[    8.263186] pcnet32: Using PHY at address 30.  Ignoring extra PHY addresses.
[    8.265506] pcnet32: 4 cards_found.
[    8.267005] Rate limiting to 80% system cpu usage per 1000 mSec interval
[   10.618060] EXT3 FS on sda3, internal journal
[   12.715812] scsi 2:0:0:0: Direct-Access     ITE TECH  PEN DRIVE Flash 2.15 PQ: 0 ANSI: 2
[   12.721480] usb-storage: device scan complete
[   12.769754] sd 2:0:0:0: [sdb] 1023488 512-byte logical blocks: (524 MB/499 MiB)
[   12.793682] sd 2:0:0:0: [sdb] Write Protect is off
[   12.795083] sd 2:0:0:0: [sdb] Mode Sense: 07 00 00 00
[   12.795102] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   13.127678] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   13.128989]  sdb: sdb1
[   13.205707] sdb: p1 size 1031121 exceeds device capacity, limited to end of disk
[   13.503634] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   13.504955] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   13.565610] IRQ 10/geode-mfgpt: IRQF_DISABLED is not guaranteed on shared IRQs
[   13.567331] geode-mfgpt: 4 timers available.
[   13.599392] mfgpt_wdt: AMD MFGPT Watchdog Driver
[   13.599418] geode-mfgpt: Timer 2 has been setup.
[   13.600408] mfgpt_wdt: timer margin 60 seconds
[   13.600894] mfgpt_wdt: enabling watchdog timer
[   13.670610] w83627hf: Found W83627HF chip at 0x290
[   13.897222] parport0: PC-style at 0x378 [PCSPP,TRISTATE,EPP]
[   13.902690] parport0: irq 0 detected
[   14.251319] ppdev: user-space parallel port driver
[   14.310715] 8139too Fast Ethernet driver 0.9.28
[   14.315054] eth0: RealTek RTL8139 at 0xd0478000, 00:01:c0:02:7e:df, IRQ 10
[   14.538940] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   14.540324] All bugs added by David S. Miller <davem@redhat.com>
[   14.718709] lm75 0-0048: hwmon1: sensor 'lm75'
[   15.457036] NET: Registered protocol family 10
[   15.460895] lo: Disabled Privacy Extensions
[   15.924424] spurious 8259A interrupt: IRQ7.
[   17.396241] lpcfpgadrv: lpc FPGA at 0x500
[   17.397733] lpcfpgadrv: lpc FPGA Signature: ffff
[   24.770932] NET: Registered protocol family 15
[   24.863558] alg: No test for cipher_null (cipher_null-generic)
[   24.864216] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   24.865084] alg: No test for digest_null (digest_null-generic)
[   24.866676] alg: No test for compress_null (compress_null-generic)
[   28.584914] mfgpt_wdt: timer margin 60 seconds
[   28.585457] mfgpt_wdt: enabling watchdog timer
[   34.181661] IPv4 FIB: Using LC-trie version 0.409
[   34.488321] eth1: link down
[   34.488842] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   35.036235] eth2: link down
[   35.037373] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   36.429951] GRE over IPv4 tunneling driver
[   36.487211] eth1: link up, 100Mbps, full-duplex
[   36.489100] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   43.124670] warning: `zebra' uses 32-bit capabilities (legacy support in use)

So the only devices on IRQ5 are the USB controllers, unless there is
some junk on the LPC bus generating an IRQ 5 (if there is I can certainly
mask that).

I am also puzzled by the BAR6 messages for the 4 AMD 79C972 (pcnet32)
chips.  Is something PCI setup missing here?  Given the BIOS is total
shit on this CPU module, I wouldn't be surprised, and I already have to
fixup IRQ assignments and PCI bridge settings in the bootloader to make
the system sane due to the failures of the BIOS.  Perhaps I am missing
some settings in the fixup.

Everything seems to be working, but I would like to fix whatever is
causing these messages.

Here is an lspci -v dump in case that is helpful:

00:01.0 Host bridge: Advanced Micro Devices [AMD] CS5536 [Geode companion] Host Bridge (rev 31)
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] Host Bridge
	Flags: bus master, 66MHz, medium devsel, latency 248

00:01.1 VGA compatible controller: Advanced Micro Devices [AMD] Geode LX Video (prog-if 00 [VGA controller])
	Subsystem: Advanced Micro Devices [AMD] Geode LX Video
	Flags: 66MHz, medium devsel, IRQ 11
	Memory at e0000000 (32-bit, non-prefetchable) [disabled] [size=1M]
	Memory at e0100000 (32-bit, non-prefetchable) [disabled] [size=16K]
	Memory at e0104000 (32-bit, non-prefetchable) [disabled] [size=16K]
	Memory at e0108000 (32-bit, non-prefetchable) [disabled] [size=16K]
	Memory at e010c000 (32-bit, non-prefetchable) [disabled] [size=16K]

00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD] Geode LX AES Security Block
	Subsystem: Advanced Micro Devices [AMD] Geode LX AES Security Block
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 11
	Memory at e0110000 (32-bit, non-prefetchable) [size=16K]
	Kernel driver in use: Geode LX AES
	Kernel modules: geode-aes

00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Flags: medium devsel, IRQ 10
	I/O ports at f800 [size=256]
	Memory at e0114000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
	Kernel modules: 8139too

00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode companion] ISA (rev 03)
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] ISA
	Flags: 66MHz, medium devsel
	I/O ports at f400 [size=8]
	I/O ports at f000 [size=256]
	I/O ports at ec00 [size=64]
	I/O ports at e800 [size=32]
	I/O ports at e400 [size=128]
	I/O ports at 9c40 [size=64]
	Kernel modules: cs5535_gpio

00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode companion] IDE (rev 01) (prog-if 80 [Master])
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] IDE
	Flags: bus master, 66MHz, medium devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at dc00 [size=16]
	Kernel driver in use: pata_cs5536

00:0f.3 Multimedia audio controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] Audio (rev 01)
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] Audio
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 10
	I/O ports at d800 [size=128]

00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] OHC (rev 02) (prog-if 10 [OHCI])
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] OHC
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 5
	Memory at e0115000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] EHC (rev 02) (prog-if 20 [EHCI])
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] EHC
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 5
	Memory at e0116000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ehci_hcd

00:0f.6 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] UDC (rev 02) (prog-if fe [USB Device])
	Subsystem: Advanced Micro Devices [AMD] CS5536 [Geode companion] UDC
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 5
	Memory at e0118000 (32-bit, non-prefetchable) [size=8K]

00:11.0 PCI bridge: Hint Corp HiNT HB4 PCI-PCI Bridge (PCI6150) (rev 04) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e0200000-e02fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000c03fffff
	Capabilities: [dc] Power Management version 1
	Capabilities: [e4] CompactPCI hot-swap <?>
	Capabilities: [e8] Vital Product Data <?>

01:04.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at cc00 [size=32]
	Memory at e0200000 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at c0000000 [disabled] [size=1M]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: pcnet32
	Kernel modules: pcnet32

01:05.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
	Flags: bus master, medium devsel, latency 64, IRQ 10
	I/O ports at c800 [size=32]
	Memory at e0200020 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at c0100000 [disabled] [size=1M]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: pcnet32
	Kernel modules: pcnet32

01:06.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at c400 [size=32]
	Memory at e0200040 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at c0200000 [disabled] [size=1M]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: pcnet32
	Kernel modules: pcnet32

01:07.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet32 LANCE] (rev 36)
	Flags: bus master, medium devsel, latency 64, IRQ 10
	I/O ports at c000 [size=32]
	Memory at e0200060 (32-bit, non-prefetchable) [size=32]
	Expansion ROM at c0300000 [disabled] [size=1M]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: pcnet32
	Kernel modules: pcnet32

01:08.0 Network controller: Sangoma Technologies Corp. A200/Remora FXO/FXS Analog AFT card
	Subsystem: Device a111:3413
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at e0208000 (32-bit, non-prefetchable) [size=32K]


-- 
Len Sorensen
