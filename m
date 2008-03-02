Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYCBLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYCBLF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 06:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYCBLFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 06:05:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:52984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753263AbYCBLFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 06:05:08 -0500
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org
Content-Type: multipart/mixed; boundary="========GMX175271204455905968840"
Date: Sun, 02 Mar 2008 12:05:05 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20071125234254.B4405DDE49@ozlabs.org>
Message-ID: <20080302110505.175270@gmx.net>
MIME-Version: 1.0
References: <20071125234254.B4405DDE49@ozlabs.org>
Subject: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, airlied@linux.ie
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19VBV1E9N9V+WgiWr9pi810rlogfCZetpdKjee5Ju
 4jYVpfQ0kdd2SUcHydrzJ8dRbk+d7GLXIlhg== 
X-GMX-UID: h/ijKAV8MydhbXlfN2plNaBjaGRhZto5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX175271204455905968840
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

-------- Original-Nachricht --------
> Datum: Mon, 26 Nov 2007 10:41:58 +1100
> Von: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> An: David Airlie <airlied@linux.ie>
> CC: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Betreff: [RFC/PATCH] drm: Fix for non-coherent DMA PowerPC

> This patch fixes bits of the DRM so to make the radeon DRI work on
> non-cache coherent PCI DMA variants of the PowerPC processors.
> 
> It moves the few places that needs change to wrappers to that
> other architectures with similar issues can easily add their
> own changes to those wrappers, at least until we have more useful
> generic kernel API.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Xorg (v7.1.1, Debian Etch) crashes with this patch (applied to 2.6.25-rc3)
on my AmigaOne with a Radeon 9200 (PCIGART mode enabled). See the attached
log file for the stack trace.

regards,

Gerhard
-- 
GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/?mc=sv_ext_mf@gmx

--========GMX175271204455905968840
Content-Type: text/x-log; charset="iso-8859-15"; name="dri_crash.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dri_crash.log"

 -> early_init_devtree(c0c11300)
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
Linux version 2.6.25-rc3 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #47 Sat Mar 1 20:03:46 CET 2008
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
irq: Allocated host of type 0 @0xc04311c0
i8259 legacy interrupt controller initialized
irq: Default host set to @0xc04311c0
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
Memory: 1550076k/1572864k available (3780k kernel code, 21744k reserved, 144k data, 295k bss, 176k init)
SLUB: Genslabs=10, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
Mount-cache hash table entries: 512
Calling initcall 0xc03a1940: init_cpufreq_transition_notifier_list+0x0/0x2c()
initcall 0xc03a1940: init_cpufreq_transition_notifier_list+0x0/0x2c() returned 0.
initcall 0xc03a1940 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x2c()
Calling initcall 0xc03a1c98: net_ns_init+0x0/0xa0()
net_namespace: 544 bytes
initcall 0xc03a1c98: net_ns_init+0x0/0xa0() returned 0.
initcall 0xc03a1c98 ran for 0 msecs: net_ns_init+0x0/0xa0()
Calling initcall 0xc03936a4: dma_alloc_init+0x0/0xac()
initcall 0xc03936a4: dma_alloc_init+0x0/0xac() returned 0.
initcall 0xc03936a4 ran for 0 msecs: dma_alloc_init+0x0/0xac()
Calling initcall 0xc03947a0: sysctl_init+0x0/0x48()
initcall 0xc03947a0: sysctl_init+0x0/0x48() returned 0.
initcall 0xc03947a0 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc039519c: ksysfs_init+0x0/0xec()
initcall 0xc039519c: ksysfs_init+0x0/0xec() returned 0.
initcall 0xc039519c ran for 0 msecs: ksysfs_init+0x0/0xec()
Calling initcall 0xc0395630: init_jiffies_clocksource+0x0/0x28()
initcall 0xc0395630: init_jiffies_clocksource+0x0/0x28() returned 0.
initcall 0xc0395630 ran for 0 msecs: init_jiffies_clocksource+0x0/0x28()
Calling initcall 0xc039589c: pm_init+0x0/0x54()
initcall 0xc039589c: pm_init+0x0/0x54() returned 0.
initcall 0xc039589c ran for 0 msecs: pm_init+0x0/0x54()
Calling initcall 0xc0398204: filelock_init+0x0/0x48()
initcall 0xc0398204: filelock_init+0x0/0x48() returned 0.
initcall 0xc0398204 ran for 0 msecs: filelock_init+0x0/0x48()
Calling initcall 0xc0398db0: init_script_binfmt+0x0/0x28()
initcall 0xc0398db0: init_script_binfmt+0x0/0x28() returned 0.
initcall 0xc0398db0 ran for 0 msecs: init_script_binfmt+0x0/0x28()
Calling initcall 0xc0398dd8: init_elf_binfmt+0x0/0x28()
initcall 0xc0398dd8: init_elf_binfmt+0x0/0x28() returned 0.
initcall 0xc0398dd8 ran for 0 msecs: init_elf_binfmt+0x0/0x28()
Calling initcall 0xc0399a64: debugfs_init+0x0/0x70()
initcall 0xc0399a64: debugfs_init+0x0/0x70() returned 0.
initcall 0xc0399a64 ran for 0 msecs: debugfs_init+0x0/0x70()
Calling initcall 0xc039a6c0: random32_init+0x0/0x34()
initcall 0xc039a6c0: random32_init+0x0/0x34() returned 0.
initcall 0xc039a6c0 ran for 0 msecs: random32_init+0x0/0x34()
Calling initcall 0xc03a1910: cpufreq_core_init+0x0/0x30()
initcall 0xc03a1910: cpufreq_core_init+0x0/0x30() returned 0.
initcall 0xc03a1910 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
Calling initcall 0xc03a1a4c: sock_init+0x0/0x5c()
initcall 0xc03a1a4c: sock_init+0x0/0x5c() returned 0.
initcall 0xc03a1a4c ran for 0 msecs: sock_init+0x0/0x5c()
Calling initcall 0xc03a24f4: netpoll_init+0x0/0x20()
initcall 0xc03a24f4: netpoll_init+0x0/0x20() returned 0.
initcall 0xc03a24f4 ran for 0 msecs: netpoll_init+0x0/0x20()
Calling initcall 0xc03a282c: netlink_proto_init+0x0/0x158()
NET: Registered protocol family 16
initcall 0xc03a282c: netlink_proto_init+0x0/0x158() returned 0.
initcall 0xc03a282c ran for 3 msecs: netlink_proto_init+0x0/0x158()
Calling initcall 0xc038c558: of_bus_driver_init+0x0/0x30()
initcall 0xc038c558: of_bus_driver_init+0x0/0x30() returned 0.
initcall 0xc038c558 ran for 0 msecs: of_bus_driver_init+0x0/0x30()
Calling initcall 0xc039a550: kobject_uevent_init+0x0/0x68()
initcall 0xc039a550: kobject_uevent_init+0x0/0x68() returned 0.
initcall 0xc039a550 ran for 0 msecs: kobject_uevent_init+0x0/0x68()
Calling initcall 0xc039a730: pcibus_class_init+0x0/0x28()
initcall 0xc039a730: pcibus_class_init+0x0/0x28() returned 0.
initcall 0xc039a730 ran for 0 msecs: pcibus_class_init+0x0/0x28()
Calling initcall 0xc039aed8: pci_driver_init+0x0/0x28()
initcall 0xc039aed8: pci_driver_init+0x0/0x28() returned 0.
initcall 0xc039aed8 ran for 0 msecs: pci_driver_init+0x0/0x28()
Calling initcall 0xc039b760: backlight_class_init+0x0/0x74()
initcall 0xc039b760: backlight_class_init+0x0/0x74() returned 0.
initcall 0xc039b760 ran for 0 msecs: backlight_class_init+0x0/0x74()
Calling initcall 0xc039ba20: video_output_class_init+0x0/0x28()
initcall 0xc039ba20: video_output_class_init+0x0/0x28() returned 0.
initcall 0xc039ba20 ran for 0 msecs: video_output_class_init+0x0/0x28()
Calling initcall 0xc039bdd8: tty_class_init+0x0/0x44()
initcall 0xc039bdd8: tty_class_init+0x0/0x44() returned 0.
initcall 0xc039bdd8 ran for 0 msecs: tty_class_init+0x0/0x44()
Calling initcall 0xc039c848: vtconsole_class_init+0x0/0xf0()
initcall 0xc039c848: vtconsole_class_init+0x0/0xf0() returned 0.
initcall 0xc039c848 ran for 0 msecs: vtconsole_class_init+0x0/0xf0()
Calling initcall 0xc0006a10: irq_late_init+0x0/0x88()
initcall 0xc0006a10: irq_late_init+0x0/0x88() returned 0.
initcall 0xc0006a10 ran for 0 msecs: irq_late_init+0x0/0x88()
Calling initcall 0xc038c340: vdso_init+0x0/0x1d8()
initcall 0xc038c340: vdso_init+0x0/0x1d8() returned 0.
initcall 0xc038c340 ran for 0 msecs: vdso_init+0x0/0x1d8()
Calling initcall 0xc001000c: powerpc_debugfs_init+0x0/0x40()
initcall 0xc001000c: powerpc_debugfs_init+0x0/0x40() returned 0.
initcall 0xc001000c ran for 0 msecs: powerpc_debugfs_init+0x0/0x40()
Calling initcall 0xc038e660: ppc_init+0x0/0x84()
initcall 0xc038e660: ppc_init+0x0/0x84() returned 0.
initcall 0xc038e660 ran for 0 msecs: ppc_init+0x0/0x84()
Calling initcall 0xc0391d48: pcibios_init+0x0/0x138()
PCI: Probing PCI hardware
PCI: Scanning bus 0000:00
PCI: Found 0000:00:00.0 [10cc/0660] 000600 00
pci 0000:00:00.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:01.0 [10cc/0661] 000604 01
pci 0000:00:01.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:06.0 [10b7/9200] 000200 00
pci 0000:00:06.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:07.0 [1106/0686] 000601 00
pci 0000:00:07.0: calling quirk 0xc02c52f0: 0xc02c52f0()
pci 0000:00:07.0: calling quirk 0xc012e81c: quirk_via_bridge+0x0/0x98()
PCI: Found 0000:00:07.1 [1106/0571] 000101 00
pci 0000:00:07.1: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:07.2 [1106/3038] 000c03 00
pci 0000:00:07.2: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:07.3 [1106/3038] 000c03 00
pci 0000:00:07.3: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:07.4 [1106/3057] 000000 00
pci 0000:00:07.4: calling quirk 0xc02c52f0: 0xc02c52f0()
pci 0000:00:07.4: calling quirk 0xc02c6d08: 0xc02c6d08()
pci 0000:00:07.4: calling quirk 0xc02c62cc: 0xc02c62cc()
PCI: Found 0000:00:07.5 [1106/3058] 000401 00
pci 0000:00:07.5: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:07.6 [1106/3068] 000780 00
pci 0000:00:07.6: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:08.0 [109e/036e] 000400 00
pci 0000:00:08.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:08.1 [109e/0878] 000480 00
pci 0000:00:08.1: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:09.0 [1102/0002] 000401 00
pci 0000:00:09.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:09.1 [1102/7002] 000980 00
pci 0000:00:09.1: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:0a.0 [10b9/5237] 000c03 00
pci 0000:00:0a.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:0a.1 [10b9/5237] 000c03 00
pci 0000:00:0a.1: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:0a.2 [10b9/5237] 000c03 00
pci 0000:00:0a.2: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:0a.3 [10b9/5239] 000c03 00
pci 0000:00:0a.3: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:00:0a.4 [10b9/5253] 000c00 00
pci 0000:00:0a.4: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Fixups for bus 0000:00
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000000...],ointsize=1
 -> no parent found !
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00003000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 7
of_irq_map_one: dev=/pci@80000000/ide@7,1, index=0
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003a00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000004 0x00003b00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x5)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 5
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003d00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00003e00...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 9
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004100...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 9
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00004800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xa)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 10
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005000...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005100...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000002 0x00005200...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x7)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 7
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00005300...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 11
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000003 0x00005400...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0x9)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 9
PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
PCI: Scanning bus 0000:01
PCI: Found 0000:01:00.0 [1002/5961] 000300 00
pci 0000:01:00.0: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Found 0000:01:00.1 [1002/5941] 000380 00
pci 0000:01:00.1: calling quirk 0xc02c52f0: 0xc02c52f0()
PCI: Fixups for bus 0000:01
of_irq_map_raw: par=/pci@80000000,intspec=[0x00000001 0x00000800...],ointsize=1
 -> no parent found !
irq: irq_create_mapping(0x00000000, 0xb)
irq: -> using host @c04311c0
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
initcall 0xc0391d48: pcibios_init+0x0/0x138() returned 0.
initcall 0xc0391d48 ran for 400 msecs: pcibios_init+0x0/0x138()
Calling initcall 0xc0394e70: param_sysfs_init+0x0/0x7c()
initcall 0xc0394e70: param_sysfs_init+0x0/0x7c() returned 0.
initcall 0xc0394e70 ran for 0 msecs: param_sysfs_init+0x0/0x7c()
Calling initcall 0xc0046028: pm_sysrq_init+0x0/0x30()
initcall 0xc0046028: pm_sysrq_init+0x0/0x30() returned 0.
initcall 0xc0046028 ran for 0 msecs: pm_sysrq_init+0x0/0x30()
Calling initcall 0xc0397924: readahead_init+0x0/0x28()
initcall 0xc0397924: readahead_init+0x0/0x28() returned 0.
initcall 0xc0397924 ran for 0 msecs: readahead_init+0x0/0x28()
Calling initcall 0xc0398a14: init_bio+0x0/0xac()
initcall 0xc0398a14: init_bio+0x0/0xac() returned 0.
initcall 0xc0398a14 ran for 0 msecs: init_bio+0x0/0xac()
Calling initcall 0xc039a16c: blk_settings_init+0x0/0x30()
initcall 0xc039a16c: blk_settings_init+0x0/0x30() returned 0.
initcall 0xc039a16c ran for 0 msecs: blk_settings_init+0x0/0x30()
Calling initcall 0xc039a19c: blk_ioc_init+0x0/0x44()
initcall 0xc039a19c: blk_ioc_init+0x0/0x44() returned 0.
initcall 0xc039a19c ran for 0 msecs: blk_ioc_init+0x0/0x44()
Calling initcall 0xc039a1e0: genhd_device_init+0x0/0x4c()
initcall 0xc039a1e0: genhd_device_init+0x0/0x4c() returned 0.
initcall 0xc039a1e0 ran for 0 msecs: genhd_device_init+0x0/0x4c()
Calling initcall 0xc039b334: fbmem_init+0x0/0xc8()
initcall 0xc039b334: fbmem_init+0x0/0xc8() returned 0.
initcall 0xc039b334 ran for 0 msecs: fbmem_init+0x0/0xc8()
Calling initcall 0xc039c220: misc_init+0x0/0xb8()
initcall 0xc039c220: misc_init+0x0/0xb8() returned 0.
initcall 0xc039c220 ran for 0 msecs: misc_init+0x0/0xb8()
Calling initcall 0xc039fe2c: init_scsi+0x0/0xa8()
SCSI subsystem initialized
initcall 0xc039fe2c: init_scsi+0x0/0xa8() returned 0.
initcall 0xc039fe2c ran for 3 msecs: init_scsi+0x0/0xa8()
Calling initcall 0xc03a04bc: usb_init+0x0/0x118()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xc03a04bc: usb_init+0x0/0x118() returned 0.
initcall 0xc03a04bc ran for 7 msecs: usb_init+0x0/0x118()
Calling initcall 0xc03a0ac8: serio_init+0x0/0xa4()
initcall 0xc03a0ac8: serio_init+0x0/0xa4() returned 0.
initcall 0xc03a0ac8 ran for 0 msecs: serio_init+0x0/0xa4()
Calling initcall 0xc03a0d5c: input_init+0x0/0x98()
initcall 0xc03a0d5c: input_init+0x0/0x98() returned 0.
initcall 0xc03a0d5c ran for 0 msecs: input_init+0x0/0x98()
Calling initcall 0xc03a10ec: rtc_init+0x0/0x94()
initcall 0xc03a10ec: rtc_init+0x0/0x94() returned 0.
initcall 0xc03a10ec ran for 0 msecs: rtc_init+0x0/0x94()
Calling initcall 0xc03a1784: i2c_init+0x0/0x7c()
initcall 0xc03a1784: i2c_init+0x0/0x7c() returned 0.
initcall 0xc03a1784 ran for 0 msecs: i2c_init+0x0/0x7c()
Calling initcall 0xc03a18bc: thermal_init+0x0/0x54()
initcall 0xc03a18bc: thermal_init+0x0/0x54() returned 0.
initcall 0xc03a18bc ran for 0 msecs: thermal_init+0x0/0x54()
Calling initcall 0xc03a1b04: proto_init+0x0/0x54()
initcall 0xc03a1b04: proto_init+0x0/0x54() returned 0.
initcall 0xc03a1b04 ran for 0 msecs: proto_init+0x0/0x54()
Calling initcall 0xc03a2080: net_dev_init+0x0/0x124()
initcall 0xc03a2080: net_dev_init+0x0/0x124() returned 0.
initcall 0xc03a2080 ran for 0 msecs: net_dev_init+0x0/0x124()
Calling initcall 0xc03a2240: neigh_init+0x0/0x98()
initcall 0xc03a2240: neigh_init+0x0/0x98() returned 0.
initcall 0xc03a2240 ran for 0 msecs: neigh_init+0x0/0x98()
Calling initcall 0xc03a2514: fib_rules_init+0x0/0xd0()
initcall 0xc03a2514: fib_rules_init+0x0/0xd0() returned 0.
initcall 0xc03a2514 ran for 0 msecs: fib_rules_init+0x0/0xd0()
Calling initcall 0xc03a25e4: pktsched_init+0x0/0xf4()
initcall 0xc03a25e4: pktsched_init+0x0/0xf4() returned 0.
initcall 0xc03a25e4 ran for 0 msecs: pktsched_init+0x0/0xf4()
Calling initcall 0xc03a2700: tc_filter_init+0x0/0x70()
initcall 0xc03a2700: tc_filter_init+0x0/0x70() returned 0.
initcall 0xc03a2700 ran for 0 msecs: tc_filter_init+0x0/0x70()
Calling initcall 0xc03a2770: tc_action_init+0x0/0x70()
initcall 0xc03a2770: tc_action_init+0x0/0x70() returned 0.
initcall 0xc03a2770 ran for 0 msecs: tc_action_init+0x0/0x70()
Calling initcall 0xc03a2984: genl_init+0x0/0xf8()
initcall 0xc03a2984: genl_init+0x0/0xf8() returned 0.
initcall 0xc03a2984 ran for 15 msecs: genl_init+0x0/0xf8()
Calling initcall 0xc03a467c: atm_init+0x0/0xd4()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xc03a467c: atm_init+0x0/0xd4() returned 0.
initcall 0xc03a467c ran for 3 msecs: atm_init+0x0/0xd4()
Calling initcall 0xc03a48f0: wireless_nlevent_init+0x0/0x20()
initcall 0xc03a48f0: wireless_nlevent_init+0x0/0x20() returned 0.
initcall 0xc03a48f0 ran for 0 msecs: wireless_nlevent_init+0x0/0x20()
Calling initcall 0xc03a4910: sysctl_init+0x0/0x48()
initcall 0xc03a4910: sysctl_init+0x0/0x48() returned 0.
initcall 0xc03a4910 ran for 0 msecs: sysctl_init+0x0/0x48()
Calling initcall 0xc0393750: add_rtc+0x0/0xcc()
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
initcall 0xc0393750: add_rtc+0x0/0xcc() returned 0.
initcall 0xc0393750 ran for 38 msecs: add_rtc+0x0/0xcc()
Calling initcall 0xc03954e4: clocksource_done_booting+0x0/0x14()
initcall 0xc03954e4: clocksource_done_booting+0x0/0x14()<6>Time: timebase clocksource has been installed.
Switched to high resolution mode on CPU 0
 returned 0.
initcall 0xc03954e4 ran for 0 msecs: clocksource_done_booting+0x0/0x14()
Calling initcall 0xc0398150: init_pipe_fs+0x0/0x70()
initcall 0xc0398150: init_pipe_fs+0x0/0x70() returned 0.
initcall 0xc0398150 ran for 0 msecs: init_pipe_fs+0x0/0x70()
Calling initcall 0xc0398c68: eventpoll_init+0x0/0x98()
initcall 0xc0398c68: eventpoll_init+0x0/0x98() returned 0.
initcall 0xc0398c68 ran for 0 msecs: eventpoll_init+0x0/0x98()
Calling initcall 0xc0398d00: anon_inode_init+0x0/0xb0()
initcall 0xc0398d00: anon_inode_init+0x0/0xb0() returned 0.
initcall 0xc0398d00 ran for 0 msecs: anon_inode_init+0x0/0xb0()
Calling initcall 0xc039ba48: chr_dev_init+0x0/0xbc()
initcall 0xc039ba48: chr_dev_init+0x0/0xbc() returned 0.
initcall 0xc039ba48 ran for 0 msecs: chr_dev_init+0x0/0xbc()
Calling initcall 0xc039f170: loopback_init+0x0/0x28()
initcall 0xc039f170: loopback_init+0x0/0x28() returned 0.
initcall 0xc039f170 ran for 0 msecs: loopback_init+0x0/0x28()
Calling initcall 0xc03a196c: cpufreq_gov_performance_init+0x0/0x28()
initcall 0xc03a196c: cpufreq_gov_performance_init+0x0/0x28() returned 0.
initcall 0xc03a196c ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x28()
Calling initcall 0xc03a3b7c: inet_init+0x0/0x1d0()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xc03a3b7c: inet_init+0x0/0x1d0() returned 0.
initcall 0xc03a3b7c ran for 78 msecs: inet_init+0x0/0x1d0()
Calling initcall 0xc038b9f0: populate_rootfs+0x0/0xf8()
initcall 0xc038b9f0: populate_rootfs+0x0/0xf8() returned 0.
initcall 0xc038b9f0 ran for 0 msecs: populate_rootfs+0x0/0xf8()
Calling initcall 0xc038bd0c: irq_debugfs_init+0x0/0x50()
initcall 0xc038bd0c: irq_debugfs_init+0x0/0x50() returned -12.
initcall 0xc038bd0c ran for 0 msecs: irq_debugfs_init+0x0/0x50()
initcall at 0xc038bd0c: irq_debugfs_init+0x0/0x50(): returned with error code -12
Calling initcall 0xc038c52c: register_powersave_nap_sysctl+0x0/0x2c()
initcall 0xc038c52c: register_powersave_nap_sysctl+0x0/0x2c() returned 0.
initcall 0xc038c52c ran for 0 msecs: register_powersave_nap_sysctl+0x0/0x2c()
Calling initcall 0xc038c5a8: TAU_init+0x0/0xf4()
Thermal assist unit not available
initcall 0xc038c5a8: TAU_init+0x0/0xf4() returned 1.
initcall 0xc038c5a8 ran for 2 msecs: TAU_init+0x0/0xf4()
initcall at 0xc038c5a8: TAU_init+0x0/0xf4(): returned with error code 1
Calling initcall 0xc038cfbc: export_flat_device_tree+0x0/0x60()
initcall 0xc038cfbc: export_flat_device_tree+0x0/0x60() returned 0.
initcall 0xc038cfbc ran for 0 msecs: export_flat_device_tree+0x0/0x60()
Calling initcall 0xc038e380: add_pcspkr+0x0/0x80()
initcall 0xc038e380: add_pcspkr+0x0/0x80() returned 0.
initcall 0xc038e380 ran for 0 msecs: add_pcspkr+0x0/0x80()
Calling initcall 0xc03911cc: serial_dev_init+0x0/0xf0()
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
irq: host = 0xc04311c0
irq: irq_create_mapping(0xc04311c0, 0x3)
irq: -> using host @c04311c0
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
irq: host = 0xc04311c0
irq: irq_create_mapping(0xc04311c0, 0x4)
irq: -> using host @c04311c0
irq: -> existing mapping on virq 4
irq: created irq mapping, virq = 4
irq: created irq mapping, virq = 4
fixup_port_pio(1)
port 1, IO 3f8 -> 3f8
Registering platform serial ports
initcall 0xc03911cc: serial_dev_init+0x0/0xf0() returned 0.
initcall 0xc03911cc ran for 136 msecs: serial_dev_init+0x0/0xf0()
Calling initcall 0xc0392254: audit_classes_init+0x0/0x70()
initcall 0xc0392254: audit_classes_init+0x0/0x70() returned 0.
initcall 0xc0392254 ran for 0 msecs: audit_classes_init+0x0/0x70()
Calling initcall 0xc0392e18: setup_kcore+0x0/0xe0()
setup_kcore: restrict size=3fffffff
initcall 0xc0392e18: setup_kcore+0x0/0xe0() returned 0.
initcall 0xc0392e18 ran for 3 msecs: setup_kcore+0x0/0xe0()
Calling initcall 0xc0394330: create_proc_profile+0x0/0x74()
initcall 0xc0394330: create_proc_profile+0x0/0x74() returned 0.
initcall 0xc0394330 ran for 0 msecs: create_proc_profile+0x0/0x74()
Calling initcall 0xc0394730: ioresources_init+0x0/0x70()
initcall 0xc0394730: ioresources_init+0x0/0x70() returned 0.
initcall 0xc0394730 ran for 0 msecs: ioresources_init+0x0/0x70()
Calling initcall 0xc039483c: uid_cache_init+0x0/0x94()
initcall 0xc039483c: uid_cache_init+0x0/0x94() returned 0.
initcall 0xc039483c ran for 0 msecs: uid_cache_init+0x0/0x94()
Calling initcall 0xc0394eec: init_posix_timers+0x0/0xc0()
initcall 0xc0394eec: init_posix_timers+0x0/0xc0() returned 0.
initcall 0xc0394eec ran for 0 msecs: init_posix_timers+0x0/0xc0()
Calling initcall 0xc0394fac: init_posix_cpu_timers+0x0/0xf0()
initcall 0xc0394fac: init_posix_cpu_timers+0x0/0xf0() returned 0.
initcall 0xc0394fac ran for 0 msecs: init_posix_cpu_timers+0x0/0xf0()
Calling initcall 0xc0395158: nsproxy_cache_init+0x0/0x44()
initcall 0xc0395158: nsproxy_cache_init+0x0/0x44() returned 0.
initcall 0xc0395158 ran for 0 msecs: nsproxy_cache_init+0x0/0x44()
Calling initcall 0xc0395310: timekeeping_init_device+0x0/0x44()
initcall 0xc0395310: timekeeping_init_device+0x0/0x44() returned 0.
initcall 0xc0395310 ran for 0 msecs: timekeeping_init_device+0x0/0x44()
Calling initcall 0xc03955b0: init_clocksource_sysfs+0x0/0x80()
initcall 0xc03955b0: init_clocksource_sysfs+0x0/0x80() returned 0.
initcall 0xc03955b0 ran for 0 msecs: init_clocksource_sysfs+0x0/0x80()
Calling initcall 0xc0395658: init_timer_list_procfs+0x0/0x4c()
initcall 0xc0395658: init_timer_list_procfs+0x0/0x4c() returned 0.
initcall 0xc0395658 ran for 0 msecs: init_timer_list_procfs+0x0/0x4c()
Calling initcall 0xc0395744: init+0x0/0xc8()
initcall 0xc0395744: init+0x0/0xc8() returned 0.
initcall 0xc0395744 ran for 0 msecs: init+0x0/0xc8()
Calling initcall 0xc039580c: proc_dma_init+0x0/0x48()
initcall 0xc039580c: proc_dma_init+0x0/0x48() returned 0.
initcall 0xc039580c ran for 0 msecs: proc_dma_init+0x0/0x48()
Calling initcall 0xc0395854: kallsyms_init+0x0/0x48()
initcall 0xc0395854: kallsyms_init+0x0/0x48() returned 0.
initcall 0xc0395854 ran for 0 msecs: kallsyms_init+0x0/0x48()
Calling initcall 0xc03959a8: audit_init+0x0/0x158()
audit: initializing netlink socket (disabled)
type=2000 audit(2.285:1): initialized
initcall 0xc03959a8: audit_init+0x0/0x158() returned 0.
initcall 0xc03959a8 ran for 7 msecs: audit_init+0x0/0x158()
Calling initcall 0xc0395bc4: audit_tree_init+0x0/0x6c()
initcall 0xc0395bc4: audit_tree_init+0x0/0x6c() returned 0.
initcall 0xc0395bc4 ran for 0 msecs: audit_tree_init+0x0/0x6c()
Calling initcall 0xc0395dfc: relay_init+0x0/0x8()
initcall 0xc0395dfc: relay_init+0x0/0x8() returned 0.
initcall 0xc0395dfc ran for 0 msecs: relay_init+0x0/0x8()
Calling initcall 0xc0395e04: utsname_sysctl_init+0x0/0x2c()
initcall 0xc0395e04: utsname_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc0395e04 ran for 0 msecs: utsname_sysctl_init+0x0/0x2c()
Calling initcall 0xc0396cf8: init_per_zone_pages_min+0x0/0x5c()
initcall 0xc0396cf8: init_per_zone_pages_min+0x0/0x5c() returned 0.
initcall 0xc0396cf8 ran for 0 msecs: init_per_zone_pages_min+0x0/0x5c()
Calling initcall 0xc03978e8: pdflush_init+0x0/0x3c()
initcall 0xc03978e8: pdflush_init+0x0/0x3c() returned 0.
initcall 0xc03978e8 ran for 0 msecs: pdflush_init+0x0/0x3c()
Calling initcall 0xc03979a4: kswapd_init+0x0/0x2c()
initcall 0xc03979a4: kswapd_init+0x0/0x2c() returned 0.
initcall 0xc03979a4 ran for 0 msecs: kswapd_init+0x0/0x2c()
Calling initcall 0xc0397aa0: init_emergency_pool+0x0/0x88()
highmem bounce pool size: 64 pages
initcall 0xc0397aa0: init_emergency_pool+0x0/0x88() returned 0.
initcall 0xc0397aa0 ran for 2 msecs: init_emergency_pool+0x0/0x88()
Calling initcall 0xc0397b28: procswaps_init+0x0/0x48()
initcall 0xc0397b28: procswaps_init+0x0/0x48() returned 0.
initcall 0xc0397b28 ran for 0 msecs: procswaps_init+0x0/0x48()
Calling initcall 0xc0397b70: init_tmpfs+0x0/0xcc()
initcall 0xc0397b70: init_tmpfs+0x0/0xcc() returned 0.
initcall 0xc0397b70 ran for 0 msecs: init_tmpfs+0x0/0xcc()
Calling initcall 0xc0397e34: slab_sysfs_init+0x0/0x118()
initcall 0xc0397e34: slab_sysfs_init+0x0/0x118() returned 0.
initcall 0xc0397e34 ran for 5 msecs: slab_sysfs_init+0x0/0x118()
Calling initcall 0xc03981c0: fasync_init+0x0/0x44()
initcall 0xc03981c0: fasync_init+0x0/0x44() returned 0.
initcall 0xc03981c0 ran for 0 msecs: fasync_init+0x0/0x44()
Calling initcall 0xc03988bc: aio_setup+0x0/0x94()
initcall 0xc03988bc: aio_setup+0x0/0x94() returned 0.
initcall 0xc03988bc ran for 0 msecs: aio_setup+0x0/0x94()
Calling initcall 0xc0398b6c: inotify_setup+0x0/0x14()
initcall 0xc0398b6c: inotify_setup+0x0/0x14() returned 0.
initcall 0xc0398b6c ran for 0 msecs: inotify_setup+0x0/0x14()
Calling initcall 0xc0398b80: inotify_user_setup+0x0/0xe8()
initcall 0xc0398b80: inotify_user_setup+0x0/0xe8() returned 0.
initcall 0xc0398b80 ran for 0 msecs: inotify_user_setup+0x0/0xe8()
Calling initcall 0xc0398e00: init_mbcache+0x0/0x2c()
initcall 0xc0398e00: init_mbcache+0x0/0x2c() returned 0.
initcall 0xc0398e00 ran for 0 msecs: init_mbcache+0x0/0x2c()
Calling initcall 0xc0398e2c: dquot_init+0x0/0x114()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall 0xc0398e2c: dquot_init+0x0/0x114() returned 0.
initcall 0xc0398e2c ran for 7 msecs: dquot_init+0x0/0x114()
Calling initcall 0xc0398f40: dnotify_init+0x0/0x44()
initcall 0xc0398f40: dnotify_init+0x0/0x44() returned 0.
initcall 0xc0398f40 ran for 0 msecs: dnotify_init+0x0/0x44()
Calling initcall 0xc0399630: init_devpts_fs+0x0/0x64()
initcall 0xc0399630: init_devpts_fs+0x0/0x64() returned 0.
initcall 0xc0399630 ran for 0 msecs: init_devpts_fs+0x0/0x64()
Calling initcall 0xc0399694: init_ext3_fs+0x0/0x5c()
initcall 0xc0399694: init_ext3_fs+0x0/0x5c() returned 0.
initcall 0xc0399694 ran for 0 msecs: init_ext3_fs+0x0/0x5c()
Calling initcall 0xc03998a4: journal_init+0x0/0x38()
initcall 0xc03998a4: journal_init+0x0/0x38() returned 0.
initcall 0xc03998a4 ran for 0 msecs: journal_init+0x0/0x38()
Calling initcall 0xc03998dc: init_ext2_fs+0x0/0x5c()
initcall 0xc03998dc: init_ext2_fs+0x0/0x5c() returned 0.
initcall 0xc03998dc ran for 0 msecs: init_ext2_fs+0x0/0x5c()
Calling initcall 0xc0399994: init_cramfs_fs+0x0/0x4c()
initcall 0xc0399994: init_cramfs_fs+0x0/0x4c() returned 0.
initcall 0xc0399994 ran for 0 msecs: init_cramfs_fs+0x0/0x4c()
Calling initcall 0xc03999e0: init_ramfs_fs+0x0/0x28()
initcall 0xc03999e0: init_ramfs_fs+0x0/0x28() returned 0.
initcall 0xc03999e0 ran for 0 msecs: init_ramfs_fs+0x0/0x28()
Calling initcall 0xc0399ad4: ipc_init+0x0/0x2c()
initcall 0xc0399ad4: ipc_init+0x0/0x2c() returned 0.
initcall 0xc0399ad4 ran for 0 msecs: ipc_init+0x0/0x2c()
Calling initcall 0xc0399c68: ipc_sysctl_init+0x0/0x2c()
initcall 0xc0399c68: ipc_sysctl_init+0x0/0x2c() returned 0.
initcall 0xc0399c68 ran for 0 msecs: ipc_sysctl_init+0x0/0x2c()
Calling initcall 0xc0399c94: init_mqueue_fs+0x0/0xe8()
initcall 0xc0399c94: init_mqueue_fs+0x0/0xe8() returned 0.
initcall 0xc0399c94 ran for 0 msecs: init_mqueue_fs+0x0/0xe8()
Calling initcall 0xc0399f0c: key_proc_init+0x0/0x54()
initcall 0xc0399f0c: key_proc_init+0x0/0x54() returned 0.
initcall 0xc0399f0c ran for 0 msecs: key_proc_init+0x0/0x54()
Calling initcall 0xc0399f60: crypto_algapi_init+0x0/0x24()
initcall 0xc0399f60: crypto_algapi_init+0x0/0x24() returned 0.
initcall 0xc0399f60 ran for 0 msecs: crypto_algapi_init+0x0/0x24()
Calling initcall 0xc0399fc8: cryptomgr_init+0x0/0x28()
initcall 0xc0399fc8: cryptomgr_init+0x0/0x28() returned 0.
initcall 0xc0399fc8 ran for 0 msecs: cryptomgr_init+0x0/0x28()
Calling initcall 0xc0399ff0: hmac_module_init+0x0/0x28()
initcall 0xc0399ff0: hmac_module_init+0x0/0x28() returned 0.
initcall 0xc0399ff0 ran for 0 msecs: hmac_module_init+0x0/0x28()
Calling initcall 0xc039a018: init+0x0/0x28()
initcall 0xc039a018: init+0x0/0x28() returned 0.
initcall 0xc039a018 ran for 0 msecs: init+0x0/0x28()
Calling initcall 0xc039a3d8: noop_init+0x0/0x2c()
io scheduler noop registered
initcall 0xc039a3d8: noop_init+0x0/0x2c() returned 0.
initcall 0xc039a3d8 ran for 2 msecs: noop_init+0x0/0x2c()
Calling initcall 0xc039a404: as_init+0x0/0x2c()
io scheduler anticipatory registered
initcall 0xc039a404: as_init+0x0/0x2c() returned 0.
initcall 0xc039a404 ran for 3 msecs: as_init+0x0/0x2c()
Calling initcall 0xc039a430: deadline_init+0x0/0x2c()
io scheduler deadline registered
initcall 0xc039a430: deadline_init+0x0/0x2c() returned 0.
initcall 0xc039a430 ran for 2 msecs: deadline_init+0x0/0x2c()
Calling initcall 0xc039a4e0: cfq_init+0x0/0x70()
io scheduler cfq registered (default)
initcall 0xc039a4e0: cfq_init+0x0/0x70() returned 0.
initcall 0xc039a4e0 ran for 3 msecs: cfq_init+0x0/0x70()
Calling initcall 0xc02c5678: 0xc02c5678()
pci 0000:00:00.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:00.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:01.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:01.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:06.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:06.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.1: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.2: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.2: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.3: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.3: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.4: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.4: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.5: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.5: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:07.6: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:07.6: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:08.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:08.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:08.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:08.1: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:09.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:09.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:09.1: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:0a.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:0a.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.1: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:0a.2: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.2: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:0a.3: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.3: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:00:0a.4: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:00:0a.4: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:01:00.0: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.0: calling quirk 0xc02cf614: 0xc02cf614()
pci 0000:01:00.1: calling quirk 0xc012f2d8: quirk_cardbus_legacy+0x0/0x44()
pci 0000:01:00.1: calling quirk 0xc02cf614: 0xc02cf614()
initcall 0xc02c5678: 0xc02c5678() returned 0.
initcall 0xc02c5678 ran for 235 msecs: 0xc02c5678()
Calling initcall 0xc039af70: pci_proc_init+0x0/0x9c()
initcall 0xc039af70: pci_proc_init+0x0/0x9c() returned 0.
initcall 0xc039af70 ran for 0 msecs: pci_proc_init+0x0/0x9c()
Calling initcall 0xc039b00c: pcie_portdrv_init+0x0/0x6c()
initcall 0xc039b00c: pcie_portdrv_init+0x0/0x6c() returned 0.
initcall 0xc039b00c ran for 0 msecs: pcie_portdrv_init+0x0/0x6c()
Calling initcall 0xc039b078: aer_service_init+0x0/0x44()
initcall 0xc039b078: aer_service_init+0x0/0x44() returned 0.
initcall 0xc039b078 ran for 0 msecs: aer_service_init+0x0/0x44()
Calling initcall 0xc039b418: fb_console_init+0x0/0xb0()
initcall 0xc039b418: fb_console_init+0x0/0xb0() returned 0.
initcall 0xc039b418 ran for 0 msecs: fb_console_init+0x0/0xb0()
Calling initcall 0xc039b9b8: radeonfb_init+0x0/0x68()
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
initcall 0xc039b9b8: radeonfb_init+0x0/0x68() returned 0.
initcall 0xc039b9b8 ran for 4553 msecs: radeonfb_init+0x0/0x68()
Calling initcall 0xc039bb2c: rand_initialize+0x0/0x44()
initcall 0xc039bb2c: rand_initialize+0x0/0x44() returned 0.
initcall 0xc039bb2c ran for 0 msecs: rand_initialize+0x0/0x44()
Calling initcall 0xc039bbd0: tty_init+0x0/0x208()
initcall 0xc039bbd0: tty_init+0x0/0x208() returned 0.
initcall 0xc039bbd0 ran for 6 msecs: tty_init+0x0/0x208()
Calling initcall 0xc039c1f8: pty_init+0x0/0x28()
initcall 0xc039c1f8: pty_init+0x0/0x28() returned 0.
initcall 0xc039c1f8 ran for 2 msecs: pty_init+0x0/0x28()
Calling initcall 0xc039c970: drm_core_init+0x0/0x168()
[drm] Initialized drm 1.1.0 20060810
initcall 0xc039c970: drm_core_init+0x0/0x168() returned 0.
initcall 0xc039c970 ran for 3 msecs: drm_core_init+0x0/0x168()
Calling initcall 0xc039cad8: radeon_init+0x0/0x38()
[drm] Initialized radeon 1.28.0 20060524 on minor 0
initcall 0xc039cad8: radeon_init+0x0/0x38() returned 0.
initcall 0xc039cad8 ran for 4 msecs: radeon_init+0x0/0x38()
Calling initcall 0xc039cfc4: serial8250_init+0x0/0xfc()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250.0: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
console [ttyS0] enabled
serial8250.0: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
initcall 0xc039cfc4: serial8250_init+0x0/0xfc() returned 0.
initcall 0xc039cfc4 ran for 53499 msecs: serial8250_init+0x0/0xfc()
Calling initcall 0xc039d0f0: serial8250_pci_init+0x0/0x34()
initcall 0xc039d0f0: serial8250_pci_init+0x0/0x34() returned 0.
initcall 0xc039d0f0 ran for 0 msecs: serial8250_pci_init+0x0/0x34()
Calling initcall 0xc039d6cc: parport_default_proc_register+0x0/0x3c()
initcall 0xc039d6cc: parport_default_proc_register+0x0/0x3c() returned 0.
initcall 0xc039d6cc ran for 0 msecs: parport_default_proc_register+0x0/0x3c()
Calling initcall 0xc039dbd4: parport_pc_init+0x0/0xf4()
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378
initcall 0xc039dbd4: parport_pc_init+0x0/0xf4() returned 0.
initcall 0xc039dbd4 ran for 156 msecs: parport_pc_init+0x0/0xf4()
Calling initcall 0xc039dcc8: parport_serial_init+0x0/0x34()
initcall 0xc039dcc8: parport_serial_init+0x0/0x34() returned 0.
initcall 0xc039dcc8 ran for 0 msecs: parport_serial_init+0x0/0x34()
Calling initcall 0xc039e67c: floppy_init+0x0/0x664()
Floppy drive(s): fd0 is 2.88M
FDC 0 is a post-1991 82077
initcall 0xc039e67c: floppy_init+0x0/0x664() returned 0.
initcall 0xc039e67c ran for 40 msecs: floppy_init+0x0/0x664()
Calling initcall 0xc039ece0: brd_init+0x0/0x198()
brd: module loaded
initcall 0xc039ece0: brd_init+0x0/0x198() returned 0.
initcall 0xc039ece0 ran for 10 msecs: brd_init+0x0/0x198()
Calling initcall 0xc039ef2c: vortex_init+0x0/0x90()
3c59x: Donald Becker and others.
0000:00:06.0: 3Com PCI 3c905C Tornado at f100c000.
initcall 0xc039ef2c: vortex_init+0x0/0x90() returned 0.
initcall 0xc039ef2c ran for 47 msecs: vortex_init+0x0/0x90()
Calling initcall 0xc039f130: net_olddevs_init+0x0/0x40()
initcall 0xc039f130: net_olddevs_init+0x0/0x40() returned 0.
initcall 0xc039f130 ran for 0 msecs: net_olddevs_init+0x0/0x40()
Calling initcall 0xc039f22c: cp_init+0x0/0x34()
initcall 0xc039f22c: cp_init+0x0/0x34() returned 0.
initcall 0xc039f22c ran for 0 msecs: cp_init+0x0/0x34()
Calling initcall 0xc039f478: ide_init+0x0/0xa4()
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
initcall 0xc039f478: ide_init+0x0/0xa4() returned 0.
initcall 0xc039f478 ran for 31 msecs: ide_init+0x0/0xa4()
Calling initcall 0xc039faf0: it8213_ide_init+0x0/0x34()
initcall 0xc039faf0: it8213_ide_init+0x0/0x34() returned 0.
initcall 0xc039faf0 ran for 0 msecs: it8213_ide_init+0x0/0x34()
Calling initcall 0xc039fb24: it821x_ide_init+0x0/0x34()
initcall 0xc039fb24: it821x_ide_init+0x0/0x34() returned 0.
initcall 0xc039fb24 ran for 0 msecs: it821x_ide_init+0x0/0x34()
Calling initcall 0xc039fb58: pdc202xx_ide_init+0x0/0x34()
initcall 0xc039fb58: pdc202xx_ide_init+0x0/0x34() returned 0.
initcall 0xc039fb58 ran for 0 msecs: pdc202xx_ide_init+0x0/0x34()
Calling initcall 0xc039fb8c: pdc202new_ide_init+0x0/0x34()
initcall 0xc039fb8c: pdc202new_ide_init+0x0/0x34() returned 0.
initcall 0xc039fb8c ran for 0 msecs: pdc202new_ide_init+0x0/0x34()
Calling initcall 0xc039fbc0: siimage_ide_init+0x0/0x34()
initcall 0xc039fbc0: siimage_ide_init+0x0/0x34() returned 0.
initcall 0xc039fbc0 ran for 0 msecs: siimage_ide_init+0x0/0x34()
Calling initcall 0xc039fbf4: via_ide_init+0x0/0x34()
initcall 0xc039fbf4: via_ide_init+0x0/0x34() returned 0.
initcall 0xc039fbf4 ran for 0 msecs: via_ide_init+0x0/0x34()
Calling initcall 0xc039fcd0: ide_scan_pcibus+0x0/0x10c()
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
initcall 0xc039fcd0: ide_scan_pcibus+0x0/0x10c() returned 0.
initcall 0xc039fcd0 ran for 8977 msecs: ide_scan_pcibus+0x0/0x10c()
Calling initcall 0xc039fddc: idedisk_init+0x0/0x28()
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: RDSK (512) hda1 (SFS^@)(res 2 spb 1) hda2 (LNX^@)(res 2 spb 2) hda3 (LNX^@)(res 2 spb 2) hda4 (LNX^@)(res 2 spb 2) hda5 (LNX^@)(res 2 spb 2) hda6 (SWP^@)(res 2 spb 2) hda7 (LNX^@)(res 2 spb 2) hda8 (DOS^C)(res 2 spb 2) hda9 (SFS^@)(res 2 spb 1) hda10 (SFS^@)(res 2 spb 1) hda11 (LNX^@)(res 2 spb 2) hda12 (LNX^@)(res 2 spb 2)
initcall 0xc039fddc: idedisk_init+0x0/0x28() returned 0.
initcall 0xc039fddc ran for 125 msecs: idedisk_init+0x0/0x28()
Calling initcall 0xc039fe04: ide_cdrom_init+0x0/0x28()
hdc: ATAPI 48X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
initcall 0xc039fe04: ide_cdrom_init+0x0/0x28() returned 0.
initcall 0xc039fe04 ran for 49 msecs: ide_cdrom_init+0x0/0x28()
Calling initcall 0xc03a0218: ieee1394_init+0x0/0x280()
initcall 0xc03a0218: ieee1394_init+0x0/0x280() returned 0.
initcall 0xc03a0218 ran for 0 msecs: ieee1394_init+0x0/0x280()
Calling initcall 0xc03a0498: cdrom_init+0x0/0x24()
initcall 0xc03a0498: cdrom_init+0x0/0x24() returned 0.
initcall 0xc03a0498 ran for 0 msecs: cdrom_init+0x0/0x24()
Calling initcall 0xc03a0748: mon_init+0x0/0xd8()
initcall 0xc03a0748: mon_init+0x0/0xd8() returned 0.
initcall 0xc03a0748 ran for 0 msecs: mon_init+0x0/0xd8()
Calling initcall 0xc03a095c: ohci_hcd_mod_init+0x0/0x94()
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
initcall 0xc03a095c: ohci_hcd_mod_init+0x0/0x94() returned 0.
initcall 0xc03a095c ran for 731 msecs: ohci_hcd_mod_init+0x0/0x94()
Calling initcall 0xc03a09f0: uhci_hcd_init+0x0/0xd8()
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
initcall 0xc03a09f0: uhci_hcd_init+0x0/0xd8() returned 0.
initcall 0xc03a09f0 ran for 422 msecs: uhci_hcd_init+0x0/0xd8()
Calling initcall 0xc03a0b6c: i8042_init+0x0/0x10c()
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xc03a0b6c: i8042_init+0x0/0x10c() returned 0.
initcall 0xc03a0b6c ran for 28 msecs: i8042_init+0x0/0x10c()
Calling initcall 0xc03a0df4: mousedev_init+0x0/0xb4()
mice: PS/2 mouse device common for all mice
initcall 0xc03a0df4: mousedev_init+0x0/0xb4() returned 0.
initcall 0xc03a0df4 ran for 14 msecs: mousedev_init+0x0/0xb4()
Calling initcall 0xc03a0ebc: atkbd_init+0x0/0x34()
initcall 0xc03a0ebc: atkbd_init+0x0/0x34() returned 0.
initcall 0xc03a0ebc ran for 0 msecs: atkbd_init+0x0/0x34()
Calling initcall 0xc03a0ef0: psmouse_init+0x0/0x94()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xc03a0ef0: psmouse_init+0x0/0x94() returned 0.
initcall 0xc03a0ef0 ran for 934 msecs: psmouse_init+0x0/0x94()
Calling initcall 0xc03a0f84: pcspkr_init+0x0/0x28()
input: PC Speaker as /class/input/input1
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
initcall 0xc03a0f84: pcspkr_init+0x0/0x28() returned 0.
initcall 0xc03a0f84 ran for 644 msecs: pcspkr_init+0x0/0x28()
Calling initcall 0xc03a11e4: cmos_init+0x0/0x30()
rtc_cmos: dev (254:0)
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
initcall 0xc03a11e4: cmos_init+0x0/0x30() returned 0.
initcall 0xc03a11e4 ran for 35 msecs: cmos_init+0x0/0x30()
Calling initcall 0xc03a1800: i2c_dev_init+0x0/0xbc()
i2c /dev entries driver
initcall 0xc03a1800: i2c_dev_init+0x0/0xbc() returned 0.
initcall 0xc03a1800 ran for 10 msecs: i2c_dev_init+0x0/0xbc()
Calling initcall 0xc03a1994: ledtrig_ide_init+0x0/0x34()
initcall 0xc03a1994: ledtrig_ide_init+0x0/0x34() returned 0.
initcall 0xc03a1994 ran for 0 msecs: ledtrig_ide_init+0x0/0x34()
Calling initcall 0xc03a19c8: hid_init+0x0/0x8()
initcall 0xc03a19c8: hid_init+0x0/0x8() returned 0.
initcall 0xc03a19c8 ran for 0 msecs: hid_init+0x0/0x8()
Calling initcall 0xc03a19d0: init_soundcore+0x0/0x7c()
initcall 0xc03a19d0: init_soundcore+0x0/0x7c() returned 0.
initcall 0xc03a19d0 ran for 0 msecs: init_soundcore+0x0/0x7c()
Calling initcall 0xc03a1d38: sysctl_core_init+0x0/0x28()
initcall 0xc03a1d38: sysctl_core_init+0x0/0x28() returned 0.
initcall 0xc03a1d38 ran for 0 msecs: sysctl_core_init+0x0/0x28()
Calling initcall 0xc03a2428: flow_cache_init+0x0/0xcc()
initcall 0xc03a2428: flow_cache_init+0x0/0xcc() returned 0.
initcall 0xc03a2428 ran for 0 msecs: flow_cache_init+0x0/0xcc()
Calling initcall 0xc03a26d8: blackhole_module_init+0x0/0x28()
initcall 0xc03a26d8: blackhole_module_init+0x0/0x28() returned 0.
initcall 0xc03a26d8 ran for 0 msecs: blackhole_module_init+0x0/0x28()
Calling initcall 0xc03a3f2c: sysctl_ipv4_init+0x0/0x48()
initcall 0xc03a3f2c: sysctl_ipv4_init+0x0/0x48() returned 0.
initcall 0xc03a3f2c ran for 0 msecs: sysctl_ipv4_init+0x0/0x48()
Calling initcall 0xc03a4238: init_syncookies+0x0/0x30()
initcall 0xc03a4238: init_syncookies+0x0/0x30() returned 0.
initcall 0xc03a4238 ran for 0 msecs: init_syncookies+0x0/0x30()
Calling initcall 0xc03a4268: xfrm4_beet_init+0x0/0x2c()
initcall 0xc03a4268: xfrm4_beet_init+0x0/0x2c() returned 0.
initcall 0xc03a4268 ran for 0 msecs: xfrm4_beet_init+0x0/0x2c()
Calling initcall 0xc02a6f90: ipv4_netfilter_init+0x0/0x28()
initcall 0xc02a6f90: ipv4_netfilter_init+0x0/0x28() returned 0.
initcall 0xc02a6f90 ran for 0 msecs: ipv4_netfilter_init+0x0/0x28()
Calling initcall 0xc03a4294: bictcp_register+0x0/0x28()
TCP bic registered
initcall 0xc03a4294: bictcp_register+0x0/0x28() returned 0.
initcall 0xc03a4294 ran for 9 msecs: bictcp_register+0x0/0x28()
Calling initcall 0xc03a4558: af_unix_init+0x0/0x70()
NET: Registered protocol family 1
initcall 0xc03a4558: af_unix_init+0x0/0x70() returned 0.
initcall 0xc03a4558 ran for 12 msecs: af_unix_init+0x0/0x70()
Calling initcall 0xc03a45c8: packet_init+0x0/0x64()
NET: Registered protocol family 17
initcall 0xc03a45c8: packet_init+0x0/0x64() returned 0.
initcall 0xc03a45c8 ran for 12 msecs: packet_init+0x0/0x64()
Calling initcall 0xc03a483c: atm_clip_init+0x0/0xb4()
initcall 0xc03a483c: atm_clip_init+0x0/0xb4() returned 0.
initcall 0xc03a483c ran for 0 msecs: atm_clip_init+0x0/0xb4()
Calling initcall 0xc038e284: check_cache_coherency+0x0/0x80()
initcall 0xc038e284: check_cache_coherency+0x0/0x80() returned 0.
initcall 0xc038e284 ran for 0 msecs: check_cache_coherency+0x0/0x80()
Calling initcall 0xc001dacc: init_oops_id+0x0/0x40()
initcall 0xc001dacc: init_oops_id+0x0/0x40() returned 0.
initcall 0xc001dacc ran for 0 msecs: init_oops_id+0x0/0x40()
Calling initcall 0xc0394150: disable_boot_consoles+0x0/0x6c()
initcall 0xc0394150: disable_boot_consoles+0x0/0x6c() returned 0.
initcall 0xc0394150 ran for 0 msecs: disable_boot_consoles+0x0/0x6c()
Calling initcall 0xc0395288: pm_qos_power_init+0x0/0x88()
initcall 0xc0395288: pm_qos_power_init+0x0/0x88() returned 0.
initcall 0xc0395288 ran for 0 msecs: pm_qos_power_init+0x0/0x88()
Calling initcall 0xc039a6f4: random32_reseed+0x0/0x3c()
initcall 0xc039a6f4: random32_reseed+0x0/0x3c() returned 0.
initcall 0xc039a6f4 ran for 0 msecs: random32_reseed+0x0/0x3c()
Calling initcall 0xc039af00: pci_sysfs_init+0x0/0x70()
initcall 0xc039af00: pci_sysfs_init+0x0/0x70() returned 0.
initcall 0xc039af00 ran for 0 msecs: pci_sysfs_init+0x0/0x70()
Calling initcall 0xc039bb04: seqgen_init+0x0/0x28()
initcall 0xc039bb04: seqgen_init+0x0/0x28() returned 0.
initcall 0xc039bb04 ran for 0 msecs: seqgen_init+0x0/0x28()
Calling initcall 0xc01e1c84: scsi_complete_async_scans+0x0/0xf0()
initcall 0xc01e1c84: scsi_complete_async_scans+0x0/0xf0() returned 0.
initcall 0xc01e1c84 ran for 0 msecs: scsi_complete_async_scans+0x0/0xf0()
Calling initcall 0xc03a0fac: rtc_hctosys+0x0/0x140()
rtc_cmos rtc_cmos: setting system clock to 2008-03-01 19:13:04 UTC (1204398784)
initcall 0xc03a0fac: rtc_hctosys+0x0/0x140() returned 0.
initcall 0xc03a0fac ran for 20 msecs: rtc_hctosys+0x0/0x140()
Calling initcall 0xc03a3460: tcp_congestion_default+0x0/0xc()
initcall 0xc03a3460: tcp_congestion_default+0x0/0xc() returned 0.
initcall 0xc03a3460 ran for 0 msecs: tcp_congestion_default+0x0/0xc()
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 176k init
vt596_smbus 0000:00:07.4: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
gameport: EMU10K1 is pci0000:00:09.1/gameport0, io 0x802420, speed 1185kHz
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[9]  MMIO=[98106800-98106fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
VIA 82xx Modem 0000:00:07.6: calling quirk 0xc012ee10: quirk_via_vlink+0x0/0xd4()
ALSA sound/pci/via82xx_modem.c:989: AC'97 codec is not ready [0x19191919]
PCI: Enabling bus mastering for device 0000:00:07.6
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090e639000006f1]
VIA 82xx Modem: probe of 0000:00:07.6 failed with error -13
ALSA sound/pci/bt87x.c:931: bt87x0: Using board 1, analog, digital (rate 32000 Hz)
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
[drm] Setting GART location based on new memory map
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#1]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_bt87x snd_via82xx_modem snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_rawmidi snd_pcm snd_hwdep snd_seq_device snd_timer ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: eef55d80 TRAP: 0300   Not tainted  (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044442  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = eef36000[2495] 'Xorg' THREAD: eef54000
GPR00: c0184534 eef55e30 eef36000 00000000 00000080 0000001f ee817ffc 00000000 
GPR08: 00009032 c040abd8 c0406f00 c040abd8 c11e3200 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00000000 2e810000 00008000 efa5d400 
GPR24: 00000000 eef73360 eeff0000 ee810000 00000800 efa5dadc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[eef55e30] [c0184144] drm_ati_alloc_pcigart_table+0x48/0xe0 (unreliable)
[eef55e40] [c0184534] drm_ati_pcigart_init+0x1b0/0x2a8
[eef55e80] [c0188de0] radeon_do_init_cp+0x8a0/0x91c
[eef55ea0] [c017fc78] drm_ioctl+0x230/0x348
[eef55ed0] [c008e744] vfs_ioctl+0x6c/0x84
[eef55ee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[eef55f10] [c008ebec] sys_ioctl+0x40/0x70
[eef55f40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 4f07021dd9266b39 ]---
[drm:drm_release] *ERROR* Device busy: 1 0
eth0: no IPv6 routers present
[drm] Setting GART location based on new memory map
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#2]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_bt87x snd_via82xx_modem snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_rawmidi snd_pcm snd_hwdep snd_seq_device snd_timer ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: ee86fd80 TRAP: 0300   Tainted: G      D   (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044422  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = ee84ec80[2686] 'Xorg' THREAD: ee86e000
GPR00: c0184534 ee86fe30 ee84ec80 00000000 00000080 0000001f ee8ffffc 00000000 
GPR08: 00009032 c040b148 c0406f80 c040b148 c11e4f00 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00000000 2e8f8000 00008000 efa5d400 
GPR24: 00000000 ee85f580 eeff0000 ee8f8000 00000800 efa5dadc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[ee86fe30] [c0184144] drm_ati_alloc_pcigart_table+0x48/0xe0 (unreliable)
[ee86fe40] [c0184534] drm_ati_pcigart_init+0x1b0/0x2a8
[ee86fe80] [c0188de0] radeon_do_init_cp+0x8a0/0x91c
[ee86fea0] [c017fc78] drm_ioctl+0x230/0x348
[ee86fed0] [c008e744] vfs_ioctl+0x6c/0x84
[ee86fee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[ee86ff10] [c008ebec] sys_ioctl+0x40/0x70
[ee86ff40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 4f07021dd9266b39 ]---
[drm:drm_release] *ERROR* Device busy: 1 0
[drm] Setting GART location based on new memory map
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0010d5c
Oops: Kernel access of bad area, sig: 11 [#3]
AmigaOne
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss sunrpc appletalk exportfs psnap llc ppdev lp ipv6 dm_snapshot dm_mirror dm_mod snd_emu10k1_synth snd_emux_synth snd_via82xx snd_seq_virmidi snd_seq_midi_emul snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_bt87x snd_via82xx_modem snd_pcm_oss snd_mixer_oss firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_rawmidi snd_pcm snd_hwdep snd_seq_device snd_timer ohci1394 snd emu10k1_gp gameport snd_page_alloc i2c_viapro evdev joydev
NIP: c0010d5c LR: c0015da4 CTR: 00000080
REGS: ee81bd80 TRAP: 0300   Tainted: G      D   (2.6.25-rc3)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42044442  XER: 00000000
DAR: 00000000, DSISR: 40000000
TASK = ef8d6640[2700] 'Xorg' THREAD: ee81a000
GPR00: c0184534 ee81be30 ef8d6640 00000000 00000080 0000001f ee927ffc 00000000 
GPR08: 00009032 c040aa18 c0407180 c040aa18 c11e5400 101dd518 101d0000 101d0000 
GPR16: 101a0000 101a0000 101a0000 101d0000 00000000 2e920000 00008000 efa5d400 
GPR24: 00000000 ee85f680 eeff0000 ee920000 00000800 efa5dadc 00000000 00000000 
NIP [c0010d5c] clean_dcache_range+0x1c/0x30
LR [c0015da4] __dma_sync+0x4c/0x64
Call Trace:
[ee81be30] [c0184144] drm_ati_alloc_pcigart_table+0x48/0xe0 (unreliable)
[ee81be40] [c0184534] drm_ati_pcigart_init+0x1b0/0x2a8
[ee81be80] [c0188de0] radeon_do_init_cp+0x8a0/0x91c
[ee81bea0] [c017fc78] drm_ioctl+0x230/0x348
[ee81bed0] [c008e744] vfs_ioctl+0x6c/0x84
[ee81bee0] [c008eb78] do_vfs_ioctl+0x18c/0x1c0
[ee81bf10] [c008ebec] sys_ioctl+0x40/0x70
[ee81bf40] [c00111bc] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfd0258c
    LR = 0xfd024f0
Instruction dump:
38c60020 4200fff8 7c0004ac 4c00012c 4e800020 38a0001f 7c632878 7c832050 
7c842a14 5484d97f 4d820020 7c8903a6 <7c00186c> 38630020 4200fff8 7c0004ac 
---[ end trace 4f07021dd9266b39 ]---
[drm:drm_release] *ERROR* Device busy: 1 0

--========GMX175271204455905968840--
