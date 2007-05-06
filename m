Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbXEFUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbXEFUgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXEFUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:36:40 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46692 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbXEFUgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:36:38 -0400
Message-ID: <463E3C50.9080207@simon.arlott.org.uk>
Date: Sun, 06 May 2007 21:36:32 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/07 09:49, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

Not sure exactly what's going on here, but it happened with a lock held on my 
(XFS) filesystem while compiling part of the kernel because I can't do anything 
with it now.

[ 1128.122000] BUG: sleeping function called from invalid context at block/cfq-iosched.c:1895
[ 1128.122000] in_atomic():1, irqs_disabled():0
[ 1128.122000] INFO: lockdep is turned off.
[ 1128.122000] BUG: unable to handle kernel paging request at virtual address 8b0c4034
[ 1128.122000]  printing eip:
[ 1128.122000] b0104e36
[ 1128.123000] *pde = 00000000
[ 1128.123000] Oops: 0000 [#1]
[ 1128.123000] PREEMPT
[ 1128.123000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
[ 1128.123000] CPU:    0
[ 1128.123000] EIP:    0060:[<b0104e36>]    Not tainted VLI
[ 1128.123000] EFLAGS: 00010246   (2.6.21-git #195)
[ 1128.123000] EIP is at dump_trace+0x66/0xb0
[ 1128.123000] eax: 00000000   ebx: b18f6fd0   ecx: b06323ec   edx: b05afc71
[ 1128.123000] esi: 8b0c4000   edi: 8b0c4ffd   ebp: b18f6fd0   esp: b18f6fb8
[ 1128.123000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[ 1128.123000] Process pdflush (pid: 186, ti=b18f6000 task=eff88b10 task.ti=b18f7000)
[ 1128.123000] Stack: b000205d 00000000 fffffffc b05b9937 efd1adb4 00000010 b18f6ff0 b0104f3a
[ 1128.123000]        b06323ec b05b9937 00000000 b05d33e6 efd1adb4 b05d33e6 b18f7000 b0104f62
[ 1128.123000]        b05b9937 b18f700c
[ 1128.123000] Call Trace:
[ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.123000]  [<b0104ffb>] show_stack_log_lvl+0x8b/0xb0
[ 1128.123000]  [<b0105243>] show_registers+0x1c3/0x320
[ 1128.123000]  [<b0105525>] die+0x105/0x230
[ 1128.123000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1128.123000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1128.123000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.123000]  [<b0104f62>] show_trace+0x12/0x20
[ 1128.123000]  =======================
[ 1128.123000] Code: 18 8b 4d 08 8b 45 0c 8b 53 04 ff 51 08 8b 03 39 d8 76 06 89 c3 39 f3 77 e4 8b 4d 08 ba 71 fc 5a b0 8b 45 0c ff 51 0c 85 c0 78 38 <8b> 76 34 85 f6 74 31 8d 76 00 e8 bb d7 00 00 eb b3 89 eb eb af
[ 1128.123000] EIP: [<b0104e36>] dump_trace+0x66/0xb0 SS:ESP 0068:b18f6fb8
[ 1128.126000] note: pdflush[186] exited with preempt_count 2
[ 1128.126000] BUG: unable to handle kernel paging request at virtual address 408be9ed
[ 1128.126000]  printing eip:
[ 1128.126000] b0146016
[ 1128.126000] *pde = 00000000
[ 1128.126000] Oops: 0002 [#2]
[ 1128.126000] PREEMPT
[ 1128.126000] Modules linked in: drbd mt352 saa7134_dvb dvb_pll video_buf_dvb dvb_core
[ 1128.126000] CPU:    0
[ 1128.126000] EIP:    0060:[<b0146016>]    Not tainted VLI
[ 1128.126000] EFLAGS: 00010206   (2.6.21-git #195)
[ 1128.126000] EIP is at module_put+0x16/0x50
[ 1128.126000] eax: b18f6000   ebx: b062e0e0   ecx: 00000000   edx: 408be86d
[ 1128.126000] esi: eff88b10   edi: eff88fb4   ebp: b18f6e78   esp: b18f6e70
[ 1128.126000] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[ 1128.126000] Process pdflush (pid: 186, ti=b18f6000 task=eff88b10 task.ti=b18f7000)
[ 1128.126000] Stack: eff88b10 b062e0e0 b18f6ea8 b0122bb5 b05b3888 eff88ca4 000000ba 00000002
[ 1128.126000]        fffffff5 00000001 0000000b b18f6f80 00000068 b18f6fb8 b18f6f08 b0105648
[ 1128.126000]        b05afd40 00000068 b18f6fb8 00000001 b063750b 00000000 b18f6ee8 00000286
[ 1128.126000] Call Trace:
[ 1128.126000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.126000]  [<b0104ffb>] show_stack_log_lvl+0x8b/0xb0
[ 1128.126000]  [<b0105243>] show_registers+0x1c3/0x320
[ 1128.126000]  [<b0105525>] die+0x105/0x230
[ 1128.126000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1128.126000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1128.126000]  [<b0122bb5>] do_exit+0x195/0x420
[ 1128.126000]  [<b0105648>] die+0x228/0x230
[ 1128.126000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1128.126000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1128.126000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.126000]  [<b0104f62>] show_trace+0x12/0x20
[ 1128.126000]  =======================
[ 1128.126000] Code: b0 89 44 24 08 e8 db 58 17 00 83 c4 14 5b c9 c3 90 8d 74 26 00 55 89 c2 89 e5 83 ec 08 85 c0 74 26 89 e0 25 00 f0 ff ff ff 40 14 <ff> 8a 80 01 00 00 83 3a 02 74 20 89 e0 25 00 f0 ff ff ff 48 14
[ 1128.126000] EIP: [<b0146016>] module_put+0x16/0x50 SS:ESP 0068:b18f6e70
[ 1128.130000] Fixing recursive fault but reboot is needed!
[ 1128.130000] BUG: scheduling while atomic: pdflush/0x00000003/186
[ 1128.130000] INFO: lockdep is turned off.
[ 1128.130000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.130000]  [<b0104f62>] show_trace+0x12/0x20
[ 1128.130000]  [<b0105075>] dump_stack+0x15/0x20
[ 1128.130000]  [<b04e7ffa>] schedule+0x53a/0x680
[ 1128.130000]  [<b0122db9>] do_exit+0x399/0x420
[ 1128.130000]  [<b0105648>] die+0x228/0x230
[ 1128.130000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1128.130000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1128.130000]  [<b0122bb5>] do_exit+0x195/0x420
[ 1128.130000]  [<b0105648>] die+0x228/0x230
[ 1128.130000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1128.130000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1128.130000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1128.130000]  [<b0104f62>] show_trace+0x12/0x20
[ 1128.130000]  =======================


[ 1835.716000] pdflush       D EFF88CA4     0   186      6 (L-TLB)
[ 1835.716000]        b18f6d30 00000046 b05b35d8 eff88ca4 00000003 000000ba b06614c0 efe979c0
[ 1835.716000]        b18f6cf0 b04eaa05 a9c9b480 00000106 006acfc0 00000000 e880a0d0 eff88b10
[ 1835.716000]        eff88c1c 000c3500 a9c9b480 00000106 b18f6d20 b02b4505 eff88b10 efd569c0
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b0122db9>] do_exit+0x399/0x420
[ 1835.716000]  [<b0105648>] die+0x228/0x230
[ 1835.716000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1835.716000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1835.716000]  [<b0122bb5>] do_exit+0x195/0x420
[ 1835.716000]  [<b0105648>] die+0x228/0x230
[ 1835.716000]  [<b011703f>] do_page_fault+0x2cf/0x5b0
[ 1835.716000]  [<b04eae3a>] error_code+0x6a/0x70
[ 1835.716000]  [<b0104f3a>] show_trace_log_lvl+0x1a/0x30
[ 1835.716000]  [<b0104f62>] show_trace+0x12/0x20
[ 1835.716000]  =======================


[ 1835.716000] bash          D EE7FB7B0     0 10835  10778 (NOTLB)
[ 1835.716000]        e571ce54 00200046 00000000 ee7fb7b0 b04ea8b0 00200046 00000000 ee7fb7b0
[ 1835.716000]        e571ce34 00200046 f0c70e80 00000162 00000000 00000000 df2b6af0 eb8c4070
[ 1835.716000]        eb8c417c 000186a0 f0c70e80 00000162 e571ce44 00200046 ee7fb794 ee7fb790
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b02ba4ad>] rwsem_down_failed_common+0x7d/0x170
[ 1835.716000]  [<b04ea00d>] rwsem_down_read_failed+0x1d/0x30
[ 1835.716000]  [<b04ea08f>] call_rwsem_down_read_failed+0x7/0xc
[ 1835.716000]  [<b025e79b>] xfs_ilock+0x8b/0xa0
[ 1835.716000]  [<b027e0c7>] xfs_access+0x27/0x50
[ 1835.716000]  [<b028bab5>] xfs_vn_permission+0x15/0x20
[ 1835.716000]  [<b0172ef7>] permission+0xd7/0xf0
[ 1835.716000]  [<b0172f22>] vfs_permission+0x12/0x20
[ 1835.716000]  [<b016aa40>] sys_chdir+0x30/0x60
[ 1835.716000]  [<b0104162>] sysenter_past_esp+0x5f/0x99


[ 1835.716000] bash          D EE7FB7B0     0 10857  10778 (NOTLB)
[ 1835.716000]        da276ca4 00200046 00000000 ee7fb7b0 b063701c 00200046 00000000 ee7fb7b0
[ 1835.716000]        da276c84 00200046 00000000 b02ba4a6 da276c84 b0140285 00200046 d9c55510
[ 1835.716000]        d9c5561c 00000000 0e8cad80 00000172 da276c94 00200046 ee7fb794 ee7fb790
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b02ba4ad>] rwsem_down_failed_common+0x7d/0x170
[ 1835.716000]  [<b04ea00d>] rwsem_down_read_failed+0x1d/0x30
[ 1835.716000]  [<b04ea08f>] call_rwsem_down_read_failed+0x7/0xc
[ 1835.716000]  [<b025e79b>] xfs_ilock+0x8b/0xa0
[ 1835.716000]  [<b027e0c7>] xfs_access+0x27/0x50
[ 1835.716000]  [<b028bab5>] xfs_vn_permission+0x15/0x20
[ 1835.716000]  [<b0172ef7>] permission+0xd7/0xf0
[ 1835.716000]  [<b0172f22>] vfs_permission+0x12/0x20
[ 1835.716000]  [<b017389a>] __link_path_walk+0x32a/0xcb0
[ 1835.716000]  [<b017425c>] link_path_walk+0x3c/0xb0
[ 1835.716000]  [<b01745a1>] do_path_lookup+0x121/0x1d0
[ 1835.716000]  [<b0174ad5>] __user_walk_fd+0x45/0x60
[ 1835.716000]  [<b016f011>] vfs_stat_fd+0x21/0x60
[ 1835.716000]  [<b016f064>] vfs_stat+0x14/0x20
[ 1835.716000]  [<b016f754>] sys_stat64+0x14/0x30
[ 1835.716000]  [<b0104162>] sysenter_past_esp+0x5f/0x99


[ 1835.716000] make          D EA5A29F0     0 16283      1 (NOTLB)
[ 1835.716000]        c8ed4ca4 00000046 00000000 ea5a29f0 011a3008 00000046 00000000 ea5a29f0
[ 1835.716000]        c8ed4c84 00000046 d936d840 00000158 00000000 00000000 d13280b0 cae91590
[ 1835.716000]        cae9169c 00000000 d936d840 00000158 c8ed4c94 00000046 ea5a29d4 ea5a29d0
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b02ba4ad>] rwsem_down_failed_common+0x7d/0x170
[ 1835.716000]  [<b04ea00d>] rwsem_down_read_failed+0x1d/0x30
[ 1835.716000]  [<b04ea08f>] call_rwsem_down_read_failed+0x7/0xc
[ 1835.716000]  [<b025e79b>] xfs_ilock+0x8b/0xa0
[ 1835.716000]  [<b027e0c7>] xfs_access+0x27/0x50
[ 1835.716000]  [<b028bab5>] xfs_vn_permission+0x15/0x20
[ 1835.716000]  [<b0172ef7>] permission+0xd7/0xf0
[ 1835.716000]  [<b0172f22>] vfs_permission+0x12/0x20
[ 1835.716000]  [<b017389a>] __link_path_walk+0x32a/0xcb0
[ 1835.716000]  [<b017425c>] link_path_walk+0x3c/0xb0
[ 1835.716000]  [<b01745a1>] do_path_lookup+0x121/0x1d0
[ 1835.716000]  [<b0174ad5>] __user_walk_fd+0x45/0x60
[ 1835.716000]  [<b016f011>] vfs_stat_fd+0x21/0x60
[ 1835.716000]  [<b016f064>] vfs_stat+0x14/0x20
[ 1835.716000]  [<b016f754>] sys_stat64+0x14/0x30
[ 1835.716000]  [<b0104162>] sysenter_past_esp+0x5f/0x99
[ 1835.716000]  =======================


[ 1835.716000] sh            ? B0122849     0 16284  16283 (L-TLB)
[ 1835.716000]        d64dae50 00000046 00000000 b0122849 d64dae10 b0140285 b18e14b0 c8de4030
[ 1835.716000]        00000001 00000046 b067ca18 00000010 d64dae20 00000046 b067ca00 c8de4030
[ 1835.716000]        c8de413c 00000000 63ea8bc0 0000015a d64dae50 b0122849 d64dae38 d64dae38
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b0122c62>] do_exit+0x242/0x420
[ 1835.716000]  [<b0122eab>] do_group_exit+0x2b/0x80
[ 1835.716000]  [<b012c8fb>] get_signal_to_deliver+0x20b/0x2a0
[ 1835.716000]  [<b0103f2b>] do_signal+0x5b/0x160
[ 1835.716000]  [<b010406d>] do_notify_resume+0x3d/0x40
[ 1835.716000]  [<b01042b5>] work_notifysig+0x13/0x1a
[ 1835.716000]  =======================


[ 1835.716000] sh            D EE23D7E0     0 16292      1 (NOTLB)
[ 1835.716000]        c8a87a20 00000046 00000000 ee23d7e0 c8a879d0 b0269e6f 00000000 00000000
[ 1835.716000]        00000000 c8b8f510 00000000 ef3d59dc c8a87a10 00000046 c8de4030 c8b8f510
[ 1835.716000]        c8b8f61c 0003d090 f56d1bc0 00000106 c8a87a20 b0140285 00000000 ee86a474
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
[ 1835.716000]  [<b026c2b9>] xlog_state_sync_all+0xc9/0x210
[ 1835.716000]  [<b026928c>] _xfs_log_force+0x5c/0x70
[ 1835.716000]  [<b025e075>] xfs_iget_core+0x425/0x5f0
[ 1835.716000]  [<b025e2f1>] xfs_iget+0xb1/0x110
[ 1835.716000]  [<b0278e18>] xfs_trans_iget+0xa8/0x140
[ 1835.716000]  [<b02604cf>] xfs_ialloc+0xaf/0x4c0
[ 1835.716000]  [<b027986d>] xfs_dir_ialloc+0x6d/0x280
[ 1835.716000]  [<b027f6de>] xfs_create+0x24e/0x680
[ 1835.716000]  [<b028b413>] xfs_vn_mknod+0x233/0x390
[ 1835.716000]  [<b028b582>] xfs_vn_create+0x12/0x20
[ 1835.716000]  [<b0174dbd>] vfs_create+0x7d/0xd0
[ 1835.716000]  [<b017502d>] open_namei_create+0x4d/0xa0
[ 1835.716000]  [<b01755a3>] open_namei+0x523/0x560
[ 1835.716000]  [<b016b1ac>] do_filp_open+0x2c/0x60
[ 1835.716000]  [<b016b500>] do_sys_open+0x50/0xe0
[ 1835.716000]  [<b016b5ac>] sys_open+0x1c/0x20
[ 1835.716000]  [<b0104162>] sysenter_past_esp+0x5f/0x99


[ 1835.716000] cc1           D EE23D6A0     0 16377  16376 (NOTLB)
[ 1835.716000]        cd885a20 00000046 00000000 ee23d6a0 cd8859d0 b0269e6f 00000000 00000000
[ 1835.716000]        00000000 cd1180f0 00000000 ef3d591c cd885a10 00000046 cd119570 cd1180f0
[ 1835.716000]        cd1181fc 004c4b40 b8720100 0000015f cd885a20 b0140285 00000000 ee86a474
[ 1835.716000] Call Trace:
[ 1835.716000]  [<b04e8a0a>] schedule_timeout+0x8a/0x90
[ 1835.716000]  [<b026c2b9>] xlog_state_sync_all+0xc9/0x210
[ 1835.716000]  [<b026928c>] _xfs_log_force+0x5c/0x70
[ 1835.716000]  [<b025e075>] xfs_iget_core+0x425/0x5f0
[ 1835.716000]  [<b025e2f1>] xfs_iget+0xb1/0x110
[ 1835.716000]  [<b0278e18>] xfs_trans_iget+0xa8/0x140
[ 1835.716000]  [<b02604cf>] xfs_ialloc+0xaf/0x4c0
[ 1835.716000]  [<b027986d>] xfs_dir_ialloc+0x6d/0x280
[ 1835.716000]  [<b027f6de>] xfs_create+0x24e/0x680
[ 1835.716000]  [<b028b413>] xfs_vn_mknod+0x233/0x390
[ 1835.716000]  [<b028b582>] xfs_vn_create+0x12/0x20
[ 1835.716000]  [<b0174dbd>] vfs_create+0x7d/0xd0
[ 1835.716000]  [<b017502d>] open_namei_create+0x4d/0xa0
[ 1835.716000]  [<b01755a3>] open_namei+0x523/0x560
[ 1835.716000]  [<b016b1ac>] do_filp_open+0x2c/0x60
[ 1835.716000]  [<b016b500>] do_sys_open+0x50/0xe0
[ 1835.716000]  [<b016b5ac>] sys_open+0x1c/0x20
[ 1835.716000]  [<b0104162>] sysenter_past_esp+0x5f/0x99
[ 1835.716000]  =======================

-- 
Simon Arlott
