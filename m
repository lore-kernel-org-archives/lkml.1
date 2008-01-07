Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYAGNY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYAGNY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYAGNYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:24:17 -0500
Received: from rosi.naasa.net ([212.8.0.13]:57304 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbYAGNYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:24:15 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Mon, 7 Jan 2008 14:24:11 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <20080107111930.GB29973@elte.hu>
In-Reply-To: <20080107111930.GB29973@elte.hu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8figHp8ld9Md860"
Message-Id: <200801071424.12448.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8figHp8ld9Md860
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Am Montag, 7. Januar 2008 schrieb Ingo Molnar:

> do:
>
>   echo t > /proc/sysrq-trigger
>
> and send us the dmesg output. If the dmesg output does not include the
> bootup bits then increase CONFIG_LOG_BUF_SHIFT to 20 or so:
>
>   CONFIG_LOG_BUF_SHIFT=20
>
> to have a large enough kernel messages buffer.

The buffer was too small, hence I copied the relevant parts 
of /var/log/kern.log, I hope it contains all required information as well.

regards,
Jörg

--Boundary-00=_8figHp8ld9Md860
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

kernel:  f509eb84 f50dc700 f50f3be4 00000246 f50f3be4 f5c37b80 c01672ef 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<c01672ef>] pipe_poll+0x24/0x7f
kernel:  [<c016d53f>] do_select+0x370/0x3b9
kernel:  [<c016daf0>] __pollwait+0x0/0xa9
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
last message repeated 4 times
kernel:  [<c0146ba7>] __rmqueue+0x14/0x196
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<c015e1ef>] __slab_free+0x5b/0x279
kernel:  [<c0215e3a>] __kfree_skb+0x8/0x63
kernel:  [<c0214a2c>] sock_wfree+0x20/0x34
kernel:  [<c0216521>] skb_release_all+0xa1/0xf6
kernel:  [<f8892813>] unix_stream_recvmsg+0x3e9/0x4d6 [unix]
kernel:  [<c016d774>] core_sys_select+0x1ec/0x282
kernel:  [<c0210d34>] sock_aio_read+0xf2/0xfa
kernel:  [<c0123d9a>] recalc_sigpending+0xa/0x2d
kernel:  [<c0162077>] do_sync_read+0xc6/0x109
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<f88929a4>] unix_ioctl+0xa4/0xac [unix]
kernel:  [<c0210adb>] sock_ioctl+0x1b2/0x1d7
kernel:  [<c016dc39>] sys_select+0xa0/0x167
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  [<c0270000>] netlbl_unlabel_list+0x9f/0x1bf
kernel:  =======================
kernel: bash          R running      0  8034   7712
kernel: bash          S 000000fd     0  8062   7713
kernel:        dfcc0a80 00000082 12210264 000000fd f537ace0 01366da4 00000000 7fffffff 
kernel:        dfc77000 00000001 bf9130cf c0271f11 f78127b0 00000000 f535ffb8 f535ff90 
kernel:        f537b034 00000000 bf9130cf f535ffb8 f535f000 c010348a 00000000 080c5c60 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<c010348a>] do_notify_resume+0x81/0x5f6
kernel:  [<c01f014b>] read_chan+0x2fc/0x521
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
kernel:  [<c01efe4f>] read_chan+0x0/0x521
kernel:  [<c01ed351>] tty_read+0x6f/0xad
kernel:  [<c01ed2e2>] tty_read+0x0/0xad
kernel:  [<c01628e5>] vfs_read+0x9f/0x149
kernel:  [<c0162c74>] sys_read+0x41/0x67
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  =======================
kernel: kwalletmanage S 00000648     0  8371      1
kernel:        f4128600 00200086 fcf08470 00000648 f52fd860 0006eb74 00000000 7fffffff 
kernel:        f407a500 00000400 f4176f4c c0271f11 f414b200 00000000 00000000 00200200 
kernel:        0016e496 c0123251 f4123e00 f4176be4 00200246 f4176be4 f407a500 001672ef 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<c0123251>] process_timeout+0x0/0x5
kernel:  [<c016d53f>] do_select+0x370/0x3b9
kernel:  [<c016daf0>] __pollwait+0x0/0xa9
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
last message repeated 4 times
kernel:  [<c01abd85>] elv_insert+0xa6/0x146
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<c02131ab>] sock_alloc_send_skb+0x7c/0x193
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<c021474d>] sock_def_readable+0x31/0x6b
kernel:  [<f8892c62>] unix_stream_sendmsg+0x263/0x32c [unix]
kernel:  [<c016d774>] core_sys_select+0x1ec/0x282
kernel:  [<c0210c3a>] sock_aio_write+0xe0/0xe8
kernel:  [<c01681c4>] pipe_read+0x32c/0x338
kernel:  [<c0161f6e>] do_sync_write+0xc6/0x109
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<c01508b4>] free_pgtables+0x90/0xa0
kernel:  [<f88929a4>] unix_ioctl+0xa4/0xac [unix]
kernel:  [<c0210adb>] sock_ioctl+0x1b2/0x1d7
kernel:  [<c016dc39>] sys_select+0xa0/0x167
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  =======================
kernel: kttsd         S 00000655     0  8384      1
kernel:        dfcc0900 00200086 af7cbb2c 00000655 f52bcce0 00044e4d 00000000 7fffffff 
kernel:        f4131180 00000400 f4050f4c c0271f11 c010478b f889407c 00000000 f4ba7000 
kernel:        f416a600 00000020 f4075c40 f4050be4 00200246 f4050be4 f4131180 c01672ef 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<c010478b>] common_interrupt+0x23/0x28
kernel:  [<c01672ef>] pipe_poll+0x24/0x7f
kernel:  [<c016d53f>] do_select+0x370/0x3b9
kernel:  [<c016daf0>] __pollwait+0x0/0xa9
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
last message repeated 4 times
kernel:  [<c017e48d>] __getblk+0x14/0x1cd
kernel:  [<c0160960>] get_unused_fd_flags+0x55/0xcb
kernel:  [<f9a154ff>] ext3_getblk+0xb9/0x173 [ext3]
kernel:  [<c0218cb7>] scm_detach_fds+0xec/0x125
kernel:  [<c0218982>] __scm_destroy+0x23/0x38
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<f889357c>] unix_write_space+0x32/0x6a [unix]
kernel:  [<c0214a2c>] sock_wfree+0x20/0x34
kernel:  [<c0216521>] skb_release_all+0xa1/0xf6
kernel:  [<f8892813>] unix_stream_recvmsg+0x3e9/0x4d6 [unix]
kernel:  [<c016d774>] core_sys_select+0x1ec/0x282
kernel:  [<c0210d34>] sock_aio_read+0xf2/0xfa
kernel:  [<c0123d9a>] recalc_sigpending+0xa/0x2d
kernel:  [<c0162077>] do_sync_read+0xc6/0x109
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<f88929a4>] unix_ioctl+0xa4/0xac [unix]
kernel:  [<c0210adb>] sock_ioctl+0x1b2/0x1d7
kernel:  [<c016dc39>] sys_select+0xa0/0x167
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  [<c0270000>] netlbl_unlabel_list+0x9f/0x1bf
kernel:  =======================
kernel: konqueror     S 00000648     0  8665   7259
kernel:        f40fb000 00000086 fa0dc86a 00000648 f418d2a0 00003d78 00000000 7fffffff 
kernel:        f5049c80 00000800 f41b5f4c c0271f11 00000200 f41b5f4c 00000000 00200200 
kernel:        0016a41f c0123251 f5cf31c0 00000246 f5cf31c0 f41b5be4 f889106f 001672ef 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<c0123251>] process_timeout+0x0/0x5
kernel:  [<f889106f>] unix_poll+0x17/0x8b [unix]
kernel:  [<c016d53f>] do_select+0x370/0x3b9
kernel:  [<c016daf0>] __pollwait+0x0/0xa9
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
last message repeated 4 times
kernel:  [<c017e46f>] __find_get_block+0x13d/0x147
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c017e76b>] __set_page_dirty+0x125/0x132
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<f88927ca>] unix_stream_recvmsg+0x3a0/0x4d6 [unix]
kernel:  [<c0214a2c>] sock_wfree+0x20/0x34
kernel:  [<f88927ca>] unix_stream_recvmsg+0x3a0/0x4d6 [unix]
kernel:  [<f88927ca>] unix_stream_recvmsg+0x3a0/0x4d6 [unix]
kernel:  [<f8892813>] unix_stream_recvmsg+0x3e9/0x4d6 [unix]
kernel:  [<c016d774>] core_sys_select+0x1ec/0x282
kernel:  [<c0210d34>] sock_aio_read+0xf2/0xfa
kernel:  [<c0162077>] do_sync_read+0xc6/0x109
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<c0150079>] handle_mm_fault+0x268/0x57d
kernel:  [<f88929a4>] unix_ioctl+0xa4/0xac [unix]
kernel:  [<c0210adb>] sock_ioctl+0x1b2/0x1d7
kernel:  [<c016dc39>] sys_select+0xa0/0x167
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  [<c0270000>] netlbl_unlabel_list+0x9f/0x1bf
kernel:  =======================
kernel: kio_file      S 00000195     0 10548   7259
kernel:        f52e0d80 00000082 97e3a48e 00000195 f5032160 00000000 00000000 7fffffff 
kernel:        f4099380 00000020 f509af4c c0271f11 00000000 00000000 00000000 00000000 
kernel:        00000000 00000000 f66b1a80 00000246 f66b1a80 f509abe4 f889106f 0009abe4 
kernel: Call Trace:
kernel:  [<c0271f11>] schedule_timeout+0x13/0x8b
kernel:  [<f889106f>] unix_poll+0x17/0x8b [unix]
kernel:  [<c016d53f>] do_select+0x370/0x3b9
kernel:  [<c016daf0>] __pollwait+0x0/0xa9
kernel:  [<c0118a51>] default_wake_function+0x0/0x5
kernel:  [<c0147e3f>] __alloc_pages+0x5d/0x2d9
kernel:  [<c0146ba7>] __rmqueue+0x14/0x196
kernel:  [<c01169ce>] enqueue_entity+0x2b/0x3d
kernel:  [<c01169f6>] enqueue_task_fair+0x16/0x24
kernel:  [<c011642e>] enqueue_task+0x3f/0x4a
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<c02131ab>] sock_alloc_send_skb+0x7c/0x193
kernel:  [<c01162b8>] __wake_up_common+0x31/0x56
kernel:  [<c021474d>] sock_def_readable+0x31/0x6b
kernel:  [<f8892c62>] unix_stream_sendmsg+0x263/0x32c [unix]
kernel:  [<c016d774>] core_sys_select+0x1ec/0x282
kernel:  [<c0210c3a>] sock_aio_write+0xe0/0xe8
kernel:  [<c0161f6e>] do_sync_write+0xc6/0x109
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<c014fffc>] handle_mm_fault+0x1eb/0x57d
kernel:  [<c016dc39>] sys_select+0xa0/0x167
kernel:  [<c0162cdb>] sys_write+0x41/0x67
kernel:  [<c0103d7a>] sysenter_past_esp+0x5f/0x85
kernel:  =======================
kernel: pdflush       D f41c2f14     0 18822      2
kernel:        f673f000 00000046 00000286 f41c2f14 f5194ce0 00000286 00000286 f41c2f14 
kernel:        00175279 f41c2f6c 00000000 c0271f6c f5ff363c f5ff3644 c0354a90 c0354a90 
kernel:        00175279 c0123251 f5194b80 c03546c0 c0271f67 6c666470 00687375 00000000 
kernel: Call Trace:
kernel:  [<c0271f6c>] schedule_timeout+0x6e/0x8b
kernel:  [<c0123251>] process_timeout+0x0/0x5
kernel:  [<c0271f67>] schedule_timeout+0x69/0x8b
kernel:  [<c027179a>] __sched_text_start+0x3a/0x70
kernel:  [<c014d34b>] congestion_wait+0x4e/0x62
kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
kernel:  [<c014971e>] pdflush+0x0/0x1bf
kernel:  [<c01493c6>] wb_kupdate+0x8c/0xd1
kernel:  [<c014971e>] pdflush+0x0/0x1bf
kernel:  [<c0149839>] pdflush+0x11b/0x1bf
kernel:  [<c014933a>] wb_kupdate+0x0/0xd1
kernel:  [<c012bd71>] kthread+0x36/0x5d
kernel:  [<c012bd3b>] kthread+0x0/0x5d
kernel:  [<c010493b>] kernel_thread_helper+0x7/0x10
kernel:  =======================
kernel: Sched Debug Version: v0.07, 2.6.24-rc7 #1
kernel: now at 5394978.742321 msecs
kernel:   .sysctl_sched_latency                    : 20.000000
kernel:   .sysctl_sched_min_granularity            : 4.000000
kernel:   .sysctl_sched_wakeup_granularity         : 10.000000
kernel:   .sysctl_sched_batch_wakeup_granularity   : 10.000000
kernel:   .sysctl_sched_child_runs_first           : 0.000001
kernel:   .sysctl_sched_features                   : 7
kernel: 
kernel: cpu#0, 599.501 MHz
kernel:   .nr_running                    : 3
kernel:   .load                          : 11596
kernel:   .nr_switches                   : 3472897
kernel:   .nr_load_updates               : 789297
kernel:   .nr_uninterruptible            : 1
kernel:   .jiffies                       : 1528423
kernel:   .next_balance                  : 0.000000
kernel:   .curr->pid                     : 8034
kernel:   .clock                         : 6967153.202929
kernel:   .idle_clock                    : 4447303.677171
kernel:   .prev_clock_raw                : 4676606.867330
kernel:   .clock_warps                   : 103
kernel:   .clock_overflows               : 4982682
kernel:   .clock_deep_idle_events        : 944576
kernel:   .clock_max_delta               : 3.333116
kernel:   .cpu_load[0]                   : 11596
kernel:   .cpu_load[1]                   : 5798
kernel:   .cpu_load[2]                   : 2899
kernel:   .cpu_load[3]                   : 1450
kernel:   .cpu_load[4]                   : 744
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 1
kernel:   .load                          : 2048
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 0.000001
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 0.000001
kernel:   .spread                        : 0.000000
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 0
kernel:   .load                          : 0
kernel:   .nr_spread_over                : 0
kernel: 
kernel: cfs_rq
kernel:   .exec_clock                    : 0.000000
kernel:   .MIN_vruntime                  : 214548.087264
kernel:   .min_vruntime                  : 616382.544882
kernel:   .max_vruntime                  : 214549.007330
kernel:   .spread                        : 0.920066
kernel:   .spread0                       : 0.000000
kernel:   .nr_running                    : 3
kernel:   .load                          : 11596
kernel:   .nr_spread_over                : 0
kernel: 
kernel: runnable tasks:
kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
kernel: ----------------------------------------------------------------------------------------------------------
kernel:            klogd  4715    214548.087264      4266   120               0               0               0.000000               0.000000               0.000000
kernel:             Xorg  5872    214549.007330    983644   110               0               0               0.000000               0.000000               0.000000
kernel: R           bash  8034    214548.926777      1418   120               0               0               0.000000               0.000000               0.000000
kernel: 

--Boundary-00=_8figHp8ld9Md860--
