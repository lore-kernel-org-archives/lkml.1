Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYCBWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYCBWac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYCBWaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:30:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:58014 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752772AbYCBWaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:30:15 -0500
Cc: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Content-Type: multipart/mixed; boundary="========GMX90211204497012566029"
Date: Sun, 02 Mar 2008 23:30:12 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <1204490829.15052.482.camel@pasglop>
Message-ID: <20080302223012.90210@gmx.net>
MIME-Version: 1.0
References: <20071125234254.B4405DDE49@ozlabs.org>	
 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
To: benh@kernel.crashing.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX196i4wi41t6Vz8iskZOqSg9u1L5EXimSfRE16mC8y
 4F77+MLA25PvTUPGJkzrrbQfS6ybiTamNgRw== 
X-GMX-UID: RhPzcgFQbmwoTlx4NTdLEJ1PUzc4clEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX90211204497012566029
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

-------- Original-Nachricht --------
> Datum: Mon, 03 Mar 2008 07:47:09 +1100
> Von: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: airlied@linux.ie, linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
> Betreff: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC

> That doesn't look possible, which is weird... looks like we are passing
> 0 to clean_dcache_range().
> 
> Interestingly enough, I can -see- possible issues with the ppc32 DMA API
> when trying to use HIGHMEM but that isn't the case here... 
> 
> Can you add printk's to ati_pcigart.c to print the arguments passed to
> 
> +               dma_sync_single_for_device(&dev->pdev->dev,
> +                                          bus_address,
> +                                          max_pages * sizeof(u32),
> +                                          PCI_DMA_TODEVICE);
> +
> 
> And also print the result of bus_to_virt(bus_address) ?
> 
> Ben.

Okay, I changed the code to this:

>DRM_DEBUG("dev = 0x%x, bus_address = 0x%x, bus_to_virt = 0x%lx, max_pages = 0x%x\n",
>	(unsigned int)&dev->pdev->dev, bus_address,
>	(unsigned long)virt_to_bus(bus_address), max_pages);
>
>if (gart_info->gart_table_location == DRM_ATI_GART_MAIN) {
>	DRM_DEBUG("calling dma_sync_single_for_device()\n");
>	dma_sync_single_for_device(&dev->pdev->dev,
>		bus_address,
>		max_pages * sizeof(u32),
>		PCI_DMA_TODEVICE);
>}

It looks like dma_sync_single_for_device() is not called here (the debug
messages don't show up in kernel log). I also included the Xorg.0.log
file.

Gerhard
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX90211204497012566029
Content-Type: text/x-log; charset="iso-8859-15"; name="dri_crash2.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dri_crash2.log"

 -> early_init_devtree(c0c0f300)
search "chosen", depth: 0, uname: 
search "chosen", depth: 1, uname: cpus
search "chosen", depth: 2, uname: cpu@0
search "chosen", depth: 1, uname: memory
search "chosen", depth: 1, uname: pci@80000000
search "chosen", depth: 2, uname: host@0
search "chosen", depth: 2, uname: isa@7
search "chosen", depth: 3, uname: dma-controller@0
search "chosen", depth: 3, uname: interrupt-controller@20
search "chosen", depth: 3, uname: timer@40
search "chosen", depth: 3, uname: 8042@60
search "chosen", depth: 4, uname: keyboard@0
search "chosen", depth: 4, uname: mouse@1
search "chosen", depth: 3, uname: rtc@70
search "chosen", depth: 3, uname: serial@2f8
search "chosen", depth: 3, uname: serial@3f8
search "chosen", depth: 3, uname: parallel@378
search "chosen", depth: 3, uname: fdc@3f0
search "chosen", depth: 4, uname: disk@0
search "chosen", depth: 2, uname: ide@7,1
search "chosen", depth: 1, uname: chosen
Looking for initrd properties... <3>initrd_start=0x0  initrd_end=0x0
Command line is: initcall_debug driver_debug debug root=/dev/hda11 console=ttyS0,115200n8r console=tty0 ide0=ata66 ide1=ata66 udbg-immortal
dt_root_size_cells = 1
dt_root_addr_cells = 1
memory scan node memory, reg size 8, data: 0 60000000 2 1,
 - 0 ,  60000000
Phys. mem: 60000000
-> move_device_tree
<- move_device_tree
Scanning CPUs ...
boot cpu: logical 0 physical 0
 <- early_init_devtree()
Using AmigaOne machine description
Total memory = 1536MB; using 4096kB for hash table (at cfc00000)
Linux version 2.6.25-rc3 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #56 Sun Mar 2 23:14:13 CET 2008
 -> unflatten_device_tree()
  size is 10c4, allocating...
  unflattening efffef38...
fixed up name for  -> 
fixed up name for cpus -> cpus
fixed up name for cpu@0 -> cpu
fixed up name for memory -> memory
fixed up name for pci@80000000 -> pci
fixed up name for host@0 -> host
fixed up name for isa@7 -> isa
fixed up name for dma-controller@0 -> dma-controller
fixed up name for interrupt-controller@20 -> interrupt-controller
fixed up name for timer@40 -> timer
fixed up name for 8042@60 -> 8042
fixed up name for keyboard@0 -> keyboard
fixed up name for mouse@1 -> mouse
fixed up name for rtc@70 -> rtc
fixed up name for serial@2f8 -> serial
fixed up name for serial@3f8 -> serial
fixed up name for parallel@378 -> parallel
fixed up name for fdc@3f0 -> fdc
fixed up name for disk@0 -> disk
fixed up name for ide@7,1 -> ide
fixed up name for chosen -> chosen
 <- unflatten_device_tree()
 -> find_legacy_serial_port()
stdout is /pci@80000000/isa@7/serial@3f8
 -> add_legacy_isa_port(/pci@80000000/isa@7/serial@2f8)
OF: ** translation for device /pci@80000000/isa@7/serial@2f8 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 000002f8
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=2f8
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 2f8
OF: one level translation: 01000000 00000000 000002f8
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=2f8
OF: parent translation for: fe000000
OF: with offset: 2f8
OF: one level translation: fe0002f8
OF: reached root node
Found legacy serial port 0 for /pci@80000000/isa@7/serial@2f8
  port=2f8, taddr=fe0002f8, irq=0, clk=1843200, speed=115200
 -> add_legacy_isa_port(/pci@80000000/isa@7/serial@3f8)
OF: ** translation for device /pci@80000000/isa@7/serial@3f8 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 000003f8
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=3f8
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 3f8
OF: one level translation: 01000000 00000000 000003f8
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=3f8
OF: parent translation for: fe000000
OF: with offset: 3f8
OF: one level translation: fe0003f8
OF: reached root node
Found legacy serial port 1 for /pci@80000000/isa@7/serial@3f8
  port=3f8, taddr=fe0003f8, irq=0, clk=1843200, speed=115200
legacy_serial_console = 1
default console speed = 115200
 <- find_legacy_serial_port()
early console immortal !
console [udbg0] enabled
Entering add_active_range(0, 0, 393216) 0 entries of 256 used
AmigaOne l2cr : L2 cache was not active, activating.
PCI host bridge /pci@80000000 (primary) ranges:
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fe000000
OF: reached root node
  IO 0x00000000fe000000..0x00000000febfffff -> 0x0000000000000000
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: 80000000
OF: reached root node
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fd000000
OF: reached root node
 MEM 0x0000000080000000..0x00000000fcffffff -> 0x0000000080000000 
OF: ** translation for device /pci@80000000 **
OF: bus is default (na=1, ns=1) on /
OF: translating address: fd000000
OF: reached root node
 MEM 0x00000000fd000000..0x00000000fdffffff -> 0x0000000000000000 
Top of RAM: 0x60000000, Total RAM: 0x60000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA             0 ->   196608
  Normal     196608 ->   196608
  HighMem    196608 ->   393216
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   393216
On node 0 totalpages: 393216
  DMA zone: 1536 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 195072 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  HighMem zone: 1536 pages used for memmap
  HighMem zone: 195072 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390144
Kernel command line: initcall_debug driver_debug debug root=/dev/hda11 console=ttyS0,115200n8r console=tty0 ide0=ata66 ide1=ata66 udbg-immortal
ide_setup: ide0=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
ide_setup: ide1=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
irq: Allocated host of type 0 @0xc042f1c0
i8259 legacy interrupt controller initialized
irq: Default host set to @0xc042f1c0
PID hash table entries: 4096 (order: 12, 16384 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 800.000000 MHz
clocksource: timebase mult[7800001] shift[22] registered
clockevent: decrementer mult[888] shift[16] cpu[0]
 -> check_legacy_serial_console()
 console was specified !
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
High memory: 786432k
Memory: 1550076k/1572864k available (3776k kernel code, 21736k reserved, 144k data, 295k bss, 176k init)
SLUB: Genslabs=10, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
Mount-cache hash table entries: 512
Calling initcall 0xc03a0940: init_cpufreq_transition_notifier_list+0x0/0x2c()
initcall 0xc03a0940: init_cpufreq_transition_notifier_list+0x0/0x2c() returned 0.
initcall 0xc03a0940 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x2c()
Calling initcall 0xc03a0c98: net_ns_init+0x0/0xa0()
net_namespace: 544 bytes
initcall 0xc03a0c98: net_ns_init+0x0/0xa0() returned 0.
initcall 0xc03a0c98 ran for 0 msecs: net_ns_init+0x0/0xa0()
Calling initcall 0xc03926a4: dma_alloc_init+0x0/0xac()
initcall 0xc03926a4: dma_alloc_init+0x0/0xac() returned 0.
initcall 0xc03926a4 ran for 0 msecs: dma_alloc_init+0x0/0xac()
Calling initcall 0xc03937a0: sysctl_init+0x0/0x48()
initcall 0xc03937a0: sysctl_init+0x0/0x48() returned 0.
initcall 0xc03937a0 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc039419c: ksysfs_init+0x0/0xec()
initcall 0xc039419c: ksysfs_init+0x0/0xec() returned 0.
initcall 0xc039419c ran for 0 msecs: ksysfs_init+0x0/0xec()
Calling initcall 0xc0394630: init_jiffies_clocksource+0x0/0x28()
initcall 0xc0394630: init_jiffies_clocksource+0x0/0x28() returned 0.
initcall 0xc0394630 ran for 0 msecs: init_jiffies_clocksource+0x0/0x28()
Calling initcall 0xc039489c: pm_init+0x0/0x54()
initcall 0xc039489c: pm_init+0x0/0x54() returned 0.
initcall 0xc039489c ran for 0 msecs: pm_init+0x0/0x54()
Calling initcall 0xc0397204: filelock_init+0x0/0x48()
initcall 0xc0397204: filelock_init+0x0/0x48() returned 0.
initcall 0xc0397204 ran for 0 msecs: filelock_init+0x0/0x48()
Calling initcall 0xc0397db0: init_script_binfmt+0x0/0x28()
initcall 0xc0397db0: init_script_binfmt+0x0/0x28() returned 0.
initcall 0xc0397db0 ran for 0 msecs: init_script_binfmt+0x0/0x28()
Calling initcall 0xc0397dd8: init_elf_binfmt+0x0/0x28()
initcall 0xc0397dd8: init_elf_binfmt+0x0/0x28() returned 0.
initcall 0xc0397dd8 ran for 0 msecs: init_elf_binfmt+0x0/0x28()
Calling initcall 0xc0398a64: debugfs_init+0x0/0x70()
initcall 0xc0398a64: debugfs_init+0x0/0x70() returned 0.
initcall 0xc0398a64 ran for 0 msecs: debugfs_init+0x0/0x70()
Calling initcall 0xc03996c0: random32_init+0x0/0x34()
initcall 0xc03996c0: random32_init+0x0/0x34() returned 0.
initcall 0xc03996c0 ran for 0 msecs: random32_init+0x0/0x34()
Calling initcall 0xc03a0910: cpufreq_core_init+0x0/0x30()
initcall 0xc03a0910: cpufreq_core_init+0x0/0x30() returned 0.
initcall 0xc03a0910 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
Calling initcall 0xc03a0a4c: sock_init+0x0/0x5c()
initcall 0xc03a0a4c: sock_init+0x0/0x5c() returned 0.
initcall 0xc03a0a4c ran for 0 msecs: sock_init+0x0/0x5c()
Calling initcall 0xc03a14f4: netpoll_init+0x0/0x20()
initcall 0xc03a14f4: netpoll_init+0x0/0x20() returned 0.
initcall 0xc03a14f4 ran for 0 msecs: netpoll_init+0x0/0x20()
Calling initcall 0xc03a182c: netlink_proto_init+0x0/0x158()
NET: Registered protocol family 16
initcall 0xc03a182c: netlink_proto_init+0x0/0x158() returned 0.
initcall 0xc03a182c ran for 3 msecs: netlink_proto_init+0x0/0x158()
Calling initcall 0xc038b558: of_bus_driver_init+0x0/0x30()
initcall 0xc038b558: of_bus_driver_init+0x0/0x30() returned 0.
initcall 0xc038b558 ran for 0 msecs: of_bus_driver_init+0x0/0x30()
Calling initcall 0xc0399550: kobject_uevent_init+0x0/0x68()
initcall 0xc0399550: kobject_uevent_init+0x0/0x68() returned 0.
initcall 0xc0399550 ran for 0 msecs: kobject_uevent_init+0x0/0x68()
Calling initcall 0xc0399730: pcibus_class_init+0x0/0x28()
initcall 0xc0399730: pcibus_class_init+0x0/0x28() returned 0.
initcall 0xc0399730 ran for 0 msecs: pcibus_class_init+0x0/0x28()
Calling initcall 0xc0399ed8: pci_driver_init+0x0/0x28()
initcall 0xc0399ed8: pci_driver_init+0x0/0x28() returned 0.
initcall 0xc0399ed8 ran for 0 msecs: pci_driver_init+0x0/0x28()
Calling initcall 0xc039a760: backlight_class_init+0x0/0x74()
initcall 0xc039a760: backlight_class_init+0x0/0x74() returned 0.
initcall 0xc039a760 ran for 0 msecs: backlight_class_init+0x0/0x74()
Calling initcall 0xc039aa20: video_output_class_init+0x0/0x28()
initcall 0xc039aa20: video_output_class_init+0x0/0x28() returned 0.
initcall 0xc039aa20 ran for 0 msecs: video_output_class_init+0x0/0x28()
Calling initcall 0xc039add8: tty_class_init+0x0/0x44()
initcall 0xc039add8: tty_class_init+0x0/0x44() returned 0.
initcall 0xc039add8 ran for 0 msecs: tty_class_init+0x0/0x44()
Calling initcall 0xc039b848: vtconsole_class_init+0x0/0xf0()
initcall 0xc039b848: vtconsole_class_init+0x0/0xf0() returned 0.
initcall 0xc039b848 ran for 0 msecs: vtconsole_class_init+0x0/0xf0()
Calling initcall 0xc0006a10: irq_late_init+0x0/0x88()
initcall 0xc0006a10: irq_late_init+0x0/0x88() returned 0.
initcall 0xc0006a10 ran for 0 msecs: irq_late_init+0x0/0x88()
Calling initcall 0xc038b340: vdso_init+0x0/0x1d8()
initcall 0xc038b340: vdso_init+0x0/0x1d8() returned 0.
initcall 0xc038b340 ran for 0 msecs: vdso_init+0x0/0x1d8()
Calling initcall 0xc001000c: powerpc_debugfs_init+0x0/0x40()
initcall 0xc001000c: powerpc_debugfs_init+0x0/0x40() returned 0.
initcall 0xc001000c ran for 0 msecs: powerpc_debugfs_init+0x0/0x40()
Calling initcall 0xc038d660: ppc_init+0x0/0x84()
initcall 0xc038d660: ppc_init+0x0/0x84() returned 0.
initcall 0xc038d660 ran for 0 msecs: ppc_init+0x0/0x84()
Calling initcall 0xc0390d48: pcibios_init+0x0/0x138()
PCI: Probing PCI hardware
PCI: Scanning bus 0000:00
PCI: Found 0000:00:00.0 [10cc/0660] 000600 00
pci 0000:00:00.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:01.0 [10cc/0661] 000604 01
pci 0000:00:01.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:06.0 [10b7/9200] 000200 00
pci 0000:00:06.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:07.0 [1106/0686] 000601 00
pci 0000:00:07.0: calling quirk 0xc02c42f0: 0xc02c42f0()
pci 0000:00:07.0: calling quirk 0xc012e81c: quirk_via_bridge+0x0/0x98()
PCI: Found 0000:00:07.1 [1106/0571] 000101 00
pci 0000:00:07.1: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:07.2 [1106/3038] 000c03 00
pci 0000:00:07.2: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:07.3 [1106/3038] 000c03 00
pci 0000:00:07.3: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:07.4 [1106/3057] 000000 00
pci 0000:00:07.4: calling quirk 0xc02c42f0: 0xc02c42f0()
pci 0000:00:07.4: calling quirk 0xc02c5d08: 0xc02c5d08()
pci 0000:00:07.4: calling quirk 0xc02c52cc: 0xc02c52cc()
PCI: Found 0000:00:07.5 [1106/3058] 000401 00
pci 0000:00:07.5: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:07.6 [1106/3068] 000780 00
pci 0000:00:07.6: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:08.0 [109e/036e] 000400 00
pci 0000:00:08.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:08.1 [109e/0878] 000480 00
pci 0000:00:08.1: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:09.0 [1102/0002] 000401 00
pci 0000:00:09.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:09.1 [1102/7002] 000980 00
pci 0000:00:09.1: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:0a.0 [10b9/5237] 000c03 00
pci 0000:00:0a.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:0a.1 [10b9/5237] 000c03 00
pci 0000:00:0a.1: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:0a.2 [10b9/5237] 000c03 00
pci 0000:00:0a.2: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:0a.3 [10b9/5239] 000c03 00
pci 0000:00:0a.3: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:00:0a.4 [10b9/5253] 000c00 00
pci 0000:00:0a.4: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Fixups for bus 0000:00
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000000...],ointsize=1
 -> no parent found !
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00003000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 7
of_irq_map_one: dev=/pci@80000000/ide@7,1, index=0
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003a00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003b00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003d00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003e00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 9
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004100...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 9
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xa)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 10
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005100...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005200...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00005300...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00005400...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 9
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
PCI: Scanning bus 0000:01
PCI: Found 0000:01:00.0 [1002/5961] 000300 00
pci 0000:01:00.0: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Found 0000:01:00.1 [1002/5941] 000380 00
pci 0000:01:00.1: calling quirk 0xc02c42f0: 0xc02c42f0()
PCI: Fixups for bus 0000:01
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 11
PCI: Bus scan for 0000:01 returning with max=01
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 1
PCI: Bus scan for 0000:00 returning with max=01
PCI: Cannot allocate resource region 0 of device 0000:00:00.0, will remap
PCI: Cannot allocate resource region 0 of device 0000:01:00.1, will remap
PCI: Cannot allocate resource region 1 of device 0000:01:00.1, will remap
  got res [88100000:8811ffff] bus [88100000:8811ffff] flags 7200 for BAR 6 of 0000:00:06.0
  got res [88120000:8812ffff] bus [88120000:8812ffff] flags 7200 for BAR 6 of 0000:00:0a.4
PCI: Failed to allocate mem resource #0:8000000@88000000 for 0000:01:00.1
  got res [88020000:8803ffff] bus [88020000:8803ffff] flags 7200 for BAR 6 of 0000:01:00.0
  got res [88010000:8801ffff] bus [88010000:8801ffff] flags 20000200 for BAR 1 of 0000:01:00.1
PCI: moved device 0000:01:00.1 resource 1 (200) to 88010000
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: 0x88000000-0x880fffff
  PREFETCH window: 0x0000000080000000-0x0000000087ffffff
initcall 0xc0390d48: pcibios_init+0x0/0x138() returned 0.
initcall 0xc0390d48 ran for 400 msecs: pcibios_init+0x0/0x138()
Calling initcall 0xc0393e70: param_sysfs_init+0x0/0x7c()
initcall 0xc0393e70: param_sysfs_init+0x0/0x7c() returned 0.
initcall 0xc0393e70 ran for 0 msecs: param_sysfs_init+0x0/0x7c()
Calling initcall 0xc0046028: pm_sysrq_init+0x0/0x30()
initcall 0xc0046028: pm_sysrq_init+0x0/0x30() returned 0.
initcall 0xc0046028 ran for 0 msecs: pm_sysrq_init+0x0/0x30()
Calling initcall 0xc0396924: readahead_init+0x0/0x28()
initcall 0xc0396924: readahead_init+0x0/0x28() returned 0.
initcall 0xc0396924 ran for 0 msecs: readahead_init+0x0/0x28()
Calling initcall 0xc0397a14: init_bio+0x0/0xac()
initcall 0xc0397a14: init_bio+0x0/0xac() returned 0.
initcall 0xc0397a14 ran for 0 msecs: init_bio+0x0/0xac()
Calling initcall 0xc039916c: blk_settings_init+0x0/0x30()
initcall 0xc039916c: blk_settings_init+0x0/0x30() returned 0.
initcall 0xc039916c ran for 0 msecs: blk_settings_init+0x0/0x30()
Calling initcall 0xc039919c: blk_ioc_init+0x0/0x44()
initcall 0xc039919c: blk_ioc_init+0x0/0x44() returned 0.
initcall 0xc039919c ran for 0 msecs: blk_ioc_init+0x0/0x44()
Calling initcall 0xc03991e0: genhd_device_init+0x0/0x4c()
initcall 0xc03991e0: genhd_device_init+0x0/0x4c() returned 0.
initcall 0xc03991e0 ran for 0 msecs: genhd_device_init+0x0/0x4c()
Calling initcall 0xc039a334: fbmem_init+0x0/0xc8()
initcall 0xc039a334: fbmem_init+0x0/0xc8() returned 0.
initcall 0xc039a334 ran for 0 msecs: fbmem_init+0x0/0xc8()
Calling initcall 0xc039b220: misc_init+0x0/0xb8()
initcall 0xc039b220: misc_init+0x0/0xb8() returned 0.
initcall 0xc039b220 ran for 0 msecs: misc_init+0x0/0xb8()
Calling initcall 0xc039ee2c: init_scsi+0x0/0xa8()
SCSI subsystem initialized
initcall 0xc039ee2c: init_scsi+0x0/0xa8() returned 0.
initcall 0xc039ee2c ran for 3 msecs: init_scsi+0x0/0xa8()
Calling initcall 0xc039f4bc: usb_init+0x0/0x118()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc039f4bc: usb_init+0x0/0x118() returned 0.
initcall 0xc039f4bc ran for 7 msecs: usb_init+0x0/0x118()
Calling initcall 0xc039fac8: serio_init+0x0/0xa4()
initcall 0xc039fac8: serio_init+0x0/0xa4() returned 0.
initcall 0xc039fac8 ran for 0 msecs: serio_init+0x0/0xa4()
Calling initcall 0xc039fd5c: input_init+0x0/0x98()
initcall 0xc039fd5c: input_init+0x0/0x98() returned 0.
initcall 0xc039fd5c ran for 0 msecs: input_init+0x0/0x98()
Calling initcall 0xc03a00ec: rtc_init+0x0/0x94()
initcall 0xc03a00ec: rtc_init+0x0/0x94() returned 0.
initcall 0xc03a00ec ran for 0 msecs: rtc_init+0x0/0x94()
Calling initcall 0xc03a0784: i2c_init+0x0/0x7c()
initcall 0xc03a0784: i2c_init+0x0/0x7c() returned 0.
initcall 0xc03a0784 ran for 0 msecs: i2c_init+0x0/0x7c()
Calling initcall 0xc03a08bc: thermal_init+0x0/0x54()
initcall 0xc03a08bc: thermal_init+0x0/0x54() returned 0.
initcall 0xc03a08bc ran for 0 msecs: thermal_init+0x0/0x54()
Calling initcall 0xc03a0b04: proto_init+0x0/0x54()
initcall 0xc03a0b04: proto_init+0x0/0x54() returned 0.
initcall 0xc03a0b04 ran for 0 msecs: proto_init+0x0/0x54()
Calling initcall 0xc03a1080: net_dev_init+0x0/0x124()
initcall 0xc03a1080: net_dev_init+0x0/0x124() returned 0.
initcall 0xc03a1080 ran for 0 msecs: net_dev_init+0x0/0x124()
Calling initcall 0xc03a1240: neigh_init+0x0/0x98()
initcall 0xc03a1240: neigh_init+0x0/0x98() returned 0.
initcall 0xc03a1240 ran for 0 msecs: neigh_init+0x0/0x98()
Calling initcall 0xc03a1514: fib_rules_init+0x0/0xd0()
initcall 0xc03a1514: fib_rules_init+0x0/0xd0() returned 0.
initcall 0xc03a1514 ran for 0 msecs: fib_rules_init+0x0/0xd0()
Calling initcall 0xc03a15e4: pktsched_init+0x0/0xf4()
initcall 0xc03a15e4: pktsched_init+0x0/0xf4() returned 0.
initcall 0xc03a15e4 ran for 0 msecs: pktsched_init+0x0/0xf4()
Calling initcall 0xc03a1700: tc_filter_init+0x0/0x70()
initcall 0xc03a1700: tc_filter_init+0x0/0x70() returned 0.
initcall 0xc03a1700 ran for 0 msecs: tc_filter_init+0x0/0x70()
Calling initcall 0xc03a1770: tc_action_init+0x0/0x70()
initcall 0xc03a1770: tc_action_init+0x0/0x70() returned 0.
initcall 0xc03a1770 ran for 0 msecs: tc_action_init+0x0/0x70()
Calling initcall 0xc03a1984: genl_init+0x0/0xf8()
initcall 0xc03a1984: genl_init+0x0/0xf8() returned 0.
initcall 0xc03a1984 ran for 15 msecs: genl_init+0x0/0xf8()
Calling initcall 0xc03a367c: atm_init+0x0/0xd4()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xc03a367c: atm_init+0x0/0xd4() returned 0.
initcall 0xc03a367c ran for 3 msecs: atm_init+0x0/0xd4()
Calling initcall 0xc03a38f0: wireless_nlevent_init+0x0/0x20()
initcall 0xc03a38f0: wireless_nlevent_init+0x0/0x20() returned 0.
initcall 0xc03a38f0 ran for 0 msecs: wireless_nlevent_init+0x0/0x20()
Calling initcall 0xc03a3910: sysctl_init+0x0/0x48()
initcall 0xc03a3910: sysctl_init+0x0/0x48() returned 0.
initcall 0xc03a3910 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc0392750: add_rtc+0x0/0xcc()
OF: ** translation for device /pci@80000000/isa@7/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pci@80000000/isa@7
OF: translating address: 00000001 00000070
OF: parent bus is pci (na=3, ns=2) on /pci@80000000
OF: walking ranges...
OF: ISA map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is default (na=1, ns=1) on /
OF: walking ranges...
OF: PCI map, cp=0, s=c00000, da=70
OF: parent translation for: fe000000
OF: with offset: 70
OF: one level translation: fe000070
OF: reached root node
initcall 0xc0392750: add_rtc+0x0/0xcc() returned 0.
initcall 0xc0392750 ran for 38 msecs: add_rtc+0x0/0xcc()
Calling initcall 0xc03944e4: clocksource_done_booting+0x0/0x14()
initcall 0xc03944e4: clocksource_done_booting+0x0/0x14()<6>Time: timebase clocksource has been installed.
Switched to high resolution mode on CPU 0
 returned 0.
initcall 0xc03944e4 ran for 0 msecs: clocksource_done_booting+0x0/0x14()
Calling initcall 0xc0397150: init_pipe_fs+0x0/0x70()
initcall 0xc0397150: init_pipe_fs+0x0/0x70() returned 0.
initcall 0xc0397150 ran for 0 msecs: init_pipe_fs+0x0/0x70()
Calling initcall 0xc0397c68: eventpoll_init+0x0/0x98()
initcall 0xc0397c68: eventpoll_init+0x0/0x98() returned 0.
initcall 0xc0397c68 ran for 0 msecs: eventpoll_init+0x0/0x98()
Calling initcall 0xc0397d00: anon_inode_init+0x0/0xb0()
initcall 0xc0397d00: anon_inode_init+0x0/0xb0() returned 0.
initcall 0xc0397d00 ran for 0 msecs: anon_inode_init+0x0/0xb0()
Calling initcall 0xc039aa48: chr_dev_init+0x0/0xbc()
initcall 0xc039aa48: chr_dev_init+0x0/0xbc() returned 0.
initcall 0xc039aa48 ran for 0 msecs: chr_dev_init+0x0/0xbc()
Calling initcall 0xc039e170: loopback_init+0x0/0x28()
initcall 0xc039e170: loopback_init+0x0/0x28() returned 0.
initcall 0xc039e170 ran for 0 msecs: loopback_init+0x0/0x28()
Calling initcall 0xc03a096c: cpufreq_gov_performance_init+0x0/0x28()
initcall 0xc03a096c: cpufreq_gov_performance_init+0x0/0x28() returned 0.
initcall 0xc03a096c ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x28()
Calling initcall 0xc03a2b7c: inet_init+0x0/0x1d0()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc03a2b7c: inet_init+0x0/0x1d0() returned 0.
initcall 0xc03a2b7c ran for 78 msecs: inet_init+0x0/0x1d0()
Calling initcall 0xc038a9f0: populate_rootfs+0x0/0xf8()
initcall 0xc038a9f0: populate_rootfs+0x0/0xf8() returned 0.
initcall 0xc038a9f0 ran for 0 msecs: populate_rootfs+0x0/0xf8()
Calling initcall 0xc038ad0c: irq_debugfs_init+0x0/0x50()
initcall 0xc038ad0c: irq_debugfs_init+0x0/0x50() returned -12.
initcall 0xc038ad0c ran for 0 msecs: irq_debugfs_init+0x0/0x50()
initcall at 0xc038ad0c: irq_debugfs_init+0x0/0x50(): returned with error code -12
Calling initcall 0xc038b52c: register_powersave_nap_sysctl+0x0/0x2c()
initcall 0xc038b52c: register_powersave_nap_sysctl+0x0/0x2c() returned 0.
initcall 0xc038b52c ran for 0 msecs: register_powersave_nap_sysctl+0x0/0x2c()
Calling initcall 0xc038b5a8: TAU_init+0x0/0xf4()
Thermal assist unit not available
initcall 0xc038b5a8: TAU_init+0x0/0xf4() returned 1.
initcall 0xc038b5a8 ran for 2 msecs: TAU_init+0x0/0xf4()
initcall at 0xc038b5a8: TAU_init+0x0/0xf4(): returned with error code 1
Calling initcall 0xc038bfbc: export_flat_device_tree+0x0/0x60()
initcall 0xc038bfbc: export_flat_device_tree+0x0/0x60() returned 0.
initcall 0xc038bfbc ran for 0 msecs: export_flat_device_tree+0x0/0x60()
Calling initcall 0xc038d380: add_pcspkr+0x0/0x80()
initcall 0xc038d380: add_pcspkr+0x0/0x80() returned 0.
initcall 0xc038d380 ran for 0 msecs: add_pcspkr+0x0/0x80()
Calling initcall 0xc03901cc: serial_dev_init+0x0/0xf0()
Fixing serial ports interrupts and IO ports ...
fixup_port_irq(0)
enter irq_of_parse_and_map()
of_irq_map_one: dev=/pci@80000000/isa@7/serial@2f8, index=0
 intsize=2 intlen=2
of_irq_map_raw: par=/pci@80000000/isa@7,intspec=[0x00000003 0x00000003...],ointsize=2
of_irq_map_raw: ipar=/pci@80000000/isa@7, size=2
 -> addrsize=2
 -> no map, getting parent
 -> new parent: /pci@80000000/isa@7/interrupt-controller@20
 -> got it !
calling irq_create_of_mapping()
irq: controller = /pci@80000000/isa@7/interrupt-controller@20, intspec = 3, intsize = 2
irq: find host controller
irq: host = 0xc042f1c0
irq: irq_create_mapping(0xc042f1c0, 0x3)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 3
irq: created irq mapping, virq = 3
irq: created irq mapping, virq = 3
fixup_port_pio(0)
port 0, IO 2f8 -> 2f8
fixup_port_irq(1)
enter irq_of_parse_and_map()
of_irq_map_one: dev=/pci@80000000/isa@7/serial@3f8, index=0
 intsize=2 intlen=2
of_irq_map_raw: par=/pci@80000000/isa@7,intspec=[0x00000004 0x00000003...],ointsize=2
of_irq_map_raw: ipar=/pci@80000000/isa@7, size=2
 -> addrsize=2
 -> no map, getting parent
 -> new parent: /pci@80000000/isa@7/interrupt-controller@20
 -> got it !
calling irq_create_of_mapping()
irq: controller = /pci@80000000/isa@7/interrupt-controller@20, intspec = 4, intsize = 2
irq: find host controller
irq: host = 0xc042f1c0
irq: irq_create_mapping(0xc042f1c0, 0x4)
irq: -> using host @c042f1c0
irq: -> existing mapping on virq 4
irq: created irq mapping, virq = 4
irq: created irq mapping, virq = 4
fixup_port_pio(1)
port 1, IO 3f8 -> 3f8
Registering platform serial ports
initcall 0xc03901cc: serial_dev_init+0x0/0xf0() returned 0.
initcall 0xc03901cc ran for 136 msecs: serial_dev_init+0x0/0xf0()
Calling initcall 0xc0391254: audit_classes_init+0x0/0x70()
initcall 0xc0391254: audit_classes_init+0x0/0x70() returned 0.
initcall 0xc0391254 ran for 0 msecs: audit_classes_init+0x0/0x70()
Calling initcall 0xc0391e18: setup_kcore+0x0/0xe0()
setup_kcore: restrict size=3fffffff
initcall 0xc0391e18: setup_kcore+0x0/0xe0() returned 0.
initcall 0xc0391e18 ran for 3 msecs: setup_kcore+0x0/0xe0()
Calling initcall 0xc0393330: create_proc_profile+0x0/0x74()
initcall 0xc0393330: create_proc_profile+0x0/0x74() returned 0.
initcall 0xc0393330 ran for 0 msecs: create_proc_profile+0x0/0x74()
Calling initcall 0xc0393730: ioresources_init+0x0/0x70()
initcall 0xc0393730: ioresources_init+0x0/0x70() returned 0.
initcall 0xc0393730 ran for 0 msecs: ioresources_init+0x0/0x70()
Calling initcall 0xc039383c: uid_cache_init+0x0/0x94()
initcall 0xc039383c: uid_cache_init+0x0/0x94() returned 0.
initcall 0xc039383c ran for 0 msecs: uid_cache_init+0x0/0x94()
Calling initcall 0xc0393eec: init_posix_timers+0x0/0xc0()
initcall 0xc0393eec: init_posix_timers+0x0/0xc0() returned 0.
initcall 0xc0393eec ran for 0 msecs: init_posix_timers+0x0/0xc0()
Calling initcall 0xc0393fac: init_posix_cpu_timers+0x0/0xf0()
initcall 0xc0393fac: init_posix_cpu_timers+0x0/0xf0() returned 0.
initcall 0xc0393fac ran for 0 msecs: init_posix_cpu_timers+0x0/0xf0()
Calling initcall 0xc0394158: nsproxy_cache_init+0x0/0x44()
initcall 0xc0394158: nsproxy_cache_init+0x0/0x44() returned 0.
initcall 0xc0394158 ran for 0 msecs: nsproxy_cache_init+0x0/0x44()
Calling initcall 0xc0394310: timekeeping_init_device+0x0/0x44()
initcall 0xc0394310: timekeeping_init_device+0x0/0x44() returned 0.
initcall 0xc0394310 ran for 0 msecs: timekeeping_init_device+0x0/0x44()
Calling initcall 0xc03945b0: init_clocksource_sysfs+0x0/0x80()
initcall 0xc03945b0: init_clocksource_sysfs+0x0/0x80() returned 0.
initcall 0xc03945b0 ran for 0 msecs: init_clocksource_sysfs+0x0/0x80()
Calling initcall 0xc0394658: init_timer_list_procfs+0x0/0x4c()
initcall 0xc0394658: init_timer_list_procfs+0x0/0x4c() returned 0.
initcall 0xc0394658 ran for 0 msecs: init_timer_list_procfs+0x0/0x4c()
Calling initcall 0xc0394744: init+0x0/0xc8()
initcall 0xc0394744: init+0x0/0xc8() returned 0.
initcall 0xc0394744 ran for 0 msecs: init+0x0/0xc8()
Calling initcall 0xc039480c: proc_dma_init+0x0/0x48()
initcall 0xc039480c: proc_dma_init+0x0/0x48() returned 0.
initcall 0xc039480c ran for 0 msecs: proc_dma_init+0x0/0x48()
Calling initcall 0xc0394854: kallsyms_init+0x0/0x48()
initcall 0xc0394854: kallsyms_init+0x0/0x48() returned 0.
initcall 0xc0394854 ran for 0 msecs: kallsyms_init+0x0/0x48()
Calling initcall 0xc03949a8: audit_init+0x0/0x158()
audit: initializing netlink socket (disabled)
type=2000 audit(2.290:1): initialized
initcall 0xc03949a8: audit_init+0x0/0x158() returned 0.
initcall 0xc03949a8 ran for 7 msecs: audit_init+0x0/0x158()
Calling initcall 0xc0394bc4: audit_tree_init+0x0/0x6c()
initcall 0xc0394bc4: audit_tree_init+0x0/0x6c() returned 0.
initcall 0xc0394bc4 ran for 0 msecs: audit_tree_init+0x0/0x6c()
Calling initcall 0xc0394dfc: relay_init+0x0/0x8()
initcall 0xc0394dfc: relay_init+0x0/0x8() returned 0.
initcall 0xc0394dfc ran for 0 msecs: relay_init+0x0/0x8()
Calling initcall 0xc0394e04: utsname_sysctl_init+0x0/0x2c()
initcall 0xc0394e04: utsname_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc0394e04 ran for 0 msecs: utsname_sysctl_init+0x0/0x2c()
Calling initcall 0xc0395cf8: init_per_zone_pages_min+0x0/0x5c()
initcall 0xc0395cf8: init_per_zone_pages_min+0x0/0x5c() returned 0.
initcall 0xc0395cf8 ran for 0 msecs: init_per_zone_pages_min+0x0/0x5c()
Calling initcall 0xc03968e8: pdflush_init+0x0/0x3c()
initcall 0xc03968e8: pdflush_init+0x0/0x3c() returned 0.
initcall 0xc03968e8 ran for 0 msecs: pdflush_init+0x0/0x3c()
Calling initcall 0xc03969a4: kswapd_init+0x0/0x2c()
initcall 0xc03969a4: kswapd_init+0x0/0x2c() returned 0.
initcall 0xc03969a4 ran for 0 msecs: kswapd_init+0x0/0x2c()
Calling initcall 0xc0396aa0: init_emergency_pool+0x0/0x88()
highmem bounce pool size: 64 pages
initcall 0xc0396aa0: init_emergency_pool+0x0/0x88() returned 0.
initcall 0xc0396aa0 ran for 3 msecs: init_emergency_pool+0x0/0x88()
Calling initcall 0xc0396b28: procswaps_init+0x0/0x48()
initcall 0xc0396b28: procswaps_init+0x0/0x48() returned 0.
initcall 0xc0396b28 ran for 0 msecs: procswaps_init+0x0/0x48()
Calling initcall 0xc0396b70: init_tmpfs+0x0/0xcc()
initcall 0xc0396b70: init_tmpfs+0x0/0xcc() returned 0.
initcall 0xc0396b70 ran for 0 msecs: init_tmpfs+0x0/0xcc()
Calling initcall 0xc0396e34: slab_sysfs_init+0x0/0x118()
initcall 0xc0396e34: slab_sysfs_init+0x0/0x118() returned 0.
initcall 0xc0396e34 ran for 5 msecs: slab_sysfs_init+0x0/0x118()
Calling initcall 0xc03971c0: fasync_init+0x0/0x44()
initcall 0xc03971c0: fasync_init+0x0/0x44() returned 0.
initcall 0xc03971c0 ran for 0 msecs: fasync_init+0x0/0x44()
Calling initcall 0xc03978bc: aio_setup+0x0/0x94()
initcall 0xc03978bc: aio_setup+0x0/0x94() returned 0.
initcall 0xc03978bc ran for 0 msecs: aio_setup+0x0/0x94()
Calling initcall 0xc0397b6c: inotify_setup+0x0/0x14()
initcall 0xc0397b6c: inotify_setup+0x0/0x14() returned 0.
initcall 0xc0397b6c ran for 0 msecs: inotify_setup+0x0/0x14()
Calling initcall 0xc0397b80: inotify_user_setup+0x0/0xe8()
initcall 0xc0397b80: inotify_user_setup+0x0/0xe8() returned 0.
initcall 0xc0397b80 ran for 0 msecs: inotify_user_setup+0x0/0xe8()
Calling initcall 0xc0397e00: init_mbcache+0x0/0x2c()
initcall 0xc0397e00: init_mbcache+0x0/0x2c() returned 0.
initcall 0xc0397e00 ran for 0 msecs: init_mbcache+0x0/0x2c()
Calling initcall 0xc0397e2c: dquot_init+0x0/0x114()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc0397e2c: dquot_init+0x0/0x114() returned 0.
initcall 0xc0397e2c ran for 7 msecs: dquot_init+0x0/0x114()
Calling initcall 0xc0397f40: dnotify_init+0x0/0x44()
initcall 0xc0397f40: dnotify_init+0x0/0x44() returned 0.
initcall 0xc0397f40 ran for 0 msecs: dnotify_init+0x0/0x44()
Calling initcall 0xc0398630: init_devpts_fs+0x0/0x64()
initcall 0xc0398630: init_devpts_fs+0x0/0x64() returned 0.
initcall 0xc0398630 ran for 0 msecs: init_devpts_fs+0x0/0x64()
Calling initcall 0xc0398694: init_ext3_fs+0x0/0x5c()
initcall 0xc0398694: init_ext3_fs+0x0/0x5c() returned 0.
initcall 0xc0398694 ran for 0 msecs: init_ext3_fs+0x0/0x5c()
Calling initcall 0xc03988a4: journal_init+0x0/0x38()
initcall 0xc03988a4: journal_init+0x0/0x38() returned 0.
initcall 0xc03988a4 ran for 0 msecs: journal_init+0x0/0x38()
Calling initcall 0xc03988dc: init_ext2_fs+0x0/0x5c()
initcall 0xc03988dc: init_ext2_fs+0x0/0x5c() returned 0.
initcall 0xc03988dc ran for 0 msecs: init_ext2_fs+0x0/0x5c()
Calling initcall 0xc0398994: init_cramfs_fs+0x0/0x4c()
initcall 0xc0398994: init_cramfs_fs+0x0/0x4c() returned 0.
initcall 0xc0398994 ran for 0 msecs: init_cramfs_fs+0x0/0x4c()
Calling initcall 0xc03989e0: init_ramfs_fs+0x0/0x28()
initcall 0xc03989e0: init_ramfs_fs+0x0/0x28() returned 0.
initcall 0xc03989e0 ran for 0 msecs: init_ramfs_fs+0x0/0x28()
Calling initcall 0xc0398ad4: ipc_init+0x0/0x2c()
initcall 0xc0398ad4: ipc_init+0x0/0x2c() returned 0.
initcall 0xc0398ad4 ran for 0 msecs: ipc_init+0x0/0x2c()
Calling initcall 0xc0398c68: ipc_sysctl_init+0x0/0x2c()
initcall 0xc0398c68: ipc_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc0398c68 ran for 0 msecs: ipc_sysctl_init+0x0/0x2c()
Calling initcall 0xc0398c94: init_mqueue_fs+0x0/0xe8()
initcall 0xc0398c94: init_mqueue_fs+0x0/0xe8() returned 0.
initcall 0xc0398c94 ran for 0 msecs: init_mqueue_fs+0x0/0xe8()
Calling initcall 0xc0398f0c: key_proc_init+0x0/0x54()
initcall 0xc0398f0c: key_proc_init+0x0/0x54() returned 0.
initcall 0xc0398f0c ran for 0 msecs: key_proc_init+0x0/0x54()
Calling initcall 0xc0398f60: crypto_algapi_init+0x0/0x24()
initcall 0xc0398f60: crypto_algapi_init+0x0/0x24() returned 0.
initcall 0xc0398f60 ran for 0 msecs: crypto_algapi_init+0x0/0x24()
Calling initcall 0xc0398fc8: cryptomgr_init+0x0/0x28()
initcall 0xc0398fc8: cryptomgr_init+0x0/0x28() returned 0.
initcall 0xc0398fc8 ran for 0 msecs: cryptomgr_init+0x0/0x28()
Calling initcall 0xc0398ff0: hmac_module_init+0x0/0x28()
initcall 0xc0398ff0: hmac_module_init+0x0/0x28() returned 0.
initcall 0xc0398ff0 ran for 0 msecs: hmac_module_init+0x0/0x28()
Calling initcall 0xc0399018: init+0x0/0x28()
initcall 0xc0399018: init+0x0/0x28() returned 0.
initcall 0xc0399018 ran for 0 msecs: init+0x0/0x28()
Calling initcall 0xc03993d8: noop_init+0x0/0x2c()
io scheduler noop registered
initcall 0xc03993d8: noop_init+0x0/0x2c() returned 0.
initcall 0xc03993d8 ran for 2 msecs: noop_init+0x0/0x2c()
Calling initcall 0xc0399404: as_init+0x0/0x2c()
io scheduler anticipatory registered
initcall 0xc0399404: as_init+0x0/0x2c() returned 0.
initcall 0xc0399404 ran for 3 msecs: as_init+0x0/0x2c()
Calling initcall 0xc0399430: deadline_init+0x0/0x2c()
io scheduler deadline registered
initcall 0xc0399430: deadline_init+0x0/0x2c() returned 0.
initcall 0xc0399430 ran for 2 msecs: deadline_init+0x0/0x2c()
Calling initcall 0xc03994e0: cfq_init+0x0/0x70()
io scheduler cfq registered (default)
initcall 0xc03994e0: cfq_init+0x0/0x70() returned 0.
initcall 0xc03994e0 ran for 3 msecs: cfq_init+0x0/0x70()
Calling initcall 0xc02c4678: 0xc02c4678()
pci 0000:00:00.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:00.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:01.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:01.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:06.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:06.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.1: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.2: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.2: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.3: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.3: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.4: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.4: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.5: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.5: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:07.6: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.6: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:08.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:08.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:08.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:08.1: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:09.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:09.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.1: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:0a.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:0a.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.1: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:0a.2: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.2: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:0a.3: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.3: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:00:0a.4: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.4: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:01:00.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.0: calling quirk 0xc02ce614: 0xc02ce614()
pci 0000:01:00.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.1: calling quirk 0xc02ce614: 0xc02ce614()
initcall 0xc02c4678: 0xc02c4678() returned 0.
initcall 0xc02c4678 ran for 235 msecs: 0xc02c4678()
Calling initcall 0xc0399f70: pci_proc_init+0x0/0x9c()
initcall 0xc0399f70: pci_proc_init+0x0/0x9c() returned 0.
initcall 0xc0399f70 ran for 0 msecs: pci_proc_init+0x0/0x9c()
Calling initcall 0xc039a00c: pcie_portdrv_init+0x0/0x6c()
initcall 0xc039a00c: pcie_portdrv_init+0x0/0x6c() returned 0.
initcall 0xc039a00c ran for 0 msecs: pcie_portdrv_init+0x0/0x6c()
Calling initcall 0xc039a078: aer_service_init+0x0/0x44()
initcall 0xc039a078: aer_service_init+0x0/0x44() returned 0.
initcall 0xc039a078 ran for 0 msecs: aer_service_init+0x0/0x44()
Calling initcall 0xc039a418: fb_console_init+0x0/0xb0()
initcall 0xc039a418: fb_console_init+0x0/0xb0() returned 0.
initcall 0xc039a418 ran for 0 msecs: fb_console_init+0x0/0xb0()
Calling initcall 0xc039a9b8: radeonfb_init+0x0/0x68()
radeonfb (0000:01:00.0): Cannot match card to OF node !
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=250.00 Mhz, System=200.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 200x75
radeonfb (0000:01:00.0): ATI Radeon Ya 
initcall 0xc039a9b8: radeonfb_init+0x0/0x68() returned 0.
initcall 0xc039a9b8 ran for 4552 msecs: radeonfb_init+0x0/0x68()
Calling initcall 0xc039ab2c: rand_initialize+0x0/0x44()
initcall 0xc039ab2c: rand_initialize+0x0/0x44() returned 0.
initcall 0xc039ab2c ran for 0 msecs: rand_initialize+0x0/0x44()
Calling initcall 0xc039abd0: tty_init+0x0/0x208()
initcall 0xc039abd0: tty_init+0x0/0x208() returned 0.
initcall 0xc039abd0 ran for 6 msecs: tty_init+0x0/0x208()
Calling initcall 0xc039b1f8: pty_init+0x0/0x28()
initcall 0xc039b1f8: pty_init+0x0/0x28() returned 0.
initcall 0xc039b1f8 ran for 3 msecs: pty_init+0x0/0x28()
Calling initcall 0xc039b970: drm_core_init+0x0/0x168()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc039b970: drm_core_init+0x0/0x168() returned 0.
initcall 0xc039b970 ran for 3 msecs: drm_core_init+0x0/0x168()
Calling initcall 0xc039bad8: radeon_init+0x0/0x38()
[drm:drm_init] 
[drm:drm_get_dev] 
[drm:radeon_driver_load] AGP card detected
[drm:drm_get_head] 
[drm:drm_get_head] new minor assigned 0
[drm] Initialized radeon 1.28.0 20060524 on minor 0
initcall 0xc039bad8: radeon_init+0x0/0x38() returned 0.
initcall 0xc039bad8 ran for 16 msecs: radeon_init+0x0/0x38()
Calling initcall 0xc039bfc4: serial8250_init+0x0/0xfc()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250.0: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
console [ttyS0] enabled
serial8250.0: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xc039bfc4: serial8250_init+0x0/0xfc() returned 0.
initcall 0xc039bfc4 ran for 53576 msecs: serial8250_init+0x0/0xfc()
Calling initcall 0xc039c0f0: serial8250_pci_init+0x0/0x34()
initcall 0xc039c0f0: serial8250_pci_init+0x0/0x34() returned 0.
initcall 0xc039c0f0 ran for 0 msecs: serial8250_pci_init+0x0/0x34()
Calling initcall 0xc039c6cc: parport_default_proc_register+0x0/0x3c()
initcall 0xc039c6cc: parport_default_proc_register+0x0/0x3c() returned 0.
initcall 0xc039c6cc ran for 0 msecs: parport_default_proc_register+0x0/0x3c()
Calling initcall 0xc039cbd4: parport_pc_init+0x0/0xf4()
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378
initcall 0xc039cbd4: parport_pc_init+0x0/0xf4() returned 0.
initcall 0xc039cbd4 ran for 157 msecs: parport_pc_init+0x0/0xf4()
Calling initcall 0xc039ccc8: parport_serial_init+0x0/0x34()
initcall 0xc039ccc8: parport_serial_init+0x0/0x34() returned 0.
initcall 0xc039ccc8 ran for 0 msecs: parport_serial_init+0x0/0x34()
Calling initcall 0xc039d67c: floppy_init+0x0/0x664()
Floppy drive(s): fd0 is 2.88M
FDC 0 is a post-1991 82077
initcall 0xc039d67c: floppy_init+0x0/0x664() returned 0.
initcall 0xc039d67c ran for 37 msecs: floppy_init+0x0/0x664()
Calling initcall 0xc039dce0: brd_init+0x0/0x198()
brd: module loaded
initcall 0xc039dce0: brd_init+0x0/0x198() returned 0.
initcall 0xc039dce0 ran for 10 msecs: brd_init+0x0/0x198()
Calling initcall 0xc039df2c: vortex_init+0x0/0x90()
3c59x: Donald Becker and others.
0000:00:06.0: 3Com PCI 3c905C Tornado at f100c000.
initcall 0xc039df2c: vortex_init+0x0/0x90() returned 0.
initcall 0xc039df2c ran for 46 msecs: vortex_init+0x0/0x90()
Calling initcall 0xc039e130: net_olddevs_init+0x0/0x40()
initcall 0xc039e130: net_olddevs_init+0x0/0x40() returned 0.
initcall 0xc039e130 ran for 0 msecs: net_olddevs_init+0x0/0x40()
Calling initcall 0xc039e22c: cp_init+0x0/0x34()
initcall 0xc039e22c: cp_init+0x0/0x34() returned 0.
initcall 0xc039e22c ran for 0 msecs: cp_init+0x0/0x34()
Calling initcall 0xc039e478: ide_init+0x0/0xa4()
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
initcall 0xc039e478: ide_init+0x0/0xa4() returned 0.
initcall 0xc039e478 ran for 31 msecs: ide_init+0x0/0xa4()
Calling initcall 0xc039eaf0: it8213_ide_init+0x0/0x34()
initcall 0xc039eaf0: it8213_ide_init+0x0/0x34() returned 0.
initcall 0xc039eaf0 ran for 0 msecs: it8213_ide_init+0x0/0x34()
Calling initcall 0xc039eb24: it821x_ide_init+0x0/0x34()
initcall 0xc039eb24: it821x_ide_init+0x0/0x34() returned 0.
initcall 0xc039eb24 ran for 0 msecs: it821x_ide_init+0x0/0x34()
Calling initcall 0xc039eb58: pdc202xx_ide_init+0x0/0x34()
initcall 0xc039eb58: pdc202xx_ide_init+0x0/0x34() returned 0.
initcall 0xc039eb58 ran for 0 msecs: pdc202xx_ide_init+0x0/0x34()
Calling initcall 0xc039eb8c: pdc202new_ide_init+0x0/0x34()
initcall 0xc039eb8c: pdc202new_ide_init+0x0/0x34() returned 0.
initcall 0xc039eb8c ran for 0 msecs: pdc202new_ide_init+0x0/0x34()
Calling initcall 0xc039ebc0: siimage_ide_init+0x0/0x34()
initcall 0xc039ebc0: siimage_ide_init+0x0/0x34() returned 0.
initcall 0xc039ebc0 ran for 0 msecs: siimage_ide_init+0x0/0x34()
Calling initcall 0xc039ebf4: via_ide_init+0x0/0x34()
initcall 0xc039ebf4: via_ide_init+0x0/0x34() returned 0.
initcall 0xc039ebf4 ran for 0 msecs: via_ide_init+0x0/0x34()
Calling initcall 0xc039ecd0: ide_scan_pcibus+0x0/0x10c()
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:07.1
pci 0000:00:07.1: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xcc00-0xcc07, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0xcc08-0xcc0f, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: ST380011A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdd: LITE-ON LTR-52327S, ATAPI CD/DVD-ROM drive
hdc: TOSHIBA ODD-DVD SD-M1802, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
initcall 0xc039ecd0: ide_scan_pcibus+0x0/0x10c() returned 0.
initcall 0xc039ecd0 ran for 8976 msecs: ide_scan_pcibus+0x0/0x10c()
Calling initcall 0xc039eddc: idedisk_init+0x0/0x28()
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: RDSK (512) hda1 (SFS^@)(res 2 spb 1) hda2 (LNX^@)(res 2 spb 2) hda3 (LNX^@)(res 2 spb 2) hda4 (LNX^@)(res 2 spb 2) hda5 (LNX^@)(res 2 spb 2) hda6 (SWP^@)(res 2 spb 2) hda7 (LNX^@)(res 2 spb 2) hda8 (DOS^C)(res 2 spb 2) hda9 (SFS^@)(res 2 spb 1) hda10 (SFS^@)(res 2 spb 1) hda11 (LNX^@)(res 2 spb 2) hda12 (LNX^@)(res 2 spb 2)
initcall 0xc039eddc: idedisk_init+0x0/0x28() returned 0.
initcall 0xc039eddc ran for 127 msecs: idedisk_init+0x0/0x28()
Calling initcall 0xc039ee04: ide_cdrom_init+0x0/0x28()
hdc: ATAPI 48X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
initcall 0xc039ee04: ide_cdrom_init+0x0/0x28() returned 0.
initcall 0xc039ee04 ran for 49 msecs: ide_cdrom_init+0x0/0x28()
Calling initcall 0xc039f218: ieee1394_init+0x0/0x280()
initcall 0xc039f218: ieee1394_init+0x0/0x280() returned 0.
initcall 0xc039f218 ran for 0 msecs: ieee1394_init+0x0/0x280()
Calling initcall 0xc039f498: cdrom_init+0x0/0x24()
initcall 0xc039f498: cdrom_init+0x0/0x24() returned 0.
initcall 0xc039f498 ran for 0 msecs: cdrom_init+0x0/0x24()
Calling initcall 0xc039f748: mon_init+0x0/0xd8()
initcall 0xc039f748: mon_init+0x0/0xd8() returned 0.
initcall 0xc039f748 ran for 0 msecs: mon_init+0x0/0xd8()
Calling initcall 0xc039f95c: ohci_hcd_mod_init+0x0/0x94()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0a.0: irq 7, io mem 0x98103000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd 0000:00:0a.1: OHCI Host Controller
ohci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.1: irq 7, io mem 0x98104000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd 0000:00:0a.2: OHCI Host Controller
ohci_hcd 0000:00:0a.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:0a.2: irq 7, io mem 0x98105000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
initcall 0xc039f95c: ohci_hcd_mod_init+0x0/0x94() returned 0.
initcall 0xc039f95c ran for 730 msecs: ohci_hcd_mod_init+0x0/0x94()
Calling initcall 0xc039f9f0: uhci_hcd_init+0x0/0xd8()
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:07.2: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:07.2: irq 5, io base 0x00802080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:07.3: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:07.3: irq 5, io base 0x008020a0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
initcall 0xc039f9f0: uhci_hcd_init+0x0/0xd8() returned 0.
initcall 0xc039f9f0 ran for 422 msecs: uhci_hcd_init+0x0/0xd8()
Calling initcall 0xc039fb6c: i8042_init+0x0/0x10c()
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc039fb6c: i8042_init+0x0/0x10c() returned 0.
initcall 0xc039fb6c ran for 28 msecs: i8042_init+0x0/0x10c()
Calling initcall 0xc039fdf4: mousedev_init+0x0/0xb4()
mice: PS/2 mouse device common for all mice
initcall 0xc039fdf4: mousedev_init+0x0/0xb4() returned 0.
initcall 0xc039fdf4 ran for 14 msecs: mousedev_init+0x0/0xb4()
Calling initcall 0xc039febc: atkbd_init+0x0/0x34()
initcall 0xc039febc: atkbd_init+0x0/0x34() returned 0.
initcall 0xc039febc ran for 0 msecs: atkbd_init+0x0/0x34()
Calling initcall 0xc039fef0: psmouse_init+0x0/0x94()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc039fef0: psmouse_init+0x0/0x94() returned 0.
initcall 0xc039fef0 ran for 4458 msecs: psmouse_init+0x0/0x94()
Calling initcall 0xc039ff84: pcspkr_init+0x0/0x28()
input: PC Speaker as /class/input/input1
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
initcall 0xc039ff84: pcspkr_init+0x0/0x28() returned 0.
initcall 0xc039ff84 ran for 644 msecs: pcspkr_init+0x0/0x28()
Calling initcall 0xc03a01e4: cmos_init+0x0/0x30()
rtc_cmos: dev (254:0)
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
initcall 0xc03a01e4: cmos_init+0x0/0x30() returned 0.
initcall 0xc03a01e4 ran for 35 msecs: cmos_init+0x0/0x30()
Calling initcall 0xc03a0800: i2c_dev_init+0x0/0xbc()
i2c /dev entries driver
initcall 0xc03a0800: i2c_dev_init+0x0/0xbc() returned 0.
initcall 0xc03a0800 ran for 10 msecs: i2c_dev_init+0x0/0xbc()
Calling initcall 0xc03a0994: ledtrig_ide_init+0x0/0x34()
initcall 0xc03a0994: ledtrig_ide_init+0x0/0x34() returned 0.
initcall 0xc03a0994 ran for 0 msecs: ledtrig_ide_init+0x0/0x34()
Calling initcall 0xc03a09c8: hid_init+0x0/0x8()
initcall 0xc03a09c8: hid_init+0x0/0x8() returned 0.
initcall 0xc03a09c8 ran for 0 msecs: hid_init+0x0/0x8()
Calling initcall 0xc03a09d0: init_soundcore+0x0/0x7c()
initcall 0xc03a09d0: init_soundcore+0x0/0x7c() returned 0.
initcall 0xc03a09d0 ran for 0 msecs: init_soundcore+0x0/0x7c()
Calling initcall 0xc03a0d38: sysctl_core_init+0x0/0x28()
initcall 0xc03a0d38: sysctl_core_init+0x0/0x28() returned 0.
initcall 0xc03a0d38 ran for 0 msecs: sysctl_core_init+0x0/0x28()
Calling initcall 0xc03a1428: flow_cache_init+0x0/0xcc()
initcall 0xc03a1428: flow_cache_init+0x0/0xcc() returned 0.
initcall 0xc03a1428 ran for 0 msecs: flow_cache_init+0x0/0xcc()
Calling initcall 0xc03a16d8: blackhole_module_init+0x0/0x28()
initcall 0xc03a16d8: blackhole_module_init+0x0/0x28() returned 0.
initcall 0xc03a16d8 ran for 0 msecs: blackhole_module_init+0x0/0x28()
Calling initcall 0xc03a2f2c: sysctl_ipv4_init+0x0/0x48()
initcall 0xc03a2f2c: sysctl_ipv4_init+0x0/0x48() returned 0.
initcall 0xc03a2f2c ran for 0 msecs: sysctl_ipv4_init+0x0/0x48()
Calling initcall 0xc03a3238: init_syncookies+0x0/0x30()
initcall 0xc03a3238: init_syncookies+0x0/0x30() returned 0.
initcall 0xc03a3238 ran for 0 msecs: init_syncookies+0x0/0x30()
Calling initcall 0xc03a3268: xfrm4_beet_init+0x0/0x2c()
initcall 0xc03a3268: xfrm4_beet_init+0x0/0x2c() returned 0.
initcall 0xc03a3268 ran for 0 msecs: xfrm4_beet_init+0x0/0x2c()
Calling initcall 0xc02a62f8: ipv4_netfilter_init+0x0/0x28()
initcall 0xc02a62f8: ipv4_netfilter_init+0x0/0x28() returned 0.
initcall 0xc02a62f8 ran for 0 msecs: ipv4_netfilter_init+0x0/0x28()
Calling initcall 0xc03a3294: bictcp_register+0x0/0x28()
TCP bic registered
initcall 0xc03a3294: bictcp_register+0x0/0x28() returned 0.
initcall 0xc03a3294 ran for 9 msecs: bictcp_register+0x0/0x28()
Calling initcall 0xc03a3558: af_unix_init+0x0/0x70()
NET: Registered protocol family 1
initcall 0xc03a3558: af_unix_init+0x0/0x70() returned 0.
initcall 0xc03a3558 ran for 12 msecs: af_unix_init+0x0/0x70()
Calling initcall 0xc03a35c8: packet_init+0x0/0x64()
NET: Registered protocol family 17
initcall 0xc03a35c8: packet_init+0x0/0x64() returned 0.
initcall 0xc03a35c8 ran for 12 msecs: packet_init+0x0/0x64()
Calling initcall 0xc03a383c: atm_clip_init+0x0/0xb4()
initcall 0xc03a383c: atm_clip_init+0x0/0xb4() returned 0.
initcall 0xc03a383c ran for 0 msecs: atm_clip_init+0x0/0xb4()
Calling initcall 0xc038d284: check_cache_coherency+0x0/0x80()
initcall 0xc038d284: check_cache_coherency+0x0/0x80() returned 0.
initcall 0xc038d284 ran for 0 msecs: check_cache_coherency+0x0/0x80()
Calling initcall 0xc001dacc: init_oops_id+0x0/0x40()
initcall 0xc001dacc: init_oops_id+0x0/0x40() returned 0.
initcall 0xc001dacc ran for 0 msecs: init_oops_id+0x0/0x40()
Calling initcall 0xc0393150: disable_boot_consoles+0x0/0x6c()
initcall 0xc0393150: disable_boot_consoles+0x0/0x6c() returned 0.
initcall 0xc0393150 ran for 0 msecs: disable_boot_consoles+0x0/0x6c()
Calling initcall 0xc0394288: pm_qos_power_init+0x0/0x88()
initcall 0xc0394288: pm_qos_power_init+0x0/0x88() returned 0.
initcall 0xc0394288 ran for 0 msecs: pm_qos_power_init+0x0/0x88()
Calling initcall 0xc03996f4: random32_reseed+0x0/0x3c()
initcall 0xc03996f4: random32_reseed+0x0/0x3c() returned 0.
initcall 0xc03996f4 ran for 0 msecs: random32_reseed+0x0/0x3c()
Calling initcall 0xc0399f00: pci_sysfs_init+0x0/0x70()
initcall 0xc0399f00: pci_sysfs_init+0x0/0x70() returned 0.
initcall 0xc0399f00 ran for 0 msecs: pci_sysfs_init+0x0/0x70()
Calling initcall 0xc039ab04: seqgen_init+0x0/0x28()
initcall 0xc039ab04: seqgen_init+0x0/0x28() returned 0.
initcall 0xc039ab04 ran for 0 msecs: seqgen_init+0x0/0x28()
Calling initcall 0xc01e0fec: scsi_complete_async_scans+0x0/0xf0()
initcall 0xc01e0fec: scsi_complete_async_scans+0x0/0xf0() returned 0.
initcall 0xc01e0fec ran for 0 msecs: scsi_complete_async_scans+0x0/0xf0()
Calling initcall 0xc039ffac: rtc_hctosys+0x0/0x140()
rtc_cmos rtc_cmos: setting system clock to 2008-03-02 22:16:53 UTC (1204496213)
initcall 0xc039ffac: rtc_hctosys+0x0/0x140() returned 0.
initcall 0xc039ffac ran for 20 msecs: rtc_hctosys+0x0/0x140()
Calling initcall 0xc03a2460: tcp_congestion_default+0x0/0xc()
initcall 0xc03a2460: tcp_congestion_default+0x0/0xc() returned 0.
initcall 0xc03a2460 ran for 0 msecs: tcp_congestion_default+0x0/0xc()
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 176k init
vt596_smbus 0000:00:07.4: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
gameport: EMU10K1 is pci0000:00:09.1/gameport0, io 0x802420, speed 1185kHz
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[9]  MMIO=[98106800-98106fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ALSA sound/pci/bt87x.c:931: bt87x0: Using board 1, analog, digital (rate 32000 Hz)
VIA 82xx Modem 0000:00:07.6: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
ALSA sound/pci/via82xx_modem.c:989: AC'97 codec is not ready [0x19191919]
PCI: Enabling bus mastering for device 0000:00:07.6
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090e639000006f1]
VIA 82xx Modem: probe of 0000:00:07.6 failed with error -13
VIA 82xx Audio 0000:00:07.5: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
ALSA sound/pci/via82xx.c:2102: AC'97 codec is not ready [0xffffffff]
PCI: Enabling bus mastering for device 0000:00:07.5
VIA 82xx Audio: probe of 0000:00:07.5 failed with error -13
Adding 1572880k swap on /dev/hda6.  Priority:-1 extents:1 across:1572880k
EXT3 FS on hda11, internal journal
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
eth0:  setting full-duplex.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
lp0: using parport0 (polling).
ppdev: user-space parallel port driver
eth0: no IPv6 routers present
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
NET: Registered protocol family 5
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2496, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2496, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2496, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2496, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2496, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2496, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2496, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2496, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2496, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2496, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2496, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_mmap_locked] start = 0x48025000, end = 0x48027000, page offset = 0xf215f
[drm:drm_vm_open_locked] 0x48025000,0x00002000
[drm:drm_do_vm_shm_fault] shm_fault 0x0
eth0: no IPv6 routers present
[drm:drm_do_vm_shm_fault] shm_fault 0x1000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_ioctl] pid=2496, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0x80086438, nr=0x38, dev 0xe200, auth=1
[drm:drm_sg_alloc] 
[drm:drm_sg_alloc] size=8388608 pages=2048
[drm:drm_sg_alloc] handle  = f24fb000
[drm:drm_sg_alloc] virtual = f24fb000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00101000, type = 4
[drm:drm_mmap_locked] start = 0x50061000, end = 0x50162000, page offset = 0xf24fb
[drm:drm_vm_open_locked] 0x50061000,0x00101000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00101000, size = 0x00001000, type = 4
[drm:drm_mmap_locked] start = 0x48027000, end = 0x48028000, page offset = 0xf25fc
[drm:drm_vm_open_locked] 0x48027000,0x00001000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00102000, size = 0x00200000, type = 4
[drm:drm_mmap_locked] start = 0x50162000, end = 0x50362000, page offset = 0xf25fd
[drm:drm_vm_open_locked] 0x50162000,0x00200000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00302000, size = 0x004e0000, type = 4
[drm:drm_mmap_locked] start = 0x50362000, end = 0x50842000, page offset = 0xf27fd
[drm:drm_vm_open_locked] 0x50362000,0x004e0000
[drm:drm_ioctl] pid=2496, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_ioctl] pid=2496, cmd=0x80106459, nr=0x59, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0xc0086420, nr=0x20, dev 0xe200, auth=1
[drm:drm_addctx] 1
[drm:drm_ioctl] pid=2496, cmd=0x80086422, nr=0x22, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2496, cmd=0x8008642a, nr=0x2a, dev 0xe200, auth=1
[drm:drm_lock] 1 (pid 2496) requests lock (0x00000000), flags = 0x00000000
[drm:drm_lock] 1 has lock
[drm:drm_fasync] fd = 6, device = 0xe200
[drm:drm_ioctl] pid=2496, cmd=0x80546440, nr=0x40, dev 0xe200, auth=1
[drm:radeon_do_init_cp] 
[drm:radeon_do_init_cp] Forcing AGP card to PCI mode
[drm:radeon_do_init_cp] dev_priv->cp_ring->handle f24fb000
[drm:radeon_do_init_cp] dev_priv->ring_rptr->handle f25fc000
[drm:radeon_do_init_cp] dev->agp_buffer_map->handle f25fd000
[drm] Setting GART location based on new memory map
[drm:radeon_do_init_cp] dev_priv->gart_size 8388608
[drm:radeon_do_init_cp] dev_priv->gart_vm_start 0x88000000
[drm:radeon_do_init_cp] dev_priv->gart_buffers_offset 0x88102000
[drm:drm_ati_pcigart_init] PCI: no table in VRAM: using normal RAM
[drm:drm_ati_alloc_pcigart_table] 3 order
[drm:drm_ati_alloc_pcigart_table] returning 0xee838000
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#1]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_via82xx_modem snd_bt87x snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_hwdep snd_rawmidi snd_pcm snd_timer snd_seq_device ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: eef7fd80 TRAP: 0300   Not tainted  (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044422  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = eef7c000[2496] 'Xorg' THREAD: eef7e000
GPR00: c0183f88 eef7fe30 eef7c000 00000000 00000080 0000001f ee83fffc c03b0000 
GPR08: 00009032 c0408cb8 c0404f80 c0408cb8 1e00d855 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00008000 2e838000 00000000 efa51400 
GPR24: eef9f6a0 ee838000 ee834000 00000800 00002000 efa51adc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[eef7fe30] [c0183c4c] drm_ati_alloc_pcigart_table+0xa8/0xc0 (unreliable)
[eef7fe40] [c0183f88] drm_ati_pcigart_init+0x18c/0x2d8
[eef7fe80] [c0188604] radeon_do_init_cp+0x7f0/0x86c
[eef7fea0] [c017f90c] drm_ioctl+0x214/0x314
[eef7fed0] [c008e744] vfs_ioctl+0x6c/0x84
[eef7fee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[eef7ff10] [c008ebec] sys_ioctl+0x40/0x70
[eef7ff40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 9a1742ac98e201b1 ]---
[drm:drm_vm_shm_close] 0x48025000,0x00002000
[drm:drm_vm_close] 0x48027000,0x00001000
[drm:drm_vm_close] 0x50061000,0x00101000
[drm:drm_vm_close] 0x50162000,0x00200000
[drm:drm_vm_close] 0x50362000,0x004e0000
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2496, device = 0xe200, open_count = 1
[drm:drm_release] File eefdb180 released, freeing lock for context 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_release] *ERROR* Device busy: 1 0
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2694, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_setup] 
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2694, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2694, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2694, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2694, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2694, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2694, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2694, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2694, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2694, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2694, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_mmap_locked] start = 0x48025000, end = 0x48027000, page offset = 0xf215f
[drm:drm_vm_open_locked] 0x48025000,0x00002000
[drm:drm_do_vm_shm_fault] shm_fault 0x0
[drm:drm_do_vm_shm_fault] shm_fault 0x1000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_ioctl] pid=2694, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0x80086438, nr=0x38, dev 0xe200, auth=1
[drm:drm_sg_alloc] 
[drm:drm_sg_alloc] size=8388608 pages=2048
[drm:drm_sg_alloc] handle  = f24fb000
[drm:drm_sg_alloc] virtual = f24fb000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00101000, type = 4
[drm:drm_mmap_locked] start = 0x50061000, end = 0x50162000, page offset = 0xf24fb
[drm:drm_vm_open_locked] 0x50061000,0x00101000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00101000, size = 0x00001000, type = 4
[drm:drm_mmap_locked] start = 0x48027000, end = 0x48028000, page offset = 0xf25fc
[drm:drm_vm_open_locked] 0x48027000,0x00001000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00102000, size = 0x00200000, type = 4
[drm:drm_mmap_locked] start = 0x50162000, end = 0x50362000, page offset = 0xf25fd
[drm:drm_vm_open_locked] 0x50162000,0x00200000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00302000, size = 0x004e0000, type = 4
[drm:drm_mmap_locked] start = 0x50362000, end = 0x50842000, page offset = 0xf27fd
[drm:drm_vm_open_locked] 0x50362000,0x004e0000
[drm:drm_ioctl] pid=2694, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_ioctl] pid=2694, cmd=0x80106459, nr=0x59, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0xc0086420, nr=0x20, dev 0xe200, auth=1
[drm:drm_addctx] 1
[drm:drm_ioctl] pid=2694, cmd=0x80086422, nr=0x22, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2694, cmd=0x8008642a, nr=0x2a, dev 0xe200, auth=1
[drm:drm_lock] 1 (pid 2694) requests lock (0x00000000), flags = 0x00000000
[drm:drm_lock] 1 has lock
[drm:drm_fasync] fd = 6, device = 0xe200
[drm:drm_ioctl] pid=2694, cmd=0x80546440, nr=0x40, dev 0xe200, auth=1
[drm:radeon_do_init_cp] 
[drm:radeon_do_init_cp] dev_priv->cp_ring->handle f24fb000
[drm:radeon_do_init_cp] dev_priv->ring_rptr->handle f25fc000
[drm:radeon_do_init_cp] dev->agp_buffer_map->handle f25fd000
[drm] Setting GART location based on new memory map
[drm:radeon_do_init_cp] dev_priv->gart_size 8388608
[drm:radeon_do_init_cp] dev_priv->gart_vm_start 0x88000000
[drm:radeon_do_init_cp] dev_priv->gart_buffers_offset 0x88102000
[drm:drm_ati_pcigart_init] PCI: no table in VRAM: using normal RAM
[drm:drm_ati_alloc_pcigart_table] 3 order
[drm:drm_ati_alloc_pcigart_table] returning 0xee928000
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#2]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_via82xx_modem snd_bt87x snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_hwdep snd_rawmidi snd_pcm snd_timer snd_seq_device ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: ee871d80 TRAP: 0300   Tainted: G      D   (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044422  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = ee873900[2694] 'Xorg' THREAD: ee870000
GPR00: c0183f88 ee871e30 ee873900 00000000 00000080 0000001f ee92fffc c03b0000 
GPR08: 00009032 c0409148 c0405000 c0409148 cfa00d80 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00008000 2e928000 00000000 efa51400 
GPR24: ee880760 ee928000 ee834000 00000800 00002000 efa51adc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[ee871e30] [c0183c4c] drm_ati_alloc_pcigart_table+0xa8/0xc0 (unreliable)
[ee871e40] [c0183f88] drm_ati_pcigart_init+0x18c/0x2d8
[ee871e80] [c0188604] radeon_do_init_cp+0x7f0/0x86c
[ee871ea0] [c017f90c] drm_ioctl+0x214/0x314
[ee871ed0] [c008e744] vfs_ioctl+0x6c/0x84
[ee871ee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[ee871f10] [c008ebec] sys_ioctl+0x40/0x70
[ee871f40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 9a1742ac98e201b1 ]---
[drm:drm_vm_shm_close] 0x48025000,0x00002000
[drm:drm_vm_close] 0x48027000,0x00001000
[drm:drm_vm_close] 0x50061000,0x00101000
[drm:drm_vm_close] 0x50162000,0x00200000
[drm:drm_vm_close] 0x50362000,0x004e0000
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2694, device = 0xe200, open_count = 1
[drm:drm_release] File eefa5900 released, freeing lock for context 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_release] *ERROR* Device busy: 1 0
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2711, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_setup] 
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2711, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2711, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2711, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2711, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2711, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2711, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2711, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0246400, nr=0x00, dev 0xe200, auth=1
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2711, device = 0xe200, open_count = 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_lastclose] 
[drm:radeon_do_cleanup_cp] 
[drm:drm_lastclose] driver lastclose completed
[drm:drm_lastclose] lastclose completed
[drm:drm_stub_open] 
[drm:drm_open_helper] pid = 2711, minor = 0
[drm:radeon_driver_open] 
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_addmap_core] 8192 13 f215f000
[drm:drm_setup] 
[drm:drm_ioctl] pid=2711, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086401, nr=0x01, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0106407, nr=0x07, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00002000, type = 2
[drm:drm_mmap_locked] start = 0x48025000, end = 0x48027000, page offset = 0xf215f
[drm:drm_vm_open_locked] 0x48025000,0x00002000
[drm:drm_do_vm_shm_fault] shm_fault 0x0
[drm:drm_do_vm_shm_fault] shm_fault 0x1000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x80000000, size = 0x08000000, type = 0
[drm:drm_ioctl] pid=2711, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086426, nr=0x26, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0x80086438, nr=0x38, dev 0xe200, auth=1
[drm:drm_sg_alloc] 
[drm:drm_sg_alloc] size=8388608 pages=2048
[drm:drm_sg_alloc] handle  = f24fb000
[drm:drm_sg_alloc] virtual = f24fb000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00000000, size = 0x00101000, type = 4
[drm:drm_mmap_locked] start = 0x50061000, end = 0x50162000, page offset = 0xf24fb
[drm:drm_vm_open_locked] 0x50061000,0x00101000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00101000, size = 0x00001000, type = 4
[drm:drm_mmap_locked] start = 0x48027000, end = 0x48028000, page offset = 0xf25fc
[drm:drm_vm_open_locked] 0x48027000,0x00001000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00102000, size = 0x00200000, type = 4
[drm:drm_mmap_locked] start = 0x50162000, end = 0x50362000, page offset = 0xf25fd
[drm:drm_vm_open_locked] 0x50162000,0x00200000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x00302000, size = 0x004e0000, type = 4
[drm:drm_mmap_locked] start = 0x50362000, end = 0x50842000, page offset = 0xf27fd
[drm:drm_vm_open_locked] 0x50362000,0x004e0000
[drm:drm_ioctl] pid=2711, cmd=0xc0186415, nr=0x15, dev 0xe200, auth=1
[drm:drm_addmap_core] offset = 0x88000000, size = 0x00010000, type = 1
[drm:drm_ioctl] pid=2711, cmd=0x80106459, nr=0x59, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0xc0086420, nr=0x20, dev 0xe200, auth=1
[drm:drm_addctx] 1
[drm:drm_ioctl] pid=2711, cmd=0x80086422, nr=0x22, dev 0xe200, auth=1
[drm:drm_ioctl] pid=2711, cmd=0x8008642a, nr=0x2a, dev 0xe200, auth=1
[drm:drm_lock] 1 (pid 2711) requests lock (0x00000000), flags = 0x00000000
[drm:drm_lock] 1 has lock
[drm:drm_fasync] fd = 6, device = 0xe200
[drm:drm_ioctl] pid=2711, cmd=0x80546440, nr=0x40, dev 0xe200, auth=1
[drm:radeon_do_init_cp] 
[drm:radeon_do_init_cp] dev_priv->cp_ring->handle f24fb000
[drm:radeon_do_init_cp] dev_priv->ring_rptr->handle f25fc000
[drm:radeon_do_init_cp] dev->agp_buffer_map->handle f25fd000
[drm] Setting GART location based on new memory map
[drm:radeon_do_init_cp] dev_priv->gart_size 8388608
[drm:radeon_do_init_cp] dev_priv->gart_vm_start 0x88000000
[drm:radeon_do_init_cp] dev_priv->gart_buffers_offset 0x88102000
[drm:drm_ati_pcigart_init] PCI: no table in VRAM: using normal RAM
[drm:drm_ati_alloc_pcigart_table] 3 order
[drm:drm_ati_alloc_pcigart_table] returning 0xee930000
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#3]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_via82xx_modem snd_bt87x snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_hwdep snd_rawmidi snd_pcm snd_timer snd_seq_device ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: eef03d80 TRAP: 0300   Tainted: G      D   (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044422  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = ee894640[2711] 'Xorg' THREAD: eef02000
GPR00: c0183f88 eef03e30 ee894640 00000000 00000080 0000001f ee937ffc c03b0000 
GPR08: 00009032 c0408d18 c0405200 c0408d18 4065b2da 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00008000 2e930000 00000000 efa51400 
GPR24: ee880860 ee930000 ee834000 00000800 00002000 efa51adc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[eef03e30] [c0183c4c] drm_ati_alloc_pcigart_table+0xa8/0xc0 (unreliable)
[eef03e40] [c0183f88] drm_ati_pcigart_init+0x18c/0x2d8
[eef03e80] [c0188604] radeon_do_init_cp+0x7f0/0x86c
[eef03ea0] [c017f90c] drm_ioctl+0x214/0x314
[eef03ed0] [c008e744] vfs_ioctl+0x6c/0x84
[eef03ee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[eef03f10] [c008ebec] sys_ioctl+0x40/0x70
[eef03f40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 9a1742ac98e201b1 ]---
[drm:drm_vm_shm_close] 0x48025000,0x00002000
[drm:drm_vm_close] 0x48027000,0x00001000
[drm:drm_vm_close] 0x50061000,0x00101000
[drm:drm_vm_close] 0x50162000,0x00200000
[drm:drm_vm_close] 0x50362000,0x004e0000
[drm:drm_release] open_count = 1
[drm:drm_release] pid = 2711, device = 0xe200, open_count = 1
[drm:drm_release] File ee908600 released, freeing lock for context 1
[drm:drm_fasync] fd = -1, device = 0xe200
[drm:drm_release] *ERROR* Device busy: 1 0

--========GMX90211204497012566029
Content-Type: text/x-log; charset="iso-8859-15"; name="Xorg.0.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="Xorg.0.log"


X Window System Version 7.1.1
Release Date: 12 May 2006
X Protocol Version 11, Revision 0, Release 7.1.1
Build Operating System: UNKNOWN 
Current Operating System: Linux amigaone 2.6.25-rc3 #56 Sun Mar 2 23:14:13 CET 2008 ppc
Build Date: 24 January 2008
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Mar  2 23:18:13 2008
(==) Using config file: "/etc/X11/xorg.conf"
(==) ServerLayout "Default Layout"
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "LCD2080UXi"
(**) |   |-->Device "ATI Technologies Inc RV280 [Radeon 9200]"
(**) |-->Input Device "Generic Keyboard"
(**) |-->Input Device "Configured Mouse"
(WW) The directory "/usr/X11R6/lib/X11/fonts/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/100dpi/" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/75dpi/" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/Type1" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/X11R6/lib/X11/fonts/75dpi" does not exist.
	Entry deleted from font path.
(**) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType
(==) RgbPath set to "/etc/X11/rgb"
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) No APM support in BIOS or kernel
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.3
	X.Org Video Driver: 1.0
	X.Org XInput driver : 0.6
	X.Org Server Extension : 0.3
	X.Org Font Renderer : 0.5
(II) Loader running on linux
(II) LoadModule: "bitmap"
(II) Loading /usr/lib/xorg/modules/fonts/libbitmap.so
(II) Module bitmap: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font Bitmap
(II) LoadModule: "pcidata"
(II) Loading /usr/lib/xorg/modules/libpcidata.so
(II) Module pcidata: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(++) using VT number 7

(II) PCI: PCI scan (all values are in hex)
(II) PCI: 00:00:0: chip 10cc,0660 card 0000,0000 rev 01 class 06,00,00 hdr 00
(II) PCI: 00:01:0: chip 10cc,0661 card 0000,0000 rev 00 class 06,04,00 hdr 01
(II) PCI: 00:06:0: chip 10b7,9200 card 10b7,1000 rev 78 class 02,00,00 hdr 00
(II) PCI: 00:07:0: chip 1106,0686 card 0000,0000 rev 40 class 06,01,00 hdr 80
(II) PCI: 00:07:1: chip 1106,0571 card 0000,0000 rev 06 class 01,01,8a hdr 00
(II) PCI: 00:07:2: chip 1106,3038 card 0925,1234 rev 1a class 0c,03,00 hdr 00
(II) PCI: 00:07:3: chip 1106,3038 card 0925,1234 rev 1a class 0c,03,00 hdr 00
(II) PCI: 00:07:4: chip 1106,3057 card 0000,0000 rev 40 class 00,00,00 hdr 00
(II) PCI: 00:07:5: chip 1106,3058 card 0000,0000 rev 50 class 04,01,00 hdr 00
(II) PCI: 00:07:6: chip 1106,3068 card 0000,0000 rev 30 class 07,80,00 hdr 00
(II) PCI: 00:08:0: chip 109e,036e card 0070,13eb rev 11 class 04,00,00 hdr 80
(II) PCI: 00:08:1: chip 109e,0878 card 0070,13eb rev 11 class 04,80,00 hdr 80
(II) PCI: 00:09:0: chip 1102,0002 card 1102,8067 rev 0a class 04,01,00 hdr 80
(II) PCI: 00:09:1: chip 1102,7002 card 1102,0020 rev 0a class 09,80,00 hdr 80
(II) PCI: 00:0a:0: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:1: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:2: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:3: chip 10b9,5239 card 10b9,5272 rev 01 class 0c,03,20 hdr 80
(II) PCI: 00:0a:4: chip 10b9,5253 card 10b9,5253 rev 00 class 0c,00,10 hdr 80
(II) PCI: 01:00:0: chip 1002,5961 card 174b,7c13 rev 01 class 03,00,00 hdr 80
(II) PCI: 01:00:1: chip 1002,5941 card 174b,7c12 rev 01 class 03,80,00 hdr 00
(II) PCI: End of PCI scan
(II) Host-to-PCI bridge:
(II) Bus 0: bridge is at (0:0:0), (0,0,1), BCTRL: 0x0008 (VGA_EN is set)
(II) Bus 0 I/O range:
	[0] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) Bus 0 non-prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) Bus 0 prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) PCI-to-PCI bridge:
(II) Bus 1: bridge is at (0:1:0), (0,1,1), BCTRL: 0x001c (VGA_EN is set)
(II) Bus 1 non-prefetchable memory range:
	[0] -1	0	0x88000000 - 0x880fffff (0x100000) MX[B]
(II) Bus 1 prefetchable memory range:
	[0] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B]
(II) PCI-to-ISA bridge:
(II) Bus -1: bridge is at (0:7:0), (0,-1,-1), BCTRL: 0x0008 (VGA_EN is set)
(--) PCI: (0:8:0) Brooktree Corporation Bt878 Video Capture rev 17, Mem @ 0x98101000/12
(--) PCI:*(1:0:0) ATI Technologies Inc RV280 [Radeon 9200] rev 1, Mem @ 0x80000000/27, 0x88000000/16, I/O @ 0x0400/8, BIOS @ 0x88020000/17
(--) PCI: (1:0:1) ATI Technologies Inc RV280 [Radeon 9200] (Secondary) rev 1, Mem @ 0x90000000/0, 0x88010000/16
(II) Addressable bus resource ranges are
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) OS-reported resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) Active PCI resource ranges:
	[0] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[1] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[2] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[3] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[4] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[5] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[6] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[7] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[8] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[9] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[10] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[11] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[12] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[13] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[14] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[15] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[16] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[17] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[18] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[19] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[20] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[21] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[22] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[23] -1	0	0xfe000400 - 0xfe0004ff (0x100) IX[B](B)
(II) Active PCI resource ranges after removing overlaps:
	[0] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[1] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[2] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[3] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[4] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[5] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[6] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[7] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[8] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[9] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[10] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[11] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[12] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[13] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[14] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[15] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[16] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[17] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[18] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[19] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[20] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[21] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[22] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[23] -1	0	0xfe000400 - 0xfe0004ff (0x100) IX[B](B)
(II) OS-reported resource ranges after removing overlaps with PCI:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) All system resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[18] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[19] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[20] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[21] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[22] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[23] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[24] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[25] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[26] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[27] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[28] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[29] -1	0	0xfe000400 - 0xfe0004ff (0x100) IX[B](B)
(II) LoadModule: "i2c"
(II) Loading /usr/lib/xorg/modules/libi2c.so
(II) Module i2c: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.2.0
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "bitmap"
(II) Reloading /usr/lib/xorg/modules/fonts/libbitmap.so
(II) Loading font Bitmap
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "ddc"
(II) Loading /usr/lib/xorg/modules/libddc.so
(II) Module ddc: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading sub module "drm"
(II) LoadModule: "drm"
(II) Loading /usr/lib/xorg/modules/linux/libdrm.so
(II) Module drm: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension XFree86-DRI
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension SHAPE
(II) Loading extension MIT-SUNDRY-NONSTANDARD
(II) Loading extension BIG-REQUESTS
(II) Loading extension SYNC
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XC-MISC
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-Misc
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension TOG-CUP
(II) Loading extension Extended-Visual-Information
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "freetype"
(II) Loading /usr/lib/xorg/modules/fonts/libfreetype.so
(II) Module freetype: vendor="X.Org Foundation & the After X-TT Project"
	compiled for 7.1.1, module version = 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font FreeType
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "int10"
(II) Loading /usr/lib/xorg/modules/libint10.so
(II) Module int10: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension RECORD
(II) LoadModule: "type1"
(II) Loading /usr/lib/xorg/modules/fonts/libtype1.so
(II) Module type1: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.2
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font Type1
(II) LoadModule: "vbe"
(II) Loading /usr/lib/xorg/modules/libvbe.so
(II) Module vbe: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.1.0
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "v4l"
(II) Loading /usr/lib/xorg/modules/drivers/v4l_drv.so
(II) Module v4l: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 0.1.1
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "ati"
(II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
(II) Module ati: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 6.6.3
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "kbd"
(II) Loading /usr/lib/xorg/modules/input/kbd_drv.so
(II) Module kbd: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.1.0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.6
(II) LoadModule: "mouse"
(II) Loading /usr/lib/xorg/modules/input/mouse_drv.so
(II) Module mouse: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.1.1
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.6
(II) v4l driver for Video4Linux
(II) ATI: ATI driver (version 6.6.3) for chipset: ati
(II) R128: Driver for ATI Rage 128 chipsets:
	ATI Rage 128 Mobility M3 LE (PCI), ATI Rage 128 Mobility M3 LF (AGP),
	ATI Rage 128 Mobility M4 MF (AGP), ATI Rage 128 Mobility M4 ML (AGP),
	ATI Rage 128 Pro GL PA (AGP?), ATI Rage 128 Pro GL PB (AGP?),
	ATI Rage 128 Pro GL PC (AGP?), ATI Rage 128 Pro GL PD (PCI),
	ATI Rage 128 Pro GL PE (AGP?), ATI Rage 128 Pro GL PF (AGP),
	ATI Rage 128 Pro VR PG (AGP?), ATI Rage 128 Pro VR PH (AGP?),
	ATI Rage 128 Pro VR PI (AGP?), ATI Rage 128 Pro VR PJ (AGP?),
	ATI Rage 128 Pro VR PK (AGP?), ATI Rage 128 Pro VR PL (AGP?),
	ATI Rage 128 Pro VR PM (AGP?), ATI Rage 128 Pro VR PN (AGP?),
	ATI Rage 128 Pro VR PO (AGP?), ATI Rage 128 Pro VR PP (PCI),
	ATI Rage 128 Pro VR PQ (AGP?), ATI Rage 128 Pro VR PR (PCI),
	ATI Rage 128 Pro VR PS (AGP?), ATI Rage 128 Pro VR PT (AGP?),
	ATI Rage 128 Pro VR PU (AGP?), ATI Rage 128 Pro VR PV (AGP?),
	ATI Rage 128 Pro VR PW (AGP?), ATI Rage 128 Pro VR PX (AGP?),
	ATI Rage 128 GL RE (PCI), ATI Rage 128 GL RF (AGP),
	ATI Rage 128 RG (AGP), ATI Rage 128 VR RK (PCI),
	ATI Rage 128 VR RL (AGP), ATI Rage 128 4X SE (AGP?),
	ATI Rage 128 4X SF (AGP?), ATI Rage 128 4X SG (AGP?),
	ATI Rage 128 4X SH (AGP?), ATI Rage 128 4X SK (AGP?),
	ATI Rage 128 4X SL (AGP?), ATI Rage 128 4X SM (AGP),
	ATI Rage 128 4X SN (AGP?), ATI Rage 128 Pro ULTRA TF (AGP),
	ATI Rage 128 Pro ULTRA TL (AGP), ATI Rage 128 Pro ULTRA TR (AGP),
	ATI Rage 128 Pro ULTRA TS (AGP?), ATI Rage 128 Pro ULTRA TT (AGP?),
	ATI Rage 128 Pro ULTRA TU (AGP?)
(II) RADEON: Driver for ATI Radeon chipsets: ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI Radeon VE/7000 QY (AGP/PCI), ATI Radeon VE/7000 QZ (AGP/PCI),
	ATI ES1000 515E (PCI), ATI ES1000 5969 (PCI),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI Radeon IGP320 (A3) 4136, ATI Radeon IGP320M (U1) 4336,
	ATI Radeon IGP330/340/350 (A4) 4137,
	ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon 7000 IGP (A4+) 4237, ATI Radeon Mobility 7000 IGP 4437,
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 8500 AIW BB (AGP),
	ATI Radeon 8500 AIW BC (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP),
	ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835, ATI Radeon 9100 PRO IGP 7834,
	ATI Radeon Mobility 9200 IGP 7835, ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP), ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP),
	ATI FireGL RV360 AV (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon 9650,
	ATI Radeon 9800SE AH (AGP), ATI Radeon 9800 AI (AGP),
	ATI Radeon 9800 AJ (AGP), ATI FireGL X2 AK (AGP),
	ATI Radeon 9800PRO NH (AGP), ATI Radeon 9800 NI (AGP),
	ATI FireGL X2 NK (AGP), ATI Radeon 9800XT NJ (AGP),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE),
	ATI Radeon Mobility X600 (M24) 3150 (PCIE),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE),
	ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE), ATI FireGL V5000 (RV410) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 XT (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 SE (RV410) (PCIE),
	ATI Radeon X800 (R420) JH (AGP), ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800XT (R420) JP (AGP), ATI Radeon X800 SE (R420) (AGP),
	ATI Radeon AIW X800 VE (R420) JT (AGP),
	ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE), ATI FireGL V7100 (R423) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Radeon X800 (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 XTP (R430) (PCIE),
	ATI Radeon X850 5D4C (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP)
(II) Primary Device is: PCI 01:00:0
(II) ATI:  Candidate "Device" section "ATI Technologies Inc RV280 [Radeon 9200]".
(WW) RADEON: No matching Device section for instance (BusID PCI:1:0:1) found
(--) Chipset ATI Radeon 9200 5961 (AGP) found
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[18] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[19] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[20] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[21] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[22] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[23] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[24] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[25] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[26] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[27] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[28] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[29] -1	0	0xfe000400 - 0xfe0004ff (0x100) IX[B](B)
(II) Loading sub module "radeon"
(II) LoadModule: "radeon"
(II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
(II) Module radeon: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 4.2.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 1.0
(WW) ****INVALID IO ALLOCATION**** b: 0xfe000400 e: 0xfe0004ff correcting
(EE) end of block range 0xfdffffff < begin 0xfe000000
(II) window:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) resSize:
(II) window fixed:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[18] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[19] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[20] -1	0	0x00000400 - 0x000004ff (0x100) IX[B](B)
	[21] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[22] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[23] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[24] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[25] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[26] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[27] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[28] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[29] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[30] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[31] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[32] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[33] 0	0	0xfe0003b0 - 0xfe0003bb (0xc) IS[B]
	[34] 0	0	0xfe0003c0 - 0xfe0003df (0x20) IS[B]
(II) Setting vga for screen 0.
(**) RADEON(0): RADEONPreInit
(II) RADEON(0): MMIO registers at 0x88000000: size 64KB
(II) RADEON(0): PCI bus 1 card 0 func 0
(**) RADEON(0): Depth 24, (--) framebuffer bpp 32
(II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
(==) RADEON(0): Default visual is TrueColor
(**) RADEON(0): Option "BusType" "PCI"
(**) RADEON(0): Option "EnablePageFlip" "true"
(II) RADEON(0): VGAAccess option set to FALSE, VGA module load skipped
(==) RADEON(0): RGB weight 888
(II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
(++) RADEON(0): "-dpi 96" given in command line, assuming "ConstantDPI" set
(++) RADEON(0): X server will keep DPI constant for all screen sizes
(--) RADEON(0): Chipset: "ATI Radeon 9200 5961 (AGP)" (ChipID = 0x5961)
(--) RADEON(0): Linear framebuffer at 0x80000000
(--) RADEON(0): BIOS at 0x88020000
(II) RADEON(0): AGP card detected
(**) RADEON(0): Forced into PCI mode
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 6, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 6, (OK)
drmOpenByBusid: drmOpenMinor returns 6
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) RADEON(0): [dri] Found DRI library version 1.2.0 and kernel module version 1.28.0
(II) Loading sub module "shadowfb"
(II) LoadModule: "shadowfb"
(II) Loading /usr/lib/xorg/modules/libshadowfb.so
(II) Module shadowfb: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) RADEON(0): Page flipping enabled
(II) RADEON(0): Will try to use DMA for Xv image transfers
(II) RADEON(0): Generation 2 PCI interface, using max accessible memory
(II) RADEON(0): Detected total video RAM=131072K, accessible=131072K (PCI BAR=131072K)
(--) RADEON(0): Mapped VideoRAM: 131072 kByte (128 bit DDR SDRAM)
(II) RADEON(0): Color tiling enabled by default
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Reloading /usr/lib/xorg/modules/libddc.so
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Reloading /usr/lib/xorg/modules/libi2c.so
(II) RADEON(0): I2C bus "DDC" initialized.
(II) Attempted to read BIOS 64KB from /sys/bus/pci/devices/0000:01:00.0/rom: got 52KB
(II) RADEON(0): Legacy BIOS detected
(II) RADEON(0): Connector0: DDCType-2, DACType-1, TMDSType-0, ConnectorType-3
(II) RADEON(0): Connector1: DDCType-3, DACType-0, TMDSType--1, ConnectorType-2
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): DDC Type: 2, Detected Type: 3
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): DDC Type: 3, Detected Type: 0
(II) RADEON(0): EDID data from the display on port 1 ----------------------
(II) RADEON(0): Manufacturer: NEC  Model: 669a  Serial#: 16843009
(II) RADEON(0): Year: 2005  Week: 44
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max H-Image Size [cm]: horiz.: 41  vert.: 31
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.639 redY: 0.342   greenX: 0.290 greenY: 0.615
(II) RADEON(0): blueX: 0.146 blueY: 0.072   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Supported VESA Video Modes:
(II) RADEON(0): 720x400@70Hz
(II) RADEON(0): 640x480@60Hz
(II) RADEON(0): 640x480@67Hz
(II) RADEON(0): 640x480@72Hz
(II) RADEON(0): 640x480@75Hz
(II) RADEON(0): 800x600@56Hz
(II) RADEON(0): 800x600@60Hz
(II) RADEON(0): 800x600@72Hz
(II) RADEON(0): 800x600@75Hz
(II) RADEON(0): 832x624@75Hz
(II) RADEON(0): 1024x768@60Hz
(II) RADEON(0): 1024x768@70Hz
(II) RADEON(0): 1024x768@75Hz
(II) RADEON(0): 1280x1024@75Hz
(II) RADEON(0): 1152x870@75Hz
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported Future Video Modes:
(II) RADEON(0): #0: hsize: 640  vsize 480  refresh: 85  vid: 22833
(II) RADEON(0): #1: hsize: 800  vsize 600  refresh: 85  vid: 22853
(II) RADEON(0): #2: hsize: 1024  vsize 768  refresh: 85  vid: 22881
(II) RADEON(0): #3: hsize: 1152  vsize 864  refresh: 75  vid: 20337
(II) RADEON(0): #4: hsize: 1280  vsize 960  refresh: 85  vid: 22913
(II) RADEON(0): #5: hsize: 1280  vsize 1024  refresh: 85  vid: 39297
(II) RADEON(0): #6: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
(II) RADEON(0): Supported additional Video Mode:
(II) RADEON(0): clock: 162.0 MHz   Image Size:  408 x 306 mm
(II) RADEON(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h_blank_end 2160 h_border: 0
(II) RADEON(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v_blanking: 1250 v_border: 0
(II) RADEON(0): Ranges: V min: 50  V max: 85 Hz, H min: 31  H max: 92 kHz, PixClock max 170 MHz
(II) RADEON(0): Monitor name: LCD2080UXi
(II) RADEON(0): Serial No: 5Y102473YB
(II) RADEON(0): 
(II) RADEON(0): Primary:
 Monitor   -- TMDS
 Connector -- DVI-I
 DAC Type  -- TVDAC/ExtDAC
 TMDS Type -- Internal
 DDC Type  -- DVI_DDC
(II) RADEON(0): Secondary:
 Monitor   -- CRT
 Connector -- VGA
 DAC Type  -- Primary
 TMDS Type -- NONE
 DDC Type  -- VGA_DDC
(II) RADEON(0): PLL parameters: rf=2700 rd=12 min=20000 max=40000; xclk=20000
(WW) RADEON(0): Failed to detect secondary monitor DDC, default HSync and VRefresh used
(==) RADEON(0): Using gamma correction (1.0, 1.0, 1.0)
(II) RADEON(0): Validating modes on Primary head ---------
(II) RADEON(0): DFP table revision: 4
(II) RADEON(0): Panel infos found from DDC detailed: 1600x1200
(II) RADEON(0): Valid Mode from Detailed timing table: 1600x1200
(II) RADEON(0): Valid Mode from standard timing table: 640x480
(II) RADEON(0): Valid Mode from standard timing table: 800x600
(II) RADEON(0): Valid Mode from standard timing table: 1024x768
(II) RADEON(0): Valid Mode from standard timing table: 1152x864
(II) RADEON(0): Valid Mode from standard timing table: 1280x960
(II) RADEON(0): Valid Mode from standard timing table: 1280x1024
(II) RADEON(0): Valid Mode from standard timing table: 1600x1200
(II) RADEON(0): Valid Mode from established timing table: 1280x1024
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 832x624
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Total of 20 mode(s) found.
(II) RADEON(0): Total number of valid DDC mode(s) found: 20
(II) RADEON(0): Validating CRTC2 modes for MergedFB ------------ 
(II) RADEON(0): CRT2 Monitor: Using hsync range of 28.00-33.00 kHz
(II) RADEON(0): CRT2 Monitor: Using vrefresh range of 43.00-72.00 Hz
(II) RADEON(0): Clock range:  20.00 to 400.00 MHz
(II) RADEON(0): Not using default mode "640x350" (hsync out of range)
(II) RADEON(0): Not using default mode "320x175" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x400" (hsync out of range)
(II) RADEON(0): Not using default mode "320x200" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "720x400" (hsync out of range)
(II) RADEON(0): Not using default mode "360x200" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (hsync out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (hsync out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (hsync out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x864" (hsync out of range)
(II) RADEON(0): Not using default mode "576x432" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x960" (hsync out of range)
(II) RADEON(0): Not using default mode "640x480" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x960" (hsync out of range)
(II) RADEON(0): Not using default mode "640x480" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1792x1344" (hsync out of range)
(II) RADEON(0): Not using default mode "896x672" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1792x1344" (hsync out of range)
(II) RADEON(0): Not using default mode "896x672" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1856x1392" (hsync out of range)
(II) RADEON(0): Not using default mode "928x696" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1856x1392" (hsync out of range)
(II) RADEON(0): Not using default mode "928x696" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "832x624" (hsync out of range)
(II) RADEON(0): Not using default mode "416x312" (hsync out of range)
(II) RADEON(0): Not using default mode "1280x768" (hsync out of range)
(II) RADEON(0): Not using default mode "640x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x800" (hsync out of range)
(II) RADEON(0): Not using default mode "640x400" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x768" (hsync out of range)
(II) RADEON(0): Not using default mode "576x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x864" (hsync out of range)
(II) RADEON(0): Not using default mode "576x432" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1440x900" (hsync out of range)
(II) RADEON(0): Not using default mode "720x450" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "800x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1680x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "840x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "960x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "960x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using mode "1600x1200" (no mode of this name)
(II) RADEON(0): Not using mode "1280x1024" (no mode of this name)
(II) RADEON(0): Not using mode "1024x768" (no mode of this name)
(II) RADEON(0): Not using mode "800x600" (no mode of this name)
(II) RADEON(0): Total of 1 CRTC2 modes found for MergedFB------------ 
(II) RADEON(0): Modes for CRT1: ********************
(--) RADEON(0): Virtual size is 1600x1200 (pitch 1600)
(**) RADEON(0): *Default mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "1280x1024": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x1024"  162.00  1280 1664 1856 2160  1024 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1280x1024": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x1024"  162.00  1280 1664 1856 2160  1024 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1280x960": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x960"  162.00  1280 1664 1856 2160  960 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1152x864": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1152x864"  162.00  1152 1664 1856 2160  864 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "832x624": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "832x624"  162.00  832 1664 1856 2160  624 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(II) RADEON(0): Modes for CRT2: ********************
(--) RADEON(0): Virtual size is 640x480 (pitch 640)
(**) RADEON(0): *Default mode "640x480": 25.2 MHz, 31.5 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"   25.20  640 656 752 800  480 490 492 525 -hsync -vsync
(II) RADEON(0): Generating MergedFB mode list
(II) RADEON(0): Clone mode, list all common modes
(EE) RADEON(0): Failed to parse MetaModes or no modes found. MergeFB mode disabled.
(++) RADEON(0): DPI set to (96, 96)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Loading /usr/lib/xorg/modules/libramdac.so
(II) Module ramdac: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 0.1.0
	ABI class: X.Org Video Driver, version 1.0
(==) RADEON(0): Using XAA acceleration architecture
(II) Loading sub module "xaa"
(II) LoadModule: "xaa"
(II) Loading /usr/lib/xorg/modules/libxaa.so
(II) Module xaa: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 1.2.0
	ABI class: X.Org Video Driver, version 1.0
(II) RADEON(0): No MM_TABLE found - assuming CARD is not TV-in capable.
(!!) RADEON(0): For information on using the multimedia capabilities
	of this adapter, please see http://gatos.sf.net.
(--) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] 0	0	0x88000000 - 0x8800ffff (0x10000) MX[B]
	[1] 0	0	0x80000000 - 0x87ffffff (0x8000000) MX[B]
	[2] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[3] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[4] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[5] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[6] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[7] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[8] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[9] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[10] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[11] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[12] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[13] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[14] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[15] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[16] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[17] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[18] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[19] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprU)
	[20] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprU)
	[21] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprU)
	[22] 0	0	0xfe000400 - 0xfe0004ff (0x100) IX[B]
	[23] -1	0	0x00000400 - 0x000004ff (0x100) IX[B](B)
	[24] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[25] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[26] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[27] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[28] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[29] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[30] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[31] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[32] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[33] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[34] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[35] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[36] 0	0	0xfe0003b0 - 0xfe0003bb (0xc) IS[B](OprU)
	[37] 0	0	0xfe0003c0 - 0xfe0003df (0x20) IS[B](OprU)
(**) RADEON(0): RADEONScreenInit 80000000 0
(**) RADEON(0): Map: 0x80000000, 0x08000000
(**) RADEON(0): RADEONSave
(**) RADEON(0): RADEONSaveMode(0x1020cd90)
(**) RADEON(0): Read: 0x0000000c 0x00010090 0x00000000
(**) RADEON(0): Read: rd=12, fd=144, pd=1
(**) RADEON(0): RADEONSaveMode returns 0x1020cd90
(==) RADEON(0): Using 24 bit depth buffer
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 6, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 6, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 6, (OK)
drmOpenByBusid: drmOpenMinor returns 6
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) RADEON(0): [drm] DRM interface version 1.3
(II) RADEON(0): [drm] created "radeon" driver at busid "pci:0000:01:00.0"
(II) RADEON(0): [drm] added 8192 byte SAREA at 0xf215f000
(II) RADEON(0): [drm] mapped SAREA 0xf215f000 to 0x48025000
(II) RADEON(0): [drm] framebuffer handle = 0x80000000
(II) RADEON(0): [drm] added 1 reserved context for kernel
(II) RADEON(0): [pci] 8192 kB allocated with handle 0x00000000
(II) RADEON(0): [pci] ring handle = 0xf24fb000
(II) RADEON(0): [pci] Ring mapped at 0x50061000
(II) RADEON(0): [pci] Ring contents 0x00000000
(II) RADEON(0): [pci] ring read ptr handle = 0xf25fc000
(II) RADEON(0): [pci] Ring read ptr mapped at 0x48027000
(II) RADEON(0): [pci] Ring read ptr contents 0x00000000
(II) RADEON(0): [pci] vertex/indirect buffers handle = 0xf25fd000
(II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x50162000
(II) RADEON(0): [pci] Vertex/indirect buffers contents 0x00000000
(II) RADEON(0): [pci] GART texture map handle = 0xf27fd000
(II) RADEON(0): [pci] GART Texture map mapped at 0x50362000
(II) RADEON(0): [drm] register handle = 0x88000000
(II) RADEON(0): [dri] Visual configs initialized
(**) RADEON(0): DRI New memory map param
(**) RADEON(0): RADEONInitMemoryMap() : 
(**) RADEON(0):   mem_size         : 0x08000000
(**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
(**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
(**) RADEON(0): RADEONModeInit()
1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
(**) RADEON(0): Pitch = 13107400 bytes (virtualX = 1600, displayWidth = 1600)
(**) RADEON(0): dc=16200, of=32400, fd=144, pd=2
(**) RADEON(0): TMDS_PLL from 1f60111 to 1f60111
(II) RADEON(0): BIOS HotKeys Disabled
(**) RADEON(0): RADEONInit returns 0x1020d740
(**) RADEON(0): RADEONRestoreMode()
(**) RADEON(0): RADEONRestoreMode(0x1020d740)
(**) RADEON(0): RADEONRestoreMemMapRegisters() : 
(**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
(**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
(**) RADEON(0): Updating display base addresses...
(**) RADEON(0): Memory map updated.
(**) RADEON(0): Programming CRTC1, offset: 0x00000000
(**) RADEON(0): Wrote: 0x0000000c 0x00010090 0x00000000 (0x0000a700)
(**) RADEON(0): Wrote: rd=12, fd=144, pd=1
(**) RADEON(0): GRPH_BUFFER_CNTL from 20185c5c to 20185c5c
(**) RADEON(0): RADEONSaveScreen(0)
(II) RADEON(0): Depth moves disabled by default
(**) RADEON(0): Setting up initial surfaces
(**) RADEON(0): Initializing fb layer
(**) RADEON(0): Setting up accel memmap
(II) RADEON(0): CP in BM mode
(II) RADEON(0): Using 8 MB GART aperture
(II) RADEON(0): Using 1 MB for the ring buffer
(II) RADEON(0): Using 2 MB for vertex/indirect buffers
(II) RADEON(0): Using 5 MB for GART textures
(II) RADEON(0): Memory manager initialized to (0,0) (1600,8191)
(II) RADEON(0): Reserved area from (0,1200) to (1600,1202)
(II) RADEON(0): Largest offscreen area available: 1600 x 6989
(II) RADEON(0): Will use back buffer at offset 0x1d4c000
(II) RADEON(0): Will use depth buffer at offset 0x249f000
(II) RADEON(0): Will use 86016 kb for textures at offset 0x2bf2000
(**) RADEON(0): Initializing backing store
(==) RADEON(0): Backing store disabled
(**) RADEON(0): DRI Finishing init !
(II) RADEON(0): X context handle = 0x1
(II) RADEON(0): [drm] installed DRM signal handler
(II) RADEON(0): [DRI] installation complete

--========GMX90211204497012566029--
