Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXJRFfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXJRFfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJRFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:35:18 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57094 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXJRFfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:35:14 -0400
Message-ID: <4716F066.5030408@linux.vnet.ibm.com>
Date: Thu, 18 Oct 2007 11:04:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.23-git12 - Kernel oops at blk_rq_map_sg+0x270/0x4e0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel oops is triggered within few seconds after boot up in ia64 machine

[  113.004837] Unable to handle kernel NULL pointer dereference (address 0000000000000022)
[  113.013077] tail[3466]: Oops 8813272891392 [1]
[  113.017643] Modules linked in:
[  113.020854] 
[  113.020855] Pid: 3466, CPU 0, comm:                 tail
[  113.027901] psr : 0000101008022018 ifs : 8000000000000184 ip  : [<a000000100506d10>]    Not tainted
[  113.037187] ip is at blk_rq_map_sg+0x270/0x4e0
[  113.041755] unat: 0000000000000000 pfs : 0000000000000309 rsc : 0000000000000003
[  113.049369] rnat: 0000000000000000 bsps: 0000000000000000 pr  : 1595696a56aa9a69
[  113.056987] ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
[  113.064596] csd : 0000000000000000 ssd : 0000000000000000
[  113.070120] b0  : a0000001006c0050 b6  : a000000100100400 b7  : a0000001006dbe40
[  113.077736] f6  : 1003e0000000000000000 f7  : 1003e0000000000000008
[  113.084131] f8  : 1003e0000000000016701 f9  : 10005a800000000000000
[  113.090526] f10 : 100138cc143fffcb90900 f11 : 1003e0000000000119828
[  113.096923] r1  : a000000100f7fd90 r2  : 00000001084d8000 r3  : 0000000000000000
[  113.104535] r8  : 0000000000000002 r9  : 00000000000420f5 r10 : 00000000002109b0
[  113.112146] r11 : 000000000000000e r12 : e00000014b107900 r13 : e00000014b100000
[  113.119755] r14 : 00000001084d9000 r15 : 00000001083d4000 r16 : 00000001083d8000
[  113.127368] r17 : 00000001083d4000 r18 : 00000000001ce6b3 r19 : 0000000000001000
[  113.134977] r20 : 4000000000042136 r21 : 0000000000000002 r22 : e0000001434797f0
[  113.142591] r23 : 0000000000001000 r24 : e0000001434797fc r25 : 0000000000000000
[  113.150206] r26 : 000000000000000a r27 : 0000000000000022 r28 : e00000014a907e80
[  113.157818] r29 : e00000014347d628 r30 : 0000000000000001 r31 : a000000100d9ef18
[  113.165442] 
[  113.165443] Call Trace:
[  113.169623]  [<a000000100014560>] show_stack+0x80/0xa0
[  113.169624]                                 sp=e00000014b1074d0 bsp=e00000014b101a68
[  113.182857]  [<a000000100014e50>] show_regs+0x870/0x8a0
[  113.182858]                                 sp=e00000014b1076a0 bsp=e00000014b101a10
[  113.196177]  [<a00000010003a2b0>] die+0x190/0x300
[  113.196178]                                 sp=e00000014b1076a0 bsp=e00000014b1019c0
[  113.208998]  [<a000000100916cb0>] ia64_do_page_fault+0xa50/0xba0
[  113.209000]                                 sp=e00000014b1076a0 bsp=e00000014b101960
[  113.223098]  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
[  113.223100]                                 sp=e00000014b107730 bsp=e00000014b101960
[  113.236934]  [<a000000100506d10>] blk_rq_map_sg+0x270/0x4e0
[  113.236935]                                 sp=e00000014b107900 bsp=e00000014b101940
[  113.250598]  [<a0000001006c0050>] scsi_init_io+0xf0/0x1e0
[  113.250599]                                 sp=e00000014b107900 bsp=e00000014b101910
[  113.264086]  [<a0000001006c01f0>] scsi_setup_fs_cmnd+0xb0/0x120
[  113.264088]                                 sp=e00000014b107900 bsp=e00000014b1018e8
[  113.278108]  [<a0000001006dbf10>] sd_prep_fn+0xd0/0x11e0
[  113.278110]                                 sp=e00000014b107900 bsp=e00000014b101868
[  113.291516]  [<a000000100500520>] elv_next_request+0x220/0x400
[  113.291518]                                 sp=e00000014b107900 bsp=e00000014b1017e8
[  113.305443]  [<a0000001006c1d60>] scsi_request_fn+0x80/0x940
[  113.305444]                                 sp=e00000014b107910 bsp=e00000014b101770
[  113.319190]  [<a000000100509c00>] __generic_unplug_device+0xa0/0xc0
[  113.319192]                                 sp=e00000014b107910 bsp=e00000014b101750
[  113.333544]  [<a00000010050c630>] generic_unplug_device+0x30/0x80
[  113.333546]                                 sp=e00000014b107910 bsp=e00000014b101728
[  113.347741]  [<a000000100502d80>] blk_backing_dev_unplug+0x60/0xa0
[  113.347743]                                 sp=e00000014b107910 bsp=e00000014b101708
[  113.362024]  [<a0000001001c08c0>] sync_buffer+0xe0/0x120
[  113.362025]                                 sp=e00000014b107910 bsp=e00000014b1016e8
[  113.375424]  [<a00000010090f0e0>] __wait_on_bit+0x140/0x160
[  113.375426]                                 sp=e00000014b107910 bsp=e00000014b101698
[  113.389084]  [<a00000010090f1d0>] out_of_line_wait_on_bit+0xd0/0x100
[  113.389086]                                 sp=e00000014b107910 bsp=e00000014b101660
[  113.403521]  [<a0000001001c0660>] __wait_on_buffer+0x40/0x60
[  113.403523]                                 sp=e00000014b107950 bsp=e00000014b101640
[  113.417275]  [<a0000001001c5960>] __bread+0x1e0/0x220
[  113.417276]                                 sp=e00000014b107950 bsp=e00000014b101610
[  113.431925]  [<a0000001002869c0>] ext3_get_branch+0xe0/0x200
[  113.431927]                                 sp=e00000014b107950 bsp=e00000014b1015a8
[  113.445679]  [<a000000100287040>] ext3_get_blocks_handle+0x120/0x1840
[  113.445681]                                 sp=e00000014b107950 bsp=e00000014b101498
[  113.460220]  [<a000000100288e80>] ext3_get_block+0xe0/0x2c0
[  113.460221]                                 sp=e00000014b107a00 bsp=e00000014b101440
[  113.473886]  [<a0000001001d3290>] do_mpage_readpage+0x630/0xee0
[  113.473888]                                 sp=e00000014b107a00 bsp=e00000014b101360
[  113.487906]  [<a0000001001d41b0>] mpage_readpages+0x1f0/0x260
[  113.487907]                                 sp=e00000014b107b00 bsp=e00000014b1012f0
[  113.501737]  [<a000000100286d90>] ext3_readpages+0x30/0x60
[  113.501738]                                 sp=e00000014b107b80 bsp=e00000014b1012b8
[  113.515318]  [<a00000010010f920>] __do_page_cache_readahead+0x240/0x580
[  113.515320]                                 sp=e00000014b107b80 bsp=e00000014b101220
[  113.530027]  [<a000000100110850>] do_page_cache_readahead+0xf0/0x120
[  113.530028]                                 sp=e00000014b107b90 bsp=e00000014b1011e0
[  113.544479]  [<a0000001000ff940>] filemap_fault+0x600/0x820
[  113.544480]                                 sp=e00000014b107b90 bsp=e00000014b101128
[  113.558146]  [<a00000010011f470>] __do_fault+0xd0/0xb40
[  113.558148]                                 sp=e00000014b107b90 bsp=e00000014b1010a0
[  113.571460]  [<a000000100124620>] handle_mm_fault+0x260/0x10a0
[  113.571461]                                 sp=e00000014b107bc0 bsp=e00000014b101018
[  113.585382]  [<a000000100916940>] ia64_do_page_fault+0x6e0/0xba0
[  113.585383]                                 sp=e00000014b107bc0 bsp=e00000014b100fb0
[  113.599472]  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
[  113.599473]                                 sp=e00000014b107c50 bsp=e00000014b100fb0
[  113.613312]  [<a00000010053a330>] __do_clear_user+0x90/0x160
[  113.613314]                                 sp=e00000014b107e20 bsp=e00000014b100fa0
[  113.627070]  [<a0000001001ee1d0>] padzero+0xb0/0xe0
[  113.627071]                                 sp=e00000014b107e20 bsp=e00000014b100f80
[  113.640040]  [<a0000001001f15b0>] load_elf_binary+0x14f0/0x2b00
[  113.640041]                                 sp=e00000014b107e20 bsp=e00000014b100e38
[  113.654052]  [<a000000100172d40>] search_binary_handler+0x1a0/0x520
[  113.654054]                                 sp=e00000014b107e30 bsp=e00000014b100da8
[  113.668418]  [<a000000100175be0>] do_execve+0x2e0/0x340
[  113.668419]                                 sp=e00000014b107e30 bsp=e00000014b100d48
[  113.681730]  [<a000000100012ba0>] sys_execve+0x60/0xc0
[  113.681731]                                 sp=e00000014b107e30 bsp=e00000014b100d10
[  113.694958]  [<a00000010000a630>] ia64_execve+0x30/0x160

[  113.694960]                                 sp=e00000014b107e30 bsp=e00000014b100cc0
[  113.708357]  [<a00000010000af60>] ia64_ret_from_syscall+0x0/0x20
[  113.708358]                                 sp=e00000014b107e30 bsp=e00000014b100cc0
[  113.722451]  [<a000000000010620>] __start_ivt_text+0xffffffff00010620/0x400
[  113.722453]                                 sp=e00000014b108000 bsp=e00000014b100cc0

and kernel panics in another machine with following oops

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
 printing eip:
c0283570
*pdpt = 000000000372e001
*pde = 0000000000000000
Oops: 0000 [#1]
SMP 
Modules linked in: sd_mod
CPU:    0
EIP:    0060:[<c0283570>]    Not tainted VLI
EFLAGS: 00010006   (2.6.23-git12-autokern1 #1)
EIP is at blk_rq_map_sg+0x1a9/0x217
eax: 00000000   ebx: c38b9b00   ecx: 00000005   edx: 00000014
esi: 7fc87000   edi: 00000000   ebp: 00000000   esp: c2841bb4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process init (pid: 1, ti=c2840000 task=c283f5b0 task.ti=c2840000)
Stack: 00000000 00000000 00000000 00000000 7fc89000 00000000 7fc88000 00000000 
       00002000 00001000 00000001 00000001 00000001 c39f1700 00000014 c355798c 
       c38c0138 c38b9b00 c38897c8 00000000 00000088 c032a6e8 00000088 c032a75b 
Call Trace:
 [<c032a6e8>] scsi_init_io+0x62/0xbe
 [<c032a75b>] scsi_get_cmd_from_req+0x17/0x32
 [<f8d0f41c>] sd_prep_fn+0x6f/0x76f [sd_mod]
 [<c028a935>] __cfq_dispatch_requests+0x7e/0x132
 [<c0281a16>] elv_set_request+0x14/0x22
 [<c0281936>] elv_next_request+0xaf/0xf7
 [<c01303f0>] lock_timer_base+0x19/0x35
 [<c032ab55>] scsi_request_fn+0x66/0x303
 [<c0283b83>] blk_remove_plug+0x52/0x5e
 [<c0283bac>] __generic_unplug_device+0x1d/0x1f
 [<c028171c>] elv_insert+0xa4/0x144
 [<c013049c>] __mod_timer+0x90/0x9a
 [<c0284ffd>] __make_request+0x2c5/0x2f4
 [<c028529f>] generic_make_request+0x1ff/0x22d
 [<c0192fed>] do_mpage_readpage+0x4ab/0x552
 [<c0192994>] mpage_end_io_read+0x0/0x53
 [<c0285391>] submit_bio+0xc4/0xcb
 [<c040477a>] _write_unlock_irq+0x5/0x7
 [<c0151b5a>] add_to_page_cache+0x6f/0x76
 [<c0192994>] mpage_end_io_read+0x0/0x53
 [<c0192a54>] mpage_bio_submit+0x19/0x1d
 [<c0193160>] mpage_readpages+0xcc/0xd6
 [<c01cffa8>] ext3_get_block+0x0/0xd1
 [<c01560be>] __alloc_pages+0x5c/0x2d7
 [<c0403e26>] __wait_on_bit_lock+0x4b/0x52
 [<c0158533>] read_pages+0x27/0x8f
 [<c01cffa8>] ext3_get_block+0x0/0xd1
 [<c01586c5>] __do_page_cache_readahead+0x12a/0x144
 [<c0158796>] do_page_cache_readahead+0x48/0x52
 [<c0152a79>] filemap_fault+0x173/0x2cb
 [<c015fd1d>] __do_fault+0x70/0x377
 [<c01563df>] __pagevec_free+0x15/0x1a
 [<c01603b3>] handle_mm_fault+0x174/0x333
 [<c011db4d>] do_page_fault+0x218/0x69f
 [<c0161142>] remove_vma+0x40/0x45
 [<c0162675>] remove_vma_list+0x40/0x4a
 [<c011d935>] do_page_fault+0x0/0x69f
 [<c04048f2>] error_code+0x72/0x78
 [<c0400000>] inet6_hash_connect+0x293/0x297
 =======================
Code: 09 c6 09 d7 39 7c 24 0c 75 0f 39 74 24 08 75 09 8b 44 24 20 89 45 10 eb 43 8b 6c 24 38 b9 05 00 00 00 8d 55 14 89 54 24 38 89 ef <8b> 45 14 89 c2 83 e2 fe a8 01 0f 44 54 24 38 31 c0 89 54 24 38 
EIP: [<c0283570>] blk_rq_map_sg+0x1a9/0x217 SS:ESP 0068:c2841bb4
Kernel panic - not syncing: Attempted to kill init!

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
