Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYAFJm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYAFJm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYAFJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:42:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:53476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753131AbYAFJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:42:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jF5AITa3j/5pL46pkl3cIbVOhWwjB9FFdJ3ih+M
	HZPglYQ43WOxEr
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1199447212.4529.13.camel@homer.simson.net>
References: <1199447212.4529.13.camel@homer.simson.net>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 10:42:13 +0100
Message-Id: <1199612533.4384.54.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW, here's box having same seizure writing to /dev/pktcdvd/sr0.

[  959.419364] SysRq : Show Blocked State
[  959.419364]   task                PC stack   pid father
[  959.419364] kswapd0       D 00000000     0   158      2
[  959.419364]        ef90bec0 00000046 00000000 00000000 00000000 00000020 00000001 00000000 
[  959.419364]        8d4fb4b9 000000b3 b040d300 b040d300 ef8ab5f0 ef8ab83c b1815300 ef90b000 
[  959.419364]        b016b41a 00000020 df606740 ef90bf10 00168208 00000000 b040a8e0 b040a8e0 
[  959.419364] Call Trace:
[  959.419364]  [<b016b41a>] __pagevec_release+0x15/0x1d
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<f086c45c>] mb_cache_shrink_fn+0xde/0xe0 [mbcache]
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016d6e2>] kswapd+0x314/0x49f
[  959.419364]  [<b013e1a8>] autoremove_wake_function+0x0/0x35
[  959.419364]  [<b016d3ce>] kswapd+0x0/0x49f
[  959.419364]  [<b013df26>] kthread+0x34/0x56
[  959.419364]  [<b013def2>] kthread+0x0/0x56
[  959.419364]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[  959.419364]  =======================
[  959.419364] Xorg          D eeeacd38     0  2366   2343
[  959.419364]        eeeacd4c 00203082 00000002 eeeacd38 eeeacd30 00000000 00000001 00000000 
[  959.419364]        00000000 ffffffff b040d300 b040d300 ee1fa8f0 ee1fab3c b1815300 eeeac000 
[  959.419364]        b016b41a 00000020 df997740 00289a1f 00000000 00000000 00000000 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b016b41a>] __pagevec_release+0x15/0x1d
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b017dc5c>] shmem_getpage+0x144/0x691
[  959.419364]  [<b017e283>] shmem_fault+0x68/0x97
[  959.419364]  [<b01cbe4c>] shm_fault+0xc/0xd
[  959.419364]  [<b016feda>] __do_fault+0x55/0x376
[  959.419364]  [<b0126f30>] scheduler_tick+0x12f/0x3de
[  959.419364]  [<b01cbe40>] shm_fault+0x0/0xd
[  959.419364]  [<b0171583>] handle_mm_fault+0x11d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  =======================
[  959.419364] top           D b0104bf8     0  4190   3771
[  959.419364]        eef49e38 00200086 b03af280 b0104bf8 ffffffe0 ffffffed 00000000 b03af280 
[  959.419364]        c23aaad8 000000d5 b040d300 b040d300 e83aeaf0 e83aed3c b180c300 eef49000 
[  959.419364]        00000000 00000020 ee23fac0 eef49e88 002da5f3 00000000 b040a8e0 b040a8e0 
[  959.419364] Call Trace:
[  959.419364]  [<b0104bf8>] apic_timer_interrupt+0x28/0x30
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0182217>] nameidata_to_filp+0x31/0x3a
[  959.419364]  [<b0168ae3>] __get_free_pages+0x39/0x47
[  959.419364]  [<b01b6ea8>] proc_info_read+0x39/0xa9
[  959.419364]  [<b01b6e6f>] proc_info_read+0x0/0xa9
[  959.419364]  [<b0184076>] vfs_read+0xa1/0x147
[  959.419364]  [<b01844ec>] sys_read+0x41/0x6a
[  959.419364]  [<b010412a>] sysenter_past_esp+0x5f/0x85
[  959.419364]  =======================
[  959.419364] cp            D c0826cd4     0  4434   3846
[  959.419364]        c0826ce8 00200082 00000002 c0826cd4 c0826ccc 00000000 00000000 00000000 
[  959.419364]        00000000 ffffffff b040d300 b040d300 e83ae430 e83ae67c b180c300 c0826000 
[  959.419364]        b1512dc0 b03af280 df606740 00286237 00000000 00000000 00000000 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b019330b>] prune_dcache+0xf5/0x189
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b016a891>] __do_page_cache_readahead+0x115/0x22e
[  959.419364]  [<b0163b56>] do_generic_mapping_read+0x160/0x45b
[  959.419364]  [<b016326a>] file_read_actor+0x0/0xd9
[  959.419364]  [<b0165636>] generic_file_aio_read+0x101/0x198
[  959.419364]  [<b016326a>] file_read_actor+0x0/0xd9
[  959.419364]  [<b01837fd>] do_sync_read+0xd2/0x10e
[  959.419364]  [<b013e1a8>] autoremove_wake_function+0x0/0x35
[  959.419364]  [<b0146a97>] tick_program_event+0x38/0x58
[  959.419364]  [<b018372b>] do_sync_read+0x0/0x10e
[  959.419364]  [<b0184076>] vfs_read+0xa1/0x147
[  959.419364]  [<b01844ec>] sys_read+0x41/0x6a
[  959.419364]  [<b010412a>] sysenter_past_esp+0x5f/0x85
[  959.419364]  =======================
[  959.419364] as            D b154cb40     0 20046  20044
[  959.419364]        ef198e04 00200086 01312d00 b154cb40 b03af280 b016bfdc 00000001 b03af280 
[  959.419364]        a0dde696 000000b2 b040d300 b040d300 df53c070 df53c2bc b1815300 ef198000 
[  959.419364]        00000000 00000020 c90c0200 ef198e54 00000000 00000000 b040a8e0 b040a8e0 
[  959.419364] Call Trace:
[  959.419364]  [<b016bfdc>] isolate_lru_pages+0x5f/0x1bb
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b019330b>] prune_dcache+0xf5/0x189
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================
[  959.419364] pdflush       D 00008784     0 20121      2
[  959.419364]        ea130d9c 00000046 beaa8a90 00008784 00000004 00000000 00000000 0fd00000 
[  959.419364]        618d6a4e 000000df b040d300 b040d300 d6d2b5f0 d6d2b83c b180c300 ea130000 
[  959.419364]        00000000 00000008 ef182200 beaa8a90 00000001 00000000 df610de0 002a5bec 
[  959.419364] Call Trace:
[  959.419364]  [<b02e3b7f>] io_schedule+0x4f/0x89
[  959.419364]  [<b01a287d>] sync_buffer+0x30/0x34
[  959.419364]  [<b02e3d8f>] __wait_on_bit+0x42/0x5e
[  959.419364]  [<b01a284d>] sync_buffer+0x0/0x34
[  959.419364]  [<b02e3e12>] out_of_line_wait_on_bit+0x67/0x6f
[  959.419364]  [<b01a284d>] sync_buffer+0x0/0x34
[  959.419364]  [<b013e1dd>] wake_bit_function+0x0/0x3c
[  959.419364]  [<b01a2814>] __wait_on_buffer+0x24/0x29
[  959.419364]  [<b01a4225>] __bread+0x55/0x8a
[  959.419364]  [<f0e9ce53>] udf_tread+0x3c/0x41 [udf]
[  959.419364]  [<f0e92add>] udf_update_inode+0x43/0xb8d [udf]
[  959.419364]  [<b016ad8d>] pagevec_lookup_tag+0x24/0x2c
[  959.419364]  [<b016917c>] __writepage+0x0/0x25
[  959.419364]  [<f0e94ca4>] udf_write_inode+0x14/0x20 [udf]
[  959.419364]  [<b019dd1c>] __writeback_single_inode+0x228/0x306
[  959.419364]  [<b0161845>] delayacct_end+0x71/0x79
[  959.419364]  [<b01e6005>] _atomic_dec_and_lock+0x31/0x5c
[  959.419364]  [<b019e1a2>] sync_sb_inodes+0x1c3/0x294
[  959.419364]  [<b019e450>] writeback_inodes+0x7d/0xac
[  959.419364]  [<b016a14d>] wb_kupdate+0x7e/0xe2
[  959.419364]  [<b016a56c>] pdflush+0x0/0x1d4
[  959.419364]  [<b016a673>] pdflush+0x107/0x1d4
[  959.419364]  [<b016a0cf>] wb_kupdate+0x0/0xe2
[  959.419364]  [<b013df26>] kthread+0x34/0x56
[  959.419364]  [<b013def2>] kthread+0x0/0x56
[  959.419364]  [<b0104d7b>] kernel_thread_helper+0x7/0x1c
[  959.419364]  =======================
[  959.419364] cc1           D b1808f00     0 20150  20149
[  959.419364]        efbf2e04 00200082 00000555 b1808f00 00000002 efbf2dec 00000000 0000000c 
[  959.419364]        16e6490f 000000d5 b040d300 b040d300 c97ab130 c97ab37c b180c300 efbf2000 
[  959.419364]        00000000 00000020 e6dccc80 0024beb7 00000000 00000000 00000001 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  =======================
[  959.419364] cc1           D def92b70     0 20181  20180
[  959.419364]        ef1fdc18 00200082 ef4f9dfc def92b70 00000004 00000000 00000001 0fd00000 
[  959.419364]        8ae5a1e1 000000b2 b040d300 b040d300 cc65eb70 cc65edbc b1815300 ef1fd000 
[  959.419364]        00000000 b1812a60 edfe4e40 b016b3a8 00000000 00000000 ee1e34f0 00277786 
[  959.419364] Call Trace:
[  959.419364]  [<b016b3a8>] mark_page_accessed+0x29/0x30
[  959.419364]  [<b02e3b7f>] io_schedule+0x4f/0x89
[  959.419364]  [<b01a287d>] sync_buffer+0x30/0x34
[  959.419364]  [<b02e3d8f>] __wait_on_bit+0x42/0x5e
[  959.419364]  [<b01a284d>] sync_buffer+0x0/0x34
[  959.419364]  [<b02e3e12>] out_of_line_wait_on_bit+0x67/0x6f
[  959.419364]  [<b01a284d>] sync_buffer+0x0/0x34
[  959.419364]  [<b013e1dd>] wake_bit_function+0x0/0x3c
[  959.419364]  [<b01a2814>] __wait_on_buffer+0x24/0x29
[  959.419364]  [<b01a37da>] sync_dirty_buffer+0x7e/0xc4
[  959.419364]  [<f0e93400>] udf_update_inode+0x966/0xb8d [udf]
[  959.419364]  [<f0e9bafc>] extent_trunc+0xac/0x16e [udf]
[  959.419364]  [<f0e94ca4>] udf_write_inode+0x14/0x20 [udf]
[  959.419364]  [<b019dd1c>] __writeback_single_inode+0x228/0x306
[  959.419364]  [<b019de8a>] write_inode_now+0x66/0xb3
[  959.419364]  [<f0e951f3>] udf_clear_inode+0x33/0x47 [udf]
[  959.419364]  [<b01957ea>] clear_inode+0x62/0x136
[  959.419364]  [<b0195dd4>] dispose_list+0x1a/0xd6
[  959.419364]  [<b019600a>] shrink_icache_memory+0x17a/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================
[  959.419364] cc1           D df737df0     0 20224  20222
[  959.419364]        df737e04 00200082 00000002 df737df0 df737de8 00000000 00000001 00000002 
[  959.419364]        df737e4c 00000020 b040d300 b040d300 df63ef30 df63f17c b1815300 df737000 
[  959.419364]        b016b41a 00000020 ee18f580 0024cb24 00000000 00000000 00000000 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b016b41a>] __pagevec_release+0x15/0x1d
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b019330b>] prune_dcache+0xf5/0x189
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================
[  959.419364] cc1           D cb5ccdf0     0 20242  20241
[  959.419364]        cb5cce04 00200086 00000002 cb5ccdf0 cb5ccde8 00000000 00000000 b1808120 
[  959.419364]        00000000 00000000 b040d300 b040d300 e6fb9870 e6fb9abc b180c300 cb5cc000 
[  959.419364]        b0104bf8 b1afd240 c90c0900 0024c96b b03b09a4 0000003f ffffffff 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b0104bf8>] apic_timer_interrupt+0x28/0x30
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b019335b>] prune_dcache+0x145/0x189
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================
[  959.419364] cc1           D b15407e0     0 20252  20251
[  959.419364]        da5d0e04 00200082 da5d0df8 b15407e0 b03af280 b016bfdc 00000001 b03af280 
[  959.419364]        2d90fbe6 000000b3 b040d300 b040d300 df63e870 df63eabc b1815300 da5d0000 
[  959.419364]        00000000 00000020 d0aa6e40 da5d0e54 00000000 00000000 b040a8e0 b040a8e0 
[  959.419364] Call Trace:
[  959.419364]  [<b016bfdc>] isolate_lru_pages+0x5f/0x1bb
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0171693>] handle_mm_fault+0x22d/0x62f
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================
[  959.419364] bash          D b4354dc0     0 20276   3582
[  959.419364]        b4354dd4 00000082 00000002 b4354dc0 b4354db8 00000000 00000001 0000000c 
[  959.419364]        b4354e1c 00000020 b040d300 b040d300 c9ba2270 c9ba24bc b1815300 b4354000 
[  959.419364]        b016b41a 00000020 c3584c80 0027f8af 00000000 00000000 ffffffff 00000003 
[  959.419364] Call Trace:
[  959.419364]  [<b016b41a>] __pagevec_release+0x15/0x1d
[  959.419364]  [<b02e3fa5>] __mutex_lock_slowpath+0x57/0x90
[  959.419364]  [<b02e3e24>] mutex_lock+0xa/0xb
[  959.419364]  [<b0195ee8>] shrink_icache_memory+0x58/0x233
[  959.419364]  [<b016d2fe>] shrink_slab+0x129/0x18f
[  959.419364]  [<b016dce7>] try_to_free_pages+0x182/0x267
[  959.419364]  [<b01688a3>] __alloc_pages+0x140/0x347
[  959.419364]  [<b0170418>] do_wp_page+0x87/0x3f1
[  959.419364]  [<b01718b5>] handle_mm_fault+0x44f/0x62f
[  959.419364]  [<b012934c>] wake_up_new_task+0x77/0x93
[  959.419364]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[  959.419364]  [<b0136005>] recalc_sigpending+0xb/0x30
[  959.419364]  [<b0136092>] sigprocmask+0x68/0xc3
[  959.419364]  [<b0102241>] sys_clone+0x36/0x3b
[  959.419364]  [<b011c99c>] do_page_fault+0x0/0x5d4
[  959.419364]  [<b02e527a>] error_code+0x72/0x78
[  959.419364]  [<b02e0000>] netlbl_secattr_catmap_setbit+0x6d/0x8b
[  959.419364]  =======================


