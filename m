Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXD2IQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXD2IQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXD2IQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:16:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49849 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932962AbXD2IQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:16:13 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com
Date: Sun, 29 Apr 2007 01:16:10 -0700
Message-Id: <20070429081610.5469.36016.sendpatchset@v0>
Subject: bad_page from quicklist patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting many 'bad_page' failures from the quicklist patches
in 2.6.21-rc7-mm1.  I have bisected the problem down the following
patches:

    quicklists-for-page-table-pages.patch
    quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
    quicklist-support-for-ia64.patch
    quicklist-support-for-x86_64.patch
    quicklist-support-for-sparc64.patch

This is on an ia64, compiled with the sn2_defconfig configuration.

If I have these quicklist patches included in the build, then starting
with the init process entering user land, I start getting many
complaints such as the following.  I don't know if it ever actually
gets past the init scripts to finish userland booting, due the large
number of such complaints, and due to another problem that I haven't
looked into yet, involving my boot hanging after the "Setting up
service network" message is displayed during the init script sequence.

But ... back to this problem ... here is the boot output, up through
the first few such 'bad_page' failures that I see when booting with
a kernel that includes the above quicklist patches:

=======================================================================

ELILO
Uncompressing Linux... done
Linux version 2.6.21-rc7-mm1 (pj@jackhammer) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #12 SMP PREEMPT Sun Apr 29 00:43:14 PDT 2007
EFI v1.10 by INTEL: SALsystab=0x3002a092f0 ACPI 2.0=0x3002a09ac0
ACPI: RSDP 3002A09AC0, 0024 (r2    SGI)
ACPI: XSDT 3002A09B00, 0044 (r1    SGI  XSDTSN2    10001            1)
ACPI: APIC 3002A09B60, 008C (r1    SGI  APICSN2    10001            1)
ACPI: SRAT 3002A09C00, 0150 (r1    SGI  SRATSN2    10001            1)
ACPI: SLIT 3002A09D60, 003C (r1    SGI  SLITSN2    10001            1)
ACPI: FACP 3002A09E40, 00F4 (r3    SGI  FACPSN2    30001            1)
ACPI: DSDT 3002A09E00, 0024 (r2    SGI  DSDTSN2    20001            1)
ACPI: FACS 3002A09DB0, 0040
Number of logical nodes in system = 4
Number of memory chunks in system = 4
SAL 2.9: SGI SN2 version 4.50
SAL Platform features: ITC_Drift
SAL: AP wakeup using external interrupt vector 0x12
No logical to physical processor mapping available
SAL_CAL_FLUSH failed with -1
ACPI: Local APIC address c0000000fee00000
ACPI: Error parsing MADT - no IOSAPIC entries
register_intr: No IOSAPIC for GSI 52
8 CPUs available, 8 CPUs total
Increasing MCA rendezvous timeout from 20000 to 49000 milliseconds
MCA related initialization done
ACPI: RSDP 3002A09AC0, 0024 (r2    SGI)
ACPI: XSDT 3002A09B00, 0044 (r1    SGI  XSDTSN2    10001            1)
ACPI: APIC 3002A09B60, 008C (r1    SGI  APICSN2    10001            1)
ACPI: SRAT 3002A09C00, 0150 (r1    SGI  SRATSN2    10001            1)
ACPI: SLIT 3002A09D60, 003C (r1    SGI  SLITSN2    10001            1)
ACPI: FACP 3002A09E40, 00F4 (r3    SGI  FACPSN2    30001            1)
ACPI: DSDT 3002A09E00, 0024 (r2    SGI  DSDTSN2    20001            1)
ACPI: FACS 3002A09DB0, 0040
SGI SAL version 4.50
Virtual mem_map starts at 0xa0007ffe85c80000
Zone PFN ranges:
  Normal   12585984 -> 113307648
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 12585984 -> 12709887
    1: 46140416 -> 46264320
    2: 79694848 -> 79753216
    3: 113249280 -> 113306111
    3: 113307136 -> 113307481
    3: 113307496 -> 113307524
    3: 113307552 -> 113307560
Built 4 zonelists, mobility grouping on.  Total pages: 362143
Kernel command line: BOOT_IMAGE=scsi1:\efi\SuSE\vmlinuz.pj6 root=/dev/sda5 console=ttySG0 splash=silent thash_entries=2097152 kdb=on ro
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
Memory: 5644256k/5796608k available (7960k code, 169936k reserved, 6062k data, 1664k init)
McKinley Errata 9 workaround not needed; disabling it
SLUB: General Slabs=20, HW alignment=128, Processors=8, Nodes=1024
Dentry cache hash table entries: 1048576 (order: 9, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 8, 4194304 bytes)
Mount-cache hash table entries: 1024
ACPI: Core revision 20070126
Boot processor id 0x0/0x0
Brought up 8 CPUs
Total of 8 processors activated (15564.80 BogoMIPS).
migration_cost=5743,44436
DMI not present or invalid.
NET: Registered protocol family 16
ACPI  DSDT OEM Rev 0x20001
ACPI: bus type pci registered
ACPI: SCI (ACPI GSI 52) not registered
ACPI: Interpreter enabled
ACPI: Using IOSAPIC for interrupt routing
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 0 devices
SCSI subsystem initialized
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 7, 2097152 bytes)
TCP established hash table entries: 2097152 (order: 11, 50331648 bytes)
TCP bind hash table entries: 65536 (order: 6, 1048576 bytes)
TCP: Hash tables configured (established 2097152 bind 65536)
TCP reno registered
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 2048 (order 0, 16384 bytes)
SGI XFS with ACLs, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
mspec 4.0 initialized devices: SGI Fetchop, Cached, Uncached
SGI Altix RTC Timer: v2.1, 20 MHz
EFI Time Services Driver v0.4
Linux agpgart interface v0.102 (c) Dave Jones
sn_console: Console driver init
ttySG0 at I/O 0x0 (irq = 0) is a SGI SN L1
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
ACPI: Unable to derive IRQ for device 0001:00:01.0
ACPI: PCI Interrupt 0001:00:01.0[A]: no GSI
IOC4 0001:00:01.0: IO9 card detected.
tg3.c:v3.75 (March 23, 2007)
ACPI: Unable to derive IRQ for device 0001:00:04.0
ACPI: PCI Interrupt 0001:00:04.0[A]: no GSI
eth0: Tigon3 [partno(030-1771-000) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000Base-T Ethernet 08:00:69:13:dd:04
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff3f0f] dma_mask[64-bit]
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
qla1280: QLA12160 found on PCI bus 0, dev 3
ACPI: Unable to derive IRQ for device 0001:00:03.0
ACPI: PCI Interrupt 0001:00:03.0[A]: no GSI
scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(0): Enabling SN2 PCI DMA workaround
scsi(0:0): Resetting SCSI BUS
scsi(0:1): Resetting SCSI BUS
scsi0 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.42, Driver version 3.26
scsi 0:0:1:0: Direct-Access     SGI      ST336753LC       2741 PQ: 0 ANSI: 3
scsi(0:0:1:0): Sync: period 9, offset 14, Wide, DT
QLogic Fibre Channel HBA Driver
sd 0:0:1:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:1:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
sd 0:0:1:0: [sda] Attached SCSI disk
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT FC Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
mice: PS/2 mouse device common for all mice
async_tx: api initialized (sync-only)
xor: measuring software checksumming speed
   ia64      :  2696.000 MB/sec
xor: using function: ia64 (2696.000 MB/sec)
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid6: int64x1   1120 MB/s
raid6: int64x2   1770 MB/s
raid6: int64x4   2232 MB/s
raid6: int64x8   2473 MB/s
raid6: int64x16  3027 MB/s
raid6: int64x32  1709 MB/s
raid6: using algorithm int64x16 (3027 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EFI Variables Facility v0.08 2004-May-17
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
IOC4 firmware revision 69
0001:00:01.0: ttyIOC0 at I/O 0x0 (irq = 60) is a SGI IOC4 Serial [rs232]
0001:00:01.0: ttyIOC1 at I/O 0x1 (irq = 60) is a SGI IOC4 Serial [rs232]
0001:00:01.0: ttyIOC2 at I/O 0x2 (irq = 60) is a SGI IOC4 Serial [rs232]
0001:00:01.0: ttyIOC3 at I/O 0x3 (irq = 60) is a SGI IOC4 Serial [rs232]
0001:00:01.0: ttyAIOC0 at I/O 0x0 (irq = 60) is a SGI IOC4 Serial [rs422]
0001:00:01.0: ttyAIOC1 at I/O 0x1 (irq = 60) is a SGI IOC4 Serial [rs422]
0001:00:01.0: ttyAIOC2 at I/O 0x2 (irq = 60) is a SGI IOC4 Serial [rs422]
0001:00:01.0: ttyAIOC3 at I/O 0x3 (irq = 60) is a SGI IOC4 Serial [rs422]
SGIIOC4: IDE controller at PCI slot 0001:00:01.0, revision 69
ide0: BM-DMA at 0xc00000080c200140-0xc00000080c200163
hda: MATSHITADVD-ROM SR-8588, ATAPI CD/DVD-ROM drive
ide0 at 0xc00000080c200100-0xc00000080c200107,0xc00000080c200120 on irq 60
hda: ATAPI 48X DVD-ROM drive, 256kB Cache, (U)DMA
Uniform CD-ROM driver Revision: 3.20
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
XFS mounting filesystem sda5
Starting XFS recovery on filesystem: sda5 (logdev: internal)
Ending XFS recovery on filesystem: sda5 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 1664kB freed
INIT: version 2.86 booting
Bad page state in process 'init'
page:a0007fff8fd84570 flags:0x0080000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c010>] free_pgd_range+0x310/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0
Bad page state in process 'init'
page:a0007fff8fd845a8 flags:0x0080000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c2a0>] free_pgd_range+0x5a0/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0
Bad page state in process 'init'
page:a0007fff8fd845e0 flags:0x0080000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c4f0>] free_pgd_range+0x7f0/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0
Bad page state in process 'init'
page:a0007fff1fe439f8 flags:0x0040000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c010>] free_pgd_range+0x310/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0
Bad page state in process 'init'
page:a0007fff1fe439c0 flags:0x0040000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c2a0>] free_pgd_range+0x5a0/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0
Bad page state in process 'init'
page:a0007fff1fe43988 flags:0x0040000000000000 mapping:0000000000000000 mapcount:0 count:1
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<a000000100012800>] show_stack+0x40/0xa0
                                sp=e00000b0203f7af0 bsp=e00000b0203f1348
 [<a000000100012890>] dump_stack+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1330
 [<a00000010010f6c0>] bad_page+0xa0/0x120
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1310
 [<a000000100111410>] free_hot_cold_page+0x130/0x440
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12d0
 [<a000000100111850>] free_hot_page+0x30/0x60
                                sp=e00000b0203f7cc0 bsp=e00000b0203f12b0
 [<a00000010012c4f0>] free_pgd_range+0x7f0/0xb00
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1210
 [<a00000010012e480>] free_pgtables+0x1c0/0x200
                                sp=e00000b0203f7cc0 bsp=e00000b0203f11b8
 [<a000000100130d60>] exit_mmap+0x160/0x540
                                sp=e00000b0203f7cc0 bsp=e00000b0203f1170
 [<a00000010009d480>] mmput+0x60/0x180
                                sp=e00000b0203f7d80 bsp=e00000b0203f1148
 [<a000000100173780>] flush_old_exec+0xee0/0x1420
                                sp=e00000b0203f7d80 bsp=e00000b0203f10d0
 [<a0000001001e2f30>] load_elf_binary+0x930/0x2740
                                sp=e00000b0203f7d90 bsp=e00000b0203f0fb8
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f68
 [<a0000001001e1480>] load_script+0x480/0x4e0
                                sp=e00000b0203f7da0 bsp=e00000b0203f0f20
 [<a000000100172380>] search_binary_handler+0x200/0x560
                                sp=e00000b0203f7e30 bsp=e00000b0203f0ed0
 [<a000000100174b10>] do_execve+0x230/0x380
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e70
 [<a000000100011660>] sys_execve+0x60/0xc0
                                sp=e00000b0203f7e30 bsp=e00000b0203f0e38
 [<a00000010000aa50>] ia64_execve+0x30/0x160
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a00000010000b380>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b0203f7e30 bsp=e00000b0203f0de0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b0203f8000 bsp=e00000b0203f0de0

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
