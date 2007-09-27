Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbXI0JlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbXI0JlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXI0Jk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:40:58 -0400
Received: from zankt.net ([84.16.234.225]:58661 "EHLO mail.zankt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbXI0Jk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:40:56 -0400
Date: Thu, 27 Sep 2007 11:40:54 +0200
From: D-Tick <mlists@zankt.net>
To: Mel Gorman <mel@skynet.ie>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
Message-ID: <20070927094054.GA21568@voltkraft>
Mail-Followup-To: D-Tick <mlists@zankt.net>,
	Mel Gorman <mel@skynet.ie>, npiggin@suse.de,
	linux-kernel@vger.kernel.org
References: <20070925115348.GA23590@voltkraft> <20070925132728.GA5525@skynet.ie> <20070926194015.GA26681@voltkraft> <20070926204304.GA5944@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926204304.GA5944@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my mistake, the link should be
http://lkml.org/lkml/2007/7/25/268

memtest was running for one week with no results, i also tried the ram
from another box. 
I replaced all SATA kables half a year ago with no result :/
A friend told me he had problems with a VIA Board when using the
hardware crypto module, but i didnt check that.

Greetings,
Hendrik - D-Tick

On Wed, Sep 26, 2007 at 09:43:04PM +0100, Mel Gorman wrote:
> On (26/09/07 21:40), D-Tick didst pronounce:
> > Hi,
> > i described it a little more in detail in
> > http://lkml.org/lkml/2007/9/25/184 2 months ago. 
> 
> Are you sure about that link? It looks like my own posting.
> 
> > The kernel oopses often when there is (heavy) disk access, but not
> > always, thats the point, sometimes it runs 4 weeks, sometimes only a
> > few days. With older kernels sometimes the software raid was out of sync
> > and one disk was gone, with ne "new" kernel nothing like this happend.
> > 
> 
> Is there any chance you have dodgy/overclocked RAM? i.e. Have you tried
> running memtest for 48 hours? I ask because a NULL reference of 00000008
> is suspiciously like a single bit flip. Similarly, is there any chance you
> have bad cables connecting your disks? I ask because of the long-lived time
> running before it corrupts in combination with the fact you say this problem
> has existed for a number of kernels. That old a kernel bug, I would have
> expected a number of similar reports particularly if ext3 is involved.
> 
> Thanks
> 
> > Hendrik - D-Tick
> > 
> > On Tue, Sep 25, 2007 at 02:27:28PM +0100, Mel Gorman wrote:
> > > On (25/09/07 13:53), Hendrik P. didst pronounce:
> > > > Maybe you know what bringt this box down:
> > > > 
> > > > regards,
> > > > Hendrik P.
> > > > 
> > > 
> > > Nick, this is a random stab in the dark but you were around mark_buffer_dirty()
> > > a few months ago. Does this error look familiar?
> > > 
> > > Hendrik, what is going on when you trigger this? Is it easily
> > > reproducible? Does it only occur with DEBUG_PAGEALLOC?
> > > 
> > > Thanks
> > > 
> > > > [263322.356816] BUG: unable to handle kernel NULL pointer dereference at
> > > > virtual address 00000008
> > > > [263322.459908]  printing eip:
> > > > [263322.493267] c014e09c
> > > > [263322.520391] *pde = 00000000
> > > > [263322.554795] Oops: 0000 [#1]
> > > > [263322.589188] DEBUG_PAGEALLOC
> > > > [263322.623796] Modules linked in: lirc_dev jfs xfs reiserfs ntfs vfat
> > > > fat isofs udf
> > > > [263322.714319] CPU:    0
> > > > [263322.714322] EIP:    0060:[<c014e09c>]    Not tainted VLI
> > > > [263322.714327] EFLAGS: 00010046   (2.6.21.5_VIA_EPIA_MII_12000 #1)
> > > > [263322.878840] EIP is at __set_page_dirty_nobuffers+0x6c/0x110
> > > > [263322.946480] eax: 00000000   ebx: f6fe9ea0   ecx: f6fe9ea0   edx:
> > > > c101cba0
> > > > [263323.028685] esi: c330e3c8   edi: 00000000   ebp: f71f1e98   esp:
> > > > f71f1e94
> > > > [263323.110886] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> > > > [263323.181661] Process kjournald (pid: 1362, ti=f71f0000 task=f7c87350
> > > > task.ti=f71f0000)
> > > > [263323.274252] Stack: c5bbe504 f71f1ea0 c018391f f71f1ec4 c01c7d0f
> > > > c01cd4d7 f7c87350 00000000 
> > > > [263323.376097]        f71f1ed8 c01cd7d6 e14a7c9c c330e3c8 f71f1ed0
> > > > c01c802b e14a7c9c f71f1ef8 
> > > > [263323.477943]        c01c809d f71f1ef8 c01cd87e c01cf4d6 00001000
> > > > 00002ff5 c5bbe4e0 e14a7c9c 
> > > > [263323.579789] Call Trace:
> > > > [263323.612215]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
> > > > [263323.674774]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
> > > > [263323.737337]  [<c0105889>] show_registers+0x1e9/0x2f0
> > > > [263323.797821]  [<c0105aab>] die+0x11b/0x230
> > > > [263323.846872]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
> > > > [263323.906318]  [<c0564994>] error_code+0x74/0x80
> > > > [263323.960566]  [<c018391f>] mark_buffer_dirty+0x1f/0x30
> > > > [263324.022089]  [<c01c7d0f>] __journal_temp_unlink_buffer+0x5f/0x160
> > > > [263324.096081]  [<c01c802b>] __journal_unfile_buffer+0xb/0x20
> > > > [263324.162801]  [<c01c809d>] __journal_refile_buffer+0x5d/0xa0
> > > > [263324.230558]  [<c01caa10>] journal_commit_transaction+0xb10/0x1220
> > > > [263324.304553]  [<c01cee8c>] kjournald+0x12c/0x340
> > > > [263324.359841]  [<c012d063>] kthread+0xa3/0xd0
> > > > [263324.410971]  [<c01051c7>] kernel_thread_helper+0x7/0x10
> > > > [263324.474573]  =======================
> > > > [263324.518323] Code: 00 00 00 90 8b 02 8b 4a 10 25 00 80 00 00 66 85 c0
> > > > 0f 85 a7 00 00 00 f6 c1 01 75 2e 85 c9 74 2a 39 cb 0f 85 81 00 00 00 8b
> > > > 43 38 <f6> 40 08 01 74 3d 8b 02 25 00 80 00 00 66 85 c0 75 72 8b 52 14 
> > > > [263324.751737] EIP: [<c014e09c>] __set_page_dirty_nobuffers+0x6c/0x110
> > > > SS:ESP 0068:f71f1e94
> > > > 
> > > > 
> > > > config can be found at http://zankt.net/~d-tick/kernel-2.6.21.5-config
> > > > lspci, cmdline, mount at http://zankt.net/~d-tick/voltkraft-sysinfo
> > > > 
> > > > 
> > > > older oops:
> > > > 
> > > > [190861.885741] BUG: unable to handle kernel paging request at virtual
> > > > address 01190024
> > > > [190861.978686]  printing eip:
> > > > [190862.012138] c0176026
> > > > [190862.039274] *pde = 00000000
> > > > [190862.073778] Oops: 0000 [#1]
> > > > [190862.108250] DEBUG_PAGEALLOC
> > > > [190862.142857] Modules linked in: ntfs vfat fat isofs udf
> > > > [190862.205945] CPU:    0
> > > > [190862.205948] EIP:    0060:[<c0176026>]    Not tainted VLI
> > > > [190862.205953] EFLAGS: 00010206   (2.6.21.5_VIA_EPIA_MII_12000 #1)
> > > > [190862.370464] EIP is at __d_lookup+0x66/0xf0
> > > > [190862.420439] eax: 0000d309   ebx: 01190024   ecx: 42ff6ccb   edx:
> > > > c0e5da0c
> > > > [190862.502644] esi: 01190024   edi: eb49bef4   ebp: eb49bdc4   esp:
> > > > eb49bd98
> > > > [190862.584847] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > > [190862.655619] Process du (pid: 18106, ti=eb49a000 task=e2b33770
> > > > task.ti=eb49a000)
> > > > [190862.741975] Stack: c0e5da0c ea407c60 eb49be20 e19f9134 c0121e7b
> > > > 00000019 42ff6ccb df8a9000
> > > > [190862.843822]        df8a9019 eb49be20 eb49bef4 eb49bdec c016cb34
> > > > eb49be2c eb49be20 c1894120
> > > > [190862.945665]        c016cddd df8a9000 df8a9019 eb49be20 eb49bef4
> > > > eb49be40 c016e62d eb49bef4
> > > > [190863.047511] Call Trace:
> > > > [190863.079939]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
> > > > [190863.142498]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
> > > > [190863.205060]  [<c0105889>] show_registers+0x1e9/0x2f0
> > > > [190863.265545]  [<c0105aab>] die+0x11b/0x230
> > > > [190863.314596]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
> > > > [190863.374040]  [<c0564994>] error_code+0x74/0x80
> > > > [190863.428289]  [<c016cb34>] do_lookup+0x24/0x170
> > > > [190863.482538]  [<c016e62d>] __link_path_walk+0x6ed/0xb90
> > > > [190863.545098]  [<c016eb14>] link_path_walk+0x44/0xc0
> > > > [190863.603505]  [<c016ed46>] do_path_lookup+0x76/0x1d0
> > > > [190863.662949]  [<c016f728>] __user_walk_fd+0x38/0x50
> > > > [190863.721354]  [<c016918e>] vfs_lstat_fd+0x1e/0x50
> > > > [190863.777681]  [<c0169201>] vfs_lstat+0x11/0x20
> > > > [190863.830889]  [<c0169224>] sys_lstat64+0x14/0x30
> > > > [190863.886177]  [<c0104030>] syscall_call+0x7/0xb
> > > > [190863.940424]  =======================
> > > > [190863.984175] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15
> > > > 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de
> > > > 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b
> > > > [190864.217589] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP
> > > > 0068:eb49bd98
> > > > [190993.430258] BUG: unable to handle kernel paging request at virtual
> > > > address 011a0024
> > > > [190993.523079]  printing eip:
> > > > [190993.556532] c0176026
> > > > [190993.583673] *pde = 00000000
> > > > [190993.618173] Oops: 0000 [#2]
> > > > [190993.652643] DEBUG_PAGEALLOC
> > > > [190993.687250] Modules linked in: ntfs vfat fat isofs udf
> > > > [190993.750340] CPU:    0
> > > > [190993.750343] EIP:    0060:[<c0176026>]    Not tainted VLI
> > > > [190993.750348] EFLAGS: 00010206   (2.6.21.5_VIA_EPIA_MII_12000 #1)
> > > > [190993.914860] EIP is at __d_lookup+0x66/0xf0
> > > > [190993.964835] eax: 00019758   ebx: 011a0024   ecx: 8a0a7369   edx:
> > > > c0e5d0d8
> > > > [190994.047038] esi: 011a0024   edi: da74fef4   ebp: da74fdc4   esp:
> > > > da74fd98
> > > > [190994.129240] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > > [190994.200013] Process du (pid: 18156, ti=da74e000 task=e2b32750
> > > > task.ti=da74e000)
> > > > [190994.286370] Stack: c0e5d0d8 ea407c60 da74fe20 e9a3eb04 c0121e7b
> > > > 0000001f 8a0a7369 d9215000
> > > > [190994.388216]        d921501f da74fe20 da74fef4 da74fdec c016cb34
> > > > da74fe2c da74fe20 c1894120
> > > > [190994.490061]        c016cddd d9215000 d921501f da74fe20 da74fef4
> > > > da74fe40 c016e62d da74fef4
> > > > [190994.591906] Call Trace:
> > > > [190994.624333]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
> > > > [190994.686892]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
> > > > [190994.749454]  [<c0105889>] show_registers+0x1e9/0x2f0
> > > > [190994.809939]  [<c0105aab>] die+0x11b/0x230
> > > > [190994.858990]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
> > > > [190994.918435]  [<c0564994>] error_code+0x74/0x80
> > > > [190994.972682]  [<c016cb34>] do_lookup+0x24/0x170
> > > > [190995.026931]  [<c016e62d>] __link_path_walk+0x6ed/0xb90
> > > > [190995.089492]  [<c016eb14>] link_path_walk+0x44/0xc0
> > > > [190995.147899]  [<c016ed46>] do_path_lookup+0x76/0x1d0
> > > > [190995.207343]  [<c016f728>] __user_walk_fd+0x38/0x50
> > > > [190995.265747]  [<c016918e>] vfs_lstat_fd+0x1e/0x50
> > > > [190995.322074]  [<c0169201>] vfs_lstat+0x11/0x20
> > > > [190995.375283]  [<c0169224>] sys_lstat64+0x14/0x30
> > > > [190995.430571]  [<c0104030>] syscall_call+0x7/0xb
> > > > [190995.484818]  =======================
> > > > [190995.528569] Code: 87 6d c0 d3 ea 31 d0 8b 15 94 87 6d c0 21 d0 8b 15
> > > > 9c 87 6d c0 8b 34 82 85 f6 75 0f eb 57 8d b4 26 00 00 00 00 85 db 89 de
> > > > 74 4a <8b> 1e 0f 18 03 90 8d 56 f4 8b 4d ec 89 55 d4 3b 4a 18 75 e6 8b
> > > > [190995.761982] EIP: [<c0176026>] __d_lookup+0x66/0xf0 SS:ESP
> > > > 0068:da74fd98
> > > > 
> > > > older oopses:
> > > > 
> > > > 
> > > > [2055678.634084] BUG: unable to handle kernel NULL pointer dereference
> > > > at virtual address 0000008c
> > > > [2055678.738361]  printing eip:
> > > > [2055678.772771] c01cd356
> > > > [2055678.801037] *pde = 00000000
> > > > [2055678.836707] Oops: 0000 [#1]
> > > > [2055678.872196] DEBUG_PAGEALLOC
> > > > [2055678.907844] Modules linked in: jfs xfs reiserfs ntfs vfat fat isofs
> > > > udf
> > > > [2055678.989950] CPU:    0
> > > > [2055678.989954] EIP:    0060:[<c01cd356>]    Not tainted VLI
> > > > [2055678.989959] EFLAGS: 00210286   (2.6.21.5_VIA_EPIA_MII_12000 #1)
> > > > [2055679.157595] EIP is at journal_blocks_per_page+0x6/0x20
> > > > [2055679.221174] eax: 00000000   ebx: 00000000   ecx: 0000000c   edx:
> > > > c101cba0
> > > > [2055679.304418] esi: 00000000   edi: c101cba0   ebp: d971fd0c   esp:
> > > > d971fd00
> > > > [2055679.387661] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > > [2055679.459474] Process newsbeuter (pid: 13443, ti=d971e000
> > > > task=cfc64870 task.ti=d971e000)
> > > > [2055679.555183] Stack: d971fd0c c01a243b c01a4810 d971fd40 c01a482a
> > > > d971fd40 c06990a8 00000000
> > > > [2055679.658067]        00000400 e9f5fbe8 d971fd40 c0148cd7 e9f5fbec
> > > > c01a4810 0000035e c056f420
> > > > [2055679.760952]        d971fdf0 c014a240 00000800 00000000 c101cba0
> > > > 00000001 d971fedc 00000001
> > > > [2055679.863835] Call Trace:
> > > > [2055679.897301]  [<c01055ba>] show_trace_log_lvl+0x1a/0x30
> > > > [2055679.960901]  [<c0105679>] show_stack_log_lvl+0xa9/0xd0
> > > > [2055680.024502]  [<c0105889>] show_registers+0x1e9/0x2f0
> > > > [2055680.086025]  [<c0105aab>] die+0x11b/0x230
> > > > [2055680.136117]  [<c01155e6>] do_page_fault+0x2c6/0x5d0
> > > > [2055680.196600]  [<c0564994>] error_code+0x74/0x80
> > > > [2055680.251888]  [<c01a482a>] ext3_prepare_write+0x1a/0x180
> > > > [2055680.316528]  [<c014a240>] generic_file_buffered_write+0x2b0/0x690
> > > > [2055680.391561]  [<c014a8aa>]
> > > > __generic_file_aio_write_nolock+0x28a/0x570
> > > > [2055680.470751]  [<c014abe4>] generic_file_aio_write+0x54/0xc0
> > > > [2055680.538510]  [<c01a07dd>] ext3_file_write+0x2d/0xc0
> > > > [2055680.598992]  [<c01660fd>] do_sync_write+0xcd/0x110
> > > > [2055680.658436]  [<c0166905>] vfs_write+0x95/0x110
> > > > [2055680.713725]  [<c0166e8d>] sys_write+0x3d/0x70
> > > > [2055680.767974]  [<c0104030>] syscall_call+0x7/0xb
> > > > [2055680.823260]  =======================
> > > > [2055680.868050] Code: 75 09 c7 40 04 00 00 00 00 31 d2 5d 89 d0 c3 8d
> > > > b6 00 00 00 00 8b 50 04 55 89 e5 85 d2 74 03 83 08 04 5d c3
> > > > [2055681.102502] EIP: [<c01cd356>] journal_blocks_per_page+0x6/0x20
> > > > SS:ESP 0068:d971fd00
> > > > 
> > > 
> > > -- 
> > > Mel Gorman
> > > Part-time Phd Student                          Linux Technology Center
> > > University of Limerick                         IBM Dublin Software Lab
> > > 
> > 
> 
> -- 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> 
