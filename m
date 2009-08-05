Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZHESIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZHESIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZHESIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:08:31 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:51133 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHESI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:08:27 -0400
Message-ID: <4A79CA90.8080101@free.fr>
Date: Wed, 05 Aug 2009 20:08:16 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.1.1pre) Gecko/20090717 SeaMonkey/2.0b1
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: linux-next: reiserfs lockout with xattr ?
X-Enigmail-Version: 0.97a
Content-Type: multipart/mixed;
 boundary="------------010602020608020507010208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010602020608020507010208
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello,

>From times to times, my desktop freezes when I log in the Gnome Desktop. I'm able to switch to a text console, but I can't login. I must reboot using the magic sysrq keys.

Yesterday, I managed to get some logs of this situation:


SysRq : Show Blocked State
  task                PC stack   pid father
sync_supers   D f7477230  2720    77      2 0x00000000
 f74beeec 00000046 00000100 f7477230 004631a2 00000100 00001240 c0546200
 c0546200 c0543284 f74beed0 f75372b0 f7537444 c1c52200 00000001 00000000
 f74beedc 00000246 00000000 00000002 f7537444 ffff442e f9f900fa 00000000
Call Trace:
 [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
 [<c0265518>] ? bdi_sync_supers+0x0/0x3a
 [<c03dd74a>] mutex_lock_nested+0x2b/0x33
 [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<f9f900fa>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<f9f7f6f8>] reiserfs_sync_fs+0x12/0x51 [reiserfs]
 [<c027e24a>] ? sync_supers+0x40/0x8e
 [<c03dd9a2>] ? down_read+0x2c/0x40
 [<f9f7f744>] reiserfs_write_super+0xd/0xf [reiserfs]
 [<c027e25e>] sync_supers+0x54/0x8e
 [<c0265544>] bdi_sync_supers+0x2c/0x3a
 [<c0237f65>] kthread+0x69/0x6e
 [<c0237efc>] ? kthread+0x0/0x6e
 [<c0203d8b>] kernel_thread_helper+0x7/0x10
gconfd-2      D f7477230  1416  4749      1 0x00000000
 f759ea84 00000046 c1c52200 f7477230 c0244e0a f759ea30 c03de2a8 c0546200
 c0546200 c0543284 f82335bb f75b5470 f75b5604 c1c52200 00000001 00000000
 f759ea74 00000246 00000000 00000002 f75b5604 ffff3ebb f9f900fa 00000000
Call Trace:
 [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
 [<c03de2a8>] ? _read_unlock_irqrestore+0x5f/0x6c
 [<f82335bb>] ? dm_get_table+0x2e/0x35 [dm_mod]
 [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
 [<c03dd74a>] mutex_lock_nested+0x2b/0x33
 [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<f9f900fa>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
 [<f9f85bc4>] search_by_key+0x19e/0x738 [reiserfs]
 [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
 [<c03dd198>] ? __mutex_unlock_slowpath+0x112/0x121
 [<c03dd1af>] ? mutex_unlock+0x8/0xa
 [<f9f8b5f8>] ? do_journal_end+0xa5a/0xc34 [reiserfs]
 [<f9f74ee2>] search_by_entry_key+0x17/0x198 [reiserfs]
 [<f9f750c1>] reiserfs_find_entry+0x5e/0x21c [reiserfs]
 [<c03dd1af>] ? mutex_unlock+0x8/0xa
 [<f9f9015e>] ? reiserfs_write_unlock+0x55/0x5a [reiserfs]
 [<f9f756f6>] reiserfs_lookup+0x6f/0xf7 [reiserfs]
 [<c02833ef>] __lookup_hash+0xa4/0xbe
 [<c0284e88>] lookup_one_len+0x8e/0x9d
 [<f9f8f1e1>] open_xa_dir+0x111/0x18a [reiserfs]
 [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
 [<f9f8f88f>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
 [<f9f8ffe8>] ? delete_one_xattr+0x0/0x94 [reiserfs]
 [<f9f8fa6a>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
 [<f9f7b3e2>] reiserfs_delete_inode+0x41/0xb7 [reiserfs]
 [<f9f7b3a1>] ? reiserfs_delete_inode+0x0/0xb7 [reiserfs]
 [<c028bff6>] generic_delete_inode+0x79/0xf1
 [<c028c080>] generic_drop_inode+0x12/0x18d
 [<c028b3b7>] iput+0x4b/0x4e
 [<c0289052>] dentry_iput+0x9c/0xb7
 [<c028910e>] d_kill+0x2d/0x47
 [<c0289814>] dput+0x110/0x119
 [<c0285831>] sys_renameat+0x176/0x1d3
 [<c0289747>] ? dput+0x43/0x119
 [<c028e6d6>] ? mntput_no_expire+0x19/0xad
 [<c02858a0>] sys_rename+0x12/0x14
 [<c0203228>] sysenter_do_call+0x12/0x3c
gnome-panel   D f0a34170  1996  4939   4534 0x00000000
 f0ae6d74 00000046 c1c52200 f0a34170 00000005 000000c1 f0ae6d4c c0546200
 c0546200 f4e2acb0 c0288adf f4e2acb0 f4e2ae44 c1c52200 00000001 f0ae6e6c
 f0ae6d64 00000246 00000000 00000002 f4e2ae44 00000000 f9f900bf 00000000
Call Trace:
 [<c0288adf>] ? pollwake+0x59/0x62
 [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
 [<c03dd74a>] mutex_lock_nested+0x2b/0x33
 [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<f9f900bf>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<f9f756ce>] reiserfs_lookup+0x47/0xf7 [reiserfs]
 [<c02832db>] do_lookup+0xb4/0x124
 [<c0283aa0>] __link_path_walk+0x33b/0x6ce
 [<c0283ff4>] path_walk+0x50/0xa5
 [<c02843ce>] do_path_lookup+0x21/0x42
 [<c0285e39>] user_path_at+0x3c/0x67
 [<c02771ac>] ? kmem_cache_alloc+0x11d/0x155
 [<c023c21e>] ? prepare_creds+0x2b/0x72
 [<c027be5f>] sys_faccessat+0x90/0x14a
 [<c027bf29>] sys_access+0x10/0x12
 [<c0203228>] sysenter_do_call+0x12/0x3c
trackerd      D f7477230  1756  4949   4534 0x00000000
 f0a36da8 00000046 f0a36d40 f7477230 f0a36d7c c03dd66d 00000202 c0546200
 c0546200 c0543284 f0a36de0 f0ac2a70 f0ac2c04 c1c52200 00000001 00000000
 f0a36d98 00000246 00000000 00000002 f0ac2c04 ffff3ebb f9f8f1cf 00000000
Call Trace:
 [<c03dd66d>] ? __mutex_lock_common+0x37c/0x3ca
 [<f9f8f1cf>] ? open_xa_dir+0xff/0x18a [reiserfs]
 [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
 [<c03dd74a>] mutex_lock_nested+0x2b/0x33
 [<f9f8f1cf>] ? open_xa_dir+0xff/0x18a [reiserfs]
 [<f9f8f1cf>] open_xa_dir+0xff/0x18a [reiserfs]
 [<f9f8f88f>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
 [<f9f8ffe8>] ? delete_one_xattr+0x0/0x94 [reiserfs]
 [<f9f8fa6a>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
 [<f9f7b3e2>] reiserfs_delete_inode+0x41/0xb7 [reiserfs]
 [<f9f7b3a1>] ? reiserfs_delete_inode+0x0/0xb7 [reiserfs]
 [<c028bff6>] generic_delete_inode+0x79/0xf1
 [<c028c080>] generic_drop_inode+0x12/0x18d
 [<c028b3b7>] iput+0x4b/0x4e
 [<c0285965>] do_unlinkat+0xc3/0x107
 [<c027da44>] ? fput+0x19/0x1b
 [<c027b3d0>] ? filp_close+0x51/0x5b
 [<c02859b9>] sys_unlink+0x10/0x12
 [<c0203228>] sysenter_do_call+0x12/0x3c
gvfsd-trash   D c04c4160  2088  4971      1 0x00000000
 f0ba2d28 00000046 ffffffff c04c4160 ed67f708 f0ba2dcb f0ba2cf0 c0546200
 c0546200 c0543284 00000000 f64512f0 f6451484 c1c42200 00000000 00000000
 f0ba2d18 00000246 00000000 00000002 f6451484 ffff3ea3 f9f900bf 00000000
Call Trace:
 [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
 [<c03dd74a>] mutex_lock_nested+0x2b/0x33
 [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<f9f900bf>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
 [<f9f756ce>] reiserfs_lookup+0x47/0xf7 [reiserfs]
 [<c02832db>] do_lookup+0xb4/0x124
 [<c0283d0a>] __link_path_walk+0x5a5/0x6ce
 [<c0283ff4>] path_walk+0x50/0xa5
 [<c02843ce>] do_path_lookup+0x21/0x42
 [<c0285e39>] user_path_at+0x3c/0x67
 [<c029e5ec>] ? __fsnotify_update_child_dentry_flags+0x76/0xcf
 [<c027f78e>] vfs_fstatat+0x2d/0x54
 [<c027f7f9>] vfs_lstat+0x16/0x18
 [<c027f80f>] sys_lstat64+0x14/0x28
 [<c02a0d3f>] ? sys_inotify_add_watch+0x270/0x2c4
 [<c02f9558>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0203228>] sysenter_do_call+0x12/0x3c


This is linux-next kernel with reiser4 patches. Full dmesg attached.
~~
laurent

--------------010602020608020507010208
Content-Type: text/x-log;
 name="dmesg-2.6.31-rc5-next-20090804.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-2.6.31-rc5-next-20090804.log"

Inspecting /boot/System.map-2.6.31-rc5-next-20090804-05379-g031a6b0
Cannot find map file.
Loaded 45029 symbols from 72 modules.
[    0.000000] Linux version 2.6.31-rc5-next-20090804-05379-g031a6b0 (laurent@calimero) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #230 SMP PREEMPT Tue Aug 4 21:26:56 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003bef0000 (usable)
[    0.000000]  BIOS-e820: 000000003bef0000 - 000000003bef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003bef3000 - 000000003bf00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003c000000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f2000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3bef0 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFE0000000 write-back
[    0.000000]   1 base 0020000000 mask FFF0000000 write-back
[    0.000000]   2 base 0030000000 mask FFF8000000 write-back
[    0.000000]   3 base 0038000000 mask FFFC000000 write-back
[    0.000000]   4 base 003BF00000 mask FFFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] RAMDISK: 37bef000 - 37fef643
[    0.000000] Allocated new RAMDISK: 00a54000 - 00e54643
[    0.000000] Move RAMDISK from 0000000037bef000 - 0000000037fef642 to 00a54000 - 00e54642
[    0.000000] ACPI: RSDP 000f6340 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 3bef3000 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: FACP 3bef3040 00074 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: DSDT 3bef30c0 05272 (v01 GBT    NVDAACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 3bef1800 00040
[    0.000000] ACPI: SSDT 3bef8400 0028A (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 3bef86c0 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
[    0.000000] ACPI: MCFG 3bef8700 0003C (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: APIC 3bef8340 0008E (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 68MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00009000 - 0000ff40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 0000a4bd28]    TEXT DATA BSS ==> [0000200000 - 0000a4bd28]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
[    0.000000]   #5 [0000a4c000 - 0000a530f6]              BRK ==> [0000a4c000 - 0000a530f6]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000a54000 - 0000e54643]      NEW RAMDISK ==> [0000a54000 - 0000e54643]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f4970] f4970
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0003bef0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003bef0
[    0.000000] On node 0 totalpages: 245391
[    0.000000] free_area_init_node: node 0, pgdat c04e4200, node_mem_map c1000000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2841 pages used for memmap
[    0.000000]   Normal zone: 220901 pages, LIFO batch:31
[    0.000000]   HighMem zone: 225 pages used for memmap
[    0.000000]   HighMem zone: 17425 pages, LIFO batch:3
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:b0000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages at c1c3b000, static data 30532 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 242273
[    0.000000] Kernel command line: root=/dev/mapper/vglinux1-lv_ubuntu2 ro locale=fr_FR vga=795 resume=/dev/mapper/vglinux1-lvswap 
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000379fe:0003bef0)
[    0.000000] Memory: 955144k/981952k available (1917k kernel code, 26184k reserved, 1081k data, 340k init, 70600k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc04f2000 - 0xc0547000   ( 340 kB)
[    0.000000]       .data : 0xc03df52f - 0xc04ed970   (1081 kB)
[    0.000000]       .text : 0xc0200000 - 0xc03df52f   (1917 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] CPU 0 irqstacks, hard=c1c3b000 soft=c1c3c000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2600.389 MHz processor.
[    0.000036] spurious 8259A interrupt: IRQ7.
[    0.000644] Console: colour dummy device 80x25
[    0.001591] console [tty0] enabled
[    0.001597] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.001609] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.001616] ... MAX_LOCK_DEPTH:          48
[    0.001623] ... MAX_LOCKDEP_KEYS:        8191
[    0.001630] ... CLASSHASH_SIZE:          4096
[    0.001637] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.001644] ... MAX_LOCKDEP_CHAINS:      32768
[    0.001651] ... CHAINHASH_SIZE:          16384
[    0.001658]  memory used by lock dependency info: 3567 kB
[    0.001666]  per task-struct memory footprint: 1152 bytes
[    0.001734] kmemleak: Early log buffer exceeded
[    0.001743] kmemleak: Kernel memory leak detector disabled
[    0.002012] hpet clockevent registered
[    0.002022] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.002039] Calibrating delay loop (skipped), value calculated using timer frequency.. 5200.77 BogoMIPS (lpj=10401556)
[    0.002321] Mount-cache hash table entries: 512
[    0.003364] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003377] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003387] CPU: Physical Processor ID: 0
[    0.003394] CPU: Processor Node ID: 0
[    0.003402] CPU: Processor Core ID: 0
[    0.003411] mce: CPU supports 5 MCE banks
[    0.003428] using C1E aware idle routine
[    0.003450] Checking 'hlt' instruction... OK.
[    0.016653] ACPI: Core revision 20090625
[    0.030444] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.070151] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.072001] lockdep: fixing up alternatives.
[    0.072001] CPU 1 irqstacks, hard=c1c4b000 soft=c1c4c000
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5199.96 BogoMIPS (lpj=10399937)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Node ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 5 MCE banks
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.156535] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.156661] Brought up 2 CPUs
[    0.156668] Total of 2 processors activated (10400.74 BogoMIPS).
[    0.156859] devtmpfs: initialized
[    0.156933] khelper used greatest stack depth: 2908 bytes left
[    0.157013] Booting paravirtualized kernel on bare hardware
[    0.157013] NET: Registered protocol family 16
[    0.157013] khelper used greatest stack depth: 2676 bytes left
[    0.160123] ACPI: bus type pci registered
[    0.160181] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 31
[    0.160181] PCI: MCFG area at f0000000 reserved in E820
[    0.160181] PCI: Using MMCONFIG for extended config space
[    0.160181] PCI: Using configuration type 1 for base access
[    0.164292] bio: create slab <bio-0> at 0
[    0.170087] ACPI: EC: Look up EC in DSDT
[    0.185051] ACPI: Interpreter enabled
[    0.185065] ACPI: (supports S0 S3 S4 S5)
[    0.185143] ACPI: Using IOAPIC for interrupt routing
[    0.208454] ACPI: No dock devices found.
[    0.208611] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.208751] pci 0000:00:01.1: reg 10 io port: [0xc800-0xc83f]
[    0.208751] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
[    0.208751] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
[    0.208751] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.208751] pci 0000:00:01.1: PME# disabled
[    0.208751] pci 0000:00:02.0: reg 10 32bit mmio: [0xf700a000-0xf700afff]
[    0.208751] pci 0000:00:02.0: supports D1 D2
[    0.208751] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208751] pci 0000:00:02.0: PME# disabled
[    0.208751] pci 0000:00:02.1: reg 10 32bit mmio: [0xf700b000-0xf700b0ff]
[    0.208751] pci 0000:00:02.1: supports D1 D2
[    0.208751] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208751] pci 0000:00:02.1: PME# disabled
[    0.208751] pci 0000:00:04.0: reg 10 32bit mmio: [0xf700c000-0xf700cfff]
[    0.208751] pci 0000:00:04.0: supports D1 D2
[    0.208751] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208751] pci 0000:00:04.0: PME# disabled
[    0.208758] pci 0000:00:04.1: reg 10 32bit mmio: [0xf7009000-0xf70090ff]
[    0.208797] pci 0000:00:04.1: supports D1 D2
[    0.208799] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208811] pci 0000:00:04.1: PME# disabled
[    0.208867] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.208923] pci 0000:00:07.0: reg 10 32bit mmio: [0xf7000000-0xf7003fff]
[    0.208962] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.208973] pci 0000:00:07.0: PME# disabled
[    0.209081] pci 0000:00:09.0: reg 10 io port: [0x9f0-0x9f7]
[    0.209086] pci 0000:00:09.0: reg 14 io port: [0xbf0-0xbf3]
[    0.209090] pci 0000:00:09.0: reg 18 io port: [0x970-0x977]
[    0.209095] pci 0000:00:09.0: reg 1c io port: [0xb70-0xb73]
[    0.209101] pci 0000:00:09.0: reg 20 io port: [0xdc00-0xdc0f]
[    0.209106] pci 0000:00:09.0: reg 24 32bit mmio: [0xf7004000-0xf7005fff]
[    0.209175] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7006000-0xf7006fff]
[    0.209180] pci 0000:00:0a.0: reg 14 io port: [0xe000-0xe007]
[    0.209185] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7007000-0xf70070ff]
[    0.209190] pci 0000:00:0a.0: reg 1c 32bit mmio: [0xf7008000-0xf700800f]
[    0.209220] pci 0000:00:0a.0: supports D1 D2
[    0.209222] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209236] pci 0000:00:0a.0: PME# disabled
[    0.209281] pci 0000:00:12.0: reg 10 32bit mmio: [0xf2000000-0xf2ffffff]
[    0.209288] pci 0000:00:12.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
[    0.209295] pci 0000:00:12.0: reg 1c 64bit mmio: [0xf5000000-0xf5ffffff]
[    0.209302] pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.209511] pci 0000:01:07.0: reg 10 io port: [0xa000-0xa007]
[    0.209518] pci 0000:01:07.0: reg 14 io port: [0xa400-0xa403]
[    0.209524] pci 0000:01:07.0: reg 18 io port: [0xa800-0xa807]
[    0.209531] pci 0000:01:07.0: reg 1c io port: [0xac00-0xac03]
[    0.209537] pci 0000:01:07.0: reg 20 io port: [0xb000-0xb00f]
[    0.209544] pci 0000:01:07.0: reg 24 32bit mmio: [0xf4000000-0xf40000ff]
[    0.209551] pci 0000:01:07.0: reg 30 32bit mmio: [0x000000-0x07ffff]
[    0.209569] pci 0000:01:07.0: supports D1 D2
[    0.209605] pci 0000:00:08.0: transparent bridge
[    0.209615] pci 0000:00:08.0: bridge io port: [0xa000-0xbfff]
[    0.209619] pci 0000:00:08.0: bridge 32bit mmio: [0xf3000000-0xf4ffffff]
[    0.209627] pci_bus 0000:00: on NUMA node 0
[    0.209634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.210362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.288287] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.288455] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
[    0.288654] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.288856] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289075] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289277] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289478] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289681] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289883] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.290088] ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 *11 14 15)
[    0.290291] ACPI: PCI Interrupt Link [LUBA] (IRQs *5 7 9 10 11 14 15)
[    0.290494] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 *10 11 14 15)
[    0.290698] ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7 9 10 *11 14 15)
[    0.290900] ACPI: PCI Interrupt Link [LU2B] (IRQs *5 7 9 10 11 14 15)
[    0.291103] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
[    0.292082] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    0.292282] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.292488] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 *11 14 15)
[    0.292687] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.292894] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[    0.293213] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.293526] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.293832] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.294138] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.294444] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.294750] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    0.295057] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[    0.295363] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.295670] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
[    0.295985] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
[    0.296307] ACPI: PCI Interrupt Link [AUB2] (IRQs 20 21 22 23) *0
[    0.296614] ACPI: PCI Interrupt Link [AU1B] (IRQs 20 21 22 23) *0
[    0.296922] ACPI: PCI Interrupt Link [AU2B] (IRQs 20 21 22 23) *0
[    0.297230] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.297538] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.297848] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.298156] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.298465] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.298774] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.299082] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.299176] PCI: Using ACPI for IRQ routing
[    0.300164] INFO: trying to register non-static key.
[    0.300164] the code is fine but needs lockdep annotation.
[    0.300164] turning off the locking correctness validator.
[    0.300164] Pid: 1, comm: swapper Not tainted 2.6.31-rc5-next-20090804-05379-g031a6b0 #230
[    0.300164] Call Trace:
[    0.300164]  [<c03dc37e>] ? printk+0xf/0x11
[    0.300164]  [<c0243e4f>] register_lock_class+0x5a/0x2a7
[    0.300164]  [<c02381c6>] ? autoremove_wake_function+0xf/0x33
[    0.300164]  [<c024571f>] __lock_acquire+0x97/0xb9e
[    0.300164]  [<c027725b>] ? cache_alloc_refill+0x77/0x5fb
[    0.300164]  [<c03de41e>] ? _spin_unlock+0x38/0x44
[    0.300164]  [<c027742a>] ? cache_alloc_refill+0x246/0x5fb
[    0.300174]  [<c0244972>] ? mark_lock+0x1e/0x1ea
[    0.300184]  [<c02762d9>] ? cache_alloc_debugcheck_after+0x2f/0x183
[    0.300196]  [<c024627b>] lock_acquire+0x55/0x77
[    0.300207]  [<c038a567>] ? alloc_netdev_mq+0x100/0x1bd
[    0.300218]  [<c03de546>] _spin_lock_bh+0x2a/0x39
[    0.300228]  [<c038a567>] ? alloc_netdev_mq+0x100/0x1bd
[    0.300238]  [<c038a567>] alloc_netdev_mq+0x100/0x1bd
[    0.300250]  [<c0367862>] ? loopback_setup+0x0/0x74
[    0.300263]  [<c050ed1c>] loopback_net_init+0x20/0x5d
[    0.300273]  [<c0385223>] register_pernet_device+0x23/0x4b
[    0.300285]  [<c0512986>] net_dev_init+0xfe/0x14d
[    0.300295]  [<c0201137>] do_one_initcall+0x4a/0x11a
[    0.300305]  [<c0512888>] ? net_dev_init+0x0/0x14d
[    0.300317]  [<c025565d>] ? register_irq_proc+0x8c/0xa8
[    0.300328]  [<c02556cc>] ? init_irq_proc+0x53/0x60
[    0.300340]  [<c04f22ee>] kernel_init+0x11e/0x16f
[    0.300350]  [<c04f21d0>] ? kernel_init+0x0/0x16f
[    0.300361]  [<c0203d8b>] kernel_thread_helper+0x7/0x10
[    0.300466] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[    0.300466] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.304128] pnp: PnP ACPI init
[    0.304149] ACPI: bus type pnp registered
[    0.308014] Switched to NOHz mode on CPU #0
[    0.308667] Switched to NOHz mode on CPU #1
[    0.311933] pnp: PnP ACPI: found 14 devices
[    0.311944] ACPI: ACPI bus type pnp unregistered
[    0.311965] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.311975] system 00:01: ioport range 0x1080-0x10ff has been reserved
[    0.311986] system 00:01: ioport range 0x1400-0x147f has been reserved
[    0.311997] system 00:01: ioport range 0x1480-0x14ff has been reserved
[    0.312016] system 00:01: ioport range 0x1800-0x187f has been reserved
[    0.312027] system 00:01: ioport range 0x1880-0x18ff has been reserved
[    0.312038] system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
[    0.312050] system 00:01: iomem range 0xfefe1000-0xfefe10ff has been reserved
[    0.312062] system 00:01: iomem range 0x3c000000-0x3fffffff has been reserved
[    0.312078] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.312089] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.312099] system 00:02: ioport range 0x295-0x314 has been reserved
[    0.312110] system 00:02: ioport range 0x290-0x294 has been reserved
[    0.312128] system 00:0c: iomem range 0xf0000000-0xf1ffffff has been reserved
[    0.312149] system 00:0d: iomem range 0xd4600-0xd7fff has been reserved
[    0.312160] system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
[    0.312171] system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
[    0.312182] system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
[    0.312194] system 00:0d: iomem range 0x3bef0000-0x3befffff could not be reserved
[    0.312206] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.312218] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.312228] system 00:0d: iomem range 0x100000-0x3beeffff could not be reserved
[    0.312241] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.312253] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.347926] pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
[    0.347936] pci 0000:00:08.0:   IO window: 0xa000-0xbfff
[    0.347947] pci 0000:00:08.0:   MEM window: 0xf3000000-0xf4ffffff
[    0.347957] pci 0000:00:08.0:   PREFETCH window: 0x40000000-0x400fffff
[    0.347973] pci 0000:00:08.0: setting latency timer to 64
[    0.347983] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.347992] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.348020] pci_bus 0000:01: resource 0 io:  [0xa000-0xbfff]
[    0.348028] pci_bus 0000:01: resource 1 mem: [0xf3000000-0xf4ffffff]
[    0.348038] pci_bus 0000:01: resource 2 pref mem [0x40000000-0x400fffff]
[    0.348048] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.348056] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.348172] NET: Registered protocol family 2
[    0.348311] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.348856] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.349639] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.351594] TCP: Hash tables configured (established 131072 bind 65536)
[    0.351609] TCP reno registered
[    0.351817] NET: Registered protocol family 1
[    0.352221] Unpacking initramfs...
[    0.482035] Freeing initrd memory: 4097k freed
[    0.487867] highmem bounce pool size: 64 pages
[    0.488329] msgmni has been set to 1736
[    0.488629] alg: No test for stdrng (krng)
[    0.488659] io scheduler noop registered
[    0.488670] io scheduler anticipatory registered
[    0.488678] io scheduler deadline registered
[    0.488720] io scheduler cfq registered (default)
[    0.488883] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.488947] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.489018] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.489095] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.489110] pci 0000:00:12.0: Boot video device
[    0.490148] vesafb: framebuffer at 0xe0000000, mapped to 0xf8280000, using 10240k, total 65536k
[    0.490164] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
[    0.490174] vesafb: protected mode interface info at c000:cfb0
[    0.490185] vesafb: pmi: set display start = c00ccfe6, set palette = c00cd050
[    0.490196] vesafb: pmi: ports = b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03 
[    0.490236] vesafb: scrolling: redraw
[    0.490245] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.514011] Console: switching to colour frame buffer device 160x64
[    0.535817] fb0: VESA VGA frame buffer device
[    0.550968] Linux agpgart interface v0.103
[    0.551580] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.551750] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.552313] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.552750] mice: PS/2 mouse device common for all mice
[    0.553171] cpuidle: using governor ladder
[    0.553287] cpuidle: using governor menu
[    0.553816] TCP cubic registered
[    0.553922] Using IPI No-Shortcut mode
[    0.572710] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.573354] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    0.573956] Freeing unused kernel memory: 340k freed
[    0.574395] Write protecting the kernel text: 1920k
[    0.574583] Write protecting the kernel read-only data: 912k
[    0.637239] setfont used greatest stack depth: 2432 bytes left
[    0.693188] console_setup used greatest stack depth: 2384 bytes left
[    0.704520] device-mapper: uevent: version 1.0.3
[    0.704867] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    0.723943] SCSI subsystem initialized
[    0.737654] libata version 3.00 loaded.
[    0.739651] pata_amd 0000:00:06.0: version 0.4.1
[    0.739925] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.740267] scsi0 : pata_amd
[    0.740678] scsi1 : pata_amd
[    0.742151] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.742343] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    0.912467] ata1.00: HPA detected: current 78163247, native 78165360
[    0.912648] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
[    0.912792] ata1.00: 78163247 sectors, multi 16: LBA 
[    0.912953] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max UDMA/33
[    0.913156] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c00000) ACPI=0x3f01f (20:60:0x1f)
[    0.919907] ata1: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc6c00000) ACPI=0x701f (20:60:0x1f)
[    0.940412] ata1.00: configured for UDMA/100
[    0.960240] ata1.01: configured for UDMA/33
[    0.969425] scsi 0:0:0:0: Direct-Access     ATA      ST340016A        3.75 PQ: 0 ANSI: 5
[    0.980665] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4165B DL05 PQ: 0 ANSI: 5
[    0.988299] ata2: port disabled. ignoring.
[    0.995553] modprobe used greatest stack depth: 2340 bytes left
[    1.007199] pata_sil680 0000:01:07.0: version 0.4.9
[    1.014983] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    1.022349]   alloc irq_desc for 17 on node -1
[    1.026343]   alloc kstat_irqs on node -1
[    1.037025] pata_sil680 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    1.044619] sil680: 133MHz clock.
[    1.052363] scsi2 : pata_sil680
[    1.060229] scsi3 : pata_sil680
[    1.067856] ata3: PATA max UDMA/133 cmd 0xa000 ctl 0xa400 bmdma 0xb000 irq 17
[    1.075553] ata4: PATA max UDMA/133 cmd 0xa800 ctl 0xac00 bmdma 0xb008 irq 17
[    1.252513] ata3.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    1.260326] ata3.01: 160086528 sectors, multi 16: LBA 
[    1.284376] ata3.01: configured for UDMA/133
[    1.292235] scsi 2:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[    1.518814] ata4.01: ATA-7: MAXTOR STM3802110A, 3.AAJ, max UDMA/100
[    1.526635] ata4.01: 156301488 sectors, multi 16: LBA48 
[    1.593633] ata4.01: configured for UDMA/100
[    1.616146] scsi 3:0:1:0: Direct-Access     ATA      MAXTOR STM380211 3.AA PQ: 0 ANSI: 5
[    1.630282] sd 0:0:0:0: [sda] 78163247 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    1.638237] sd 0:0:0:0: [sda] Write Protect is off
[    1.645958] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.653730] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.661765]  sda:
[    1.662116] sd 2:0:1:0: [sdb] 160086528 512-byte logical blocks: (81.9 GB/76.3 GiB)
[    1.677800] sd 2:0:1:0: [sdb] Write Protect is off
[    1.685724]  sda1
[    1.685728] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.685761] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.708919]  sda2 sda3 <
[    1.709206]  sdb:
[    1.717202] sd 3:0:1:0: [sdc] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    1.723684]  sda5 sdb1 sdb2 <
[    1.732958] sd 3:0:1:0: [sdc] Write Protect is off
[    1.741311]  sdb5 sda6 sda7 >
[    1.756391] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    1.757228] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.758273]  sdb6 >
[    1.779494] sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.780135] sd 2:0:1:0: [sdb] Attached SCSI disk
[    1.795401]  sdc: sdc1 sdc2 < sdc5 >
[    1.831759] sd 3:0:1:0: [sdc] Attached SCSI disk
[    1.847094] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    1.873543] fuse init (API version 7.13)
[    1.906651] md: linear personality registered for level -1
[    1.920388] md: raid0 personality registered for level 0
[    1.932927] md: raid1 personality registered for level 1
[    1.952741] md: raid10 personality registered for level 10
[    2.111026] scsi_id used greatest stack depth: 2244 bytes left
[    2.248678] udevd used greatest stack depth: 2200 bytes left
[    2.383976] md: bind<sdc5>
[    2.401562] mdadm used greatest stack depth: 2172 bytes left
[    2.484824] md: bind<sdb6>
[    2.503721] raid1: raid set md127 active with 2 out of 2 mirrors
[    2.511331] md127: detected capacity change from 0 to 42952228864
[    2.519040] mdadm used greatest stack depth: 1992 bytes left
[    2.528863]  md127: unknown partition table
[   10.103577] EXT3-fs: INFO: recovery required on readonly filesystem.
[   10.110868] EXT3-fs: write access will be enabled during recovery.
[   10.413732] kjournald starting.  Commit interval 5 seconds
[   10.413753] EXT3-fs: recovery complete.
[   10.414372] EXT3-fs: mounted filesystem with writeback data mode.
[   22.070300] udev: starting version 141
[   22.286745] input: PC Speaker as /devices/platform/pcspkr/input/input1
[   22.387157] processor LNXCPU:00: registered as cooling_device0
[   22.393760] processor LNXCPU:01: registered as cooling_device1
[   22.418946] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   22.425936] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[   22.432167]   alloc irq_desc for 23 on node -1
[   22.436661]   alloc kstat_irqs on node -1
[   22.444420] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[   22.450626] forcedeth 0000:00:0a.0: setting latency timer to 64
[   22.500229] rtc_cmos 00:05: RTC can wake from S4
[   22.506936] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   22.513102] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[   22.607222] Floppy drive(s): fd0 is 1.44M
[   22.633443] FDC 0 is a post-1991 82077
[   22.875160] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   22.881704] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[   22.888292] sd 2:0:1:0: Attached scsi generic sg2 type 0
[   22.894752] sd 3:0:1:0: Attached scsi generic sg3 type 0
[   22.904006] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   22.910345] ACPI: Power Button [PWRF]
[   22.916802] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   22.923438] ACPI: Power Button [PWRB]
[   22.978494] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1f:d0:53:49:ae
[   22.985049] forcedeth 0000:00:0a.0: highdma pwrctl mgmt gbit lnktim msi desc-v3
[   22.991592] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   23.114959] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   23.121785] Uniform CD-ROM driver Revision: 3.20
[   23.132029] ahci 0000:00:09.0: version 3.0
[   23.139751] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
[   23.149197] sr 0:0:1:0: Attached scsi CD-ROM sr0
[   23.156561]   alloc irq_desc for 22 on node -1
[   23.159952]   alloc kstat_irqs on node -1
[   23.170520] ahci 0000:00:09.0: PCI INT A -> Link[APSI] -> GSI 22 (level, low) -> IRQ 22
[   23.177762]   alloc irq_desc for 24 on node -1
[   23.181448]   alloc kstat_irqs on node -1
[   23.191649] ahci 0000:00:09.0: irq 24 for MSI/MSI-X
[   23.199003] ahci 0000:00:09.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   23.207849] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio 
[   23.214602] ahci 0000:00:09.0: setting latency timer to 64
[   23.222319] scsi4 : ahci
[   23.229521] scsi5 : ahci
[   23.236202] md: bind<sdc1>
[   23.245104] scsi6 : ahci
[   23.252173] scsi7 : ahci
[   23.259237] ata5: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004100 irq 24
[   23.267419] ata6: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004180 irq 24
[   23.274202] ata7: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004200 irq 24
[   23.280622] ata8: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004280 irq 24
[   23.458862] usbcore: registered new interface driver usbfs
[   23.465633] usbcore: registered new interface driver hub
[   23.472651] usbcore: registered new device driver usb
[   23.489646] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   23.496543] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.503692] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[   23.512922] parport_pc 00:0a: reported by Plug and Play ACPI
[   23.520078] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   23.567019] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.574727] ACPI: PCI Interrupt Link [AUB2] enabled at IRQ 21
[   23.582583]   alloc irq_desc for 21 on node -1
[   23.585956]   alloc kstat_irqs on node -1
[   23.597410] ehci_hcd 0000:00:02.1: PCI INT B -> Link[AUB2] -> GSI 21 (level, low) -> IRQ 21
[   23.600531]   alloc irq_desc for 25 on node -1
[   23.600535]   alloc kstat_irqs on node -1
[   23.600547] forcedeth 0000:00:0a.0: irq 25 for MSI/MSI-X
[   23.600761] eth0: no link during initialization.
[   23.634631] ata6: SATA link down (SStatus 0 SControl 300)
[   23.637499] ata5: SATA link down (SStatus 0 SControl 300)
[   23.637561] ata8: SATA link down (SStatus 0 SControl 300)
[   23.657240] ata7: SATA link down (SStatus 0 SControl 300)
[   23.663171] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   23.663175] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   23.663317] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   23.663369] ehci_hcd 0000:00:02.1: debug port 1
[   23.663374] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[   23.663404] ehci_hcd 0000:00:02.1: irq 21, io mem 0xf700b000
[   23.709490] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[   23.716643] usb usb1: configuration #1 chosen from 1 choice
[   23.725731] hub 1-0:1.0: USB hub found
[   23.732705] hub 1-0:1.0: 5 ports detected
[   23.740892] ACPI: PCI Interrupt Link [AU2B] disabled and referenced, BIOS bug
[   23.748080] ACPI: PCI Interrupt Link [AU2B] enabled at IRQ 20
[   23.755131]   alloc irq_desc for 20 on node -1
[   23.759042]   alloc kstat_irqs on node -1
[   23.769678] ehci_hcd 0000:00:04.1: PCI INT B -> Link[AU2B] -> GSI 20 (level, low) -> IRQ 20
[   23.783681] ehci_hcd 0000:00:04.1: setting latency timer to 64
[   23.794217] ehci_hcd 0000:00:04.1: EHCI Host Controller
[   23.803193] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
[   23.810073] ehci_hcd 0000:00:04.1: debug port 1
[   23.814869] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.828946] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
[   23.835527] ehci_hcd 0000:00:04.1: irq 20, io mem 0xf7009000
[   23.853530] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[   23.860425] usb usb2: configuration #1 chosen from 1 choice
[   23.867375] hub 2-0:1.0: USB hub found
[   23.875237] hub 2-0:1.0: 5 ports detected
[   23.990763] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.997691] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 23
[   24.004665] ohci_hcd 0000:00:02.0: PCI INT A -> Link[AUBA] -> GSI 23 (level, low) -> IRQ 23
[   24.011374] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   24.017884] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   24.024262] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
[   24.030755] ohci_hcd 0000:00:02.0: irq 23, io mem 0xf700a000
[   24.095708] usb usb3: configuration #1 chosen from 1 choice
[   24.102277] hub 3-0:1.0: USB hub found
[   24.108723] hub 3-0:1.0: 5 ports detected
[   24.116780] ACPI: PCI Interrupt Link [AU1B] enabled at IRQ 22
[   24.123420] ohci_hcd 0000:00:04.0: PCI INT A -> Link[AU1B] -> GSI 22 (level, low) -> IRQ 22
[   24.130658] ohci_hcd 0000:00:04.0: setting latency timer to 64
[   24.137580] ohci_hcd 0000:00:04.0: OHCI Host Controller
[   24.144415] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
[   24.152524] ohci_hcd 0000:00:04.0: irq 22, io mem 0xf700c000
[   24.215782] usb usb4: configuration #1 chosen from 1 choice
[   24.222936] hub 4-0:1.0: USB hub found
[   24.229870] hub 4-0:1.0: 5 ports detected
[   24.237523] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
[   24.244804] HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 21 (level, low) -> IRQ 21
[   24.252050] HDA Intel 0000:00:07.0: setting latency timer to 64
[   24.253525] usb 2-2: new high speed USB device using ehci_hcd and address 3
[   24.266198] NET: Registered protocol family 10
[   24.274937] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.383492] usb 2-2: configuration #1 chosen from 1 choice
[   24.390781] hub 2-2:1.0: USB hub found
[   24.398880] hub 2-2:1.0: 4 ports detected
[   24.453646] eth0: link up.
[   24.460585] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.600777] md: bind<sda1>
[   24.609555] usb 4-1: new low speed USB device using ohci_hcd and address 2
[   24.675892] raid1: raid set md0 active with 2 out of 2 mirrors
[   24.682908] md0: detected capacity change from 0 to 98656256
[   24.691941]  md0:
[   24.817710] usb 4-1: configuration #1 chosen from 1 choice
[   24.898353] usb 2-2.4: new full speed USB device using ehci_hcd and address 4
[   24.966939] input: PS/2+USB Mouse as /devices/pci0000:00/0000:00:04.0/usb4/4-1/4-1:1.0/input/input4
[   24.974546] generic-usb 0003:04F3:0210.0001: input: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:04.0-1/input0
[   24.982653] usbcore: registered new interface driver usbhid
[   24.990438] usbhid: v2.6:USB HID core driver
[   25.019019] usb 2-2.4: configuration #1 chosen from 1 choice
[   25.079335] usbcore: registered new interface driver usbserial
[   25.088201] usbserial: USB Serial Driver core
[   25.128518] USB Serial support registered for pl2303
[   25.136269] pl2303 2-2.4:1.0: pl2303 converter detected
[   25.145744] usb 2-2.4: pl2303 converter now attached to ttyUSB0
[   25.153611] usbcore: registered new interface driver pl2303
[   25.161460] pl2303: Prolific PL2303 USB to serial adaptor driver
[   25.388823] it87: Found IT8716F chip at 0x290, revision 3
[   26.259741] EXT3 FS on dm-5, internal journal
[   27.023476] kjournald starting.  Commit interval 5 seconds
[   27.038390] EXT3 FS on md0, internal journal
[   27.038397] EXT3-fs: mounted filesystem with writeback data mode.
[   27.149622] REISERFS (device dm-0): found reiserfs format "3.6" with standard journal
[   27.149702] REISERFS (device dm-0): using ordered data mode
[   27.158849] REISERFS (device dm-0): journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   27.159486] REISERFS (device dm-0): checking transaction log (dm-0)
[   27.509151] REISERFS (device dm-0): replayed 5 transactions in 1 seconds
[   27.555068] REISERFS (device dm-0): Using r5 hash to sort names
[   27.621851] reiser4: dm-4: found disk format 4.0.0.
[   28.207830] reiser4: dm-3: found disk format 4.0.0.
[   28.646877] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   28.646994] kjournald starting.  Commit interval 5 seconds
[   28.686721] EXT3 FS on dm-10, internal journal
[   28.686724] EXT3-fs: recovery complete.
[   28.686728] EXT3-fs: mounted filesystem with writeback data mode.
[   28.893578] REISERFS (device sda6): found reiserfs format "3.6" with standard journal
[   28.893652] REISERFS (device sda6): using ordered data mode
[   28.901904] REISERFS (device sda6): journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   28.902506] REISERFS (device sda6): checking transaction log (sda6)
[   28.912833] REISERFS (device sda6): replayed 1 transactions in 0 seconds
[   28.939669] REISERFS (device sda6): Using r5 hash to sort names
[   29.168471] umount used greatest stack depth: 1988 bytes left
[   29.305951] Unable to find swap-space signature
[   29.813402] ttyS1: LSR safety check engaged!
[   29.814456] ttyS1: LSR safety check engaged!
[   31.779652] pktcdvd: writer pktcdvd0 mapped to sr0
[   33.136499] ttyS1: LSR safety check engaged!
[   33.809780] lp0: using parport0 (interrupt-driven).
[   34.478157] eth0: no IPv6 routers present
[   45.264035] git used greatest stack depth: 1660 bytes left
[   85.272874] less used greatest stack depth: 1504 bytes left
[  110.821183] SysRq : Show Blocked State
[  110.825169]   task                PC stack   pid father
[  110.825169] sync_supers   D f7477230  2720    77      2 0x00000000
[  110.825169]  f74beeec 00000046 00000100 f7477230 004631a2 00000100 00001240 c0546200
[  110.825169]  c0546200 c0543284 f74beed0 f75372b0 f7537444 c1c52200 00000001 00000000
[  110.825169]  f74beedc 00000246 00000000 00000002 f7537444 ffff442e f9f900fa 00000000
[  110.825169] Call Trace:
[  110.825169]  [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
[  110.825169]  [<c0265518>] ? bdi_sync_supers+0x0/0x3a
[  110.825169]  [<c03dd74a>] mutex_lock_nested+0x2b/0x33
[  110.825169]  [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<f9f900fa>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<f9f7f6f8>] reiserfs_sync_fs+0x12/0x51 [reiserfs]
[  110.825169]  [<c027e24a>] ? sync_supers+0x40/0x8e
[  110.825169]  [<c03dd9a2>] ? down_read+0x2c/0x40
[  110.825169]  [<f9f7f744>] reiserfs_write_super+0xd/0xf [reiserfs]
[  110.825169]  [<c027e25e>] sync_supers+0x54/0x8e
[  110.825169]  [<c0265544>] bdi_sync_supers+0x2c/0x3a
[  110.825169]  [<c0237f65>] kthread+0x69/0x6e
[  110.825169]  [<c0237efc>] ? kthread+0x0/0x6e
[  110.825169]  [<c0203d8b>] kernel_thread_helper+0x7/0x10
[  110.825169] gconfd-2      D f7477230  1416  4749      1 0x00000000
[  110.825169]  f759ea84 00000046 c1c52200 f7477230 c0244e0a f759ea30 c03de2a8 c0546200
[  110.825169]  c0546200 c0543284 f82335bb f75b5470 f75b5604 c1c52200 00000001 00000000
[  110.825169]  f759ea74 00000246 00000000 00000002 f75b5604 ffff3ebb f9f900fa 00000000
[  110.825169] Call Trace:
[  110.825169]  [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
[  110.825169]  [<c03de2a8>] ? _read_unlock_irqrestore+0x5f/0x6c
[  110.825169]  [<f82335bb>] ? dm_get_table+0x2e/0x35 [dm_mod]
[  110.825169]  [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
[  110.825169]  [<c03dd74a>] mutex_lock_nested+0x2b/0x33
[  110.825169]  [<f9f900fa>] ? reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<f9f900fa>] reiserfs_write_lock+0x1f/0x2e [reiserfs]
[  110.825169]  [<f9f85bc4>] search_by_key+0x19e/0x738 [reiserfs]
[  110.825169]  [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
[  110.825169]  [<c03dd198>] ? __mutex_unlock_slowpath+0x112/0x121
[  110.825169]  [<c03dd1af>] ? mutex_unlock+0x8/0xa
[  110.825169]  [<f9f8b5f8>] ? do_journal_end+0xa5a/0xc34 [reiserfs]
[  110.825169]  [<f9f74ee2>] search_by_entry_key+0x17/0x198 [reiserfs]
[  110.825169]  [<f9f750c1>] reiserfs_find_entry+0x5e/0x21c [reiserfs]
[  110.825169]  [<c03dd1af>] ? mutex_unlock+0x8/0xa
[  110.825169]  [<f9f9015e>] ? reiserfs_write_unlock+0x55/0x5a [reiserfs]
[  110.825169]  [<f9f756f6>] reiserfs_lookup+0x6f/0xf7 [reiserfs]
[  110.825169]  [<c02833ef>] __lookup_hash+0xa4/0xbe
[  110.825169]  [<c0284e88>] lookup_one_len+0x8e/0x9d
[  110.825169]  [<f9f8f1e1>] open_xa_dir+0x111/0x18a [reiserfs]
[  110.825169]  [<c0244e0a>] ? trace_hardirqs_on+0xb/0xd
[  110.825169]  [<f9f8f88f>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
[  110.825169]  [<f9f8ffe8>] ? delete_one_xattr+0x0/0x94 [reiserfs]
[  110.825169]  [<f9f8fa6a>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
[  110.825169]  [<f9f7b3e2>] reiserfs_delete_inode+0x41/0xb7 [reiserfs]
[  110.825169]  [<f9f7b3a1>] ? reiserfs_delete_inode+0x0/0xb7 [reiserfs]
[  110.825169]  [<c028bff6>] generic_delete_inode+0x79/0xf1
[  110.825169]  [<c028c080>] generic_drop_inode+0x12/0x18d
[  110.825169]  [<c028b3b7>] iput+0x4b/0x4e
[  110.825169]  [<c0289052>] dentry_iput+0x9c/0xb7
[  110.825169]  [<c028910e>] d_kill+0x2d/0x47
[  110.825169]  [<c0289814>] dput+0x110/0x119
[  110.825169]  [<c0285831>] sys_renameat+0x176/0x1d3
[  110.825169]  [<c0289747>] ? dput+0x43/0x119
[  110.825169]  [<c028e6d6>] ? mntput_no_expire+0x19/0xad
[  110.825169]  [<c02858a0>] sys_rename+0x12/0x14
[  110.825169]  [<c0203228>] sysenter_do_call+0x12/0x3c
[  110.825169] gnome-panel   D f0a34170  1996  4939   4534 0x00000000
[  110.825169]  f0ae6d74 00000046 c1c52200 f0a34170 00000005 000000c1 f0ae6d4c c0546200
[  110.825169]  c0546200 f4e2acb0 c0288adf f4e2acb0 f4e2ae44 c1c52200 00000001 f0ae6e6c
[  110.825169]  f0ae6d64 00000246 00000000 00000002 f4e2ae44 00000000 f9f900bf 00000000
[  110.825169] Call Trace:
[  110.825169]  [<c0288adf>] ? pollwake+0x59/0x62
[  110.825169]  [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  110.825169]  [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
[  110.825169]  [<c03dd74a>] mutex_lock_nested+0x2b/0x33
[  110.825169]  [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  110.825169]  [<f9f900bf>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  110.825169]  [<f9f756ce>] reiserfs_lookup+0x47/0xf7 [reiserfs]
[  110.825169]  [<c02832db>] do_lookup+0xb4/0x124
[  111.350948]  [<c0283aa0>] __link_path_walk+0x33b/0x6ce
[  111.350948]  [<c0283ff4>] path_walk+0x50/0xa5
[  111.350948]  [<c02843ce>] do_path_lookup+0x21/0x42
[  111.350948]  [<c0285e39>] user_path_at+0x3c/0x67
[  111.350948]  [<c02771ac>] ? kmem_cache_alloc+0x11d/0x155
[  111.350948]  [<c023c21e>] ? prepare_creds+0x2b/0x72
[  111.350948]  [<c027be5f>] sys_faccessat+0x90/0x14a
[  111.350948]  [<c027bf29>] sys_access+0x10/0x12
[  111.350948]  [<c0203228>] sysenter_do_call+0x12/0x3c
[  111.350948] trackerd      D f7477230  1756  4949   4534 0x00000000
[  111.350948]  f0a36da8 00000046 f0a36d40 f7477230 f0a36d7c c03dd66d 00000202 c0546200
[  111.350948]  c0546200 c0543284 f0a36de0 f0ac2a70 f0ac2c04 c1c52200 00000001 00000000
[  111.350948]  f0a36d98 00000246 00000000 00000002 f0ac2c04 ffff3ebb f9f8f1cf 00000000
[  111.350948] Call Trace:
[  111.350948]  [<c03dd66d>] ? __mutex_lock_common+0x37c/0x3ca
[  111.350948]  [<f9f8f1cf>] ? open_xa_dir+0xff/0x18a [reiserfs]
[  111.350948]  [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
[  111.350948]  [<c03dd74a>] mutex_lock_nested+0x2b/0x33
[  111.350948]  [<f9f8f1cf>] ? open_xa_dir+0xff/0x18a [reiserfs]
[  111.350948]  [<f9f8f1cf>] open_xa_dir+0xff/0x18a [reiserfs]
[  111.350948]  [<f9f8f88f>] reiserfs_for_each_xattr+0x57/0x1df [reiserfs]
[  111.350948]  [<f9f8ffe8>] ? delete_one_xattr+0x0/0x94 [reiserfs]
[  111.350948]  [<f9f8fa6a>] reiserfs_delete_xattrs+0x13/0x40 [reiserfs]
[  111.350948]  [<f9f7b3e2>] reiserfs_delete_inode+0x41/0xb7 [reiserfs]
[  111.350948]  [<f9f7b3a1>] ? reiserfs_delete_inode+0x0/0xb7 [reiserfs]
[  111.350948]  [<c028bff6>] generic_delete_inode+0x79/0xf1
[  111.350948]  [<c028c080>] generic_drop_inode+0x12/0x18d
[  111.350948]  [<c028b3b7>] iput+0x4b/0x4e
[  111.350948]  [<c0285965>] do_unlinkat+0xc3/0x107
[  111.350948]  [<c027da44>] ? fput+0x19/0x1b
[  111.350948]  [<c027b3d0>] ? filp_close+0x51/0x5b
[  111.350948]  [<c02859b9>] sys_unlink+0x10/0x12
[  111.350948]  [<c0203228>] sysenter_do_call+0x12/0x3c
[  111.350948] gvfsd-trash   D c04c4160  2088  4971      1 0x00000000
[  111.350948]  f0ba2d28 00000046 ffffffff c04c4160 ed67f708 f0ba2dcb f0ba2cf0 c0546200
[  111.350948]  c0546200 c0543284 00000000 f64512f0 f6451484 c1c42200 00000000 00000000
[  111.350948]  f0ba2d18 00000246 00000000 00000002 f6451484 ffff3ea3 f9f900bf 00000000
[  111.350948] Call Trace:
[  111.350948]  [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  111.350948]  [<c03dd52a>] __mutex_lock_common+0x239/0x3ca
[  111.350948]  [<c03dd74a>] mutex_lock_nested+0x2b/0x33
[  111.350948]  [<f9f900bf>] ? reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  111.350948]  [<f9f900bf>] reiserfs_write_lock_once+0x1f/0x3b [reiserfs]
[  111.350948]  [<f9f756ce>] reiserfs_lookup+0x47/0xf7 [reiserfs]
[  111.350948]  [<c02832db>] do_lookup+0xb4/0x124
[  111.350948]  [<c0283d0a>] __link_path_walk+0x5a5/0x6ce
[  111.350948]  [<c0283ff4>] path_walk+0x50/0xa5
[  111.350948]  [<c02843ce>] do_path_lookup+0x21/0x42
[  111.350948]  [<c0285e39>] user_path_at+0x3c/0x67
[  111.350948]  [<c029e5ec>] ? __fsnotify_update_child_dentry_flags+0x76/0xcf
[  111.350948]  [<c027f78e>] vfs_fstatat+0x2d/0x54
[  111.350948]  [<c027f7f9>] vfs_lstat+0x16/0x18
[  111.350948]  [<c027f80f>] sys_lstat64+0x14/0x28
[  111.350948]  [<c02a0d3f>] ? sys_inotify_add_watch+0x270/0x2c4
[  111.350948]  [<c02f9558>] ? trace_hardirqs_on_thunk+0xc/0x10
[  111.350948]  [<c0203228>] sysenter_do_call+0x12/0x3c
[  111.707398] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[  174.847555] pktcdvd: writer pktcdvd0 unmapped

--------------010602020608020507010208--
