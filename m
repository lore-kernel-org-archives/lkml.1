Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbYASSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbYASSxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYASSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:53:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:62783 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYASSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PVAxkjm0p9I12SCFmOxkDWpGRs3btAZx5pHgQ181yYs4mh2ycr7sb98Y5HDYM/u2djM6/2Yjtb6uPG1E2qTN8+k3j/cVcnAZyR4A4zJWcG5bpSgrggc3YpTf1DBX/mzBjYgVc4zQW63FV+w3jdo2E23oSSGwsjCzpZmQeXL7JEs=
Message-ID: <6101e8c40801191053j7e81988fm8aaf0a75fb8bd405@mail.gmail.com>
Date: Sat, 19 Jan 2008 19:53:08 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: konqueror deadlocks on 2.6.22
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200801192114.41427.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192114.41427.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel is vanilla 2.6.22.y or with CFS?

On 1/19/08, Al Boldi <a1426z@gawab.com> wrote:
> I was just attacked by some deadlock issue involving sqlite3 and konqueror.
> While sqlite3 continues to slowly fill a 7M-record db in transaction mode,
> konqueror hangs for a few minutes, then continues only to hang again and
> again.
>
> Looks like an fs/blockIO issue involving fsync.
>
> As a workaround, is there a way to make fsync soft?
>
>
> Thanks!
>
> --
> Al
>
> ---
> Jan 19 20:36:13 localhost kernel: SysRq : Show Blocked State
> Jan 19 20:36:13 localhost kernel:   task                PC stack   pid
> father
> Jan 19 20:36:13 localhost kernel: kjournald     D c153b4c0     0   951
> 2
> Jan 19 20:36:13 localhost kernel:        c1579d70 00000046 00000010 c153b4c0
> c153b5fc 00000000 c1579dbc 00000001
> Jan 19 20:36:13 localhost kernel:        c1579d78 c03f163e c1527848 c0216d50
> 00000010 c1527878 00000001 d7ca8dc0
> Jan 19 20:36:13 localhost kernel:        00000000 c153b4c0 c012dcb0 c1579dbc
> c1579dbc 00000001 d62092c0 d7ca8dc0
> Jan 19 20:36:13 localhost kernel: Call Trace:
> Jan 19 20:36:13 localhost kernel:  [<c03f163e>] io_schedule+0xe/0x20
> Jan 19 20:36:13 localhost kernel:  [<c0216d50>] get_request_wait+0x100/0x120
> Jan 19 20:36:13 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:13 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:13 localhost kernel:  [<c021383a>] elv_merge+0xba/0x150
> Jan 19 20:36:13 localhost kernel:  [<c021779c>] __make_request+0x6c/0x2f0
> Jan 19 20:36:13 localhost kernel:  [<c0217bef>]
> generic_make_request+0x13f/0x1d0
> Jan 19 20:36:14 localhost kernel:  [<c015a847>] __slab_alloc+0x87/0xf0
> Jan 19 20:36:14 localhost kernel:  [<c014450a>] mempool_alloc+0x2a/0xc0
> Jan 19 20:36:14 localhost kernel:  [<c0217cc6>] submit_bio+0x46/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c0111bb8>]
> smp_apic_timer_interrupt+0x28/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01048f4>]
> apic_timer_interrupt+0x28/0x30
> Jan 19 20:36:14 localhost kernel:  [<c017ebff>] bio_alloc_bioset+0x7f/0x160
> Jan 19 20:36:14 localhost kernel:  [<c017b5e0>]
> end_buffer_write_sync+0x0/0x70
> Jan 19 20:36:14 localhost kernel:  [<c017e541>] submit_bh+0xd1/0x130
> Jan 19 20:36:14 localhost kernel:  [<c01a73c9>]
> journal_do_submit_data+0x29/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01a74e5>]
> journal_submit_data_buffers+0x115/0x170
> Jan 19 20:36:14 localhost kernel:  [<c01a76ef>]
> journal_commit_transaction+0x1af/0xc30
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c01a9ed7>] kjournald+0x197/0x1e0
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c01a9d40>] kjournald+0x0/0x1e0
> Jan 19 20:36:14 localhost kernel:  [<c012d89a>] kthread+0x6a/0x70
> Jan 19 20:36:14 localhost kernel:  [<c012d830>] kthread+0x0/0x70
> Jan 19 20:36:14 localhost kernel:  [<c0104a77>]
> kernel_thread_helper+0x7/0x10
> Jan 19 20:36:14 localhost kernel:  =======================
> Jan 19 20:36:14 localhost kernel: konqueror     D c14b39f0     0  1922
> 1918
> Jan 19 20:36:14 localhost kernel:        dbb13e08 00000082 dbb13e08 c14b39f0
> c14b3b2c c1517f40 c1517f00 0009813c
> Jan 19 20:36:14 localhost kernel:        dbb13e3c c01aa5e1 00000000 c1517f50
> 00000000 00000000 c14b39f0 c012dcb0
> Jan 19 20:36:14 localhost kernel:        dbb13e48 dbb13e48 c1517f50 00000001
> 00000003 00000000 c14b39f0 c012dcb0
> Jan 19 20:36:14 localhost kernel: Call Trace:
> Jan 19 20:36:14 localhost kernel:  [<c01aa5e1>] log_wait_commit+0xf1/0x140
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c01a6866>] journal_stop+0x146/0x1c0
> Jan 19 20:36:14 localhost kernel:  [<c01a57d3>] journal_start+0x93/0xc0
> Jan 19 20:36:14 localhost kernel:  [<c0147250>] __writepage+0x0/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01a68fc>]
> journal_force_commit+0x1c/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01a2e85>] ext3_force_commit+0x25/0x30
> Jan 19 20:36:14 localhost kernel:  [<c017807b>] write_inode+0x4b/0x50
> Jan 19 20:36:14 localhost kernel:  [<c0178223>]
> __sync_single_inode+0x1a3/0x1d0
> Jan 19 20:36:14 localhost kernel:  [<c017829e>]
> __writeback_single_inode+0x4e/0x1b0
> Jan 19 20:36:14 localhost kernel:  [<c01472fd>] do_writepages+0x3d/0x50
> Jan 19 20:36:14 localhost kernel:  [<c0141207>]
> __filemap_fdatawrite_range+0x87/0x90
> Jan 19 20:36:14 localhost kernel:  [<c01982c8>] ext3_sync_file+0x98/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c0141233>] filemap_fdatawrite+0x23/0x30
> Jan 19 20:36:14 localhost kernel:  [<c017aced>] do_fsync+0x6d/0x90
> Jan 19 20:36:14 localhost kernel:  [<c017ad37>] __do_fsync+0x27/0x50
> Jan 19 20:36:14 localhost kernel:  [<c0103f1e>] syscall_call+0x7/0xb
> Jan 19 20:36:14 localhost kernel:  [<c03f0000>] svc_seq_show+0x110/0x120
> Jan 19 20:36:14 localhost kernel:  =======================
> Jan 19 20:36:14 localhost kernel: sqlite3       D c4aa4000     0  5507
> 2021
> Jan 19 20:36:14 localhost kernel:        dd53bbf0 00200082 c0217bef c4aa4000
> c4aa413c dd53bc40 00000000 dd53bc48
> Jan 19 20:36:14 localhost kernel:        dd53bbf8 c03f163e c13e0758 c017b4b7
> c03f17d5 c017b490 c89c3690 00000002
> Jan 19 20:36:14 localhost kernel:        c4aa4000 c017b490 c03f1882 00000002
> c89c3690 00000002 00000000 c4aa4000
> Jan 19 20:36:14 localhost kernel: Call Trace:
> Jan 19 20:36:14 localhost kernel:  [<c0217bef>]
> generic_make_request+0x13f/0x1d0
> Jan 19 20:36:14 localhost kernel:  [<c03f163e>] io_schedule+0xe/0x20
> Jan 19 20:36:14 localhost kernel:  [<c017b4b7>] sync_buffer+0x27/0x40
> Jan 19 20:36:14 localhost kernel:  [<c03f17d5>] __wait_on_bit+0x65/0x70
> Jan 19 20:36:14 localhost kernel:  [<c017b490>] sync_buffer+0x0/0x40
> Jan 19 20:36:14 localhost kernel:  [<c017b490>] sync_buffer+0x0/0x40
> Jan 19 20:36:14 localhost kernel:  [<c03f1882>]
> out_of_line_wait_on_bit+0xa2/0xc0
> Jan 19 20:36:14 localhost kernel:  [<c012dd00>] wake_bit_function+0x0/0x60
> Jan 19 20:36:14 localhost kernel:  [<c012dd00>] wake_bit_function+0x0/0x60
> Jan 19 20:36:14 localhost kernel:  [<c017b550>] __wait_on_buffer+0x30/0x40
> Jan 19 20:36:14 localhost kernel:  [<c017e6b7>] sync_dirty_buffer+0x67/0xf0
> Jan 19 20:36:14 localhost kernel:  [<c01a6365>]
> journal_dirty_data+0x145/0x170
> Jan 19 20:36:14 localhost kernel:  [<c019a568>]
> ext3_journal_dirty_data+0x18/0x50
> Jan 19 20:36:14 localhost kernel:  [<c019a370>] walk_page_buffers+0x70/0x80
> Jan 19 20:36:14 localhost kernel:  [<c019a62e>]
> ext3_ordered_commit_write+0x5e/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c019a550>]
> ext3_journal_dirty_data+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c014334d>]
> generic_file_buffered_write+0x27d/0x630
> Jan 19 20:36:14 localhost kernel:  [<c01a6858>] journal_stop+0x138/0x1c0
> Jan 19 20:36:14 localhost kernel:  [<c019cc7b>]
> ext3_mark_inode_dirty+0x3b/0x40
> Jan 19 20:36:14 localhost kernel:  [<c0147d60>]
> __do_page_cache_readahead+0x60/0x100
> Jan 19 20:36:14 localhost kernel:  [<c0170289>] file_update_time+0x49/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c014397f>]
> __generic_file_aio_write_nolock+0x27f/0x540
> Jan 19 20:36:14 localhost kernel:  [<c0143d67>]
> generic_file_aio_write+0x67/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c0142483>]
> generic_file_aio_read+0x143/0x170
> Jan 19 20:36:14 localhost kernel:  [<c0198190>] ext3_file_write+0x30/0xd0
> Jan 19 20:36:14 localhost kernel:  [<c015d9f0>] do_sync_write+0xc0/0x100
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c02e95e9>]
> scsi_finish_command+0x39/0x60
> Jan 19 20:36:14 localhost kernel:  [<c02ee137>] scsi_softirq_done+0x77/0xe0
> Jan 19 20:36:14 localhost kernel:  [<c015d2f5>]
> generic_file_llseek+0x95/0xd0
> Jan 19 20:36:14 localhost kernel:  [<c015d930>] do_sync_write+0x0/0x100
> Jan 19 20:36:14 localhost kernel:  [<c015dad7>] vfs_write+0xa7/0x120
> Jan 19 20:36:14 localhost kernel:  [<c015dc17>] sys_write+0x47/0x80
> Jan 19 20:36:14 localhost kernel:  [<c0103f1e>] syscall_call+0x7/0xb
> Jan 19 20:36:14 localhost kernel:  =======================
> Jan 19 20:36:14 localhost kernel: pdflush       D ce384a60     0  6381
> 2
> Jan 19 20:36:14 localhost kernel:        cd7bdec8 00000046 cd7bded8 ce384a60
> ce384b9c cd7bded8 03b52325 cd7bdf2c
> Jan 19 20:36:14 localhost kernel:        cd7bdf04 c03f16db ce384a60 cc45aa80
> c0552e90 c0552e90 03b52325 c0124840
> Jan 19 20:36:14 localhost kernel:        ce384a60 c0552d60 00001e35 00000000
> 00000064 c04d90d0 c03f165e 00000000
> Jan 19 20:36:14 localhost kernel: Call Trace:
> Jan 19 20:36:14 localhost kernel:  [<c03f16db>] schedule_timeout+0x4b/0xa0
> Jan 19 20:36:14 localhost kernel:  [<c0124840>] process_timeout+0x0/0x10
> Jan 19 20:36:14 localhost kernel:  [<c03f165e>] io_schedule_timeout+0xe/0x20
> Jan 19 20:36:14 localhost kernel:  [<c014b61b>] congestion_wait+0x8b/0xa0
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c012dcb0>]
> autoremove_wake_function+0x0/0x50
> Jan 19 20:36:14 localhost kernel:  [<c01786c4>] writeback_inodes+0x54/0x80
> Jan 19 20:36:14 localhost kernel:  [<c0146de2>] wb_kupdate+0xa2/0xf0
> Jan 19 20:36:14 localhost kernel:  [<c014790e>] __pdflush+0xae/0x160
> Jan 19 20:36:14 localhost kernel:  [<c01479c0>] pdflush+0x0/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01479c0>] pdflush+0x0/0x30
> Jan 19 20:36:14 localhost kernel:  [<c01479e3>] pdflush+0x23/0x30
> Jan 19 20:36:14 localhost kernel:  [<c0146d40>] wb_kupdate+0x0/0xf0
> Jan 19 20:36:14 localhost kernel:  [<c012d89a>] kthread+0x6a/0x70
> Jan 19 20:36:14 localhost kernel:  [<c012d830>] kthread+0x0/0x70
> Jan 19 20:36:14 localhost kernel:  [<c0104a77>]
> kernel_thread_helper+0x7/0x10
> Jan 19 20:36:14 localhost kernel:  =======================
> Jan 19 20:36:14 localhost kernel: Sched Debug Version: v0.05-v20.4, 2.6.22
> #11
> Jan 19 20:36:14 localhost kernel: now at 62472243502739 nsecs
> Jan 19 20:36:14 localhost kernel:
> Jan 19 20:36:14 localhost kernel: cpu#0, 3000.368 MHz
> Jan 19 20:36:14 localhost kernel:   .nr_running                    : 2
> Jan 19 20:36:14 localhost kernel:   .load                          : 4145
> Jan 19 20:36:14 localhost kernel:   .ls.delta_fair                 : 0
> Jan 19 20:36:14 localhost kernel:   .ls.delta_exec                 : 0
> Jan 19 20:36:14 localhost kernel:   .nr_switches                   :
> 33411314
> Jan 19 20:36:14 localhost kernel:   .nr_load_updates               :
> 62502647
> Jan 19 20:36:14 localhost kernel:   .nr_uninterruptible            : 4
> Jan 19 20:36:14 localhost kernel:   .jiffies                       :
> 62202647
> Jan 19 20:36:14 localhost kernel:   .next_balance                  : 0
> Jan 19 20:36:14 localhost kernel:   .curr->pid                     : 0
> Jan 19 20:36:14 localhost kernel:   .clock                         :
> 62493147453426
> Jan 19 20:36:14 localhost kernel:   .idle_clock                    : 0
> Jan 19 20:36:14 localhost kernel:   .prev_clock_raw                :
> 27221561477728
> Jan 19 20:36:14 localhost kernel:   .clock_warps                   : 2
> Jan 19 20:36:14 localhost kernel:   .clock_overflows               : 3461066
> Jan 19 20:36:14 localhost kernel:   .clock_deep_idle_events        : 0
> Jan 19 20:36:14 localhost kernel:   .clock_max_delta               : 999846
> Jan 19 20:36:14 localhost kernel:   .cpu_load[0]                   : 0
> Jan 19 20:36:14 localhost kernel:   .cpu_load[1]                   : 0
> Jan 19 20:36:14 localhost kernel:   .cpu_load[2]                   : 0
> Jan 19 20:36:14 localhost kernel:   .cpu_load[3]                   : 0
> Jan 19 20:36:14 localhost kernel:   .cpu_load[4]                   : 0
> Jan 19 20:36:14 localhost kernel:
> Jan 19 20:36:14 localhost kernel: cfs_rq
> Jan 19 20:36:14 localhost kernel:   .fair_clock                    :
> 6470841940805
> Jan 19 20:36:14 localhost kernel:   .exec_clock                    :
> 8802399638656
> Jan 19 20:36:14 localhost kernel:   .wait_runtime                  :
> -33767489
> Jan 19 20:36:14 localhost kernel:   .wait_runtime_overruns         : 0
> Jan 19 20:36:14 localhost kernel:   .wait_runtime_underruns        : 0
> Jan 19 20:36:14 localhost kernel:   .sleeper_bonus                 : 0
> Jan 19 20:36:14 localhost kernel:   .wait_runtime_rq_sum           : 6226413
> Jan 19 20:36:14 localhost kernel:
> Jan 19 20:36:14 localhost kernel: runnable tasks:
> Jan 19 20:36:14 localhost kernel:             task   PID        tree-key
>     delta       waiting  switches  prio        sum-exec        sum-wait
>  sum-sleep    wait-overrun   wait-underrun
> Jan 19 20:36:14 localhost kernel:
> ------------------------------------------------------------------------------------------------------------------------------------------------------------------
> Jan 19 20:36:14 localhost kernel:         events/0     4   6470840086822
>  -1853983       5650666     83829   115               0               0
>          0               0               0
> Jan 19 20:36:14 localhost kernel:            klogd  1419   6470841365058
>   -575747        575747      1869   120               0               0
>          0               0               0
> Jan 19 20:36:14 localhost kernel:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
