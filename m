Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbXCBSoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbXCBSoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXCBSoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:44:12 -0500
Received: from village.ehouse.ru ([193.111.92.18]:1028 "EHLO mail.ehouse.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXCBSoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:44:09 -0500
X-Greylist: delayed 17566 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 13:44:08 EST
From: "Alexander Y. Fomichev" <gluk@php4.ru>
Reply-To: "Alexander Y. Fomichev" <gluk@php4.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
Subject: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Date: Fri, 2 Mar 2007 16:51:15 +0300
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UvC6F0Qwsg2qcmt"
Message-Id: <200703021651.16050.gluk@php4.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_UvC6F0Qwsg2qcmt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

G'day

I'm hit a bug on 2.6.21-rc1 at startup of mysql with 'large-pages' flag set.
(at this point mysql trying to allocate pages from hugetlb pool by sysv 
shm syscalls). Seems like it could be triggered by previous badness
and probably hugetlb itself is not related. Anyway i couldn't reproduce
it by now with 2.6.21-rc2 git commit 562aa1d4c6a874373f9a48ac184f662fbbb06a04.
Very likely it has been fixed somwhere between 2.6.21-rc1 and -rc2,
but i couldn't find something related by git log so any comments are welcome.

[422123.288864] Bad page state in process 'mysqld'
[422123.288867] page:ffff810004d09800 flags:0x00f0080000000010 
mapping:0000000000000000 mapcount:1 count:0
[422123.288869] Trying to fix it up, but a reboot is needed
[422123.288871] Backtrace:
[422123.311745]
[422123.311746] Call Trace:
[422123.311756]  [<ffffffff8025d84b>] _spin_unlock_irq+0x9/0xc
[422123.311762]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.311768]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.311773]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.311777]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.311784]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.311789]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.311795]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.311799]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.311803]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.311808]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.311814]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.311819]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.311824]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.311828]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.311834]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.311839]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.311843]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.311848]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.311851]
[422123.312248] Bad page state in process 'mysqld'
[422123.312249] page:ffff810004d09840 flags:0x00f0080000000010 
mapping:0000000000000000 mapcount:1 count:0
[422123.312251] Trying to fix it up, but a reboot is needed
[422123.312253] Backtrace:
[422123.335123]
[422123.335124] Call Trace:
[422123.335128]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.335132]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.335137]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.335140]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.335145]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.335150]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.335155]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.335159]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.335163]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.335167]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.335172]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.335177]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.335182]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.335186]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.335191]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.335195]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.335200]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.335204]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.335206]
[422123.335277] Bad page state in process 'mysqld'
[422123.335278] page:ffff810004d09880 flags:0x00f0080000000010 
mapping:0000000000000000 mapcount:1 count:0
[422123.335280] Trying to fix it up, but a reboot is needed
[422123.335282] Backtrace:
[422123.358152]
[422123.358153] Call Trace:
[422123.358157]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.358161]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.358166]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.358170]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.358174]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.358179]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.358184]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.358188]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.358192]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.358196]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.358201]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.358206]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.358211]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.358215]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.358220]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.358224]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.358228]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.358233]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.358235]
[422123.358305] Bad page state in process 'mysqld'
[422123.358307] page:ffff810004d098c0 flags:0x00f0080000000010 
mapping:0000000000000000 mapcount:1 count:0
[422123.358308] Trying to fix it up, but a reboot is needed
[422123.358310] Backtrace:
[422123.381169]
[422123.381170] Call Trace:
[422123.381174]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.381178]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.381183]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.381187]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.381191]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.381196]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.381201]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.381205]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.381209]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.381214]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.381218]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.381223]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.381228]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.381232]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.381237]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.381241]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.381246]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.381250]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.381253]
[422123.381338] ------------[ cut here ]------------
[422123.386310] kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
[422123.393559] invalid opcode: 0000 [1] SMP
[422123.397918] CPU 1
[422123.400168] Modules linked in: xt_state ipt_REJECT iptable_filter
[422123.406736] Pid: 7904, comm: mysqld Tainted: G    B  2.6.21-rc1 #2
[422123.413353] RIP: 0010:[<ffffffff8026e114>]  [<ffffffff8026e114>] 
huge_pte_alloc+0x364/0x377
[422123.422281] RSP: 0000:ffff8100f5015cc8  EFLAGS: 00010202
[422123.427982] RAX: ffff8100f5527560 RBX: ffff8100ed9462b8 RCX: 
0000000000000000
[422123.435604] RDX: 00000000f40bc067 RSI: 00002b8295964004 RDI: 
ffff8100f4c99800
[422123.443243] RBP: ffff8100f5015d58 R08: 00002b8294ee28c8 R09: 
000000000001c000
[422123.450864] R10: ffff8100f5015e38 R11: 0000000000000202 R12: 
00002b8295964004
[422123.458494] R13: 0000000000000560 R14: 00002b8295964004 R15: 
ffff810005f89088
[422123.466125] FS:  00002b8284792ae0(0000) GS:ffff81010406eec0(0000) 
knlGS:0000000000000000
[422123.474774] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[422123.480917] CR2: 00002b8295964004 CR3: 00000000ed946000 CR4: 
00000000000006e0
[422123.488565] Process mysqld (pid: 7904, threadinfo ffff8100f5014000, task 
ffff8100f5ba7180)
[422123.497370] Stack:  0000000000000002 ffff8100f4c99800 ffff8100f2814050 
ffffffff8028b978
[422123.506022]  ffff8100f5015d08 ffffffff80302dda 0000000000004000 
ffff810004cb0a40
[422123.514007]  ffff8100f5015d18 ffffffff8025d857 ffff8100f5015d48 
ffffffff802076cf
[422123.521774] Call Trace:
[422123.524692]  [<ffffffff8028b978>] up_read+0x9/0xb
[422123.529745]  [<ffffffff80302dda>] xfs_iunlock+0x33/0x79
[422123.535341]  [<ffffffff8025d857>] _read_unlock_irq+0x9/0xc
[422123.541206]  [<ffffffff802076cf>] find_get_page+0x50/0x5b
[422123.546987]  [<ffffffff802a5369>] hugetlb_fault+0x28/0xc6
[422123.552756]  [<ffffffff80208692>] __handle_mm_fault+0x60/0xc24
[422123.559003]  [<ffffffff8020acfa>] do_page_fault+0x457/0x803
[422123.564971]  [<ffffffff8025d84b>] _spin_unlock_irq+0x9/0xc
[422123.570838]  [<ffffffff8025b649>] thread_return+0x5e/0xf5
[422123.576624]  [<ffffffff8025d74d>] _spin_unlock+0x9/0xb
[422123.582135]  [<ffffffff8025da1d>] error_exit+0x0/0x84
[422123.587540]
[422123.589218]
[422123.589218] Code: 0f 0b eb fe 48 83 c4 68 5b 41 5c 41 5d 41 5e 41 5f c9 c3 
55
[422123.599079] RIP  [<ffffffff8026e114>] huge_pte_alloc+0x364/0x377
[422123.605508]  RSP <ffff8100f5015cc8>

full dmesg attached.


-- 
Best regards.
        Alexander Y. Fomichev <gluk@php4.ru>
        Public PGP key: http://sysadminday.org.ru/gluk.asc

--Boundary-00=_UvC6F0Qwsg2qcmt
Content-Type: text/x-log;
  charset="us-ascii";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.log"

[    0.000000] Linux version 2.6.21-rc1 (gluk@localhost) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #2 SMP Thu Feb 22 14:10:40 Local time zone must be set--see zic 
[    0.000000] Command line: root=/dev/sda2 console=ttyS0,115200 console=tty0 idle=pool profile=2 panic=30
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000f6ff0000 (usable)
[    0.000000]  BIOS-e820: 00000000f6ff0000 - 00000000f6fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000f6fff000 - 00000000f7000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000200000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1011696) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
[    0.000000] end_pfn_map = 2097152
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6A80, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT F6FF0000, 0034 (r1 A M I  OEMRSDT   4000430 MSFT       97)
[    0.000000] ACPI: FACP F6FF0200, 0081 (r1 A M I  OEMFACP   4000430 MSFT       97)
[    0.000000] ACPI: DSDT F6FF0450, 2F29 (r1  1ABTX 1ABTX000        0 INTL  2002026)
[    0.000000] ACPI: FACS F6FFF000, 0040
[    0.000000] ACPI: APIC F6FF0380, 0074 (r1 A M I  OEMAPIC   4000430 MSFT       97)
[    0.000000] ACPI: OEMB F6FFF040, 0041 (r1 A M I  OEMBIOS   4000430 MSFT       97)
[    0.000000] ACPI: SRAT F6FF3380, 00F0 (r1 A M I  OEMSRAT   4000430 MSFT       97)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 1 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 100000-f7000000
[    0.000000] Entering add_active_range(0, 256, 1011696) 0 entries of 3200 used
[    0.000000] SRAT: Node 1 PXM 1 100000000-200000000
[    0.000000] Entering add_active_range(1, 1048576, 2097152) 1 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 0-f7000000
[    0.000000] Entering add_active_range(0, 0, 159) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1011696) 3 entries of 3200 used
[    0.000000] NUMA: Using 32 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-00000000f7000000
[    0.000000] Bootmem setup node 1 0000000100000000-0000000200000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2097152
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->  1011696
[    0.000000]     1:  1048576 ->  2097152
[    0.000000] On node 0 totalpages: 1011599
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 1016 pages reserved
[    0.000000]   DMA zone: 2919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 15743 pages used for memmap
[    0.000000]   DMA32 zone: 991857 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1032192 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x5008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfebfe000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, address 0xfebfe000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfebff000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 4, address 0xfebff000, GSI 28-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e0000
[    0.000000] Nosave address range: 00000000000e0000 - 0000000000100000
[    0.000000] Nosave address range: 00000000f6ff0000 - 00000000f6fff000
[    0.000000] Nosave address range: 00000000f6fff000 - 00000000f7000000
[    0.000000] Nosave address range: 00000000f7000000 - 00000000ff7c0000
[    0.000000] Nosave address range: 00000000ff7c0000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f8000000 (gap: f7000000:87c0000)
[    0.000000] PERCPU: Allocating 33216 bytes of per cpu data
[    0.000000] Built 2 zonelists.  Total pages: 2026968
[    0.000000] Kernel command line: root=/dev/sda2 console=ttyS0,115200 console=tty0 idle=pool profile=2 panic=30
[    0.000000] kernel profiling enabled (shift: 2)
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   81.559725] time.c: Detected 2004.579 MHz processor.
[   81.568683] Console: colour VGA+ 80x25
[   81.970539] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[   81.987506] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   81.998143] Checking aperture...
[   82.001473] CPU 0: aperture @ 1ee0000000 size 64 MB
[   82.006452] Aperture beyond 4GB. Ignoring.
[   82.017045] No AGP bridge found
[   82.020277] Your BIOS doesn't leave a aperture memory hole
[   82.025865] Please enable the IOMMU option in the BIOS setup
[   82.031626] This costs you 64 MB of RAM
[   82.095082] Mapping aperture over 65536 KB of RAM @ 8000000
[   82.410674] Memory: 8027220k/8388608k available (2101k kernel code, 213480k reserved, 1036k data, 288k init)
[   82.500233] Calibrating delay using timer specific routine.. 4013.16 BogoMIPS (lpj=8026336)
[   82.508879] Security Framework v1.0.0 initialized
[   82.513691] Capability LSM initialized
[   82.517576] Mount-cache hash table entries: 256
[   82.522358] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   82.529595] CPU: L2 Cache: 1024K (64 bytes/line)
[   82.534310] CPU 0/0 -> Node 0
[   82.537397] Freeing SMP alternatives: 20k freed
[   82.542037] ACPI: Core revision 20070126
[   82.588559] Using local APIC timer interrupts.
[   82.642902] result 12528637
[   82.645788] Detected 12.528 MHz APIC timer.
[   82.652344] Booting processor 1/2 APIC 0x1
[   82.666833] Initializing CPU#1
[   82.743839] Calibrating delay using timer specific routine.. 4009.38 BogoMIPS (lpj=8018778)
[   82.743848] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   82.743851] CPU: L2 Cache: 1024K (64 bytes/line)
[   82.743853] CPU 1/1 -> Node 1
[   82.743986] AMD Opteron(tm) Processor 246 stepping 08
[   82.747859] Brought up 2 CPUs
[   82.782749] testing NMI watchdog ... OK.
[   83.656289] migration_cost=625
[   83.659928] NET: Registered protocol family 16
[   83.664623] ACPI: bus type pci registered
[   83.674850] PCI: Using configuration type 1
[   83.686672] ACPI: Interpreter enabled
[   83.690431] ACPI: Using IOAPIC for interrupt routing
[   83.703090] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   83.707983] PCI: Probing PCI hardware (bus 00)
[   83.708604] Boot video device is 0000:04:06.0
[   83.709044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   83.709146] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   83.709299] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLA._PRT]
[   83.709468] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLB._PRT]
[   83.712421] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[   83.720873] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[   83.729324] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[   83.737776] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[   83.746200] Linux Plug and Play Support v0.97 (c) Adam Belay
[   83.751967] pnp: PnP ACPI init
[   83.760214] pnp: PnP ACPI: found 13 devices
[   83.764741] SCSI subsystem initialized
[   83.768629] PCI: Using ACPI for IRQ routing
[   83.772911] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   83.781446] PCI-DMA: Disabling AGP.
[   83.785081] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   83.790662] PCI-DMA: using GART IOMMU.
[   83.794504] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   83.801133] pnp: 00:09: ioport range 0x680-0x6ff has been reserved
[   83.807410] pnp: 00:09: ioport range 0x295-0x296 has been reserved
[   83.813699] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   83.820759] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[   83.827819] pnp: 00:0b: iomem range 0xfff80000-0xffffffff has been reserved
[   83.834878] pnp: 00:0b: iomem range 0xff780000-0xff7fffff has been reserved
[   83.841941] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   83.848476] pnp: 00:0c: iomem range 0xc0000-0xdffff has been reserved
[   83.855018] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   83.861903] pnp: 00:0c: iomem range 0x100000-0xf6ffffff could not be reserved
[   83.869530] PCI: Bridge: 0000:00:06.0
[   83.873288]   IO window: a000-cfff
[   83.876785]   MEM window: fca00000-feafffff
[   83.881064]   PREFETCH window: disabled.
[   83.885081] PCI: Bridge: 0000:00:0a.0
[   83.888841]   IO window: 9000-9fff
[   83.892337]   MEM window: fc800000-fc9fffff
[   83.896620]   PREFETCH window: disabled.
[   83.900643] PCI: Bridge: 0000:01:01.0
[   83.904405]   IO window: disabled.
[   83.907901]   MEM window: fc600000-fc7fffff
[   83.912182]   PREFETCH window: ff500000-ff5fffff
[   83.916897] PCI: Bridge: 0000:00:0b.0
[   83.920650]   IO window: disabled.
[   83.924148]   MEM window: fc600000-fc7fffff
[   83.928430]   PREFETCH window: ff500000-ff5fffff
[   83.933294] NET: Registered protocol family 2
[   83.973899] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   83.983026] TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
[   83.992376] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[   84.000501] TCP: Hash tables configured (established 65536 bind 65536)
[   84.007127] TCP reno registered
[   84.023102] Total HugeTLB memory allocated, 0
[   84.027768] SGI XFS with large block/inode numbers, no debug enabled
[   84.034492] io scheduler noop registered
[   84.038623] io scheduler deadline registered (default)
[   84.044025] PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:00:0a.0 subordinate bus.
[   84.052858] PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:00:0b.0 subordinate bus.
[   84.064947] Real Time Clock Driver v1.12ac
[   84.069254] Linux agpgart interface v0.102 (c) Dave Jones
[   84.074751] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   84.082845] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   84.089070] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   84.095572] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   84.101411] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   84.107219] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   84.113760] Copyright (c) 1999-2006 Intel Corporation.
[   84.119059] ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 27 (level, low) -> IRQ 27
[   84.390916] e1000: 0000:03:03.0: e1000_probe: (PCI:66MHz:32-bit) 00:d0:68:05:ba:5e
[   84.590844] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   84.597837] ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 24 (level, low) -> IRQ 24
[   84.870109] e1000: 0000:03:04.0: e1000_probe: (PCI:66MHz:32-bit) 00:d0:68:05:ba:5f
[   85.070027] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[   85.077121] netconsole: not configured, aborting
[   85.081839] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   85.089281] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   85.096399] megaraid: probe new device 0x1000:0x0407:0x1000:0x0532: bus 2:slot 0:func 0
[   85.104618] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 29 (level, low) -> IRQ 29
[   85.139958] megaraid: fw version:[414G] bios version:[A100]
[   85.146046] scsi0 : LSI Logic MegaRAID driver
[   85.150599] scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
[   88.414703] scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
[   91.432418] scsi[0]: scanning scsi channel 2 [virtual] for logical drives
[   91.439527] scsi 0:2:0:0: Direct-Access     MegaRAID LD 0 RAID1   34G 414G PQ: 0 ANSI: 2
[   91.447998] scsi 0:2:1:0: Direct-Access     MegaRAID LD 1 RAID1   70G 414G PQ: 0 ANSI: 2
[   91.459145] SCSI device sda: 71677952 512-byte hdwr sectors (36699 MB)
[   91.465812] sda: Write Protect is off
[   91.469573] sda: Mode Sense: 00 00 00 00
[   91.469586] sda: asking for cache data failed
[   91.474046] sda: assuming drive cache: write through
[   91.479230] SCSI device sda: 71677952 512-byte hdwr sectors (36699 MB)
[   91.485862] sda: Write Protect is off
[   91.489627] sda: Mode Sense: 00 00 00 00
[   91.489636] sda: asking for cache data failed
[   91.494090] sda: assuming drive cache: write through
[   91.499154]  sda: sda1 sda2 sda3 sda4
[   91.503732] sd 0:2:0:0: Attached scsi disk sda
[   91.508392] SCSI device sdb: 143366144 512-byte hdwr sectors (73403 MB)
[   91.515111] sdb: Write Protect is off
[   91.518874] sdb: Mode Sense: 00 00 00 00
[   91.518884] sdb: asking for cache data failed
[   91.523336] sdb: assuming drive cache: write through
[   91.528476] SCSI device sdb: 143366144 512-byte hdwr sectors (73403 MB)
[   91.535196] sdb: Write Protect is off
[   91.538952] sdb: Mode Sense: 00 00 00 00
[   91.538961] sdb: asking for cache data failed
[   91.543417] sdb: assuming drive cache: write through
[   91.548476]  sdb: sdb1 sdb2 sdb3
[   91.569049] sd 0:2:1:0: Attached scsi disk sdb
[   91.573728] PNP: No PS/2 controller found. Probing ports directly.
[   91.582567] serio: i8042 KBD port at 0x60,0x64 irq 1
[   91.587635] serio: i8042 AUX port at 0x60,0x64 irq 12
[   91.592832] mice: PS/2 mouse device common for all mice
[   91.598308] oprofile: using NMI interrupt.
[   91.602508] nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
[   91.608791] ip_tables: (C) 2000-2006 Netfilter Core Team
[   91.614212] TCP cubic registered
[   91.617550] NET: Registered protocol family 1
[   91.622006] NET: Registered protocol family 17
[   91.629731] Time: acpi_pm clocksource has been installed.
[   92.362211] XFS mounting filesystem sda2
[   92.415823] Ending clean XFS mount for filesystem: sda2
[   92.415941] VFS: Mounted root (xfs filesystem) readonly.
[   92.421474] Freeing unused kernel memory: 288k freed
[   94.308171] XFS mounting filesystem sda3
[   94.356269] Ending clean XFS mount for filesystem: sda3
[   94.376626] XFS mounting filesystem sda4
[   94.430586] Ending clean XFS mount for filesystem: sda4
[   94.467770] XFS mounting filesystem sdb2
[   94.510716] Ending clean XFS mount for filesystem: sdb2
[   94.512003] XFS mounting filesystem sdb3
[   94.599377] Ending clean XFS mount for filesystem: sdb3
[   94.622623] Adding 1959888k swap on /dev/sda1.  Priority:-1 extents:1 across:1959888k
[   94.624601] Adding 3911788k swap on /dev/sdb1.  Priority:-2 extents:1 across:3911788k
[   99.784379] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   99.788371] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Half Duplex, Flow Control: None
[  103.318382] e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[ 1662.471349] factorial[4360]: segfault at 0000000000020f51 rip 00000000004034fc rsp 00007fffe5073840 error 4
[ 1662.478033] factorial[4363]: segfault at 0000000000020f51 rip 00000000004034fc rsp 00007fffd6a16200 error 4
[ 1662.484712] factorial[4366]: segfault at 0000000000020f51 rip 00000000004034fc rsp 00007fffbafcb7c0 error 4
[ 1662.492100] factorial[4370]: segfault at 0000000000020f51 rip 00000000004034fc rsp 00007fffd5b7d370 error 4
[ 1662.498846] factorial[4373]: segfault at 0000000000020f51 rip 00000000004034fc rsp 00007fff03c65450 error 4
[422123.288864] Bad page state in process 'mysqld'
[422123.288867] page:ffff810004d09800 flags:0x00f0080000000010 mapping:0000000000000000 mapcount:1 count:0
[422123.288869] Trying to fix it up, but a reboot is needed
[422123.288871] Backtrace:
[422123.311745] 
[422123.311746] Call Trace:
[422123.311756]  [<ffffffff8025d84b>] _spin_unlock_irq+0x9/0xc
[422123.311762]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.311768]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.311773]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.311777]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.311784]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.311789]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.311795]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.311799]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.311803]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.311808]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.311814]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.311819]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.311824]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.311828]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.311834]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.311839]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.311843]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.311848]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.311851] 
[422123.312248] Bad page state in process 'mysqld'
[422123.312249] page:ffff810004d09840 flags:0x00f0080000000010 mapping:0000000000000000 mapcount:1 count:0
[422123.312251] Trying to fix it up, but a reboot is needed
[422123.312253] Backtrace:
[422123.335123] 
[422123.335124] Call Trace:
[422123.335128]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.335132]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.335137]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.335140]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.335145]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.335150]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.335155]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.335159]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.335163]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.335167]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.335172]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.335177]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.335182]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.335186]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.335191]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.335195]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.335200]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.335204]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.335206] 
[422123.335277] Bad page state in process 'mysqld'
[422123.335278] page:ffff810004d09880 flags:0x00f0080000000010 mapping:0000000000000000 mapcount:1 count:0
[422123.335280] Trying to fix it up, but a reboot is needed
[422123.335282] Backtrace:
[422123.358152] 
[422123.358153] Call Trace:
[422123.358157]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.358161]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.358166]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.358170]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.358174]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.358179]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.358184]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.358188]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.358192]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.358196]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.358201]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.358206]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.358211]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.358215]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.358220]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.358224]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.358228]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.358233]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.358235] 
[422123.358305] Bad page state in process 'mysqld'
[422123.358307] page:ffff810004d098c0 flags:0x00f0080000000010 mapping:0000000000000000 mapcount:1 count:0
[422123.358308] Trying to fix it up, but a reboot is needed
[422123.358310] Backtrace:
[422123.381169] 
[422123.381170] Call Trace:
[422123.381174]  [<ffffffff8029a33a>] bad_page+0x5b/0x89
[422123.381178]  [<ffffffff8020b94d>] free_hot_cold_page+0x8c/0x11e
[422123.381183]  [<ffffffff8024c0a0>] free_hot_page+0xb/0xd
[422123.381187]  [<ffffffff8020cba7>] put_page+0xc8/0xd0
[422123.381191]  [<ffffffff802c4af8>] dio_bio_complete+0x7c/0xa4
[422123.381196]  [<ffffffff802c59f9>] __blockdev_direct_IO+0x928/0xa4d
[422123.381201]  [<ffffffff80322f58>] xfs_vm_direct_IO+0xf0/0x125
[422123.381205]  [<ffffffff80323246>] xfs_get_blocks_direct+0x0/0x17
[422123.381209]  [<ffffffff803229b3>] xfs_end_io_direct+0x0/0x49
[422123.381214]  [<ffffffff80298f45>] generic_file_direct_IO+0xa5/0xeb
[422123.381218]  [<ffffffff802163da>] generic_file_aio_read+0xc7/0x194
[422123.381223]  [<ffffffff8032a38c>] xfs_read+0x270/0x2e6
[422123.381228]  [<ffffffff80326e96>] xfs_file_aio_read+0x5c/0x5e
[422123.381232]  [<ffffffff8020cf2e>] do_sync_read+0xe2/0x126
[422123.381237]  [<ffffffff80289833>] autoremove_wake_function+0x0/0x38
[422123.381241]  [<ffffffff8020b7af>] vfs_read+0xcc/0x155
[422123.381246]  [<ffffffff80212929>] sys_pread64+0x55/0x76
[422123.381250]  [<ffffffff802583de>] system_call+0x7e/0x83
[422123.381253] 
[422123.381338] ------------[ cut here ]------------
[422123.386310] kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
[422123.393559] invalid opcode: 0000 [1] SMP 
[422123.397918] CPU 1 
[422123.400168] Modules linked in: xt_state ipt_REJECT iptable_filter
[422123.406736] Pid: 7904, comm: mysqld Tainted: G    B  2.6.21-rc1 #2
[422123.413353] RIP: 0010:[<ffffffff8026e114>]  [<ffffffff8026e114>] huge_pte_alloc+0x364/0x377
[422123.422281] RSP: 0000:ffff8100f5015cc8  EFLAGS: 00010202
[422123.427982] RAX: ffff8100f5527560 RBX: ffff8100ed9462b8 RCX: 0000000000000000
[422123.435604] RDX: 00000000f40bc067 RSI: 00002b8295964004 RDI: ffff8100f4c99800
[422123.443243] RBP: ffff8100f5015d58 R08: 00002b8294ee28c8 R09: 000000000001c000
[422123.450864] R10: ffff8100f5015e38 R11: 0000000000000202 R12: 00002b8295964004
[422123.458494] R13: 0000000000000560 R14: 00002b8295964004 R15: ffff810005f89088
[422123.466125] FS:  00002b8284792ae0(0000) GS:ffff81010406eec0(0000) knlGS:0000000000000000
[422123.474774] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[422123.480917] CR2: 00002b8295964004 CR3: 00000000ed946000 CR4: 00000000000006e0
[422123.488565] Process mysqld (pid: 7904, threadinfo ffff8100f5014000, task ffff8100f5ba7180)
[422123.497370] Stack:  0000000000000002 ffff8100f4c99800 ffff8100f2814050 ffffffff8028b978
[422123.506022]  ffff8100f5015d08 ffffffff80302dda 0000000000004000 ffff810004cb0a40
[422123.514007]  ffff8100f5015d18 ffffffff8025d857 ffff8100f5015d48 ffffffff802076cf
[422123.521774] Call Trace:
[422123.524692]  [<ffffffff8028b978>] up_read+0x9/0xb
[422123.529745]  [<ffffffff80302dda>] xfs_iunlock+0x33/0x79
[422123.535341]  [<ffffffff8025d857>] _read_unlock_irq+0x9/0xc
[422123.541206]  [<ffffffff802076cf>] find_get_page+0x50/0x5b
[422123.546987]  [<ffffffff802a5369>] hugetlb_fault+0x28/0xc6
[422123.552756]  [<ffffffff80208692>] __handle_mm_fault+0x60/0xc24
[422123.559003]  [<ffffffff8020acfa>] do_page_fault+0x457/0x803
[422123.564971]  [<ffffffff8025d84b>] _spin_unlock_irq+0x9/0xc
[422123.570838]  [<ffffffff8025b649>] thread_return+0x5e/0xf5
[422123.576624]  [<ffffffff8025d74d>] _spin_unlock+0x9/0xb
[422123.582135]  [<ffffffff8025da1d>] error_exit+0x0/0x84
[422123.587540] 
[422123.589218] 
[422123.589218] Code: 0f 0b eb fe 48 83 c4 68 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 
[422123.599079] RIP  [<ffffffff8026e114>] huge_pte_alloc+0x364/0x377
[422123.605508]  RSP <ffff8100f5015cc8>

--Boundary-00=_UvC6F0Qwsg2qcmt--
