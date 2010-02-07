Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0BGApz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 19:45:55 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:33606 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0BGApy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 19:45:54 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: Bad page state in process portageq
Date: Sun, 7 Feb 2010 01:45:46 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc6-00228-g56dca4c; KDE/4.3.98; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002070145.47514.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When recompiling PHP on my system the corresponding portageq (Gentoo portage) 
process died suddenly with a segfault and I found this in the log:

Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq  
pfn:2846d
Feb  6 20:47:45 datengrab kernel: page:ffffea00008cf7d8 flags:0400000000000000 
count:0 mapcount:-1 mapping:(null) index:7f46ba809
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Not tainted 
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:47:45 datengrab kernel: [<ffffffff81073a0a>] ? do_wp_page+0x5c3/0x680
Feb  6 20:47:45 datengrab kernel: [<ffffffff81075162>] ? 
handle_mm_fault+0x662/0x6b6
Feb  6 20:47:45 datengrab kernel: [<ffffffff8108b5c9>] ? __slab_free+0x79/0x2d3
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:47:45 datengrab kernel: Disabling lock debugging due to kernel taint
Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq  
pfn:1645e
Feb  6 20:47:45 datengrab kernel: page:ffffea00004df490 flags:0400000000000000 
count:0 mapcount:-1 mapping:(null) index:7f46bb080
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:47:45 datengrab kernel: [<ffffffff81073a0a>] ? do_wp_page+0x5c3/0x680
Feb  6 20:47:45 datengrab kernel: [<ffffffff81075162>] ? 
handle_mm_fault+0x662/0x6b6
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq  
pfn:1c8d5
Feb  6 20:47:45 datengrab kernel: page:ffffea000063ee98 flags:0400000000000000 
count:0 mapcount:-1 mapping:(null) index:7f46ba808
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:47:45 datengrab kernel: [<ffffffff81073a0a>] ? do_wp_page+0x5c3/0x680
Feb  6 20:47:45 datengrab kernel: [<ffffffff81075162>] ? 
handle_mm_fault+0x662/0x6b6
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq  
pfn:75e76
Feb  6 20:47:45 datengrab kernel: page:ffffea00019ca9d0 flags:0400000000000000 
count:0 mapcount:-1 mapping:(null) index:7f46bb070
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:47:45 datengrab kernel: [<ffffffff81073a0a>] ? do_wp_page+0x5c3/0x680
Feb  6 20:47:45 datengrab kernel: [<ffffffff81075162>] ? 
handle_mm_fault+0x662/0x6b6
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:47:45 datengrab kernel: portageq[26064]: segfault at 1 ip 
00007f46bd5ddd36 sp 00007fff7e236780 error 4 in 
libpython3.1.so.1.0[7f46bd546000+165000]
Feb  6 20:47:45 datengrab kernel: BUG: Bad page map in process portageq  
pte:800000005bc67065 pmd:8b2fa067
Feb  6 20:47:45 datengrab kernel: page:ffffea0001413688 flags:0400000000080014 
count:0 mapcount:-1 mapping:(null) index:7f46bb08f
Feb  6 20:47:45 datengrab kernel: addr:00007f46bb08f000 vm_flags:00100073 
anon_vma:ffff88005e2aae00 mapping:(null) index:7f46bb08f
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff810733dc>] ? print_bad_pte+0x20c/0x224
Feb  6 20:47:45 datengrab kernel: [<ffffffff810807bb>] ? 
free_pages_and_swap_cache+0x86/0xa4
Feb  6 20:47:45 datengrab kernel: [<ffffffff81074269>] ? unmap_vmas+0x45b/0x798
Feb  6 20:47:45 datengrab kernel: [<ffffffff810784bf>] ? exit_mmap+0xac/0x139
Feb  6 20:47:45 datengrab kernel: [<ffffffff8102e68e>] ? mmput+0x28/0xc7
Feb  6 20:47:45 datengrab kernel: [<ffffffff81031f5c>] ? exit_mm+0xfa/0x105
Feb  6 20:47:45 datengrab kernel: [<ffffffff810455f4>] ? 
hrtimer_try_to_cancel+0x62/0x6b
Feb  6 20:47:45 datengrab kernel: [<ffffffff810336c7>] ? do_exit+0x1b5/0x62a
Feb  6 20:47:45 datengrab kernel: [<ffffffff81033ba9>] ? do_group_exit+0x6d/0x94
Feb  6 20:47:45 datengrab kernel: [<ffffffff8103c618>] ? 
get_signal_to_deliver+0x2cc/0x2e7
Feb  6 20:47:45 datengrab kernel: [<ffffffff8100141f>] ? do_signal+0x6c/0x67e
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101e3a1>] ? 
force_sig_info_fault+0x40/0x48
Feb  6 20:47:45 datengrab kernel: [<ffffffff81001a56>] ? 
do_notify_resume+0x25/0x42
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c2da>] ? retint_signal+0x3d/0x83
Feb  6 20:47:45 datengrab kernel: BUG: Bad page map in process portageq  
pte:80000000399c1065 pmd:8b2fa067
Feb  6 20:47:45 datengrab kernel: page:ffffea0000c9a238 flags:0400000000080014 
count:0 mapcount:-1 mapping:(null) index:7f46bb09e
Feb  6 20:47:45 datengrab kernel: addr:00007f46bb09e000 vm_flags:00100073 
anon_vma:ffff88005e2aae00 mapping:(null) index:7f46bb09e
Feb  6 20:47:45 datengrab kernel: Pid: 26064, comm: portageq Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff810733dc>] ? print_bad_pte+0x20c/0x224
Feb  6 20:47:45 datengrab kernel: [<ffffffff810807bb>] ? 
free_pages_and_swap_cache+0x86/0xa4
Feb  6 20:47:45 datengrab kernel: [<ffffffff81074269>] ? unmap_vmas+0x45b/0x798
Feb  6 20:47:45 datengrab kernel: [<ffffffff810784bf>] ? exit_mmap+0xac/0x139
Feb  6 20:47:45 datengrab kernel: [<ffffffff8102e68e>] ? mmput+0x28/0xc7
Feb  6 20:47:45 datengrab kernel: [<ffffffff81031f5c>] ? exit_mm+0xfa/0x105
Feb  6 20:47:45 datengrab kernel: [<ffffffff810455f4>] ? 
hrtimer_try_to_cancel+0x62/0x6b
Feb  6 20:47:45 datengrab kernel: [<ffffffff810336c7>] ? do_exit+0x1b5/0x62a
Feb  6 20:47:45 datengrab kernel: [<ffffffff81033ba9>] ? do_group_exit+0x6d/0x94
Feb  6 20:47:45 datengrab kernel: [<ffffffff8103c618>] ? 
get_signal_to_deliver+0x2cc/0x2e7
Feb  6 20:47:45 datengrab kernel: [<ffffffff8100141f>] ? do_signal+0x6c/0x67e
Feb  6 20:47:45 datengrab kernel: [<ffffffff8101e3a1>] ? 
force_sig_info_fault+0x40/0x48
Feb  6 20:47:45 datengrab kernel: [<ffffffff81001a56>] ? 
do_notify_resume+0x25/0x42
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134c2da>] ? retint_signal+0x3d/0x83
Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process flush-btrfs-1  
pfn:1645e
Feb  6 20:47:45 datengrab kernel: page:ffffea00004df490 flags:0400000000000000 
count:-1 mapcount:-1 mapping:(null) index:7f46bb080
Feb  6 20:47:45 datengrab kernel: Pid: 1702, comm: flush-btrfs-1 Tainted: G    
B      2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:47:45 datengrab kernel: Call Trace:
Feb  6 20:47:45 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:47:45 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:47:45 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:47:45 datengrab kernel: [<ffffffff811a8f3c>] ? __up_read+0x13/0x99
Feb  6 20:47:45 datengrab kernel: [<ffffffff811402d4>] ? 
find_free_extent+0x854/0x869
Feb  6 20:47:45 datengrab kernel: [<ffffffff81061558>] ? find_get_page+0x1e/0x8a
Feb  6 20:47:45 datengrab kernel: [<ffffffff81061fce>] ? 
find_or_create_page+0x3c/0x83
Feb  6 20:47:45 datengrab kernel: [<ffffffff81165932>] ? 
alloc_extent_buffer+0x16c/0x2df
Feb  6 20:47:45 datengrab kernel: [<ffffffff8113ebb7>] ? 
btrfs_init_new_buffer+0x17/0x110
Feb  6 20:47:45 datengrab kernel: [<ffffffff81145587>] ? 
btrfs_alloc_free_block+0x176/0x17b
Feb  6 20:47:45 datengrab kernel: [<ffffffff81134c01>] ? leaf_space_used+0xba/0xe0
Feb  6 20:47:45 datengrab kernel: [<ffffffff81139770>] ? split_leaf+0x2ad/0x5e4
Feb  6 20:47:45 datengrab kernel: [<ffffffff8113b361>] ? 
btrfs_search_slot+0x67b/0x78c
Feb  6 20:47:45 datengrab kernel: [<ffffffff8113b9df>] ? 
btrfs_insert_empty_items+0x62/0xb5
Feb  6 20:47:45 datengrab kernel: [<ffffffff811518f8>] ? 
insert_inline_extent+0xc3/0x2e1
Feb  6 20:47:45 datengrab kernel: [<ffffffff81151c23>] ? 
cow_file_range_inline+0x10d/0x141
Feb  6 20:47:45 datengrab kernel: [<ffffffff81151cef>] ? cow_file_range+0x98/0x348
Feb  6 20:47:45 datengrab kernel: [<ffffffff8116683a>] ? 
set_extent_bit+0x3ac/0x41d
Feb  6 20:47:45 datengrab kernel: [<ffffffff811525f8>] ? 
run_delalloc_range+0xa1/0x309
Feb  6 20:47:45 datengrab kernel: [<ffffffff81168d54>] ? 
find_lock_delalloc_range+0x180/0x1a2
Feb  6 20:47:45 datengrab kernel: [<ffffffff81168f5b>] ? 
__extent_writepage+0x1e5/0x61f
Feb  6 20:47:45 datengrab kernel: [<ffffffff810612bb>] ? 
find_get_pages_tag+0x41/0xfc
Feb  6 20:47:45 datengrab kernel: [<ffffffff811697c5>] ? T.858+0x14b/0x246
Feb  6 20:47:45 datengrab kernel: [<ffffffff8102b02c>] ? 
finish_task_switch+0x3b/0x82
Feb  6 20:47:45 datengrab kernel: [<ffffffff8134a6ba>] ? schedule+0x7b8/0x893
Feb  6 20:47:45 datengrab kernel: [<ffffffff811699bb>] ? 
extent_writepages+0x41/0x5a
Feb  6 20:47:45 datengrab kernel: [<ffffffff81150edf>] ? 
btrfs_get_extent+0x0/0x783
Feb  6 20:47:45 datengrab kernel: [<ffffffff810ab731>] ? 
writeback_single_inode+0xe1/0x2d1
Feb  6 20:47:45 datengrab kernel: [<ffffffff810ac33e>] ? 
writeback_inodes_wb+0x37e/0x460
Feb  6 20:47:45 datengrab kernel: [<ffffffff810ac54e>] ? wb_writeback+0x12e/0x1aa
Feb  6 20:47:45 datengrab kernel: [<ffffffff810ac7a5>] ? 
wb_do_writeback+0x13e/0x154
Feb  6 20:47:45 datengrab kernel: [<ffffffff810ac7e5>] ? 
bdi_writeback_task+0x2a/0x82
Feb  6 20:47:45 datengrab kernel: [<ffffffff810719d2>] ? bdi_start_fn+0x0/0xc2
Feb  6 20:47:45 datengrab kernel: [<ffffffff81071a35>] ? bdi_start_fn+0x63/0xc2
Feb  6 20:47:45 datengrab kernel: [<ffffffff810719d2>] ? bdi_start_fn+0x0/0xc2
Feb  6 20:47:45 datengrab kernel: [<ffffffff81042275>] ? kthread+0x75/0x7d
Feb  6 20:47:45 datengrab kernel: [<ffffffff81002b94>] ? 
kernel_thread_helper+0x4/0x10
Feb  6 20:47:45 datengrab kernel: [<ffffffff81042200>] ? kthread+0x0/0x7d
Feb  6 20:47:45 datengrab kernel: [<ffffffff81002b90>] ? 
kernel_thread_helper+0x0/0x10
Feb  6 20:49:16 datengrab kernel: BUG: Bad page state in process kmail  
pfn:399c1
Feb  6 20:49:16 datengrab kernel: page:ffffea0000c9a238 flags:0400000000000014 
count:-1 mapcount:-1 mapping:(null) index:7f46bb09e
Feb  6 20:49:16 datengrab kernel: Pid: 26188, comm: kmail Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:49:16 datengrab kernel: Call Trace:
Feb  6 20:49:16 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:49:16 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:49:16 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:49:16 datengrab kernel: [<ffffffff81070c5b>] ? zone_statistics+0x3c/0x5d
Feb  6 20:49:16 datengrab kernel: [<ffffffff810685db>] ? 
__do_page_cache_readahead+0x93/0x1b3
Feb  6 20:49:16 datengrab kernel: [<ffffffff81068717>] ? ra_submit+0x1c/0x20
Feb  6 20:49:16 datengrab kernel: [<ffffffff81061db5>] ? filemap_fault+0x18f/0x305
Feb  6 20:49:16 datengrab kernel: [<ffffffff81072e32>] ? __do_fault+0x52/0x3f0
Feb  6 20:49:16 datengrab kernel: [<ffffffff8106fe9b>] ? 
vma_prio_tree_insert+0x20/0xb5
Feb  6 20:49:16 datengrab kernel: [<ffffffff81074e46>] ? 
handle_mm_fault+0x346/0x6b6
Feb  6 20:49:16 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:49:16 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:49:16 datengrab kernel: BUG: Bad page state in process kmail  
pfn:5bc67
Feb  6 20:49:16 datengrab kernel: page:ffffea0001413688 flags:0400000000000014 
count:-1 mapcount:-1 mapping:(null) index:7f46bb08f
Feb  6 20:49:16 datengrab kernel: Pid: 26188, comm: kmail Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:49:16 datengrab kernel: Call Trace:
Feb  6 20:49:16 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:49:16 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:49:16 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:49:16 datengrab kernel: [<ffffffff81070c5b>] ? zone_statistics+0x3c/0x5d
Feb  6 20:49:16 datengrab kernel: [<ffffffff810685db>] ? 
__do_page_cache_readahead+0x93/0x1b3
Feb  6 20:49:16 datengrab kernel: [<ffffffff81068717>] ? ra_submit+0x1c/0x20
Feb  6 20:49:16 datengrab kernel: [<ffffffff81061db5>] ? filemap_fault+0x18f/0x305
Feb  6 20:49:16 datengrab kernel: [<ffffffff81072e32>] ? __do_fault+0x52/0x3f0
Feb  6 20:49:16 datengrab kernel: [<ffffffff8106fe9b>] ? 
vma_prio_tree_insert+0x20/0xb5
Feb  6 20:49:16 datengrab kernel: [<ffffffff81074e46>] ? 
handle_mm_fault+0x346/0x6b6
Feb  6 20:49:16 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:49:16 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:49:16 datengrab kernel: BUG: Bad page state in process kmail  
pfn:75e76
Feb  6 20:49:16 datengrab kernel: page:ffffea00019ca9d0 flags:0400000000000000 
count:-1 mapcount:-1 mapping:(null) index:7f46bb070
Feb  6 20:49:16 datengrab kernel: Pid: 26188, comm: kmail Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:49:16 datengrab kernel: Call Trace:
Feb  6 20:49:16 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:49:16 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:49:16 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:49:16 datengrab kernel: [<ffffffff81070c5b>] ? zone_statistics+0x3c/0x5d
Feb  6 20:49:16 datengrab kernel: [<ffffffff810685db>] ? 
__do_page_cache_readahead+0x93/0x1b3
Feb  6 20:49:16 datengrab kernel: [<ffffffff81068717>] ? ra_submit+0x1c/0x20
Feb  6 20:49:16 datengrab kernel: [<ffffffff81061db5>] ? filemap_fault+0x18f/0x305
Feb  6 20:49:16 datengrab kernel: [<ffffffff81072e32>] ? __do_fault+0x52/0x3f0
Feb  6 20:49:16 datengrab kernel: [<ffffffff8106fe9b>] ? 
vma_prio_tree_insert+0x20/0xb5
Feb  6 20:49:16 datengrab kernel: [<ffffffff81074e46>] ? 
handle_mm_fault+0x346/0x6b6
Feb  6 20:49:16 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:49:16 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:49:16 datengrab kernel: BUG: Bad page state in process kmail  
pfn:1c8d5
Feb  6 20:49:16 datengrab kernel: page:ffffea000063ee98 flags:0400000000000000 
count:-1 mapcount:-1 mapping:(null) index:7f46ba808
Feb  6 20:49:16 datengrab kernel: Pid: 26188, comm: kmail Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:49:16 datengrab kernel: Call Trace:
Feb  6 20:49:16 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:49:16 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:49:16 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:49:16 datengrab kernel: [<ffffffff81070c5b>] ? zone_statistics+0x3c/0x5d
Feb  6 20:49:16 datengrab kernel: [<ffffffff810685db>] ? 
__do_page_cache_readahead+0x93/0x1b3
Feb  6 20:49:16 datengrab kernel: [<ffffffff81068717>] ? ra_submit+0x1c/0x20
Feb  6 20:49:16 datengrab kernel: [<ffffffff81061db5>] ? filemap_fault+0x18f/0x305
Feb  6 20:49:16 datengrab kernel: [<ffffffff81072e32>] ? __do_fault+0x52/0x3f0
Feb  6 20:49:16 datengrab kernel: [<ffffffff8106fe9b>] ? 
vma_prio_tree_insert+0x20/0xb5
Feb  6 20:49:16 datengrab kernel: [<ffffffff81074e46>] ? 
handle_mm_fault+0x346/0x6b6
Feb  6 20:49:16 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:49:16 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30
Feb  6 20:49:16 datengrab kernel: BUG: Bad page state in process kmail  
pfn:2846d
Feb  6 20:49:16 datengrab kernel: page:ffffea00008cf7d8 flags:0400000000000000 
count:-1 mapcount:-1 mapping:(null) index:7f46ba809
Feb  6 20:49:16 datengrab kernel: Pid: 26188, comm: kmail Tainted: G    B      
2.6.33-rc6-00228-g56dca4c #39
Feb  6 20:49:16 datengrab kernel: Call Trace:
Feb  6 20:49:16 datengrab kernel: [<ffffffff81064bd4>] ? bad_page+0x102/0x115
Feb  6 20:49:16 datengrab kernel: [<ffffffff810662c4>] ? 
get_page_from_freelist+0x441/0x667
Feb  6 20:49:16 datengrab kernel: [<ffffffff810666cc>] ? 
__alloc_pages_nodemask+0x102/0x587
Feb  6 20:49:16 datengrab kernel: [<ffffffff81070c5b>] ? zone_statistics+0x3c/0x5d
Feb  6 20:49:16 datengrab kernel: [<ffffffff810685db>] ? 
__do_page_cache_readahead+0x93/0x1b3
Feb  6 20:49:16 datengrab kernel: [<ffffffff81068717>] ? ra_submit+0x1c/0x20
Feb  6 20:49:16 datengrab kernel: [<ffffffff81061db5>] ? filemap_fault+0x18f/0x305
Feb  6 20:49:16 datengrab kernel: [<ffffffff81072e32>] ? __do_fault+0x52/0x3f0
Feb  6 20:49:16 datengrab kernel: [<ffffffff8106fe9b>] ? 
vma_prio_tree_insert+0x20/0xb5
Feb  6 20:49:16 datengrab kernel: [<ffffffff81074e46>] ? 
handle_mm_fault+0x346/0x6b6
Feb  6 20:49:16 datengrab kernel: [<ffffffff8101eaeb>] ? do_page_fault+0x264/0x280
Feb  6 20:49:16 datengrab kernel: [<ffffffff8134c41f>] ? page_fault+0x1f/0x30

Until reboot the system was unstable after this (e.g. crashing kwin) but 
nothing appeared in the log.

regards,
  Johannes
