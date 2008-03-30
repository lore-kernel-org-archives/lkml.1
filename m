Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYC3Wcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYC3Wcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYC3Wci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:32:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19140 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYC3Wcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FxjpI7weHtKdnH3Wzgs6+QjFRT/TSyqp8f3hiU2wwpeZ0Wdx219isnlgnhTaxtRHw52SNOHkL7lgv3ZQXkyE6ZLxMFZJcgioiYk84Nr9FzvDsByeyCd2YJ5AIbvHxKUKnNKMLyiD6Riaj2mx5V4M9MnnJzzixzCLgeb4ScOKOOM=
Date: Mon, 31 Mar 2008 02:32:12 +0400
From: Sergey Dolgov <dolgovs@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
	2.6.25-rc7
Message-ID: <20080330223212.GB8178@slk.laptop>
References: <20080330074927.GA8178@slk.laptop> <Pine.LNX.4.44L0.0803301456560.21506-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803301456560.21506-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 30, 2008 at 02:59:49PM -0400, Alan Stern wrote:
> On Sun, 30 Mar 2008, Sergey Dolgov wrote:
> 
> > Hi!
> > 
> > If I boot Asus Eee PC with 8 Gb Transcend SDHC card inserted into the
> > internal card reader, 2.6.25-rc7 prints the following:
> > 
> >    [    9.914968] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
> >    [   10.248951] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
> >    [   10.249695] sd 2:0:0:0: [sdb] Write Protect is off
> >    [   10.249928] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
> >    [   10.249935] sd 2:0:0:0: [sdb] Assuming drive cache: write through
> >    [   10.256632] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
> >    [   10.257440] sd 2:0:0:0: [sdb] Write Protect is off
> >    [   10.257546] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
> >    [   10.257552] sd 2:0:0:0: [sdb] Assuming drive cache: write through
> >    [   10.257657]  sdb: sdb1 sdb2 sdb3
> >    [   10.259560] sd 2:0:0:0: [sdb] Attached SCSI removable disk
> >    [   10.260489] usb-storage: device scan complete
> >    [   10.380590] sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> >    [   10.380590] sd 2:0:0:0: [sdb] Sense Key : 0x4 [current] 
> >    [   10.380590] sd 2:0:0:0: [sdb] ASC=0x11 ASCQ=0x0
> >    [   10.380590] end_request: I/O error, dev sdb, sector 15660024
> > 
> > As a result, no sdb device is created by udev.
> > 
> > If the card is inserted after the boot, it sometimes works fine (I've
> > tested with "dd if=/dev/sdb of=/dev/null bs=512 skip=15660000"), and
> > sometimes fails in the same way (the same I/O error message, dd
> > hangs).
> > 
> > 2.6.24.4 is fine (no problems at boot, always can dd read the whole
> > card, all 15660032 sectors of it).
> > 
> > The other SD card I've got, 2 Gb, also works ok even with 2.6.25-rc7.
> 
> Can you build both 2.6.24.4 and 2.6.25-rc7 with
> CONFIG_USB_STORAGE_DEBUG enabled, and post the dmesg logs from both
> kernels showing what happens when the SDHC card is probed during boot?
> Comparing the two logs should indicate where the crucial difference 
> lies.

The dmesg output for 2.6.25-rc7 with USB storage debugging enabled is
attached. I hope to produce the same for 2.6.24.4 on Monday.

-- 
Sergey

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.25.8G-dbg"

[    0.000000] Linux version 2.6.25-rc7-storage-dbg (root@slke) (gcc version 4.2.3 (Debian 4.2.3-3)) #2 Mon Mar 31 02:15:20 MSD 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 503MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 128896) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   128896
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   128896
[    0.000000] On node 0 totalpages: 128896
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1F780000, 0034 (r1 A M I  OEMRSDT   1000808 MSFT       97)
[    0.000000] ACPI: FACP 1F780200, 0081 (r1 A M I  OEMFACP   1000808 MSFT       97)
[    0.000000] ACPI: DSDT 1F780400, 5F2B (r1  A0797 A0797000        0 INTL 20051117)
[    0.000000] ACPI: FACS 1F790000, 0040
[    0.000000] ACPI: APIC 1F780390, 0068 (r1 A M I  OEMAPIC   1000808 MSFT       97)
[    0.000000] ACPI: OEMB 1F790040, 0046 (r1 A M I  AMI_OEM   1000808 MSFT       97)
[    0.000000] ACPI: MCFG 1F786330, 003C (r1 A M I  OEMMCFG   1000808 MSFT       97)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127889
[    0.000000] Kernel command line: root=LABEL=root ro 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 630.086 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.010000] Memory: 504820k/515584k available (1999k kernel code, 10172k reserved, 954k data, 256k init, 0k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.010000]     vmalloc : 0xe0000000 - 0xfffb3000   ( 511 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.010000]       .init : 0xc03e6000 - 0xc0426000   ( 256 kB)
[    0.010000]       .data : 0xc02f3c2a - 0xc03e2808   ( 954 kB)
[    0.010000]       .text : 0xc0100000 - 0xc02f3c2a   (1999 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[    0.160004] Calibrating delay using timer specific routine.. 1261.29 BogoMIPS (lpj=6306478)
[    0.160230] Mount-cache hash table entries: 512
[    0.160625] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160768] CPU: L2 cache: 512K
[    0.160859] Intel machine check architecture supported.
[    0.160961] Intel machine check reporting enabled on CPU#0.
[    0.161063] Compat vDSO mapped to ffffe000.
[    0.161161] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.161357] Checking 'hlt' instruction... OK.
[    0.205596] Freeing SMP alternatives: 0k freed
[    0.205694] ACPI: Core revision 20070126
[    0.228125] Parsing all Control Methods:
[    0.228530] Table [DSDT](id 0001) - 841 Objects with 56 Devices 257 Methods 20 Regions
[    0.228742]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.230008] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.230525] ENABLING IO-APIC IRQs
[    0.230842] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.350000] net_namespace: 152 bytes
[    0.350000] Booting paravirtualized kernel on bare hardware
[    0.350000] NET: Registered protocol family 16
[    0.350000] No dock devices found.
[    0.350000] ACPI: bus type pci registered
[    0.350000] PCI: Using configuration type 1
[    0.350000] Setting up standard PCI resources
[    0.363333] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[    0.368950] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 9 Wake, Enabled 0 Runtime GPEs in this block
[    0.369190] ACPI: EC: Look up EC in DSDT
[    0.371443] Completing Region/Field/Buffer/Package initialization:..............................................................................................
[    0.384077] Initialized 19/20 Regions 18/18 Fields 33/34 Buffers 24/26 Packages (850 nodes)
[    0.384289] Initializing Device/Processor/Thermal objects by executing _INI methods:..
[    0.390372] Executed 2 _INI methods requiring 0 _STA executions (examined 60 objects)
[    0.390597] ACPI: Interpreter enabled
[    0.390689] ACPI: (supports S0 S1 S3 S4 S5)
[    0.391041] ACPI: Using IOAPIC for interrupt routing
[    0.417959] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.418073] ACPI: EC: driver started in poll mode
[    0.418495] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.419587] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.419605] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.419745] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.420460] PCI: Transparent bridge - 0000:00:1e.0
[    0.420611] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.421176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.421456] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.421725] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.435912] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.436949] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.437966] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.438979] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.440066] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.441215] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.442352] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.443487] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.444577] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.444760] pnp: PnP ACPI init
[    0.444865] ACPI: bus type pnp registered
[    0.451660] pnp: PnP ACPI: found 13 devices
[    0.451762] ACPI: ACPI bus type pnp unregistered
[    0.452373] SCSI subsystem initialized
[    0.452544] libata version 3.00 loaded.
[    0.453052] PCI: Using ACPI for IRQ routing
[    0.453151] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.454008] hpet clockevent registered
[    0.454124] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.454274] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.454379] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.454482] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.454585] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.454689] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.454795] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.454901] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.455046] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.455152] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.455295] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.455412] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.455528] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.455632] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.455738] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.455843] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.455978] system 00:0c: iomem range 0x0-0x0 could not be reserved
[    0.487095] PCI: Bridge: 0000:00:1c.0
[    0.487191]   IO window: disabled.
[    0.487283]   MEM window: disabled.
[    0.487374]   PREFETCH window: disabled.
[    0.487470] PCI: Bridge: 0000:00:1c.1
[    0.487559]   IO window: disabled.
[    0.487651]   MEM window: 0xfbf00000-0xfbffffff
[    0.487746]   PREFETCH window: disabled.
[    0.487844] PCI: Bridge: 0000:00:1c.2
[    0.487932]   IO window: disabled.
[    0.488027]   MEM window: 0xf8000000-0xfbefffff
[    0.488123]   PREFETCH window: 0x00000000f0000000-0x00000000f6ffffff
[    0.488229] PCI: Bridge: 0000:00:1e.0
[    0.488317]   IO window: disabled.
[    0.488408]   MEM window: disabled.
[    0.488499]   PREFETCH window: disabled.
[    0.488648] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.488834] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.488864] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.490006] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.490037] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.490218] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.490236] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.490264] NET: Registered protocol family 2
[    0.490568] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.491102] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.491497] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.491738] TCP: Hash tables configured (established 16384 bind 16384)
[    0.491841] TCP reno registered
[    0.492298] checking if image is initramfs... it is
[    0.960024] Switched to high resolution mode on CPU 0
[    0.990710] Freeing initrd memory: 2015k freed
[    0.999395] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.999552] io scheduler noop registered
[    0.999644] io scheduler deadline registered (default)
[    0.999756] pci 0000:00:02.0: Boot video device
[    1.000122] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.000172] assign_interrupt_mode Found MSI capability
[    1.000275] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.000395] Allocate Port Service[0000:00:1c.0:pcie02]
[    1.000562] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.000608] assign_interrupt_mode Found MSI capability
[    1.000707] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.000813] Allocate Port Service[0000:00:1c.1:pcie02]
[    1.000972] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.001018] assign_interrupt_mode Found MSI capability
[    1.001117] Allocate Port Service[0000:00:1c.2:pcie00]
[    1.001239] Allocate Port Service[0000:00:1c.2:pcie02]
[    1.074455] Linux agpgart interface v0.103
[    1.074601] agpgart: Detected an Intel 915GM Chipset.
[    1.075138] agpgart: Detected 7932K stolen memory.
[    1.105045] agpgart: AGP aperture is 256M @ 0xd0000000
[    1.105360] [drm] Initialized drm 1.1.0 20060810
[    1.105501] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.105686] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    1.105905] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    1.107580] brd: module loaded
[    1.108480] loop: module loaded
[    1.108588] tun: Universal TUN/TAP device driver, 1.6
[    1.108684] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.108954] Driver 'sd' needs updating - please use bus_type methods
[    1.109171] ata_piix 0000:00:1f.2: version 2.12
[    1.109232] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    1.109416] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.109746] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.109922] scsi0 : ata_piix
[    1.110230] scsi1 : ata_piix
[    1.114779] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.114887] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.463155] ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
[    1.463155] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.463155] ata2.00: limited to UDMA/33 due to 40-wire cable
[    1.502062] ata2.00: configured for UDMA/33
[    1.502062] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.502062] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[    1.502062] sd 1:0:0:0: [sda] Write Protect is off
[    1.502062] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.502062] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.502062] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[    1.502062] sd 1:0:0:0: [sda] Write Protect is off
[    1.502062] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.502062] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.502062]  sda: sda1 sda2
[    1.502304] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.502304] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.527550] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.527653] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.528112] mice: PS/2 mouse device common for all mice
[    1.556643] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.563532] cpuidle: using governor ladder
[    1.563532] cpuidle: using governor menu
[    1.563532] TCP cubic registered
[    1.563532] NET: Registered protocol family 1
[    1.563532] NET: Registered protocol family 17
[    1.563532] Using IPI Shortcut mode
[    1.563532] registered taskstats version 1
[    1.563532] Freeing unused kernel memory: 256k freed
[    1.721802] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.722199] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.722316] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.730278] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.730506] Marking TSC unstable due to: TSC halts in idle.
[    1.738682] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.749426] ACPI: Thermal Zone [TZ00] (56 C)
[    2.513871] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    2.603185] input: SynPS/2 Synaptics TouchPad as /class/input/input1
[    3.511679] usbcore: registered new interface driver usbfs
[    3.511854] usbcore: registered new interface driver hub
[    3.519687] usbcore: registered new device driver usb
[    3.522795] USB Universal Host Controller Interface driver v3.0
[    3.523009] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    3.523203] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    3.523213] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.524033] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    3.524225] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    3.524649] usb usb1: configuration #1 chosen from 1 choice
[    3.524804] hub 1-0:1.0: USB hub found
[    3.524906] hub 1-0:1.0: 2 ports detected
[    3.629716] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.629832] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.629965] usb usb1: Product: UHCI Host Controller
[    3.630060] usb usb1: Manufacturer: Linux 2.6.25-rc7-storage-dbg uhci_hcd
[    3.630163] usb usb1: SerialNumber: 0000:00:1d.0
[    3.630321] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    3.630518] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.630527] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.630677] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    3.630862] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    3.631232] usb usb2: configuration #1 chosen from 1 choice
[    3.631393] hub 2-0:1.0: USB hub found
[    3.631495] hub 2-0:1.0: 2 ports detected
[    3.739600] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.739717] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.739852] usb usb2: Product: UHCI Host Controller
[    3.739946] usb usb2: Manufacturer: Linux 2.6.25-rc7-storage-dbg uhci_hcd
[    3.740049] usb usb2: SerialNumber: 0000:00:1d.1
[    3.740203] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.740396] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.740405] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.740570] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    3.740754] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    3.741125] usb usb3: configuration #1 chosen from 1 choice
[    3.741288] hub 3-0:1.0: USB hub found
[    3.741389] hub 3-0:1.0: 2 ports detected
[    3.849295] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.849406] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.849548] usb usb3: Product: UHCI Host Controller
[    3.849643] usb usb3: Manufacturer: Linux 2.6.25-rc7-storage-dbg uhci_hcd
[    3.849745] usb usb3: SerialNumber: 0000:00:1d.2
[    3.849886] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    3.850084] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    3.850095] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.850246] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    3.850428] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    3.850791] usb usb4: configuration #1 chosen from 1 choice
[    3.850955] hub 4-0:1.0: USB hub found
[    3.851056] hub 4-0:1.0: 2 ports detected
[    3.938943] Clocksource tsc unstable (delta = -216649331 ns)
[    3.959038] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.959143] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.959277] usb usb4: Product: UHCI Host Controller
[    3.959372] usb usb4: Manufacturer: Linux 2.6.25-rc7-storage-dbg uhci_hcd
[    3.959474] usb usb4: SerialNumber: 0000:00:1d.3
[    3.961428] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    3.961639] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.961648] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.961831] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    3.965889] ehci_hcd 0000:00:1d.7: debug port 1
[    3.965989] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    3.966006] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    3.988939] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.989420] usb usb5: configuration #1 chosen from 1 choice
[    3.989583] hub 5-0:1.0: USB hub found
[    3.989692] hub 5-0:1.0: 8 ports detected
[    4.099048] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    4.099164] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.099299] usb usb5: Product: EHCI Host Controller
[    4.099394] usb usb5: Manufacturer: Linux 2.6.25-rc7-storage-dbg ehci_hcd
[    4.099497] usb usb5: SerialNumber: 0000:00:1d.7
[    4.189116] kjournald starting.  Commit interval 5 seconds
[    4.189241] EXT3-fs: mounted filesystem with ordered data mode.
[    4.573048] usb 5-5: new high speed USB device using ehci_hcd and address 2
[    4.725046] usb 5-5: configuration #1 chosen from 1 choice
[    4.728586] usb 5-5: New USB device found, idVendor=0951, idProduct=1606
[    4.728700] usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=4
[    4.728807] usb 5-5: Product: UB6225
[    4.728900] usb 5-5: Manufacturer: ENE
[    4.728991] usb 5-5: SerialNumber: 146030377350
[    5.004515] usb 5-8: new high speed USB device using ehci_hcd and address 3
[    5.156605] usb 5-8: configuration #1 chosen from 1 choice
[    5.157480] usb 5-8: New USB device found, idVendor=eb1a, idProduct=2761
[    5.157590] usb 5-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.167699] usbcore: registered new interface driver libusual
[    5.217631] Initializing USB Mass Storage driver...
[    5.217794] usb-storage: USB Mass Storage device detected
[    5.227852] usb-storage: -- associate_dev
[    5.227864] usb-storage: Vendor: 0x0951, Product: 0x1606, Revision: 0x0100
[    5.227871] usb-storage: Interface Subclass: 0x06, Protocol: 0x50
[    5.227888] usb-storage: Transport: Bulk
[    5.227893] usb-storage: Protocol: Transparent SCSI
[    5.237414] scsi2 : SCSI emulation for USB Mass Storage devices
[    5.237656] usb-storage: *** thread sleeping.
[    5.246113] usbcore: registered new interface driver usb-storage
[    5.246233] USB Mass Storage support registered.
[    5.246554] usb-storage: device found at 2
[    5.246560] usb-storage: waiting for device to settle before scanning
[    6.959069] input: Power Button (FF) as /class/input/input2
[    7.026546] ACPI: Power Button (FF) [PWRF]
[    7.026852] input: Lid Switch as /class/input/input3
[    7.081144] ACPI: Lid Switch [LID]
[    7.081441] input: Sleep Button (CM) as /class/input/input4
[    7.143348] ACPI: Sleep Button (CM) [SLPB]
[    7.143603] input: Power Button (CM) as /class/input/input5
[    7.213152] ACPI: Power Button (CM) [PWRB]
[    7.505795] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    7.506030] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    7.512095] power_supply AC0: uevent
[    7.512104] power_supply AC0: No power supply yet
[    7.512130] power_supply AC0: power_supply_changed
[    7.512151] ACPI: AC Adapter [AC0] (off-line)
[    7.512891] power_supply AC0: power_supply_changed_work
[    7.512900] power_supply AC0: power_supply_update_gen_leds 0
[    7.512924] power_supply AC0: uevent
[    7.512928] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    7.512940] power_supply AC0: Static prop TYPE=Mains
[    7.512947] power_supply AC0: 1 dynamic props
[    7.512954] power_supply AC0: prop ONLINE=0
[    7.942018] power_supply BAT0: uevent
[    7.942029] power_supply BAT0: No power supply yet
[    7.942083] power_supply BAT0: power_supply_changed
[    7.943000] power_supply BAT0: power_supply_changed_work
[    8.208838] ACPI: Battery Slot [BAT0] (battery present)
[    8.209607] input: Video Bus as /class/input/input6
[    8.211689] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    8.303160] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    8.407939] power_supply BAT0: power_supply_update_bat_leds 2
[    8.407973] power_supply BAT0: uevent
[    8.407979] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    8.407994] power_supply BAT0: Static prop TYPE=Battery
[    8.408001] power_supply BAT0: 12 dynamic props
[    8.408008] power_supply BAT0: prop STATUS=Discharging
[    8.408016] power_supply BAT0: prop PRESENT=1
[    8.408025] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    8.408033] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=8400000
[    8.408042] power_supply BAT0: prop VOLTAGE_NOW=7325000
[    8.408050] power_supply BAT0: prop CURRENT_NOW=-1000
[    8.408058] power_supply BAT0: prop CHARGE_FULL_DESIGN=5200000
[    8.408066] power_supply BAT0: prop CHARGE_FULL=100000
[    8.408074] power_supply BAT0: prop CHARGE_NOW=30000
[    8.408081] power_supply BAT0: prop MODEL_NAME=701
[    8.408089] power_supply BAT0: prop MANUFACTURER=ASUS
[    8.408096] power_supply BAT0: prop SERIAL_NUMBER= 
[    9.949215] EXT3 FS on sda2, internal journal
[   10.237060] usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
[   10.237234] usb-storage: GetMaxLUN command result is 1, data is 0
[   10.237346] usb-storage: queuecommand called
[   10.237367] usb-storage: *** thread awakened.
[   10.237374] usb-storage: Command INQUIRY (6 bytes)
[   10.237379] usb-storage:  12 00 00 00 24 00
[   10.237394] usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
[   10.237402] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.242370] usb-storage: Status code 0; transferred 31/31
[   10.242376] usb-storage: -- transfer complete
[   10.242381] usb-storage: Bulk command transfer result=0
[   10.242388] usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
[   10.242474] usb-storage: Status code 0; transferred 36/36
[   10.242479] usb-storage: -- transfer complete
[   10.242483] usb-storage: Bulk data transfer result 0x0
[   10.242488] usb-storage: Attempting to get CSW...
[   10.242493] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.242590] usb-storage: Status code 0; transferred 13/13
[   10.242595] usb-storage: -- transfer complete
[   10.242600] usb-storage: Bulk status result = 0
[   10.242606] usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
[   10.242612] usb-storage: scsi cmd done, result=0x0
[   10.242621] usb-storage: *** thread sleeping.
[   10.242713] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[   10.243050] usb-storage: queuecommand called
[   10.243068] usb-storage: *** thread awakened.
[   10.243075] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.243079] usb-storage:  00 00 00 00 00 00
[   10.243091] usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.243098] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.243235] usb-storage: Status code 0; transferred 31/31
[   10.243240] usb-storage: -- transfer complete
[   10.243245] usb-storage: Bulk command transfer result=0
[   10.243250] usb-storage: Attempting to get CSW...
[   10.243256] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.611486] usb-storage: Status code 0; transferred 13/13
[   10.611498] usb-storage: -- transfer complete
[   10.611503] usb-storage: Bulk status result = 0
[   10.611510] usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x1
[   10.611517] usb-storage: -- transport indicates command failure
[   10.611522] usb-storage: Issuing auto-REQUEST_SENSE
[   10.611534] usb-storage: Bulk Command S 0x43425355 T 0x3 L 18 F 128 Trg 0 LUN 0 CL 6
[   10.611541] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.611593] usb-storage: Status code 0; transferred 31/31
[   10.611598] usb-storage: -- transfer complete
[   10.611602] usb-storage: Bulk command transfer result=0
[   10.611609] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.611844] usb-storage: Status code 0; transferred 18/18
[   10.611849] usb-storage: -- transfer complete
[   10.611854] usb-storage: Bulk data transfer result 0x0
[   10.611859] usb-storage: Attempting to get CSW...
[   10.611864] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.611966] usb-storage: Status code 0; transferred 13/13
[   10.611971] usb-storage: -- transfer complete
[   10.611976] usb-storage: Bulk status result = 0
[   10.611982] usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
[   10.611990] usb-storage: -- Result from auto-sense is 0
[   10.611997] usb-storage: -- code: 0x70, key: 0x6, ASC: 0x28, ASCQ: 0x0
[   10.612003] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.612010] usb-storage: scsi cmd done, result=0x2
[   10.612023] usb-storage: *** thread sleeping.
[   10.612084] usb-storage: queuecommand called
[   10.612098] usb-storage: *** thread awakened.
[   10.612104] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.612109] usb-storage:  00 00 00 00 00 00
[   10.612121] usb-storage: Bulk Command S 0x43425355 T 0x4 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.612128] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.617089] usb-storage: Status code 0; transferred 31/31
[   10.617094] usb-storage: -- transfer complete
[   10.617098] usb-storage: Bulk command transfer result=0
[   10.617103] usb-storage: Attempting to get CSW...
[   10.617108] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.617220] usb-storage: Status code 0; transferred 13/13
[   10.617225] usb-storage: -- transfer complete
[   10.617229] usb-storage: Bulk status result = 0
[   10.617237] usb-storage: Bulk Status S 0x53425355 T 0x4 R 0 Stat 0x0
[   10.617243] usb-storage: scsi cmd done, result=0x0
[   10.617250] usb-storage: *** thread sleeping.
[   10.617287] usb-storage: queuecommand called
[   10.617300] usb-storage: *** thread awakened.
[   10.617306] usb-storage: Command READ_CAPACITY (10 bytes)
[   10.617311] usb-storage:  25 00 00 00 00 00 00 00 00 00
[   10.617325] usb-storage: Bulk Command S 0x43425355 T 0x5 L 8 F 128 Trg 0 LUN 0 CL 10
[   10.617337] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.617470] usb-storage: Status code 0; transferred 31/31
[   10.617474] usb-storage: -- transfer complete
[   10.617479] usb-storage: Bulk command transfer result=0
[   10.617485] usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
[   10.617718] usb-storage: Status code 0; transferred 8/8
[   10.617723] usb-storage: -- transfer complete
[   10.617728] usb-storage: Bulk data transfer result 0x0
[   10.617732] usb-storage: Attempting to get CSW...
[   10.617738] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.617841] usb-storage: Status code 0; transferred 13/13
[   10.617846] usb-storage: -- transfer complete
[   10.617850] usb-storage: Bulk status result = 0
[   10.617856] usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
[   10.617862] usb-storage: scsi cmd done, result=0x0
[   10.617869] usb-storage: *** thread sleeping.
[   10.617898] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   10.618020] usb-storage: queuecommand called
[   10.618036] usb-storage: *** thread awakened.
[   10.618041] usb-storage: Command MODE_SENSE (6 bytes)
[   10.618046] usb-storage:  1a 00 3f 00 c0 00
[   10.618058] usb-storage: Bulk Command S 0x43425355 T 0x6 L 192 F 128 Trg 0 LUN 0 CL 6
[   10.618065] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.618221] usb-storage: Status code 0; transferred 31/31
[   10.618225] usb-storage: -- transfer complete
[   10.618230] usb-storage: Bulk command transfer result=0
[   10.618236] usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
[   10.618472] usb-storage: Status code -121; transferred 4/192
[   10.618477] usb-storage: -- short read transfer
[   10.618481] usb-storage: Bulk data transfer result 0x1
[   10.618486] usb-storage: Attempting to get CSW...
[   10.618491] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.618718] usb-storage: Status code 0; transferred 13/13
[   10.618723] usb-storage: -- transfer complete
[   10.618728] usb-storage: Bulk status result = 0
[   10.618734] usb-storage: Bulk Status S 0x53425355 T 0x6 R 188 Stat 0x0
[   10.618740] usb-storage: scsi cmd done, result=0x0
[   10.618747] usb-storage: *** thread sleeping.
[   10.618774] sd 2:0:0:0: [sdb] Write Protect is off
[   10.618878] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   10.618884] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.619079] usb-storage: queuecommand called
[   10.619098] usb-storage: *** thread awakened.
[   10.619104] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.619109] usb-storage:  00 00 00 00 00 00
[   10.619120] usb-storage: Bulk Command S 0x43425355 T 0x7 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.619127] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.624087] usb-storage: Status code 0; transferred 31/31
[   10.624092] usb-storage: -- transfer complete
[   10.624097] usb-storage: Bulk command transfer result=0
[   10.624102] usb-storage: Attempting to get CSW...
[   10.624107] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.624218] usb-storage: Status code 0; transferred 13/13
[   10.624223] usb-storage: -- transfer complete
[   10.624227] usb-storage: Bulk status result = 0
[   10.624233] usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
[   10.624239] usb-storage: scsi cmd done, result=0x0
[   10.624247] usb-storage: *** thread sleeping.
[   10.624281] usb-storage: queuecommand called
[   10.624295] usb-storage: *** thread awakened.
[   10.624300] usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
[   10.624305] usb-storage:  1e 00 00 00 01 00
[   10.624317] usb-storage: Bulk Command S 0x43425355 T 0x8 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.624323] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.625107] usb-storage: Status code 0; transferred 31/31
[   10.625114] usb-storage: -- transfer complete
[   10.625119] usb-storage: Bulk command transfer result=0
[   10.625124] usb-storage: Attempting to get CSW...
[   10.625129] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.625894] usb-storage: Status code 0; transferred 13/13
[   10.625901] usb-storage: -- transfer complete
[   10.625906] usb-storage: Bulk status result = 0
[   10.625914] usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x1
[   10.625921] usb-storage: -- transport indicates command failure
[   10.625926] usb-storage: Issuing auto-REQUEST_SENSE
[   10.625936] usb-storage: Bulk Command S 0x43425355 T 0x9 L 18 F 128 Trg 0 LUN 0 CL 6
[   10.625943] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.626627] usb-storage: Status code 0; transferred 31/31
[   10.626634] usb-storage: -- transfer complete
[   10.626639] usb-storage: Bulk command transfer result=0
[   10.626646] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.626727] usb-storage: Status code 0; transferred 18/18
[   10.626732] usb-storage: -- transfer complete
[   10.626737] usb-storage: Bulk data transfer result 0x0
[   10.626742] usb-storage: Attempting to get CSW...
[   10.626747] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.626840] usb-storage: Status code 0; transferred 13/13
[   10.626844] usb-storage: -- transfer complete
[   10.626849] usb-storage: Bulk status result = 0
[   10.626855] usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
[   10.626861] usb-storage: -- Result from auto-sense is 0
[   10.626868] usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
[   10.626874] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.626881] usb-storage: scsi cmd done, result=0x2
[   10.626891] usb-storage: *** thread sleeping.
[   10.626963] usb-storage: queuecommand called
[   10.626978] usb-storage: *** thread awakened.
[   10.626984] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.626989] usb-storage:  00 00 00 00 00 00
[   10.627001] usb-storage: Bulk Command S 0x43425355 T 0xa L 0 F 0 Trg 0 LUN 0 CL 6
[   10.627008] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.631966] usb-storage: Status code 0; transferred 31/31
[   10.631971] usb-storage: -- transfer complete
[   10.631976] usb-storage: Bulk command transfer result=0
[   10.631981] usb-storage: Attempting to get CSW...
[   10.631986] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.632090] usb-storage: Status code 0; transferred 13/13
[   10.632094] usb-storage: -- transfer complete
[   10.632099] usb-storage: Bulk status result = 0
[   10.632105] usb-storage: Bulk Status S 0x53425355 T 0xa R 0 Stat 0x0
[   10.632111] usb-storage: scsi cmd done, result=0x0
[   10.632118] usb-storage: *** thread sleeping.
[   10.632160] usb-storage: queuecommand called
[   10.632173] usb-storage: *** thread awakened.
[   10.632179] usb-storage: Command READ_CAPACITY (10 bytes)
[   10.632184] usb-storage:  25 00 00 00 00 00 00 00 00 00
[   10.632199] usb-storage: Bulk Command S 0x43425355 T 0xb L 8 F 128 Trg 0 LUN 0 CL 10
[   10.632213] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.632338] usb-storage: Status code 0; transferred 31/31
[   10.632343] usb-storage: -- transfer complete
[   10.632348] usb-storage: Bulk command transfer result=0
[   10.632354] usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
[   10.632587] usb-storage: Status code 0; transferred 8/8
[   10.632592] usb-storage: -- transfer complete
[   10.632596] usb-storage: Bulk data transfer result 0x0
[   10.632601] usb-storage: Attempting to get CSW...
[   10.632606] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.632710] usb-storage: Status code 0; transferred 13/13
[   10.632715] usb-storage: -- transfer complete
[   10.632720] usb-storage: Bulk status result = 0
[   10.632726] usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
[   10.632732] usb-storage: scsi cmd done, result=0x0
[   10.632740] usb-storage: *** thread sleeping.
[   10.632768] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   10.632892] usb-storage: queuecommand called
[   10.632906] usb-storage: *** thread awakened.
[   10.632912] usb-storage: Command MODE_SENSE (6 bytes)
[   10.632916] usb-storage:  1a 00 3f 00 c0 00
[   10.632929] usb-storage: Bulk Command S 0x43425355 T 0xc L 192 F 128 Trg 0 LUN 0 CL 6
[   10.632936] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.633089] usb-storage: Status code 0; transferred 31/31
[   10.633094] usb-storage: -- transfer complete
[   10.633098] usb-storage: Bulk command transfer result=0
[   10.633104] usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
[   10.633340] usb-storage: Status code -121; transferred 4/192
[   10.633345] usb-storage: -- short read transfer
[   10.633350] usb-storage: Bulk data transfer result 0x1
[   10.633354] usb-storage: Attempting to get CSW...
[   10.633360] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.633586] usb-storage: Status code 0; transferred 13/13
[   10.633591] usb-storage: -- transfer complete
[   10.633595] usb-storage: Bulk status result = 0
[   10.633601] usb-storage: Bulk Status S 0x53425355 T 0xc R 188 Stat 0x0
[   10.633607] usb-storage: scsi cmd done, result=0x0
[   10.633615] usb-storage: *** thread sleeping.
[   10.633641] sd 2:0:0:0: [sdb] Write Protect is off
[   10.633743] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   10.633749] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.633852]  sdb:<7>usb-storage: queuecommand called
[   10.634043] usb-storage: *** thread awakened.
[   10.634048] usb-storage: Command READ_10 (10 bytes)
[   10.634053] usb-storage:  28 00 00 00 00 00 00 00 08 00
[   10.634068] usb-storage: Bulk Command S 0x43425355 T 0xd L 4096 F 128 Trg 0 LUN 0 CL 10
[   10.634075] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.634215] usb-storage: Status code 0; transferred 31/31
[   10.634220] usb-storage: -- transfer complete
[   10.634224] usb-storage: Bulk command transfer result=0
[   10.634231] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   10.635212] usb-storage: Status code 0; transferred 4096/4096
[   10.635217] usb-storage: -- transfer complete
[   10.635222] usb-storage: Bulk data transfer result 0x0
[   10.635227] usb-storage: Attempting to get CSW...
[   10.635232] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.635335] usb-storage: Status code 0; transferred 13/13
[   10.635340] usb-storage: -- transfer complete
[   10.635345] usb-storage: Bulk status result = 0
[   10.635351] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
[   10.635356] usb-storage: scsi cmd done, result=0x0
[   10.635363] usb-storage: *** thread sleeping.
[   10.635396]  sdb1 sdb2
[   10.635775] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   10.636029] usb-storage: queuecommand called
[   10.636050] usb-storage: *** thread awakened.
[   10.636055] usb-storage: Bad target number (1:0)
[   10.636060] usb-storage: scsi cmd done, result=0x40000
[   10.636069] usb-storage: *** thread sleeping.
[   10.636154] usb-storage: queuecommand called
[   10.636170] usb-storage: *** thread awakened.
[   10.636176] usb-storage: Bad target number (2:0)
[   10.636180] usb-storage: scsi cmd done, result=0x40000
[   10.636188] usb-storage: *** thread sleeping.
[   10.636254] usb-storage: queuecommand called
[   10.636272] usb-storage: *** thread awakened.
[   10.636277] usb-storage: Bad target number (3:0)
[   10.636282] usb-storage: scsi cmd done, result=0x40000
[   10.636290] usb-storage: *** thread sleeping.
[   10.636358] usb-storage: queuecommand called
[   10.636375] usb-storage: *** thread awakened.
[   10.636380] usb-storage: Bad target number (4:0)
[   10.636385] usb-storage: scsi cmd done, result=0x40000
[   10.636392] usb-storage: *** thread sleeping.
[   10.636457] usb-storage: queuecommand called
[   10.636474] usb-storage: *** thread awakened.
[   10.636479] usb-storage: Bad target number (5:0)
[   10.636483] usb-storage: scsi cmd done, result=0x40000
[   10.636491] usb-storage: *** thread sleeping.
[   10.636556] usb-storage: queuecommand called
[   10.636573] usb-storage: *** thread awakened.
[   10.636578] usb-storage: Bad target number (6:0)
[   10.636583] usb-storage: scsi cmd done, result=0x40000
[   10.636590] usb-storage: *** thread sleeping.
[   10.636655] usb-storage: queuecommand called
[   10.636671] usb-storage: *** thread awakened.
[   10.636676] usb-storage: Bad target number (7:0)
[   10.636681] usb-storage: scsi cmd done, result=0x40000
[   10.636689] usb-storage: *** thread sleeping.
[   10.636725] usb-storage: device scan complete
[   10.646639] usb-storage: queuecommand called
[   10.646679] usb-storage: *** thread awakened.
[   10.646687] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.646694] usb-storage:  00 00 00 00 00 00
[   10.646708] usb-storage: Bulk Command S 0x43425355 T 0xe L 0 F 0 Trg 0 LUN 0 CL 6
[   10.646715] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.646859] usb-storage: Status code 0; transferred 31/31
[   10.646865] usb-storage: -- transfer complete
[   10.646870] usb-storage: Bulk command transfer result=0
[   10.646875] usb-storage: Attempting to get CSW...
[   10.646880] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.647100] usb-storage: Status code 0; transferred 13/13
[   10.647106] usb-storage: -- transfer complete
[   10.647111] usb-storage: Bulk status result = 0
[   10.647117] usb-storage: Bulk Status S 0x53425355 T 0xe R 0 Stat 0x0
[   10.647124] usb-storage: scsi cmd done, result=0x0
[   10.647133] usb-storage: *** thread sleeping.
[   10.657153] usb-storage: queuecommand called
[   10.657189] usb-storage: *** thread awakened.
[   10.657196] usb-storage: Command INQUIRY (6 bytes)
[   10.657201] usb-storage:  12 00 00 00 fe 00
[   10.657216] usb-storage: Bulk Command S 0x43425355 T 0xf L 254 F 128 Trg 0 LUN 0 CL 6
[   10.657224] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.657357] usb-storage: Status code 0; transferred 31/31
[   10.657363] usb-storage: -- transfer complete
[   10.657368] usb-storage: Bulk command transfer result=0
[   10.657374] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   10.657603] usb-storage: Status code -121; transferred 36/254
[   10.657612] usb-storage: -- short read transfer
[   10.657617] usb-storage: Bulk data transfer result 0x1
[   10.657622] usb-storage: Attempting to get CSW...
[   10.657627] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.657841] usb-storage: Status code 0; transferred 13/13
[   10.657846] usb-storage: -- transfer complete
[   10.657851] usb-storage: Bulk status result = 0
[   10.657858] usb-storage: Bulk Status S 0x53425355 T 0xf R 218 Stat 0x0
[   10.657865] usb-storage: scsi cmd done, result=0x0
[   10.657876] usb-storage: *** thread sleeping.
[   10.658131] usb-storage: queuecommand called
[   10.658159] usb-storage: *** thread awakened.
[   10.658165] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.658170] usb-storage:  00 00 00 00 00 00
[   10.658183] usb-storage: Bulk Command S 0x43425355 T 0x10 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.658190] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.658350] usb-storage: Status code 0; transferred 31/31
[   10.658357] usb-storage: -- transfer complete
[   10.658361] usb-storage: Bulk command transfer result=0
[   10.658366] usb-storage: Attempting to get CSW...
[   10.658372] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.658587] usb-storage: Status code 0; transferred 13/13
[   10.658593] usb-storage: -- transfer complete
[   10.658597] usb-storage: Bulk status result = 0
[   10.658604] usb-storage: Bulk Status S 0x53425355 T 0x10 R 0 Stat 0x0
[   10.658610] usb-storage: scsi cmd done, result=0x0
[   10.658619] usb-storage: *** thread sleeping.
[   10.658713] usb-storage: queuecommand called
[   10.658732] usb-storage: *** thread awakened.
[   10.658738] usb-storage: Command INQUIRY (6 bytes)
[   10.658743] usb-storage:  12 01 00 00 fe 00
[   10.658755] usb-storage: Bulk Command S 0x43425355 T 0x11 L 254 F 128 Trg 0 LUN 0 CL 6
[   10.658763] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.660730] usb-storage: Status code 0; transferred 31/31
[   10.660735] usb-storage: -- transfer complete
[   10.660740] usb-storage: Bulk command transfer result=0
[   10.660746] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   10.660948] usb-storage: Status code -121; transferred 36/254
[   10.660954] usb-storage: -- short read transfer
[   10.660959] usb-storage: Bulk data transfer result 0x1
[   10.660964] usb-storage: Attempting to get CSW...
[   10.660969] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.662543] usb-storage: Status code 0; transferred 13/13
[   10.662551] usb-storage: -- transfer complete
[   10.662556] usb-storage: Bulk status result = 0
[   10.662563] usb-storage: Bulk Status S 0x53425355 T 0x11 R 218 Stat 0x0
[   10.662570] usb-storage: scsi cmd done, result=0x0
[   10.662583] usb-storage: *** thread sleeping.
[   10.746778] usb-storage: queuecommand called
[   10.746822] usb-storage: *** thread awakened.
[   10.746829] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   10.746834] usb-storage:  00 00 00 00 00 00
[   10.746849] usb-storage: Bulk Command S 0x43425355 T 0x12 L 0 F 0 Trg 0 LUN 0 CL 6
[   10.746856] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.750465] usb-storage: Status code 0; transferred 31/31
[   10.750471] usb-storage: -- transfer complete
[   10.750476] usb-storage: Bulk command transfer result=0
[   10.750481] usb-storage: Attempting to get CSW...
[   10.750487] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.750587] usb-storage: Status code 0; transferred 13/13
[   10.750592] usb-storage: -- transfer complete
[   10.750596] usb-storage: Bulk status result = 0
[   10.750603] usb-storage: Bulk Status S 0x53425355 T 0x12 R 0 Stat 0x0
[   10.750609] usb-storage: scsi cmd done, result=0x0
[   10.750618] usb-storage: *** thread sleeping.
[   10.752050] usb-storage: queuecommand called
[   10.752077] usb-storage: *** thread awakened.
[   10.752087] usb-storage: Command READ_10 (10 bytes)
[   10.752092] usb-storage:  28 00 00 ee f3 80 00 00 08 00
[   10.752110] usb-storage: Bulk Command S 0x43425355 T 0x13 L 4096 F 128 Trg 0 LUN 0 CL 10
[   10.752117] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.753579] usb-storage: Status code 0; transferred 31/31
[   10.753588] usb-storage: -- transfer complete
[   10.753594] usb-storage: Bulk command transfer result=0
[   10.753602] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   10.754042] usb-storage: Status code 0; transferred 4096/4096
[   10.754049] usb-storage: -- transfer complete
[   10.754054] usb-storage: Bulk data transfer result 0x0
[   10.754059] usb-storage: Attempting to get CSW...
[   10.754066] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.757671] usb-storage: Status code 0; transferred 13/13
[   10.757676] usb-storage: -- transfer complete
[   10.757681] usb-storage: Bulk status result = 0
[   10.757687] usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x0
[   10.757698] usb-storage: scsi cmd done, result=0x0
[   10.757708] usb-storage: *** thread sleeping.
[   10.757889] usb-storage: queuecommand called
[   10.757909] usb-storage: *** thread awakened.
[   10.757915] usb-storage: Command READ_10 (10 bytes)
[   10.757920] usb-storage:  28 00 00 00 00 00 00 00 08 00
[   10.757937] usb-storage: Bulk Command S 0x43425355 T 0x14 L 4096 F 128 Trg 0 LUN 0 CL 10
[   10.757944] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.758095] usb-storage: Status code 0; transferred 31/31
[   10.758100] usb-storage: -- transfer complete
[   10.758105] usb-storage: Bulk command transfer result=0
[   10.758111] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   10.758592] usb-storage: Status code 0; transferred 4096/4096
[   10.758597] usb-storage: -- transfer complete
[   10.758602] usb-storage: Bulk data transfer result 0x0
[   10.758606] usb-storage: Attempting to get CSW...
[   10.758612] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.758710] usb-storage: Status code 0; transferred 13/13
[   10.758715] usb-storage: -- transfer complete
[   10.758719] usb-storage: Bulk status result = 0
[   10.758725] usb-storage: Bulk Status S 0x53425355 T 0x14 R 0 Stat 0x0
[   10.758731] usb-storage: scsi cmd done, result=0x0
[   10.758739] usb-storage: *** thread sleeping.
[   10.758853] usb-storage: queuecommand called
[   10.758869] usb-storage: *** thread awakened.
[   10.758874] usb-storage: Command READ_10 (10 bytes)
[   10.758879] usb-storage:  28 00 00 00 00 08 00 00 20 00
[   10.758894] usb-storage: Bulk Command S 0x43425355 T 0x15 L 16384 F 128 Trg 0 LUN 0 CL 10
[   10.758902] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.758965] usb-storage: Status code 0; transferred 31/31
[   10.758970] usb-storage: -- transfer complete
[   10.758974] usb-storage: Bulk command transfer result=0
[   10.758980] usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
[   10.760092] usb-storage: Status code 0; transferred 16384/16384
[   10.760097] usb-storage: -- transfer complete
[   10.760102] usb-storage: Bulk data transfer result 0x0
[   10.760107] usb-storage: Attempting to get CSW...
[   10.760112] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.760210] usb-storage: Status code 0; transferred 13/13
[   10.760215] usb-storage: -- transfer complete
[   10.760219] usb-storage: Bulk status result = 0
[   10.760226] usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x0
[   10.760231] usb-storage: scsi cmd done, result=0x0
[   10.760239] usb-storage: *** thread sleeping.
[   10.760337] usb-storage: queuecommand called
[   10.760351] usb-storage: *** thread awakened.
[   10.760357] usb-storage: Command READ_10 (10 bytes)
[   10.760361] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.760376] usb-storage: Bulk Command S 0x43425355 T 0x16 L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.760384] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.760466] usb-storage: Status code 0; transferred 31/31
[   10.760471] usb-storage: -- transfer complete
[   10.760475] usb-storage: Bulk command transfer result=0
[   10.760482] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.761089] usb-storage: Status code 0; transferred 3584/3584
[   10.761094] usb-storage: -- transfer complete
[   10.761099] usb-storage: Bulk data transfer result 0x0
[   10.761104] usb-storage: Attempting to get CSW...
[   10.761109] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.761214] usb-storage: Status code -32; transferred 0/13
[   10.761220] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.761231] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.761337] usb-storage: usb_stor_clear_halt: result = 0
[   10.761342] usb-storage: Attempting to get CSW (2nd try)...
[   10.761348] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.761461] usb-storage: Status code 0; transferred 13/13
[   10.761466] usb-storage: -- transfer complete
[   10.761470] usb-storage: Bulk status result = 0
[   10.761477] usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x1
[   10.761483] usb-storage: -- transport indicates command failure
[   10.761488] usb-storage: Issuing auto-REQUEST_SENSE
[   10.761497] usb-storage: Bulk Command S 0x43425355 T 0x17 L 18 F 128 Trg 0 LUN 0 CL 6
[   10.761504] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.761588] usb-storage: Status code 0; transferred 31/31
[   10.761593] usb-storage: -- transfer complete
[   10.761597] usb-storage: Bulk command transfer result=0
[   10.761603] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.761838] usb-storage: Status code 0; transferred 18/18
[   10.761843] usb-storage: -- transfer complete
[   10.761848] usb-storage: Bulk data transfer result 0x0
[   10.761853] usb-storage: Attempting to get CSW...
[   10.761858] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.761962] usb-storage: Status code 0; transferred 13/13
[   10.761967] usb-storage: -- transfer complete
[   10.761971] usb-storage: Bulk status result = 0
[   10.761977] usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x0
[   10.761984] usb-storage: -- Result from auto-sense is 0
[   10.761990] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.761996] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.762003] usb-storage: scsi cmd done, result=0x2
[   10.762010] usb-storage: *** thread sleeping.
[   10.762025] usb-storage: queuecommand called
[   10.762037] usb-storage: *** thread awakened.
[   10.762042] usb-storage: Command READ_10 (10 bytes)
[   10.762047] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.762062] usb-storage: Bulk Command S 0x43425355 T 0x18 L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.762069] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.762214] usb-storage: Status code 0; transferred 31/31
[   10.762219] usb-storage: -- transfer complete
[   10.762223] usb-storage: Bulk command transfer result=0
[   10.762229] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.762586] usb-storage: Status code 0; transferred 3584/3584
[   10.762591] usb-storage: -- transfer complete
[   10.762596] usb-storage: Bulk data transfer result 0x0
[   10.762601] usb-storage: Attempting to get CSW...
[   10.762606] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.762712] usb-storage: Status code -32; transferred 0/13
[   10.762718] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.762725] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.762835] usb-storage: usb_stor_clear_halt: result = 0
[   10.762840] usb-storage: Attempting to get CSW (2nd try)...
[   10.762846] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.762961] usb-storage: Status code 0; transferred 13/13
[   10.762966] usb-storage: -- transfer complete
[   10.762971] usb-storage: Bulk status result = 0
[   10.762978] usb-storage: Bulk Status S 0x53425355 T 0x18 R 0 Stat 0x1
[   10.762984] usb-storage: -- transport indicates command failure
[   10.762989] usb-storage: Issuing auto-REQUEST_SENSE
[   10.762997] usb-storage: Bulk Command S 0x43425355 T 0x19 L 18 F 128 Trg 0 LUN 0 CL 6
[   10.763004] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.763091] usb-storage: Status code 0; transferred 31/31
[   10.763096] usb-storage: -- transfer complete
[   10.763101] usb-storage: Bulk command transfer result=0
[   10.763107] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.763338] usb-storage: Status code 0; transferred 18/18
[   10.763343] usb-storage: -- transfer complete
[   10.763348] usb-storage: Bulk data transfer result 0x0
[   10.763352] usb-storage: Attempting to get CSW...
[   10.763358] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.763459] usb-storage: Status code 0; transferred 13/13
[   10.763463] usb-storage: -- transfer complete
[   10.763468] usb-storage: Bulk status result = 0
[   10.763474] usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x0
[   10.763480] usb-storage: -- Result from auto-sense is 0
[   10.763486] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.763492] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.763498] usb-storage: scsi cmd done, result=0x2
[   10.763506] usb-storage: *** thread sleeping.
[   10.763518] usb-storage: queuecommand called
[   10.763530] usb-storage: *** thread awakened.
[   10.763535] usb-storage: Command READ_10 (10 bytes)
[   10.763540] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.763555] usb-storage: Bulk Command S 0x43425355 T 0x1a L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.763562] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.763711] usb-storage: Status code 0; transferred 31/31
[   10.763716] usb-storage: -- transfer complete
[   10.763721] usb-storage: Bulk command transfer result=0
[   10.763727] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.764088] usb-storage: Status code 0; transferred 3584/3584
[   10.764093] usb-storage: -- transfer complete
[   10.764098] usb-storage: Bulk data transfer result 0x0
[   10.764103] usb-storage: Attempting to get CSW...
[   10.764108] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.764211] usb-storage: Status code -32; transferred 0/13
[   10.764217] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.764224] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.764337] usb-storage: usb_stor_clear_halt: result = 0
[   10.764342] usb-storage: Attempting to get CSW (2nd try)...
[   10.764348] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.764464] usb-storage: Status code 0; transferred 13/13
[   10.764469] usb-storage: -- transfer complete
[   10.764473] usb-storage: Bulk status result = 0
[   10.764479] usb-storage: Bulk Status S 0x53425355 T 0x1a R 0 Stat 0x1
[   10.764485] usb-storage: -- transport indicates command failure
[   10.764490] usb-storage: Issuing auto-REQUEST_SENSE
[   10.764498] usb-storage: Bulk Command S 0x43425355 T 0x1b L 18 F 128 Trg 0 LUN 0 CL 6
[   10.764505] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.764586] usb-storage: Status code 0; transferred 31/31
[   10.764591] usb-storage: -- transfer complete
[   10.764595] usb-storage: Bulk command transfer result=0
[   10.764601] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.764839] usb-storage: Status code 0; transferred 18/18
[   10.764844] usb-storage: -- transfer complete
[   10.764849] usb-storage: Bulk data transfer result 0x0
[   10.764854] usb-storage: Attempting to get CSW...
[   10.764859] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.764962] usb-storage: Status code 0; transferred 13/13
[   10.764967] usb-storage: -- transfer complete
[   10.764971] usb-storage: Bulk status result = 0
[   10.764978] usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x0
[   10.764983] usb-storage: -- Result from auto-sense is 0
[   10.764990] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.764996] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.765002] usb-storage: scsi cmd done, result=0x2
[   10.765009] usb-storage: *** thread sleeping.
[   10.765021] usb-storage: queuecommand called
[   10.765033] usb-storage: *** thread awakened.
[   10.765039] usb-storage: Command READ_10 (10 bytes)
[   10.765043] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.765058] usb-storage: Bulk Command S 0x43425355 T 0x1c L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.765065] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.765212] usb-storage: Status code 0; transferred 31/31
[   10.765216] usb-storage: -- transfer complete
[   10.765221] usb-storage: Bulk command transfer result=0
[   10.765227] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.765588] usb-storage: Status code 0; transferred 3584/3584
[   10.765593] usb-storage: -- transfer complete
[   10.765598] usb-storage: Bulk data transfer result 0x0
[   10.765602] usb-storage: Attempting to get CSW...
[   10.765608] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.765711] usb-storage: Status code -32; transferred 0/13
[   10.765716] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.765724] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.765834] usb-storage: usb_stor_clear_halt: result = 0
[   10.765839] usb-storage: Attempting to get CSW (2nd try)...
[   10.765845] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.765960] usb-storage: Status code 0; transferred 13/13
[   10.765965] usb-storage: -- transfer complete
[   10.765969] usb-storage: Bulk status result = 0
[   10.765976] usb-storage: Bulk Status S 0x53425355 T 0x1c R 0 Stat 0x1
[   10.765981] usb-storage: -- transport indicates command failure
[   10.765986] usb-storage: Issuing auto-REQUEST_SENSE
[   10.765994] usb-storage: Bulk Command S 0x43425355 T 0x1d L 18 F 128 Trg 0 LUN 0 CL 6
[   10.766001] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.766088] usb-storage: Status code 0; transferred 31/31
[   10.766093] usb-storage: -- transfer complete
[   10.766098] usb-storage: Bulk command transfer result=0
[   10.766104] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.766337] usb-storage: Status code 0; transferred 18/18
[   10.766342] usb-storage: -- transfer complete
[   10.766347] usb-storage: Bulk data transfer result 0x0
[   10.766352] usb-storage: Attempting to get CSW...
[   10.766357] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.766458] usb-storage: Status code 0; transferred 13/13
[   10.766463] usb-storage: -- transfer complete
[   10.766468] usb-storage: Bulk status result = 0
[   10.766474] usb-storage: Bulk Status S 0x53425355 T 0x1d R 0 Stat 0x0
[   10.766480] usb-storage: -- Result from auto-sense is 0
[   10.766486] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.766492] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.766498] usb-storage: scsi cmd done, result=0x2
[   10.766505] usb-storage: *** thread sleeping.
[   10.766517] usb-storage: queuecommand called
[   10.766529] usb-storage: *** thread awakened.
[   10.766534] usb-storage: Command READ_10 (10 bytes)
[   10.766539] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.766554] usb-storage: Bulk Command S 0x43425355 T 0x1e L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.766561] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.766714] usb-storage: Status code 0; transferred 31/31
[   10.766719] usb-storage: -- transfer complete
[   10.766723] usb-storage: Bulk command transfer result=0
[   10.766730] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.767094] usb-storage: Status code 0; transferred 3584/3584
[   10.767099] usb-storage: -- transfer complete
[   10.767104] usb-storage: Bulk data transfer result 0x0
[   10.767109] usb-storage: Attempting to get CSW...
[   10.767114] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.767218] usb-storage: Status code -32; transferred 0/13
[   10.767224] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.767232] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.767341] usb-storage: usb_stor_clear_halt: result = 0
[   10.767346] usb-storage: Attempting to get CSW (2nd try)...
[   10.767351] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.767465] usb-storage: Status code 0; transferred 13/13
[   10.767470] usb-storage: -- transfer complete
[   10.767474] usb-storage: Bulk status result = 0
[   10.767480] usb-storage: Bulk Status S 0x53425355 T 0x1e R 0 Stat 0x1
[   10.767486] usb-storage: -- transport indicates command failure
[   10.767491] usb-storage: Issuing auto-REQUEST_SENSE
[   10.767500] usb-storage: Bulk Command S 0x43425355 T 0x1f L 18 F 128 Trg 0 LUN 0 CL 6
[   10.767507] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.767589] usb-storage: Status code 0; transferred 31/31
[   10.767594] usb-storage: -- transfer complete
[   10.767599] usb-storage: Bulk command transfer result=0
[   10.767605] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.767843] usb-storage: Status code 0; transferred 18/18
[   10.767848] usb-storage: -- transfer complete
[   10.767853] usb-storage: Bulk data transfer result 0x0
[   10.767858] usb-storage: Attempting to get CSW...
[   10.767863] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.767962] usb-storage: Status code 0; transferred 13/13
[   10.767967] usb-storage: -- transfer complete
[   10.767972] usb-storage: Bulk status result = 0
[   10.767978] usb-storage: Bulk Status S 0x53425355 T 0x1f R 0 Stat 0x0
[   10.767983] usb-storage: -- Result from auto-sense is 0
[   10.767990] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.767995] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.768002] usb-storage: scsi cmd done, result=0x2
[   10.768009] usb-storage: *** thread sleeping.
[   10.768023] usb-storage: queuecommand called
[   10.768036] usb-storage: *** thread awakened.
[   10.768041] usb-storage: Command READ_10 (10 bytes)
[   10.768045] usb-storage:  28 00 00 ee f3 f8 00 00 07 00
[   10.768060] usb-storage: Bulk Command S 0x43425355 T 0x20 L 3584 F 128 Trg 0 LUN 0 CL 10
[   10.768068] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.768216] usb-storage: Status code 0; transferred 31/31
[   10.768221] usb-storage: -- transfer complete
[   10.768225] usb-storage: Bulk command transfer result=0
[   10.768231] usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
[   10.768589] usb-storage: Status code 0; transferred 3584/3584
[   10.768594] usb-storage: -- transfer complete
[   10.768599] usb-storage: Bulk data transfer result 0x0
[   10.768604] usb-storage: Attempting to get CSW...
[   10.768609] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.768717] usb-storage: Status code -32; transferred 0/13
[   10.768722] usb-storage: clearing endpoint halt for pipe 0xc0010280
[   10.768730] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=82 len=0
[   10.768838] usb-storage: usb_stor_clear_halt: result = 0
[   10.768843] usb-storage: Attempting to get CSW (2nd try)...
[   10.768849] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.768966] usb-storage: Status code 0; transferred 13/13
[   10.768971] usb-storage: -- transfer complete
[   10.768975] usb-storage: Bulk status result = 0
[   10.768982] usb-storage: Bulk Status S 0x53425355 T 0x20 R 0 Stat 0x1
[   10.768987] usb-storage: -- transport indicates command failure
[   10.768993] usb-storage: Issuing auto-REQUEST_SENSE
[   10.769001] usb-storage: Bulk Command S 0x43425355 T 0x21 L 18 F 128 Trg 0 LUN 0 CL 6
[   10.769007] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   10.769091] usb-storage: Status code 0; transferred 31/31
[   10.769096] usb-storage: -- transfer complete
[   10.769101] usb-storage: Bulk command transfer result=0
[   10.769107] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   10.769341] usb-storage: Status code 0; transferred 18/18
[   10.769346] usb-storage: -- transfer complete
[   10.769351] usb-storage: Bulk data transfer result 0x0
[   10.769356] usb-storage: Attempting to get CSW...
[   10.769361] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   10.769462] usb-storage: Status code 0; transferred 13/13
[   10.769467] usb-storage: -- transfer complete
[   10.769472] usb-storage: Bulk status result = 0
[   10.769478] usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x0
[   10.769484] usb-storage: -- Result from auto-sense is 0
[   10.769490] usb-storage: -- code: 0x70, key: 0x4, ASC: 0x11, ASCQ: 0x0
[   10.769496] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   10.769502] usb-storage: scsi cmd done, result=0x2
[   10.769509] usb-storage: *** thread sleeping.
[   10.769527] sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[   10.769683] sd 2:0:0:0: [sdb] Sense Key : 0x4 [current] 
[   10.769922] sd 2:0:0:0: [sdb] ASC=0x11 ASCQ=0x0
[   10.770110] end_request: I/O error, dev sdb, sector 15660024
[   11.197280] fuse init (API version 7.9)

--sm4nu43k4a2Rpi4c--
