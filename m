Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYFPT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYFPT2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYFPT20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:28:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:39199 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYFPT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:28:15 -0400
Subject: kernel BUG at kernel/workqueue.c:169 (was: linux-next: Tree for
	June 16)
From: Thomas Meyer <thomas@m3y3r.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080616190103.c3271e3e.sfr@canb.auug.org.au>
References: <20080616190103.c3271e3e.sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary="=-QQoYNgtK1Fo59RjBS0qg"
Date: Mon, 16 Jun 2008 23:28:47 +0200
Message-Id: <1213651727.3275.3.camel@dhcppc4>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QQoYNgtK1Fo59RjBS0qg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Am Montag, den 16.06.2008, 19:01 +1000 schrieb Stephen Rothwell:
> Changes since next-20080613:
> 
> The driver-core tree gained a conflict with the scsi-rc-fixes tree.
> 
> The ide tree needed a build fixup patch.
> 
> The net (really the included wireless) tree gained a couple of conflicts
> with the wireless-current tree.  It also needed a build fixup patch.
> 
> The arm tree needed a new driver reverted because it needs better Kconfig
> dependencies.
> 
> The blk-removal tree gained a conflict with the acpi tree.
> 
> The pcmcia tree gained a conflict with the bkl-removal tree.
> 
> I have temporarily applied the patch "powerpc: ppc32 does not need
> console_drivers exported" to fix know build problems on some powerpc
> platforms.

My internet is gone :-(

[   24.176830] kernel BUG at kernel/workqueue.c:169!
[   24.176830] invalid opcode: 0000 [#1] SMP 
[   24.176830] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/host2/target2:0:0/2:0:0:0/rev
[   24.176830] Modules linked in: rndis_wlan(+) cfi_probe snd_pcm gen_probe rndis_host ck804xrom(+) cdc_ether mtd snd_timer usbnet snd_page_alloc chipreg k8temp(+) snd_hwdep i2c_nforce2(+) hwmon button snd forcedeth(+) mii map_funcs i2c_core serio_raw soundcore pcspkr sg sr_mod cdrom sata_nv pata_amd ata_generic pata_acpi libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[   24.176830] 
[   24.176830] Pid: 1006, comm: modprobe Not tainted (2.6.26-rc6-next-20080616 #74)
[   24.176830] EIP: 0060:[<c04342e4>] EFLAGS: 00010213 CPU: 0
[   24.176830] EIP is at queue_work+0x1b/0x48
[   24.176830] EAX: f786606c EBX: 00000000 ECX: 00000000 EDX: f7866068
[   24.176830] ESI: f7866800 EDI: f897a98c EBP: f6490c88 ESP: f6490c84
[   24.176830]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   24.176830] Process modprobe (pid: 1006, ti=f6490000 task=f6458c70 task.ti=f6490000)
[   24.176830] Stack: f6e93cb8 f6490c90 f99a00b1 f6490cc0 f897a343 f7865c80 f7865d50 00000000 
[   24.176830]        00000000 80000002 00000001 00000000 00000003 ffffffea f7865c80 f6490d00 
[   24.176830]        f897a625 00000001 00000002 f6e93c00 f7865c80 f7865800 f7866800 c04f6d22 
[   24.176830] Call Trace:
[   24.176830]  [<f99a00b1>] ? rndis_wext_link_change+0x29/0x2b [rndis_wlan]
[   24.176830]  [<f897a343>] ? rndis_command+0x1af/0x23c [rndis_host]
[   24.176830]  [<f897a625>] ? generic_rndis_bind+0x109/0x3a6 [rndis_host]
[   24.176830]  [<c04f6d22>] ? idr_get_empty_slot+0x12a/0x1d9
[   24.176830]  [<f99a1f9f>] ? rndis_wext_bind+0x74/0x289 [rndis_wlan]
[   24.176830]  [<c05be14e>] ? alloc_netdev_mq+0xb8/0xc3
[   24.176830]  [<c05cbc0d>] ? ether_setup+0x0/0x78
[   24.176830]  [<f89685b3>] ? usbnet_probe+0x21d/0x4dd [usbnet]
[   24.176830]  [<c062ddfb>] ? mutex_lock+0x1d/0x2d
[   24.176830]  [<c0581ab5>] ? usb_autopm_do_device+0xb1/0xb9
[   24.176830]  [<c0582081>] ? usb_probe_interface+0xbc/0xef
[   24.176830]  [<c056bc6d>] ? driver_probe_device+0xa0/0x136
[   24.176830]  [<c056bd3d>] ? __driver_attach+0x3a/0x59
[   24.176830]  [<c056b6a5>] ? bus_for_each_dev+0x3b/0x63
[   24.176830]  [<c056bb12>] ? driver_attach+0x14/0x16
[   24.176830]  [<c056bd03>] ? __driver_attach+0x0/0x59
[   24.176830]  [<c056b0da>] ? bus_add_driver+0x9d/0x1ba
[   24.176830]  [<c056bec7>] ? driver_register+0x81/0xe1
[   24.176830]  [<c0582266>] ? usb_register_driver+0x66/0xc0
[   24.176830]  [<f891d017>] ? rndis_wlan_init+0x17/0x19 [rndis_wlan]
[   24.176830]  [<c04451bb>] ? sys_init_module+0x177e/0x1930
[   24.176830]  [<c0403895>] ? sysenter_past_esp+0x6a/0x91
[   24.176830]  =======================
[   24.176830] Code: 76 c0 8b 00 f7 d0 8b 04 88 e8 a7 ff ff ff c9 c3 55 89 e5 53 89 c3 f0 0f ba 2a 00 19 c0 31 c9 85 c0 75 30 8d 42 04 39 42 04 74 04 <0f> 0b eb fe 64 8b 0d 04 00 7b c0 83 7b 10 00 74 06 8b 0d f4 b4 
[   24.176830] EIP: [<c04342e4>] queue_work+0x1b/0x48 SS:ESP 0068:f6490c84
[   24.185309] ---[ end trace 6a99273b07870aed ]---

See attached dmesg and config.

greets
thomas


--=-QQoYNgtK1Fo59RjBS0qg
Content-Disposition: attachment; filename=d16.text
Content-Type: text/plain; name=d16.text; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-rc6-next-20080616 (thomas@dhcppc4) (gcc=
 version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #74 SMP Mon Jun 16 20:45:=
48 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786384) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1835008) 2 entries of =
256 used
[    0.000000] last_pfn =3D 1835008 max_arch_pfn =3D 16777216
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] 6272MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] old RAMDISK: 37cff000 - 37fefe3e
[    0.000000]   mapped low ram: 0 - 01200000
[    0.000000]   low ram: 0088c000 - 38000000
[    0.000000]   bootmap 0088c000 - 00893000
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [1000-1fff] EX TRAMPOLINE
[    0.000000]   early res: 2 [6000-6fff] TRAMPOLINE
[    0.000000]   early res: 3 [400000-88228b] TEXT DATA BSS
[    0.000000]   early res: 4 [37cff000-37fefe3d] RAMDISK
[    0.000000]   early res: 5 [883000-88bfff] INIT_PG_TABLE
[    0.000000]   early res: 6 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 7 [88c000-892fff] BOOTMAP
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 786384) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1835008) 2 entries of =
256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1835008
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786384
[    0.000000]     0:  1048576 ->  1835008
[    0.000000] On node 0 totalpages: 1572719
[    0.000000] free_area_init_node: node 0, pgdat c0742ac0, node_mem_map c1=
000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 12544 pages used for memmap
[    0.000000]   HighMem zone: 1330896 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F98B0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFD0000, 003C (r1 MSIISM OEMRSDT   4000807 MSFT =
      97)
[    0.000000] ACPI: FACP BFFD0200, 0084 (r2 MSIISM OEMFACP   4000807 MSFT =
      97)
[    0.000000] ACPI: DSDT BFFD0440, 5045 (r1  1ADGH 1ADGH013       13 INTL =
20051117)
[    0.000000] ACPI: FACS BFFDE000, 0040
[    0.000000] ACPI: APIC BFFD0390, 0070 (r1 MSIISM OEMAPIC   4000807 MSFT =
      97)
[    0.000000] ACPI: MCFG BFFD0400, 003C (r1 MSIISM OEMMCFG   4000807 MSFT =
      97)
[    0.000000] ACPI: OEMB BFFDE040, 0061 (r1 MSIISM AMI_OEM   4000807 MSFT =
      97)
[    0.000000] ACPI: HPET BFFD5490, 0038 (r1 MSIISM OEMHPET0  4000807 MSFT =
      97)
[    0.000000] ACPI: SSDT BFFD54D0, 028A (r1 A M I  POWERNOW        1 AMD  =
       1)
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000=
:1ec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31976 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1558383
[    0.000000] Kernel command line: ro root=3DLABEL=3DROOT rhgb
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc07d8000 soft=3Dc07b8000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2600.001 MHz processor.
[    0.000999] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000999] Memory: 6223892k/7340032k available (2250k kernel code, 6603=
6k reserved, 1258k data, 264k init, 5373760k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
[    0.000999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc0773000 - 0xc07b5000   ( 264 kB)
[    0.000999]       .data : 0xc0632a4a - 0xc076d458   (1258 kB)
[    0.000999]       .text : 0xc0400000 - 0xc0632a4a   (2250 kB)
[    0.000999] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000999] hpet clockevent registered
[    0.060866] Calibrating delay using timer specific routine.. 5203.05 Bog=
oMIPS (lpj=3D2601526)
[    0.060990] Security Framework initialized
[    0.060990] SELinux:  Initializing.
[    0.060990] SELinux:  Starting in permissive mode
[    0.060990] selinux_register_security:  Registering secondary module cap=
ability
[    0.060990] Capability LSM initialized as secondary
[    0.060990] Mount-cache hash table entries: 512
[    0.060990] Initializing cgroup subsys ns
[    0.060990] Initializing cgroup subsys cpuacct
[    0.060990] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.060990] CPU: L2 Cache: 512K (64 bytes/line)
[    0.060990] CPU 0(2) -> Core 0
[    0.060990] Intel machine check architecture supported.
[    0.060990] Intel machine check reporting enabled on CPU#0.
[    0.061055] using C1E aware idle routine
[    0.061118] Checking 'hlt' instruction... OK.
[    0.065270] ACPI: Core revision 20080609
[    0.071448] ENABLING IO-APIC IRQs
[    0.071707] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.081755] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ steppin=
g 02
[    0.081987] CPU 1 irqstacks, hard=3Dc07d9000 soft=3Dc07b9000
[    0.081987] Booting processor 1/1 ip 6000
[    0.091986] Initializing CPU#1
[    0.091986] Calibrating delay using timer specific routine.. 5199.69 Bog=
oMIPS (lpj=3D2599846)
[    0.091986] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.091986] CPU: L2 Cache: 512K (64 bytes/line)
[    0.091986] CPU 1(2) -> Core 1
[    0.091986] Intel machine check architecture supported.
[    0.091986] Intel machine check reporting enabled on CPU#1.
[    0.091986] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.152976] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ steppin=
g 02
[    0.153567] Brought up 2 CPUs
[    0.153623] Total of 2 processors activated (10402.74 BogoMIPS).
[    0.153712] CPU0 attaching sched-domain:
[    0.153714]  domain 0: span 0-1 level CPU
[    0.153716]   groups: 0 1
[    0.153720] CPU1 attaching sched-domain:
[    0.153722]  domain 0: span 0-1 level CPU
[    0.153723]   groups: 1 0
[    0.153976] net_namespace: 668 bytes
[    0.153976] NET: Registered protocol family 16
[    0.153976] No dock devices found.
[    0.153976] ACPI: bus type pci registered
[    0.154109] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.154169] PCI: Not using MMCONFIG.
[    0.154768] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D7
[    0.154827] PCI: Using configuration type 1 for base access
[    0.154887] Setting up standard PCI resources
[    0.160975] ACPI: EC: Look up EC in DSDT
[    0.168970] ACPI: Interpreter enabled
[    0.168974] ACPI: (supports S0 S1 S3 S4 S5)
[    0.168974] ACPI: Using IOAPIC for interrupt routing
[    0.169333] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.173746] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.173806] PCI: Using MMCONFIG for extended config space
[    0.181726] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.182375] PCI: Transparent bridge - 0000:00:06.0
[    0.182842] bus 00 -> node 0
[    0.182847] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.183107] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.183257] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.183336] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.183414] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.183492] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.183572] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.183651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.192527] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.192527] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disab=
led.
[    0.192910] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.193291] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disab=
led.
[    0.193527] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disab=
led.
[    0.193910] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.194270] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disab=
led.
[    0.194653] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disab=
led.
[    0.195033] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
[    0.195373] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
[    0.195676] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
[    0.196016] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
[    0.196317] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
[    0.196660] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.197000] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.197341] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
[    0.197683] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
[    0.198053] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled=
.
[    0.198415] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.199526] ACPI Warning (tbutils-0217): Incorrect checksum in table [OE=
MB] - 03, should be 02 [20080609]
[    0.199526] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.199526] pnp: PnP ACPI init
[    0.199526] ACPI: bus type pnp registered
[    0.203457] pnp: PnP ACPI: found 15 devices
[    0.203514] ACPI: ACPI bus type pnp unregistered
[    0.204525] usbcore: registered new interface driver usbfs
[    0.204525] usbcore: registered new interface driver hub
[    0.204525] usbcore: registered new device driver usb
[    0.204525] PCI: Using ACPI for IRQ routing
[    0.205954] NetLabel: Initializing
[    0.206525] NetLabel:  domain hash size =3D 128
[    0.206525] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.206525] NetLabel:  unlabeled traffic allowed by default
[    0.206525] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.207132] hpet0: 3 32-bit timers, 25000000 Hz
[    0.208617] tracer: 772 pages allocated for 65536<6> entries of 48 bytes
[    0.208697]    actual entries 65620
[    0.209060] Switched to high resolution mode on CPU 0
[    0.209090] Switched to high resolution mode on CPU 1
[    0.212096] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.212156] system 00:06: ioport range 0x800-0x80f has been reserved
[    0.212215] system 00:06: ioport range 0x2000-0x207f has been reserved
[    0.212275] system 00:06: ioport range 0x2080-0x20ff has been reserved
[    0.212339] system 00:06: ioport range 0x2400-0x247f has been reserved
[    0.212398] system 00:06: ioport range 0x2480-0x24ff has been reserved
[    0.212458] system 00:06: ioport range 0x2800-0x287f has been reserved
[    0.212517] system 00:06: ioport range 0x2880-0x28ff has been reserved
[    0.212802] system 00:06: ioport range 0x2c00-0x2c7f has been reserved
[    0.212862] system 00:06: ioport range 0x2c80-0x2cff has been reserved
[    0.212922] system 00:06: iomem range 0xfbf80000-0xfbfbffff has been res=
erved
[    0.212982] system 00:06: iomem range 0xfee01000-0xfeefffff could not be=
 reserved
[    0.213085] system 00:08: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.213178] system 00:08: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.213274] system 00:0b: ioport range 0xa00-0xa0f has been reserved
[    0.213338] system 00:0b: ioport range 0xa10-0xa1f has been reserved
[    0.213402] system 00:0c: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.213465] system 00:0d: iomem range 0xd0000000-0xdfffffff could not be=
 reserved
[    0.213561] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.213620] system 00:0e: iomem range 0xc0000-0xcffff could not be reser=
ved
[    0.213680] system 00:0e: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.213740] system 00:0e: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.213833] system 00:0e: iomem range 0xfec00000-0xffffffff could not be=
 reserved
[    0.245154] PCI: Bridge: 0000:00:06.0
[    0.245154]   IO window: disabled.
[    0.245154]   MEM window: disabled.
[    0.245154]   PREFETCH window: disabled.
[    0.245154] PCI: Bridge: 0000:00:0a.0
[    0.245154]   IO window: disabled.
[    0.245154]   MEM window: disabled.
[    0.245154]   PREFETCH window: disabled.
[    0.245154] PCI: Bridge: 0000:00:0b.0
[    0.245154]   IO window: disabled.
[    0.245186]   MEM window: disabled.
[    0.245242]   PREFETCH window: disabled.
[    0.245299] PCI: Bridge: 0000:00:0c.0
[    0.245355]   IO window: disabled.
[    0.246183]   MEM window: disabled.
[    0.246183]   PREFETCH window: disabled.
[    0.246183] PCI: Bridge: 0000:00:0d.0
[    0.246183]   IO window: disabled.
[    0.246183]   MEM window: disabled.
[    0.246183]   PREFETCH window: disabled.
[    0.246183] PCI: Bridge: 0000:00:0e.0
[    0.246183]   IO window: disabled.
[    0.246183]   MEM window: disabled.
[    0.246183]   PREFETCH window: disabled.
[    0.246183] PCI: Bridge: 0000:00:0f.0
[    0.246183]   IO window: e000-efff
[    0.246183]   MEM window: 0xfc000000-0xfebfffff
[    0.246187]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[    0.246252] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.246259] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    0.246265] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.246270] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.246276] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.246282] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.246287] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    0.246298] NET: Registered protocol family 2
[    0.249216] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.250155] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.250174] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.251158] TCP: Hash tables configured (established 131072 bind 65536)
[    0.251158] TCP reno registered
[    0.252219] NET: Registered protocol family 1
[    0.252371] checking if image is initramfs... it is
[    0.421159] Freeing initrd memory: 3011k freed
[    0.422338] Machine check exception polling timer started.
[    0.422338] audit: initializing netlink socket (disabled)
[    0.422338] type=3D2000 audit(1213649836.420:1): initialized
[    0.427338] highmem bounce pool size: 64 pages
[    0.427338] Total HugeTLB memory allocated, 0
[    0.429338] VFS: Disk quotas dquot_6.5.1
[    0.429338] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.429338] msgmni has been set to 1668
[    0.429338] SELinux:  Registering netfilter hooks
[    0.429338] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.429439] io scheduler noop registered
[    0.429495] io scheduler anticipatory registered
[    0.429552] io scheduler deadline registered
[    0.429616] io scheduler cfq registered (default)
[    0.429696] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.440458] pci 0000:00:05.0: Enabling HT MSI Mapping
[    0.441349] pci 0000:00:05.1: Enabling HT MSI Mapping
[    0.441417] pci 0000:00:05.2: Enabling HT MSI Mapping
[    0.441483] pci 0000:00:06.0: Enabling HT MSI Mapping
[    0.441551] pci 0000:00:06.1: Enabling HT MSI Mapping
[    0.441621] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.441690] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.441758] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.441825] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.441893] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.441961] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.442029] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.442102] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    0.442156] pci 0000:07:00.0: Boot video device
[    0.443156] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    0.443156] assign_interrupt_mode Found MSI capability
[    0.443161] Allocate Port Service[0000:00:0a.0:pcie00]
[    0.443161] Allocate Port Service[0000:00:0a.0:pcie03]
[    0.443161] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.443161] assign_interrupt_mode Found MSI capability
[    0.443161] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.443161] Allocate Port Service[0000:00:0b.0:pcie03]
[    0.443161] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.443161] assign_interrupt_mode Found MSI capability
[    0.443161] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.443161] Allocate Port Service[0000:00:0c.0:pcie03]
[    0.443161] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.443161] assign_interrupt_mode Found MSI capability
[    0.443161] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.443161] Allocate Port Service[0000:00:0d.0:pcie03]
[    0.443161] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.443161] assign_interrupt_mode Found MSI capability
[    0.443235] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.443235] Allocate Port Service[0000:00:0e.0:pcie03]
[    0.443235] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    0.443235] assign_interrupt_mode Found MSI capability
[    0.443235] Allocate Port Service[0000:00:0f.0:pcie00]
[    0.443744] Allocate Port Service[0000:00:0f.0:pcie03]
[    0.444155] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.444155] processor ACPI0007:00: registered as cooling_device0
[    0.444155] processor ACPI0007:01: registered as cooling_device1
[    0.448503] isapnp: Scanning for PnP cards...
[    0.803290] isapnp: No Plug & Play device found
[    0.806538] Real Time Clock Driver v1.12ac
[    0.807019] hpet_resources: 0xfed00000 is busy
[    0.807019] Non-volatile memory driver v1.2
[    0.807019] Linux agpgart interface v0.103
[    0.807027] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[    1.050875] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.052020] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.102048] brd: module loaded
[    1.102271] input: Macintosh mouse button emulation as /class/input/inpu=
t0
[    1.103271] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4 irq 1,12
[    1.105412] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.105412] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.106314] mice: PS/2 mouse device common for all mice
[    1.148819] cpuidle: using governor ladder
[    1.148819] cpuidle: using governor menu
[    1.148819] usbcore: registered new interface driver hiddev
[    1.148820] usbcore: registered new interface driver usbhid
[    1.148820] usbhid: v2.6:USB HID core driver
[    1.150278] TCP cubic registered
[    1.150315] Initializing XFRM netlink socket
[    1.150315] NET: Registered protocol family 17
[    1.150315] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 5000+ processors (2 cpu cores) (version 2.20.00)
[    1.159995] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.160055] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.160114] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.160172] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.160235] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.160293] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.160894] Using IPI No-Shortcut mode
[    1.160955] registered taskstats version 1
[    1.161316] Freeing unused kernel memory: 264k freed
[    1.161390] Write protecting the kernel text: 2252k
[    1.161463] Write protecting the kernel read-only data: 1060k
[    1.450808] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    1.450808] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 23=
 (level, low) -> IRQ 23
[    1.450808] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 17
[    1.450808] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    1.450808] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.450938] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    1.451050] ehci_hcd 0000:00:02.1: debug port 1
[    1.451108] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    1.451121] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfbffac00
[    1.456847] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    1.456990] usb usb1: configuration #1 chosen from 1 choice
[    1.457070] hub 1-0:1.0: USB hub found
[    1.457136] hub 1-0:1.0: 10 ports detected
[    1.669895] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[    1.670170] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    1.670236] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22=
 (level, low) -> IRQ 22
[    1.670370] Int: type 0, pol 3, trig 3, bus 00, IRQ 08, APIC ID 2, APIC =
INT 16
[    1.670470] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    1.670473] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    1.670808] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    1.671618] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfbffb000
[    1.724526] usb usb2: configuration #1 chosen from 1 choice
[    1.724604] hub 2-0:1.0: USB hub found
[    1.724666] hub 2-0:1.0: 10 ports detected
[    1.761392] usb 1-4: new high speed USB device using ehci_hcd and addres=
s 2
[    1.837033] USB Universal Host Controller Interface driver v3.0
[    1.866883] device-mapper: uevent: version 1.0.3
[    1.867019] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:=
 dm-devel@redhat.com
[    1.879396] usb 1-4: configuration #1 chosen from 1 choice
[    1.926009] padlock: VIA PadLock not detected.
[    1.940195] padlock: VIA PadLock Hash Engine not detected.
[    1.966146] SCSI subsystem initialized
[    1.978979] Driver 'sd' needs updating - please use bus_type methods
[    1.986174] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 3
[    1.996979] libata version 3.00 loaded.
[    2.008746] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    2.009025] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[    2.009091] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21=
 (level, low) -> IRQ 21
[    2.009226] Int: type 0, pol 3, trig 3, bus 00, IRQ 14, APIC ID 2, APIC =
INT 15
[    2.009336] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    2.009342] ACPI: PCI interrupt for device 0000:00:05.0 disabled
[    2.009871] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    2.009929] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23=
 (level, low) -> IRQ 23
[    2.010069] Int: type 0, pol 3, trig 3, bus 00, IRQ 15, APIC ID 2, APIC =
INT 17
[    2.010180] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    2.010186] ACPI: PCI interrupt for device 0000:00:05.1 disabled
[    2.010461] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 22
[    2.010520] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22=
 (level, low) -> IRQ 22
[    2.010653] Int: type 0, pol 3, trig 3, bus 00, IRQ 16, APIC ID 2, APIC =
INT 16
[    2.010755] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    2.010760] ACPI: PCI interrupt for device 0000:00:05.2 disabled
[    2.101794] usb 1-6: configuration #1 chosen from 1 choice
[    2.102023] hub 1-6:1.0: USB hub found
[    2.102120] hub 1-6:1.0: 4 ports detected
[    2.367129] usb 1-6.1: new low speed USB device using ehci_hcd and addre=
ss 4
[    2.461145] usb 1-6.1: configuration #1 chosen from 1 choice
[    2.468861] input: Microsoft Microsoft IntelliMouse=AE Optical as /class=
/input/input1
[    2.473027] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Inte=
lliMouse=AE Optical] on usb-0000:00:02.1-6.1
[    2.535129] usb 1-6.2: new low speed USB device using ehci_hcd and addre=
ss 5
[    2.619030] usb 1-6.2: configuration #1 chosen from 1 choice
[    2.623836] input: DELL DELL USB Keyboard as /class/input/input2
[    2.630026] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboar=
d] on usb-0000:00:02.1-6.2
[    2.639792] input: DELL DELL USB Keyboard as /class/input/input3
[    2.645028] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard]=
 on usb-0000:00:02.1-6.2
[    4.533998] pata_amd 0000:00:04.0: version 0.3.10
[    4.533998] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    4.533998] scsi0 : pata_amd
[    4.534131] scsi1 : pata_amd
[    4.535221] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq=
 14
[    4.535280] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq=
 15
[    4.698450] ata1.00: ATA-6: IC35L090AVV207-0, V23OA63A, max UDMA/100
[    4.698510] ata1.00: 160836480 sectors, multi 16: LBA48=20
[    4.698782] ata1.01: ATA-5: IC35L060AVVA07-0, VA3OA52A, max UDMA/100
[    4.698841] ata1.01: 120103200 sectors, multi 16: LBA=20
[    4.698905] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=3D0x3f0=
00 (0xc6c60000) ACPI=3D0x3f01f (20:20:0x15)
[    4.698909] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=3D0x3f0=
00 (0xc6c60000) ACPI=3D0x3f01f (20:20:0x15)
[    4.708376] ata1.00: configured for UDMA/100
[    4.717390] ata1.01: configured for UDMA/100
[    4.717460] ata2: port disabled. ignoring.
[    4.717541] scsi 0:0:0:0: Direct-Access     ATA      IC35L090AVV207-0 V2=
3O PQ: 0 ANSI: 5
[    4.717698] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348=
 MB)
[    4.717768] sd 0:0:0:0: [sda] Write Protect is off
[    4.717827] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.717846] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.717988] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348=
 MB)
[    4.718065] sd 0:0:0:0: [sda] Write Protect is off
[    4.718122] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.718141] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.718235]  sda: sda1
[    4.724419] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.724562] scsi 0:0:1:0: Direct-Access     ATA      IC35L060AVVA07-0 VA=
3O PQ: 0 ANSI: 5
[    4.724706] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493=
 MB)
[    4.724774] sd 0:0:1:0: [sdb] Write Protect is off
[    4.724833] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.724852] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.724978] sd 0:0:1:0: [sdb] 120103200 512-byte hardware sectors (61493=
 MB)
[    4.725053] sd 0:0:1:0: [sdb] Write Protect is off
[    4.725111] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.725129] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.725223]  sdb: sdb1 sdb2 sdb3
[    4.752374] sd 0:0:1:0: [sdb] Attached SCSI disk
[    7.261611] sata_nv 0000:00:05.0: version 3.5
[    7.261622] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21=
 (level, low) -> IRQ 21
[    7.261758] Int: type 0, pol 3, trig 3, bus 00, IRQ 14, APIC ID 2, APIC =
INT 15
[    7.261850] sata_nv 0000:00:05.0: Using SWNCQ mode
[    7.262033] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    7.262033] scsi2 : sata_nv
[    7.262033] scsi3 : sata_nv
[    7.262033] ata3: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 i=
rq 21
[    7.262102] ata4: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 i=
rq 21
[    7.718057] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.721135] ata3.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    7.727136] ata3.00: configured for UDMA/66
[    8.042369] ata4: SATA link down (SStatus 0 SControl 300)
[    8.056725] scsi 2:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.=
18 PQ: 0 ANSI: 5
[    8.056907] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23=
 (level, low) -> IRQ 23
[    8.057041] Int: type 0, pol 3, trig 3, bus 00, IRQ 15, APIC ID 2, APIC =
INT 17
[    8.057133] sata_nv 0000:00:05.1: Using SWNCQ mode
[    8.057392] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    8.057511] scsi4 : sata_nv
[    8.057609] scsi5 : sata_nv
[    8.057816] ata5: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 i=
rq 23
[    8.057875] ata6: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 i=
rq 23
[    8.373035] ata5: SATA link down (SStatus 0 SControl 300)
[    8.695578] ata6: SATA link down (SStatus 0 SControl 300)
[    8.695649] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22=
 (level, low) -> IRQ 22
[    8.695782] Int: type 0, pol 3, trig 3, bus 00, IRQ 16, APIC ID 2, APIC =
INT 16
[    8.695874] sata_nv 0000:00:05.2: Using SWNCQ mode
[    8.704101] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    8.704543] scsi6 : sata_nv
[    8.704647] scsi7 : sata_nv
[    8.704792] ata7: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb480 i=
rq 22
[    8.704852] ata8: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb488 i=
rq 22
[    9.020242] ata7: SATA link down (SStatus 0 SControl 300)
[    9.335547] ata8: SATA link down (SStatus 0 SControl 300)
[   19.356600] kjournald starting.  Commit interval 5 seconds
[   19.357563] EXT3-fs: mounted filesystem with ordered data mode.
[   19.445282] type=3D1404 audit(1213649855.346:2): enforcing=3D1 old_enfor=
cing=3D0 auid=3D4294967295 ses=3D4294967295
[   19.587286] SELinux: 8192 avtab hash slots, 169520 rules.
[   19.609638] SELinux: 8192 avtab hash slots, 169520 rules.
[   19.686876] SELinux:  6 users, 12 roles, 2330 types, 113 bools, 1 sens, =
1024 cats
[   19.686880] SELinux:  72 classes, 169520 rules
[   19.688592] SELinux:  permission open in class dir not defined in policy
[   19.688656] SELinux:  permission open in class file not defined in polic=
y
[   19.688717] SELinux:  permission open in class chr_file not defined in p=
olicy
[   19.688776] SELinux:  permission open in class blk_file not defined in p=
olicy
[   19.688836] SELinux:  permission open in class fifo_file not defined in =
policy
[   19.689119] SELinux: the above unknown classes and permissions will be a=
llowed
[   19.689218] SELinux:  Completing initialization.
[   19.689220] SELinux:  Setting up existing superblocks.
[   19.703434] SELinux: initialized (dev dm-0, type ext3), uses xattr
[   19.703459] SELinux: initialized (dev usbfs, type usbfs), uses genfs_con=
texts
[   19.703467] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[   19.703723] SELinux: initialized (dev selinuxfs, type selinuxfs), uses g=
enfs_contexts
[   19.703747] SELinux: initialized (dev mqueue, type mqueue), uses transit=
ion SIDs
[   19.703760] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses g=
enfs_contexts
[   19.703764] SELinux: initialized (dev devpts, type devpts), uses transit=
ion SIDs
[   19.703777] SELinux: initialized (dev inotifyfs, type inotifyfs), uses g=
enfs_contexts
[   19.703780] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[   19.703792] SELinux: initialized (dev anon_inodefs, type anon_inodefs), =
uses genfs_contexts
[   19.703795] SELinux: initialized (dev pipefs, type pipefs), uses task SI=
Ds
[   19.703800] SELinux: initialized (dev debugfs, type debugfs), uses genfs=
_contexts
[   19.703826] SELinux: initialized (dev sockfs, type sockfs), uses task SI=
Ds
[   19.703833] SELinux: initialized (dev proc, type proc), uses genfs_conte=
xts
[   19.703845] SELinux: initialized (dev bdev, type bdev), uses genfs_conte=
xts
[   19.703849] SELinux: initialized (dev rootfs, type rootfs), uses genfs_c=
ontexts
[   19.703904] SELinux: initialized (dev sysfs, type sysfs), uses genfs_con=
texts
[   19.711639] type=3D1403 audit(1213649855.612:3): policy loaded auid=3D42=
94967295 ses=3D4294967295
[   23.734015] Driver 'sr' needs updating - please use bus_type methods
[   23.735376] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   23.735400] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   23.735421] sr 2:0:0:0: Attached scsi generic sg2 type 5
[   23.769527] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   23.769532] Uniform CD-ROM driver Revision: 3.20
[   23.769656] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   23.782012] input: PC Speaker as /class/input/input4
[   23.961132] forcedeth: Reverse Engineered nForce ethernet driver. Versio=
n 0.61.
[   23.961402] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   23.961410] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 20=
 (level, low) -> IRQ 20
[   23.961415] Int: type 0, pol 3, trig 3, bus 00, IRQ 20, APIC ID 2, APIC =
INT 14
[   23.961419] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   23.977769] input: Power Button (FF) as /class/input/input5
[   23.986731] ACPI: Power Button (FF) [PWRF]
[   23.986816] input: Power Button (CM) as /class/input/input6
[   23.996417] ACPI: Power Button (CM) [PWRB]
[   24.089438] usbcore: registered new interface driver cdc_ether
[   24.105940] ck804xrom ck804xrom_init_one(): Unable to register resource =
0x00000000ff000000-0x00000000ffffffff - kernel bug?
[   24.122248] usbcore: registered new interface driver rndis_host
[   24.171828] CFI: Found no ck804xrom @ffc00000 device at location zero
[   24.176830] rndis_wlan 1-4:1.0: rndis media disconnect
[   24.176830] ------------[ cut here ]------------
[   24.176830] kernel BUG at kernel/workqueue.c:169!
[   24.176830] invalid opcode: 0000 [#1] SMP=20
[   24.176830] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/host2/=
target2:0:0/2:0:0:0/rev
[   24.176830] Modules linked in: rndis_wlan(+) cfi_probe snd_pcm gen_probe=
 rndis_host ck804xrom(+) cdc_ether mtd snd_timer usbnet snd_page_alloc chip=
reg k8temp(+) snd_hwdep i2c_nforce2(+) hwmon button snd forcedeth(+) mii ma=
p_funcs i2c_core serio_raw soundcore pcspkr sg sr_mod cdrom sata_nv pata_am=
d ata_generic pata_acpi libata sd_mod scsi_mod sha256_generic aes_i586 dm_c=
rypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd =
ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[   24.176830]=20
[   24.176830] Pid: 1006, comm: modprobe Not tainted (2.6.26-rc6-next-20080=
616 #74)
[   24.176830] EIP: 0060:[<c04342e4>] EFLAGS: 00010213 CPU: 0
[   24.176830] EIP is at queue_work+0x1b/0x48
[   24.176830] EAX: f786606c EBX: 00000000 ECX: 00000000 EDX: f7866068
[   24.176830] ESI: f7866800 EDI: f897a98c EBP: f6490c88 ESP: f6490c84
[   24.176830]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   24.176830] Process modprobe (pid: 1006, ti=3Df6490000 task=3Df6458c70 t=
ask.ti=3Df6490000)
[   24.176830] Stack: f6e93cb8 f6490c90 f99a00b1 f6490cc0 f897a343 f7865c80=
 f7865d50 00000000=20
[   24.176830]        00000000 80000002 00000001 00000000 00000003 ffffffea=
 f7865c80 f6490d00=20
[   24.176830]        f897a625 00000001 00000002 f6e93c00 f7865c80 f7865800=
 f7866800 c04f6d22=20
[   24.176830] Call Trace:
[   24.176830]  [<f99a00b1>] ? rndis_wext_link_change+0x29/0x2b [rndis_wlan=
]
[   24.176830]  [<f897a343>] ? rndis_command+0x1af/0x23c [rndis_host]
[   24.176830]  [<f897a625>] ? generic_rndis_bind+0x109/0x3a6 [rndis_host]
[   24.176830]  [<c04f6d22>] ? idr_get_empty_slot+0x12a/0x1d9
[   24.176830]  [<f99a1f9f>] ? rndis_wext_bind+0x74/0x289 [rndis_wlan]
[   24.176830]  [<c05be14e>] ? alloc_netdev_mq+0xb8/0xc3
[   24.176830]  [<c05cbc0d>] ? ether_setup+0x0/0x78
[   24.176830]  [<f89685b3>] ? usbnet_probe+0x21d/0x4dd [usbnet]
[   24.176830]  [<c062ddfb>] ? mutex_lock+0x1d/0x2d
[   24.176830]  [<c0581ab5>] ? usb_autopm_do_device+0xb1/0xb9
[   24.176830]  [<c0582081>] ? usb_probe_interface+0xbc/0xef
[   24.176830]  [<c056bc6d>] ? driver_probe_device+0xa0/0x136
[   24.176830]  [<c056bd3d>] ? __driver_attach+0x3a/0x59
[   24.176830]  [<c056b6a5>] ? bus_for_each_dev+0x3b/0x63
[   24.176830]  [<c056bb12>] ? driver_attach+0x14/0x16
[   24.176830]  [<c056bd03>] ? __driver_attach+0x0/0x59
[   24.176830]  [<c056b0da>] ? bus_add_driver+0x9d/0x1ba
[   24.176830]  [<c056bec7>] ? driver_register+0x81/0xe1
[   24.176830]  [<c0582266>] ? usb_register_driver+0x66/0xc0
[   24.176830]  [<f891d017>] ? rndis_wlan_init+0x17/0x19 [rndis_wlan]
[   24.176830]  [<c04451bb>] ? sys_init_module+0x177e/0x1930
[   24.176830]  [<c0403895>] ? sysenter_past_esp+0x6a/0x91
[   24.176830]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   24.176830] Code: 76 c0 8b 00 f7 d0 8b 04 88 e8 a7 ff ff ff c9 c3 55 89 =
e5 53 89 c3 f0 0f ba 2a 00 19 c0 31 c9 85 c0 75 30 8d 42 04 39 42 04 74 04 =
<0f> 0b eb fe 64 8b 0d 04 00 7b c0 83 7b 10 00 74 06 8b 0d f4 b4=20
[   24.176830] EIP: [<c04342e4>] queue_work+0x1b/0x48 SS:ESP 0068:f6490c84
[   24.185309] ---[ end trace 6a99273b07870aed ]---
[   24.192828] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   24.192906] CFI: Found no ck804xrom @ffc00000 device at location zero
[   24.198303] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   24.198372] CFI: Found no ck804xrom @ffc00000 device at location zero
[   24.198506] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   24.198576] CFI: Found no ck804xrom @ffc10000 device at location zero
[   24.198710] JEDEC: Found no ck804xrom @ffc10000 device at location zero
[   24.198785] CFI: Found no ck804xrom @ffc10000 device at location zero
[   24.199353] JEDEC: Found no ck804xrom @ffc10000 device at location zero
[   24.199487] CFI: Found no ck804xrom @ffc10000 device at location zero
[   24.199621] JEDEC: Found no ck804xrom @ffc10000 device at location zero
[   24.199690] CFI: Found no ck804xrom @ffc20000 device at location zero
[   24.199824] JEDEC: Found no ck804xrom @ffc20000 device at location zero
[   24.199899] CFI: Found no ck804xrom @ffc20000 device at location zero
[   24.200082] JEDEC: Found no ck804xrom @ffc20000 device at location zero
[   24.200151] CFI: Found no ck804xrom @ffc20000 device at location zero
[   24.200352] JEDEC: Found no ck804xrom @ffc20000 device at location zero
[   24.200421] CFI: Found no ck804xrom @ffc30000 device at location zero
[   24.200561] JEDEC: Found no ck804xrom @ffc30000 device at location zero
[   24.200636] CFI: Found no ck804xrom @ffc30000 device at location zero
[   24.200819] JEDEC: Found no ck804xrom @ffc30000 device at location zero
[   24.200888] CFI: Found no ck804xrom @ffc30000 device at location zero
[   24.201484] JEDEC: Found no ck804xrom @ffc30000 device at location zero
[   24.201484] CFI: Found no ck804xrom @ffc40000 device at location zero
[   24.201484] JEDEC: Found no ck804xrom @ffc40000 device at location zero
[   24.201484] CFI: Found no ck804xrom @ffc40000 device at location zero
[   24.201484] JEDEC: Found no ck804xrom @ffc40000 device at location zero
[   24.201559] CFI: Found no ck804xrom @ffc40000 device at location zero
[   24.201693] JEDEC: Found no ck804xrom @ffc40000 device at location zero
[   24.201762] CFI: Found no ck804xrom @ffc50000 device at location zero
[   24.201896] JEDEC: Found no ck804xrom @ffc50000 device at location zero
[   24.201971] CFI: Found no ck804xrom @ffc50000 device at location zero
[   24.202154] JEDEC: Found no ck804xrom @ffc50000 device at location zero
[   24.202223] CFI: Found no ck804xrom @ffc50000 device at location zero
[   24.202484] JEDEC: Found no ck804xrom @ffc50000 device at location zero
[   24.202553] CFI: Found no ck804xrom @ffc60000 device at location zero
[   24.202693] JEDEC: Found no ck804xrom @ffc60000 device at location zero
[   24.202768] CFI: Found no ck804xrom @ffc60000 device at location zero
[   24.202952] JEDEC: Found no ck804xrom @ffc60000 device at location zero
[   24.203020] CFI: Found no ck804xrom @ffc60000 device at location zero
[   24.203154] JEDEC: Found no ck804xrom @ffc60000 device at location zero
[   24.203223] CFI: Found no ck804xrom @ffc70000 device at location zero
[   24.203356] JEDEC: Found no ck804xrom @ffc70000 device at location zero
[   24.203436] CFI: Found no ck804xrom @ffc70000 device at location zero
[   24.203607] JEDEC: Found no ck804xrom @ffc70000 device at location zero
[   24.203682] CFI: Found no ck804xrom @ffc70000 device at location zero
[   24.203816] JEDEC: Found no ck804xrom @ffc70000 device at location zero
[   24.203885] CFI: Found no ck804xrom @ffc80000 device at location zero
[   24.204019] JEDEC: Found no ck804xrom @ffc80000 device at location zero
[   24.204094] CFI: Found no ck804xrom @ffc80000 device at location zero
[   24.204277] JEDEC: Found no ck804xrom @ffc80000 device at location zero
[   24.204345] CFI: Found no ck804xrom @ffc80000 device at location zero
[   24.204485] JEDEC: Found no ck804xrom @ffc80000 device at location zero
[   24.204554] CFI: Found no ck804xrom @ffc90000 device at location zero
[   24.204710] JEDEC: Found no ck804xrom @ffc90000 device at location zero
[   24.204785] CFI: Found no ck804xrom @ffc90000 device at location zero
[   24.204969] JEDEC: Found no ck804xrom @ffc90000 device at location zero
[   24.205037] CFI: Found no ck804xrom @ffc90000 device at location zero
[   24.205171] JEDEC: Found no ck804xrom @ffc90000 device at location zero
[   24.205301] CFI: Found no ck804xrom @ffca0000 device at location zero
[   24.205484] JEDEC: Found no ck804xrom @ffca0000 device at location zero
[   24.205560] CFI: Found no ck804xrom @ffca0000 device at location zero
[   24.205750] JEDEC: Found no ck804xrom @ffca0000 device at location zero
[   24.205818] CFI: Found no ck804xrom @ffca0000 device at location zero
[   24.205952] JEDEC: Found no ck804xrom @ffca0000 device at location zero
[   24.206021] CFI: Found no ck804xrom @ffcb0000 device at location zero
[   24.206155] JEDEC: Found no ck804xrom @ffcb0000 device at location zero
[   24.206230] CFI: Found no ck804xrom @ffcb0000 device at location zero
[   24.206413] JEDEC: Found no ck804xrom @ffcb0000 device at location zero
[   24.206486] CFI: Found no ck804xrom @ffcb0000 device at location zero
[   24.206619] JEDEC: Found no ck804xrom @ffcb0000 device at location zero
[   24.206695] CFI: Found no ck804xrom @ffcc0000 device at location zero
[   24.206828] JEDEC: Found no ck804xrom @ffcc0000 device at location zero
[   24.206903] CFI: Found no ck804xrom @ffcc0000 device at location zero
[   24.207086] JEDEC: Found no ck804xrom @ffcc0000 device at location zero
[   24.207155] CFI: Found no ck804xrom @ffcc0000 device at location zero
[   24.207289] JEDEC: Found no ck804xrom @ffcc0000 device at location zero
[   24.207358] CFI: Found no ck804xrom @ffcd0000 device at location zero
[   24.207498] JEDEC: Found no ck804xrom @ffcd0000 device at location zero
[   24.207573] CFI: Found no ck804xrom @ffcd0000 device at location zero
[   24.207763] JEDEC: Found no ck804xrom @ffcd0000 device at location zero
[   24.207832] CFI: Found no ck804xrom @ffcd0000 device at location zero
[   24.207966] JEDEC: Found no ck804xrom @ffcd0000 device at location zero
[   24.208035] CFI: Found no ck804xrom @ffce0000 device at location zero
[   24.208169] JEDEC: Found no ck804xrom @ffce0000 device at location zero
[   24.208244] CFI: Found no ck804xrom @ffce0000 device at location zero
[   24.208483] JEDEC: Found no ck804xrom @ffce0000 device at location zero
[   24.208552] CFI: Found no ck804xrom @ffce0000 device at location zero
[   24.208686] JEDEC: Found no ck804xrom @ffce0000 device at location zero
[   24.208761] CFI: Found no ck804xrom @ffcf0000 device at location zero
[   24.208894] JEDEC: Found no ck804xrom @ffcf0000 device at location zero
[   24.208969] CFI: Found no ck804xrom @ffcf0000 device at location zero
[   24.209152] JEDEC: Found no ck804xrom @ffcf0000 device at location zero
[   24.209221] CFI: Found no ck804xrom @ffcf0000 device at location zero
[   24.209355] JEDEC: Found no ck804xrom @ffcf0000 device at location zero
[   24.209424] CFI: Found no ck804xrom @ffd00000 device at location zero
[   24.209561] JEDEC: Found no ck804xrom @ffd00000 device at location zero
[   24.209636] CFI: Found no ck804xrom @ffd00000 device at location zero
[   24.209826] JEDEC: Found no ck804xrom @ffd00000 device at location zero
[   24.209895] CFI: Found no ck804xrom @ffd00000 device at location zero
[   24.210028] JEDEC: Found no ck804xrom @ffd00000 device at location zero
[   24.210097] CFI: Found no ck804xrom @ffd10000 device at location zero
[   24.210230] JEDEC: Found no ck804xrom @ffd10000 device at location zero
[   24.210305] CFI: Found no ck804xrom @ffd10000 device at location zero
[   24.210494] JEDEC: Found no ck804xrom @ffd10000 device at location zero
[   24.210563] CFI: Found no ck804xrom @ffd10000 device at location zero
[   24.210693] JEDEC: Found no ck804xrom @ffd10000 device at location zero
[   24.210768] CFI: Found no ck804xrom @ffd20000 device at location zero
[   24.210901] JEDEC: Found no ck804xrom @ffd20000 device at location zero
[   24.210976] CFI: Found no ck804xrom @ffd20000 device at location zero
[   24.211160] JEDEC: Found no ck804xrom @ffd20000 device at location zero
[   24.211228] CFI: Found no ck804xrom @ffd20000 device at location zero
[   24.211362] JEDEC: Found no ck804xrom @ffd20000 device at location zero
[   24.211431] CFI: Found no ck804xrom @ffd30000 device at location zero
[   24.211570] JEDEC: Found no ck804xrom @ffd30000 device at location zero
[   24.211645] CFI: Found no ck804xrom @ffd30000 device at location zero
[   24.211858] JEDEC: Found no ck804xrom @ffd30000 device at location zero
[   24.211927] CFI: Found no ck804xrom @ffd30000 device at location zero
[   24.212061] JEDEC: Found no ck804xrom @ffd30000 device at location zero
[   24.212129] CFI: Found no ck804xrom @ffd40000 device at location zero
[   24.212263] JEDEC: Found no ck804xrom @ffd40000 device at location zero
[   24.212338] CFI: Found no ck804xrom @ffd40000 device at location zero
[   24.212527] JEDEC: Found no ck804xrom @ffd40000 device at location zero
[   24.212596] CFI: Found no ck804xrom @ffd40000 device at location zero
[   24.212736] JEDEC: Found no ck804xrom @ffd40000 device at location zero
[   24.212805] CFI: Found no ck804xrom @ffd50000 device at location zero
[   24.212939] JEDEC: Found no ck804xrom @ffd50000 device at location zero
[   24.213013] CFI: Found no ck804xrom @ffd50000 device at location zero
[   24.213197] JEDEC: Found no ck804xrom @ffd50000 device at location zero
[   24.213265] CFI: Found no ck804xrom @ffd50000 device at location zero
[   24.214102] JEDEC: Found no ck804xrom @ffd50000 device at location zero
[   24.214171] CFI: Found no ck804xrom @ffd60000 device at location zero
[   24.214304] JEDEC: Found no ck804xrom @ffd60000 device at location zero
[   24.214379] CFI: Found no ck804xrom @ffd60000 device at location zero
[   24.214567] JEDEC: Found no ck804xrom @ffd60000 device at location zero
[   24.214636] CFI: Found no ck804xrom @ffd60000 device at location zero
[   24.215037] JEDEC: Found no ck804xrom @ffd60000 device at location zero
[   24.215106] CFI: Found no ck804xrom @ffd70000 device at location zero
[   24.215239] JEDEC: Found no ck804xrom @ffd70000 device at location zero
[   24.215314] CFI: Found no ck804xrom @ffd70000 device at location zero
[   24.215497] JEDEC: Found no ck804xrom @ffd70000 device at location zero
[   24.215566] CFI: Found no ck804xrom @ffd70000 device at location zero
[   24.215693] JEDEC: Found no ck804xrom @ffd70000 device at location zero
[   24.215693] CFI: Found no ck804xrom @ffd80000 device at location zero
[   24.215693] JEDEC: Found no ck804xrom @ffd80000 device at location zero
[   24.215774] CFI: Found no ck804xrom @ffd80000 device at location zero
[   24.215957] JEDEC: Found no ck804xrom @ffd80000 device at location zero
[   24.216026] CFI: Found no ck804xrom @ffd80000 device at location zero
[   24.216160] JEDEC: Found no ck804xrom @ffd80000 device at location zero
[   24.216229] CFI: Found no ck804xrom @ffd90000 device at location zero
[   24.216362] JEDEC: Found no ck804xrom @ffd90000 device at location zero
[   24.216437] CFI: Found no ck804xrom @ffd90000 device at location zero
[   24.216693] JEDEC: Found no ck804xrom @ffd90000 device at location zero
[   24.216761] CFI: Found no ck804xrom @ffd90000 device at location zero
[   24.216901] JEDEC: Found no ck804xrom @ffd90000 device at location zero
[   24.216970] CFI: Found no ck804xrom @ffda0000 device at location zero
[   24.217104] JEDEC: Found no ck804xrom @ffda0000 device at location zero
[   24.217179] CFI: Found no ck804xrom @ffda0000 device at location zero
[   24.217363] JEDEC: Found no ck804xrom @ffda0000 device at location zero
[   24.217431] CFI: Found no ck804xrom @ffda0000 device at location zero
[   24.217565] JEDEC: Found no ck804xrom @ffda0000 device at location zero
[   24.217639] CFI: Found no ck804xrom @ffdb0000 device at location zero
[   24.217761] JEDEC: Found no ck804xrom @ffdb0000 device at location zero
[   24.217842] CFI: Found no ck804xrom @ffdb0000 device at location zero
[   24.218026] JEDEC: Found no ck804xrom @ffdb0000 device at location zero
[   24.218094] CFI: Found no ck804xrom @ffdb0000 device at location zero
[   24.218228] JEDEC: Found no ck804xrom @ffdb0000 device at location zero
[   24.218297] CFI: Found no ck804xrom @ffdc0000 device at location zero
[   24.218431] JEDEC: Found no ck804xrom @ffdc0000 device at location zero
[   24.218505] CFI: Found no ck804xrom @ffdc0000 device at location zero
[   24.218694] JEDEC: Found no ck804xrom @ffdc0000 device at location zero
[   24.218762] CFI: Found no ck804xrom @ffdc0000 device at location zero
[   24.218902] JEDEC: Found no ck804xrom @ffdc0000 device at location zero
[   24.218971] CFI: Found no ck804xrom @ffdd0000 device at location zero
[   24.219105] JEDEC: Found no ck804xrom @ffdd0000 device at location zero
[   24.219180] CFI: Found no ck804xrom @ffdd0000 device at location zero
[   24.219363] JEDEC: Found no ck804xrom @ffdd0000 device at location zero
[   24.219431] CFI: Found no ck804xrom @ffdd0000 device at location zero
[   24.219565] JEDEC: Found no ck804xrom @ffdd0000 device at location zero
[   24.219638] CFI: Found no ck804xrom @ffde0000 device at location zero
[   24.219765] JEDEC: Found no ck804xrom @ffde0000 device at location zero
[   24.219846] CFI: Found no ck804xrom @ffde0000 device at location zero
[   24.220029] JEDEC: Found no ck804xrom @ffde0000 device at location zero
[   24.220098] CFI: Found no ck804xrom @ffde0000 device at location zero
[   24.220232] JEDEC: Found no ck804xrom @ffde0000 device at location zero
[   24.220300] CFI: Found no ck804xrom @ffdf0000 device at location zero
[   24.220434] JEDEC: Found no ck804xrom @ffdf0000 device at location zero
[   24.220509] CFI: Found no ck804xrom @ffdf0000 device at location zero
[   24.220697] JEDEC: Found no ck804xrom @ffdf0000 device at location zero
[   24.220766] CFI: Found no ck804xrom @ffdf0000 device at location zero
[   24.220906] JEDEC: Found no ck804xrom @ffdf0000 device at location zero
[   24.220975] CFI: Found no ck804xrom @ffe00000 device at location zero
[   24.221109] JEDEC: Found no ck804xrom @ffe00000 device at location zero
[   24.221184] CFI: Found no ck804xrom @ffe00000 device at location zero
[   24.221367] JEDEC: Found no ck804xrom @ffe00000 device at location zero
[   24.221436] CFI: Found no ck804xrom @ffe00000 device at location zero
[   24.221693] JEDEC: Found no ck804xrom @ffe00000 device at location zero
[   24.221762] CFI: Found no ck804xrom @ffe10000 device at location zero
[   24.221896] JEDEC: Found no ck804xrom @ffe10000 device at location zero
[   24.221977] CFI: Found no ck804xrom @ffe10000 device at location zero
[   24.222161] JEDEC: Found no ck804xrom @ffe10000 device at location zero
[   24.222229] CFI: Found no ck804xrom @ffe10000 device at location zero
[   24.222363] JEDEC: Found no ck804xrom @ffe10000 device at location zero
[   24.222432] CFI: Found no ck804xrom @ffe20000 device at location zero
[   24.222566] JEDEC: Found no ck804xrom @ffe20000 device at location zero
[   24.222640] CFI: Found no ck804xrom @ffe20000 device at location zero
[   24.222829] JEDEC: Found no ck804xrom @ffe20000 device at location zero
[   24.222897] CFI: Found no ck804xrom @ffe20000 device at location zero
[   24.223037] JEDEC: Found no ck804xrom @ffe20000 device at location zero
[   24.223106] CFI: Found no ck804xrom @ffe30000 device at location zero
[   24.223240] JEDEC: Found no ck804xrom @ffe30000 device at location zero
[   24.223315] CFI: Found no ck804xrom @ffe30000 device at location zero
[   24.223499] JEDEC: Found no ck804xrom @ffe30000 device at location zero
[   24.223567] CFI: Found no ck804xrom @ffe30000 device at location zero
[   24.223707] JEDEC: Found no ck804xrom @ffe30000 device at location zero
[   24.223775] CFI: Found no ck804xrom @ffe40000 device at location zero
[   24.223909] JEDEC: Found no ck804xrom @ffe40000 device at location zero
[   24.223990] CFI: Found no ck804xrom @ffe40000 device at location zero
[   24.224173] JEDEC: Found no ck804xrom @ffe40000 device at location zero
[   24.224242] CFI: Found no ck804xrom @ffe40000 device at location zero
[   24.224375] JEDEC: Found no ck804xrom @ffe40000 device at location zero
[   24.224444] CFI: Found no ck804xrom @ffe50000 device at location zero
[   24.224578] JEDEC: Found no ck804xrom @ffe50000 device at location zero
[   24.224652] CFI: Found no ck804xrom @ffe50000 device at location zero
[   24.224841] JEDEC: Found no ck804xrom @ffe50000 device at location zero
[   24.224909] CFI: Found no ck804xrom @ffe50000 device at location zero
[   24.225050] JEDEC: Found no ck804xrom @ffe50000 device at location zero
[   24.225119] CFI: Found no ck804xrom @ffe60000 device at location zero
[   24.225253] JEDEC: Found no ck804xrom @ffe60000 device at location zero
[   24.225327] CFI: Found no ck804xrom @ffe60000 device at location zero
[   24.225511] JEDEC: Found no ck804xrom @ffe60000 device at location zero
[   24.225580] CFI: Found no ck804xrom @ffe60000 device at location zero
[   24.225719] JEDEC: Found no ck804xrom @ffe60000 device at location zero
[   24.225787] CFI: Found no ck804xrom @ffe70000 device at location zero
[   24.225943] JEDEC: Found no ck804xrom @ffe70000 device at location zero
[   24.226018] CFI: Found no ck804xrom @ffe70000 device at location zero
[   24.226202] JEDEC: Found no ck804xrom @ffe70000 device at location zero
[   24.226271] CFI: Found no ck804xrom @ffe70000 device at location zero
[   24.226405] JEDEC: Found no ck804xrom @ffe70000 device at location zero
[   24.226474] CFI: Found no ck804xrom @ffe80000 device at location zero
[   24.226607] JEDEC: Found no ck804xrom @ffe80000 device at location zero
[   24.226881] CFI: Found no ck804xrom @ffe80000 device at location zero
[   24.226881] JEDEC: Found no ck804xrom @ffe80000 device at location zero
[   24.226955] CFI: Found no ck804xrom @ffe80000 device at location zero
[   24.227089] JEDEC: Found no ck804xrom @ffe80000 device at location zero
[   24.227158] CFI: Found no ck804xrom @ffe90000 device at location zero
[   24.227291] JEDEC: Found no ck804xrom @ffe90000 device at location zero
[   24.227366] CFI: Found no ck804xrom @ffe90000 device at location zero
[   24.227550] JEDEC: Found no ck804xrom @ffe90000 device at location zero
[   24.227618] CFI: Found no ck804xrom @ffe90000 device at location zero
[   24.227757] JEDEC: Found no ck804xrom @ffe90000 device at location zero
[   24.227826] CFI: Found no ck804xrom @ffea0000 device at location zero
[   24.227965] JEDEC: Found no ck804xrom @ffea0000 device at location zero
[   24.228040] CFI: Found no ck804xrom @ffea0000 device at location zero
[   24.228224] JEDEC: Found no ck804xrom @ffea0000 device at location zero
[   24.228292] CFI: Found no ck804xrom @ffea0000 device at location zero
[   24.228426] JEDEC: Found no ck804xrom @ffea0000 device at location zero
[   24.228495] CFI: Found no ck804xrom @ffeb0000 device at location zero
[   24.228629] JEDEC: Found no ck804xrom @ffeb0000 device at location zero
[   24.228881] CFI: Found no ck804xrom @ffeb0000 device at location zero
[   24.228881] JEDEC: Found no ck804xrom @ffeb0000 device at location zero
[   24.228955] CFI: Found no ck804xrom @ffeb0000 device at location zero
[   24.229090] JEDEC: Found no ck804xrom @ffeb0000 device at location zero
[   24.229159] CFI: Found no ck804xrom @ffec0000 device at location zero
[   24.229292] JEDEC: Found no ck804xrom @ffec0000 device at location zero
[   24.229367] CFI: Found no ck804xrom @ffec0000 device at location zero
[   24.229551] JEDEC: Found no ck804xrom @ffec0000 device at location zero
[   24.229619] CFI: Found no ck804xrom @ffec0000 device at location zero
[   24.229898] JEDEC: Found no ck804xrom @ffec0000 device at location zero
[   24.229898] CFI: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] JEDEC: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] CFI: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] JEDEC: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] CFI: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] JEDEC: Found no ck804xrom @ffed0000 device at location zero
[   24.230898] CFI: Found no ck804xrom @ffee0000 device at location zero
[   24.230898] JEDEC: Found no ck804xrom @ffee0000 device at location zero
[   24.230898] CFI: Found no ck804xrom @ffee0000 device at location zero
[   24.230898] JEDEC: Found no ck804xrom @ffee0000 device at location zero
[   24.230973] CFI: Found no ck804xrom @ffee0000 device at location zero
[   24.231107] JEDEC: Found no ck804xrom @ffee0000 device at location zero
[   24.231176] CFI: Found no ck804xrom @ffef0000 device at location zero
[   24.231309] JEDEC: Found no ck804xrom @ffef0000 device at location zero
[   24.231384] CFI: Found no ck804xrom @ffef0000 device at location zero
[   24.231568] JEDEC: Found no ck804xrom @ffef0000 device at location zero
[   24.231636] CFI: Found no ck804xrom @ffef0000 device at location zero
[   24.231927] JEDEC: Found no ck804xrom @ffef0000 device at location zero
[   24.231927] CFI: Found no ck804xrom @fff00000 device at location zero
[   24.232067] JEDEC: Found no ck804xrom @fff00000 device at location zero
[   24.232142] CFI: Found no ck804xrom @fff00000 device at location zero
[   24.232326] JEDEC: Found no ck804xrom @fff00000 device at location zero
[   24.232394] CFI: Found no ck804xrom @fff00000 device at location zero
[   24.232528] JEDEC: Found no ck804xrom @fff00000 device at location zero
[   24.232597] CFI: Found no ck804xrom @fff10000 device at location zero
[   24.232731] JEDEC: Found no ck804xrom @fff10000 device at location zero
[   24.232898] CFI: Found no ck804xrom @fff10000 device at location zero
[   24.233090] JEDEC: Found no ck804xrom @fff10000 device at location zero
[   24.233159] CFI: Found no ck804xrom @fff10000 device at location zero
[   24.233293] JEDEC: Found no ck804xrom @fff10000 device at location zero
[   24.233362] CFI: Found no ck804xrom @fff20000 device at location zero
[   24.233495] JEDEC: Found no ck804xrom @fff20000 device at location zero
[   24.233570] CFI: Found no ck804xrom @fff20000 device at location zero
[   24.233753] JEDEC: Found no ck804xrom @fff20000 device at location zero
[   24.233822] CFI: Found no ck804xrom @fff20000 device at location zero
[   24.233897] JEDEC: Found no ck804xrom @fff20000 device at location zero
[   24.233897] CFI: Found no ck804xrom @fff30000 device at location zero
[   24.234099] JEDEC: Found no ck804xrom @fff30000 device at location zero
[   24.234235] CFI: Found no ck804xrom @fff30000 device at location zero
[   24.234431] JEDEC: Found no ck804xrom @fff30000 device at location zero
[   24.234499] CFI: Found no ck804xrom @fff30000 device at location zero
[   24.235336] JEDEC: Found no ck804xrom @fff30000 device at location zero
[   24.235405] CFI: Found no ck804xrom @fff40000 device at location zero
[   24.235539] JEDEC: Found no ck804xrom @fff40000 device at location zero
[   24.235614] CFI: Found no ck804xrom @fff40000 device at location zero
[   24.235898] JEDEC: Found no ck804xrom @fff40000 device at location zero
[   24.235966] CFI: Found no ck804xrom @fff40000 device at location zero
[   24.236383] JEDEC: Found no ck804xrom @fff40000 device at location zero
[   24.236452] CFI: Found no ck804xrom @fff50000 device at location zero
[   24.236964] JEDEC: Found no ck804xrom @fff50000 device at location zero
[   24.236996] CFI: Found no ck804xrom @fff50000 device at location zero
[   24.236996] JEDEC: Found no ck804xrom @fff50000 device at location zero
[   24.236996] CFI: Found no ck804xrom @fff50000 device at location zero
[   24.236996] JEDEC: Found no ck804xrom @fff50000 device at location zero
[   24.236996] CFI: Found no ck804xrom @fff60000 device at location zero
[   24.236996] JEDEC: Found no ck804xrom @fff60000 device at location zero
[   24.237077] CFI: Found no ck804xrom @fff60000 device at location zero
[   24.237261] JEDEC: Found no ck804xrom @fff60000 device at location zero
[   24.237329] CFI: Found no ck804xrom @fff60000 device at location zero
[   24.237463] JEDEC: Found no ck804xrom @fff60000 device at location zero
[   24.237532] CFI: Found no ck804xrom @fff70000 device at location zero
[   24.237666] JEDEC: Found no ck804xrom @fff70000 device at location zero
[   24.237741] CFI: Found no ck804xrom @fff70000 device at location zero
[   24.237963] JEDEC: Found no ck804xrom @fff70000 device at location zero
[   24.238032] CFI: Found no ck804xrom @fff70000 device at location zero
[   24.238172] JEDEC: Found no ck804xrom @fff70000 device at location zero
[   24.238297] CFI: Found no ck804xrom @fff80000 device at location zero
[   24.238811] JEDEC: Found no ck804xrom @fff80000 device at location zero
[   24.238964] CFI: Found no ck804xrom @fff80000 device at location zero
[   24.239970] JEDEC: Found no ck804xrom @fff80000 device at location zero
[   24.240055] CFI: Found no ck804xrom @fff80000 device at location zero
[   24.240055] Found: PMC Pm49FL004
[   24.240055] ck804xrom @fff80000: Found 1 x8 devices at 0x0 in 8-bit bank
[   24.279679] number of JEDEC chips: 1
[   24.279679] cfi_cmdset_0002: Disabling erase-suspend-program due to code=
 brokenness.
[   24.511404] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr=
 00:16:17:45:c9:df
[   24.511501] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq=
 gbit lnktim msi desc-v3
[   24.641262] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   24.641338] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 20=
 (level, low) -> IRQ 20
[   24.641473] Int: type 0, pol 3, trig 3, bus 00, IRQ 24, APIC ID 2, APIC =
INT 14
[   24.641566] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   25.154419] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr=
 00:16:17:45:c9:de
[   25.154516] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq=
 gbit lnktim msi desc-v3
[   25.155182] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   25.155256] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   25.416264] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   25.416264] ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [LAZA] -> GSI 21=
 (level, low) -> IRQ 21
[   25.416264] Int: type 0, pol 3, trig 3, bus 00, IRQ 19, APIC ID 2, APIC =
INT 15
[   25.416264] PCI: Setting latency timer of device 0000:00:06.1 to 64
[   27.140766] SELinux: initialized (dev ramfs, type ramfs), uses genfs_con=
texts
[   28.033841] NET: Registered protocol family 10
[   28.034518] lo: Disabled Privacy Extensions
[   31.880008] device-mapper: multipath: version 1.0.5 loaded
[   32.966292] EXT3 FS on dm-0, internal journal
[   33.291913] SELinux: initialized (dev sdb1, type ext2), uses xattr
[   33.292276] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[   35.263791] SELinux: initialized (dev binfmt_misc, type binfmt_misc), us=
es genfs_contexts
[   36.405186] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   37.396997] ip_tables: (C) 2000-2006 Netfilter Core Team
[   37.762233] Clocksource tsc unstable (delta =3D -300864752 ns)
[   37.814652] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   43.659015] warning: `mcstransd' uses deprecated v2 capabilities in a wa=
y that may be insecure.
[   44.470576] RPC: Registered udp transport module.
[   44.470576] RPC: Registered tcp transport module.
[   44.475667] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses=
 genfs_contexts
[   44.805788] fuse init (API version 7.9)
[   44.819768] SELinux: initialized (dev fusectl, type fusectl), uses genfs=
_contexts
[   45.048454] type=3D1400 audit(1213649879.117:4): avc:  denied  { read } =
for  pid=3D1974 comm=3D"rsyslogd" name=3D"System.map-2.6.26-rc6-next-200806=
16" dev=3Dsdb1 ino=3D22 scontext=3Dsystem_u:system_r:syslogd_t:s0 tcontext=
=3Dunconfined_u:object_r:boot_t:s0 tclass=3Dfile
[   45.642476] SELinux: initialized (dev autofs, type autofs), uses genfs_c=
ontexts
[   45.740625] SELinux: initialized (dev autofs, type autofs), uses genfs_c=
ontexts
[   45.770622] SELinux: initialized (dev autofs, type autofs), uses genfs_c=
ontexts
[   46.461396] Bluetooth: Core ver 2.11
[   46.464436] NET: Registered protocol family 31
[   46.464441] Bluetooth: HCI device and connection manager initialized
[   46.464444] Bluetooth: HCI socket layer initialized
[   46.569405] Bluetooth: L2CAP ver 2.9
[   46.569410] Bluetooth: L2CAP socket layer initialized
[   46.712893] Bluetooth: RFCOMM socket layer initialized
[   46.713366] Bluetooth: RFCOMM TTY layer initialized
[   46.713366] Bluetooth: RFCOMM ver 1.8
[   46.924988] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   46.924995] Bluetooth: BNEP filters: protocol multicast
[   47.058846] Bridge firewalling registered
[   47.058992] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.

--=-QQoYNgtK1Fo59RjBS0qg
Content-Disposition: attachment; filename=.config
Content-Type: text/plain; name=.config; charset=UTF-8
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc6
# Mon Jun 16 20:29:47 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_VMI is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_PARAVIRT is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
# CONFIG_NUMA is not set
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x400000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x400000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=1999
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_I82365=m
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RR=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_SCC=m
# CONFIG_SCC_DELAY is not set
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# QoS/HT support disabled
#

#
# QoS/HT support needs CONFIG_NETDEVICES_MULTIQUEUE
#

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=m
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_BUILTIN_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_DILNETPC is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_ONENAND is not set

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_BPCK6=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ACER_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_TC1100_WMI is not set
CONFIG_MSI_LAPTOP=m
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_SYM53C416 is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=m
CONFIG_PATA_CS5536=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_ISAPNP=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_LEGACY is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_QDI=m
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
CONFIG_EL3=m
# CONFIG_3C515 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_LANCE is not set
CONFIG_NET_VENDOR_SMC=y
# CONFIG_WD80x3 is not set
CONFIG_ULTRA=m
# CONFIG_SMC9194 is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
CONFIG_EWRK3=m
# CONFIG_EEXPRESS is not set
# CONFIG_EEXPRESS_PRO is not set
# CONFIG_HPLAN_PLUS is not set
# CONFIG_HPLAN is not set
# CONFIG_LP486E is not set
# CONFIG_ETH16I is not set
CONFIG_NE2000=m
# CONFIG_ZNET is not set
# CONFIG_SEEQ8005 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_ADAPTEC_STARFIRE_NAPI=y
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=m
# CONFIG_E100_FIRMWARE is not set
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_E1000E=m
CONFIG_E1000E_ENABLED=y
CONFIG_IP1000=m
# CONFIG_IGB is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_NAPI=y
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T1_NAPI=y
CONFIG_CHELSIO_T3=m
CONFIG_IXGBE=m
CONFIG_IXGB=m
CONFIG_IXGB_NAPI=y
CONFIG_S2IO=m
CONFIG_S2IO_NAPI=y
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
# CONFIG_BNX2X is not set
# CONFIG_SFC is not set
CONFIG_TR=y
# CONFIG_IBMTR is not set
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
# CONFIG_TMS380TR is not set
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
# CONFIG_WAVELAN is not set
CONFIG_PCMCIA_WAVELAN=m
CONFIG_PCMCIA_NETWAVE=m
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=m
CONFIG_HERMES=m
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_ADM8211=m
# CONFIG_MAC80211_HWSIM is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
# CONFIG_IWLWIFI_RFKILL is not set
CONFIG_IWL4965=m
CONFIG_IWL4965_LEDS=y
CONFIG_IWL4965_SPECTRUM_MEASUREMENT=y
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_IWL5000 is not set
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2400PCI=m
CONFIG_RT2400PCI_RFKILL=y
CONFIG_RT2400PCI_LEDS=y
CONFIG_RT2500PCI=m
CONFIG_RT2500PCI_RFKILL=y
CONFIG_RT2500PCI_LEDS=y
CONFIG_RT61PCI=m
CONFIG_RT61PCI_RFKILL=y
CONFIG_RT61PCI_LEDS=y
CONFIG_RT2500USB=m
# CONFIG_RT2500USB_LEDS is not set
CONFIG_RT73USB=m
# CONFIG_RT73USB_LEDS is not set
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
# CONFIG_USB_KAWETH_FIRMWARE is not set
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PCMCIA_IBMTR=m
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_FIRMWARE is not set
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E_MAYBE=m
# CONFIG_ATM_FORE200E_PCA is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=m
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_0 is not set
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_AVM_A1 is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_IX1MICROR2 is not set
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_ASUSCOM is not set
# CONFIG_HISAX_TELEINT is not set
# CONFIG_HISAX_HFCS is not set
CONFIG_HISAX_SEDLBAUER=y
# CONFIG_HISAX_SPORTSTER is not set
# CONFIG_HISAX_MIC is not set
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_ISURF is not set
# CONFIG_HISAX_HSTSAPHIR is not set
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m
CONFIG_HISAX_HDLC=y

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
# CONFIG_ISDN_DRV_PCBIT is not set
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_HYSDN=m
# CONFIG_HYSDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_HTCPEN=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_WISTRON_BTNS=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_ESPSERIAL is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_DTLK=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_CS5535_GPIO=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ISCH=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
CONFIG_I2C_PCA_ISA=m
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# Video decoders
#
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_ALSA is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_ZC0301=m
CONFIG_USB_ZR364XX=m
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_CADET is not set
# CONFIG_RADIO_RTRACK is not set
# CONFIG_RADIO_RTRACK2 is not set
# CONFIG_RADIO_AZTECH is not set
# CONFIG_RADIO_GEMTEK is not set
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
# CONFIG_RADIO_SF16FMI is not set
# CONFIG_RADIO_SF16FMR2 is not set
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
# CONFIG_RADIO_TYPHOON is not set
# CONFIG_RADIO_ZOLTRIX is not set
CONFIG_USB_DSBR=m
# CONFIG_USB_SI470X is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_IMAC=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
CONFIG_FB_CYBLA=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_TRIDENT_ACCEL=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_AD1848_LIB=m
CONFIG_SND_CS4231_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
CONFIG_SND_CS4236=m
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=m
CONFIG_SND_SC6000=m
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_OPL3SA2=m
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
CONFIG_SND_MIRO=m
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
# CONFIG_SND_SB16_CSP is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
# CONFIG_SND_HIFIER is not set
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL=y
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SIS7019=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_PANTHERLORD_FF=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_WUSB=m

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_AIRPRIME=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_WHITEHEAT_FIRMWARE is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA_FIRMWARE is not set
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_TI_3410_FIRMWARE is not set
# CONFIG_USB_SERIAL_TI_5052_FIRMWARE is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_XIRCOM_FIRMWARE is not set
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI62_FIRMWARE is not set
CONFIG_USB_EMI26=m
# CONFIG_USB_EMI26_FIRMWARE is not set
CONFIG_USB_ADUTUX=m
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_GOTEMP is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_PASSWORDS is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
CONFIG_EDAC_I5000=m
# CONFIG_RTC_CLASS is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
# CONFIG_UIO_SMX is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_XATTR is not set
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=m
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_KERNEL_TESTS is not set
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_MMIOTRACE_HOOKS=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y

--=-QQoYNgtK1Fo59RjBS0qg--

