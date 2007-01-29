Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXA2WCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXA2WCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXA2WCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:02:41 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:22297 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXA2WCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:02:38 -0500
X-IronPort-AV: i="4.13,253,1167627600"; 
   d="scan'208"; a="399654202:sNHT2339119924"
From: "Matthew Kirk" <mkirk01@rcn.com>
To: "'Andrew Morton'" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
References: <001a01c74136$0028ecf0$6600a8c0@charm> <20070126031654.a41fe374.akpm@osdl.org>
Subject: RE: fsync occasionally very slow
Date: Mon, 29 Jan 2007 17:02:14 -0500
Message-ID: <002701c743f1$2271c850$6600a8c0@charm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070126031654.a41fe374.akpm@osdl.org>
Thread-Index: AcdBO4JmoSoJJ6VJQD2VrzXdKeDUzQCs9gBA
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A090205.45BE6EEA.001F,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2006-05-09 23:27:51,
	dmn=5.2.125/2006-10-10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding the long fsyncs, here's a trace...

I upgraded to a more recent kernel - 2.6.18.6 - and ran it on a workstation.
This particular box has In this case the elevator is CFQ.

This sample came from a stall that lasted about 2.5 minutes(!) - the longest
one I've seen yet.  The box is a bit more memory constrained than the
original system but exhibits similar behavior.  It doesn't page.  Also,
there is no raid card - simply striped PATA drives.

Thanks!
Matt

2          5407  5405 (NOTLB)
       e2cf9eb4 00000086 00000001 00000286 c0141c54 c1467ec0 00000000
c18084e0 
       c04ea4e0 e06c7680 00000000 00003c4f 6cd9179d 0000001b c040e3e0
e06c7570 
       7fffffff 08a4b310 c04ff5d0 00000001 c02d06ba c012e965 f7fdb3c0
08a4b000 
Call Trace:
 [<c0141c54>] buffered_rmqueue+0x13a/0x173
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c012e965>] get_futex_key+0x3d/0xd3
 [<c012baa1>] add_wait_queue+0x12/0x30
 [<c012f9f4>] futex_wait+0x18c/0x1f2
 [<c014ac97>] __handle_mm_fault+0x185/0x28c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c013061d>] do_futex+0x35/0x95
 [<c0130778>] sys_futex+0xfb/0x10a
 [<c0114386>] schedule_tail+0x2e/0x81
 [<c01028e5>] sysenter_past_esp+0x56/0x79
PolicyScrubbe S 2C3D55DE     0  5407   5392          5408  5406 (NOTLB)
       e1ea5f2c 00000086 c012e032 2c3d55de 000001de 00000003 f6c9b570
c18084e0 
       c04ea4e0 e06c7140 00000000 00000bbe 2c3d55de 000001de f6c9b570
e06c7030 
       e1ea5f68 00000000 00000001 af637014 c02d0aec e1ea5f68 09bdcead
000001dd 
Call Trace:
 [<c012e032>] enqueue_hrtimer+0x58/0x7f
 [<c02d0aec>] do_nanosleep+0x40/0x6d
 [<c012e3e1>] hrtimer_nanosleep+0x4c/0xe9
 [<c0126396>] sys_rt_sigaction+0x76/0x8d
 [<c012e366>] hrtimer_wakeup+0x0/0x1c
 [<c012e4c2>] sys_nanosleep+0x44/0x4f
 [<c01028e5>] sysenter_past_esp+0x56/0x79
PolicyScrubbe S 00000000     0  5408   5392                5407 (NOTLB)
       de739b50 00000086 e4d15030 00000000 00000213 00000000 e4d15030
c18084e0 
       c04ea4e0 e1ee3bc0 00000000 00000764 299782a2 000001c2 e4d15030
e1ee3ab0 
       de739b60 00099160 00001000 00000000 c02d0716 de739b60 00099160
c04fdcc0 
Call Trace:
 [<c02d0716>] schedule_timeout+0x6f/0x8e
 [<c01234b2>] process_timeout+0x0/0x9
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b5e>] __wake_up_common+0x2f/0x4b
 [<c0115ba1>] __wake_up+0x27/0x3b
 [<c026c573>] sock_def_readable+0x33/0x61
 [<c029c433>] tcp_rcv_established+0x382/0x5da
 [<c02a332d>] tcp_v4_do_rcv+0x1f/0xb5
 [<c02a38ec>] tcp_v4_rcv+0x529/0x86f
 [<c011386c>] activate_task+0x55/0xa2
 [<c0113769>] __activate_task+0x1e/0x30
 [<c0113925>] resched_task+0x41/0x63
 [<c011401e>] try_to_wake_up+0x2ab/0x2b6
 [<c026d1c3>] __alloc_skb+0x49/0xf0
 [<c0115b5e>] __wake_up_common+0x2f/0x4b
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c026ec50>] skb_dequeue+0x3b/0x41
 [<c02c65f8>] unix_stream_recvmsg+0xd1/0x350
 [<c02c67f1>] unix_stream_recvmsg+0x2ca/0x350
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c02cfee7>] schedule+0x60b/0x625
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c012e965>] get_futex_key+0x3d/0xd3
 [<c012f7e9>] unqueue_me+0x84/0x8b
 [<c012fa10>] futex_wait+0x1a8/0x1f2
 [<c014cb5a>] find_extend_vma+0x17/0x58
 [<c012e965>] get_futex_key+0x3d/0xd3
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a882>] sys_select+0x9d/0x161
 [<c011e597>] sys_gettimeofday+0x22/0x55
 [<c01028e5>] sysenter_past_esp+0x56/0x79
gnome-termina S 1FC984CA     0  5410      1  5411    5413  5396 (NOTLB)
       df785bd0 00000082 c01e93d8 1fc984ca 000001df 00000002 e4509570
c18084e0 
       c04ea4e0 e1ee3140 00000000 0000022f 1fca0963 000001df e4509570
e1ee3030 
       df785be0 0006ab15 e45b1980 00000000 c02d0716 df785be0 0006ab15
c04fd238 
Call Trace:
 [<c01e93d8>] tty_ldisc_try+0x33/0x38
 [<c02d0716>] schedule_timeout+0x6f/0x8e
 [<c01234b2>] process_timeout+0x0/0x9
 [<c016acff>] do_poll+0x15b/0x19a
 [<c016aeb3>] do_sys_poll+0x175/0x21b
 [<c026d1c3>] __alloc_skb+0x49/0xf0
 [<c011386c>] activate_task+0x55/0xa2
 [<c0113769>] __activate_task+0x1e/0x30
 [<c02d13a6>] _spin_lock+0xd/0x59
 [<c011356f>] task_rq_lock+0x2c/0x52
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c011401e>] try_to_wake_up+0x2ab/0x2b6
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0159ab0>] do_sync_write+0xbe/0xf1
 [<c02c6a5a>] unix_ioctl+0xa4/0xb2
 [<c0269b03>] sock_ioctl+0x1a6/0x1c3
 [<c0169804>] do_ioctl+0x28/0x65
 [<c012274f>] do_gettimeofday+0x2e/0x117
 [<c01cf017>] copy_to_user+0x38/0x42
 [<c016af9c>] sys_poll+0x43/0x47
 [<c01028e5>] sysenter_past_esp+0x56/0x79
gnome-termina S BAC48363     0  5413      1          5443  5410 (NOTLB)
       f1491ec4 00000082 00000000 bac48363 0000001b 00000003 e6672570
c18084e0 
       c04ea4e0 dd45c680 00000000 00002a5d bac48363 0000001b e6672570
dd45c570 
       e6f3b400 b792f3e0 f1491eec e6f3b400 c016415d 00000000 dd45c570
c012bc09 
Call Trace:
 [<c016415d>] pipe_wait+0x6d/0x8e
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c01645e0>] pipe_readv+0x209/0x275
 [<c0164671>] pipe_read+0x25/0x29
 [<c015995c>] vfs_read+0x87/0x11d
 [<c0159c3b>] sys_read+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
gnome-pty-hel S C019B2D0     0  5411   5410          5412       (NOTLB)
       df7bfd4c 00000086 00000b80 c019b2d0 f75453c4 00000000 e1ee3030
c18084e0 
       c04ea4e0 e1ee3680 00000000 00004eb4 b9572a54 0000001b e1ee3030
e1ee3570 
       7fffffff dfaf3a80 df7bfd94 7fffffff c02d06ba 00000180 00000a00
7fffffff 
Call Trace:
 [<c019b2d0>] __ext3_journal_stop+0x19/0x37
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c012bb34>] prepare_to_wait+0x12/0x4c
 [<c02c64ef>] unix_stream_data_wait+0xb8/0xf0
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c0197998>] ext3_dirty_inode+0x5d/0x63
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c02c6663>] unix_stream_recvmsg+0x13c/0x350
 [<c02695d7>] do_sock_read+0x83/0x8b
 [<c0269723>] sock_aio_read+0x56/0x64
 [<c01598a2>] do_sync_read+0xbe/0xf1
 [<c012ddd3>] ktime_get_ts+0x4b/0x51
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c0171ca7>] mntput_no_expire+0x14/0x6c
 [<c015a78c>] __fput+0x150/0x157
 [<c0159967>] vfs_read+0x92/0x11d
 [<c0159c3b>] sys_read+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
bash          S 57E802AC     0  5412   5410  6741          5411 (NOTLB)
       e08aff30 00000086 fffb8000 57e802ac 00000159 00000002 e4502ab0
c18084e0 
       c04ea4e0 dd45cbc0 00000000 000050a2 57f07a0a 00000159 e4502ab0
dd45cab0 
       fffffe00 dd45cab0 dd45cb68 00000000 c011db3a 00000001 00000000
dd45cab0 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c01cf017>] copy_to_user+0x38/0x42
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c011dc7d>] sys_waitpid+0x13/0x1a
 [<c01028e5>] sysenter_past_esp+0x56/0x79
ntpd          S F99DA445     0  5675      1                5464 (NOTLB)
       ddbbfb58 00000082 c040e3e0 f99da445 000001de 00000003 f7e1f570
c18084e0 
       c04ea4e0 ddff3bc0 00000000 00000c3b f99da445 000001de f7e1f570
ddff3ab0 
       7fffffff 00000000 00000100 00000000 c02d06ba ddbbfbd0 e46749c0
00000000 
Call Trace:
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c0269b5a>] sock_poll+0x13/0x17
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011eec7>] local_bh_enable+0x7b/0x91
 [<c027277d>] dev_queue_xmit+0x230/0x237
 [<c028e934>] ip_output+0x1c6/0x1fc
 [<c02905e8>] ip_push_pending_frames+0x36f/0x3fa
 [<c026ff0e>] skb_copy_and_csum_datagram+0x8b/0x31c
 [<c0270259>] skb_copy_and_csum_datagram_iovec+0x65/0xb7
 [<c026d4aa>] kfree_skbmem+0x6c/0x70
 [<c02a81b4>] udp_recvmsg+0x190/0x1d9
 [<c026c9a9>] sock_common_recvmsg+0x36/0x4b
 [<c0269456>] sock_recvmsg+0xda/0xf5
 [<c026e6ce>] skb_checksum+0x45/0x25d
 [<c026c695>] sk_reset_timer+0x12/0x1e
 [<c02a03cd>] tcp_send_delayed_ack+0xb3/0xbb
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c010739c>] convert_fxsr_to_user+0x100/0x157
 [<c01cee56>] __copy_to_user_ll+0x55/0x5f
 [<c01075a6>] save_i387_fxsave+0xd7/0xe9
 [<c010214b>] setup_sigcontext+0xd9/0x11e
 [<c010225c>] setup_frame+0xcc/0x1b7
 [<c0102662>] handle_signal+0x9a/0x10e
 [<c02d16c2>] _spin_unlock_irq+0xe/0x22
 [<c01026d0>] handle_signal+0x108/0x10e
 [<c0102750>] do_signal+0x7a/0xfb
 [<c010740b>] convert_fxsr_from_user+0x18/0xdc
 [<c016a882>] sys_select+0x9d/0x161
 [<c0101e29>] restore_sigcontext+0x107/0x184
 [<c0101f57>] sys_sigreturn+0xb1/0xd7
 [<c01028e5>] sysenter_past_esp+0x56/0x79
in.telnetd    S 2397C627     0  6556   4054  6568    6829       (NOTLB)
       c9613b58 00000086 c041c9a0 2397c627 000001df 00000002 e4502570
c18084e0 
       c04ea4e0 f43aa140 00000000 00000a63 2398171b 000001df e4502570
f43aa030 
       7fffffff 00000000 00000010 00000000 c02d06ba 00000104 c02d16a0
c01eb51f 
Call Trace:
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c01eb51f>] tty_poll+0x4a/0x54
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0217ba7>] e100_xmit_prepare+0x0/0x90
 [<c027eef7>] __qdisc_run+0x34/0x1a3
 [<c011eec7>] local_bh_enable+0x7b/0x91
 [<c027277d>] dev_queue_xmit+0x230/0x237
 [<c028e934>] ip_output+0x1c6/0x1fc
 [<c028ed28>] ip_queue_xmit+0x3be/0x40c
 [<c028b7d6>] ip_local_deliver+0x218/0x235
 [<c011386c>] activate_task+0x55/0xa2
 [<c0113769>] __activate_task+0x1e/0x30
 [<c0113fd5>] try_to_wake_up+0x262/0x2b6
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c011386c>] activate_task+0x55/0xa2
 [<c02a244a>] tcp_v4_send_check+0x83/0xc4
 [<c01221bd>] lock_timer_base+0x19/0x33
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0122266>] __mod_timer+0x8f/0x99
 [<c026c695>] sk_reset_timer+0x12/0x1e
 [<c029ee52>] tcp_write_xmit+0x1bc/0x212
 [<c029ee7e>] tcp_write_xmit+0x1e8/0x212
 [<c029eecb>] __tcp_push_pending_frames+0x23/0x80
 [<c011ed36>] local_bh_disable+0xa/0xb
 [<c011ef1d>] local_bh_enable_ip+0x40/0x56
 [<c02d16eb>] _spin_unlock_bh+0x15/0x17
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c02698ef>] sock_aio_write+0x56/0x64
 [<c0159ab0>] do_sync_write+0xbe/0xf1
 [<c01ee5b1>] read_chan+0x4b8/0x4c5
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c011eb3a>] current_fs_time+0x44/0x4e
 [<c016a882>] sys_select+0x9d/0x161
 [<c0159c9e>] sys_write+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
login         S C04EA4E0     0  6568   6556  6609               (NOTLB)
       c9b47f44 00000082 00000012 c04ea4e0 c10ca50c 3fa32065 00000000
c18084e0 
       c04ea4e0 df258140 00000000 00001291 11f54f26 0000013a c040e3e0
df258030 
       fffffe00 df258030 df2580e8 00000000 c011db3a 00000001 00000000
df258030 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011216e>] do_page_fault+0x225/0x565
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c01028e5>] sysenter_past_esp+0x56/0x79
bash          R running     0  6609   6568                     (NOTLB)
DConsole      S C0113925     0  6741   5412          6749       (NOTLB)
       c7619eac 00000086 f43aaab0 c0113925 e1ee3030 f43aaab0 c7619ebc
c18084e0 
       c04ea4e0 f43aabc0 00000000 000003f8 7b69c894 0000015c c040e3e0
f43aaab0 
       7fffffff e3493180 c7619f0c e0147800 c02d06ba f7b6c900 f7af9c80
e45b1980 
Call Trace:
 [<c0113925>] resched_task+0x41/0x63
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c012baa1>] add_wait_queue+0x12/0x30
 [<c01ee3a8>] read_chan+0x2af/0x4c5
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c01e94e7>] tty_ldisc_deref+0x52/0x61
 [<c01ea094>] tty_read+0x67/0x95
 [<c015995c>] vfs_read+0x87/0x11d
 [<c0159c3b>] sys_read+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
DConsole      S 006E106D     0  6749   5412                6741 (NOTLB)
       dbd11f2c 00000086 c012e032 006e106d 000001da 00000003 e6672570
c18084e0 
       c04ea4e0 f5cf0680 00000000 00001007 006e106d 000001da e6672570
f5cf0570 
       dbd11f68 00000000 00000001 00000000 c02d0aec dbd11f68 aa2b65d0
000001e5 
Call Trace:
 [<c012e032>] enqueue_hrtimer+0x58/0x7f
 [<c02d0aec>] do_nanosleep+0x40/0x6d
 [<c012e3e1>] hrtimer_nanosleep+0x4c/0xe9
 [<c01621c1>] sys_stat64+0x20/0x27
 [<c012e366>] hrtimer_wakeup+0x0/0x1c
 [<c012e4c2>] sys_nanosleep+0x44/0x4f
 [<c01028e5>] sysenter_past_esp+0x56/0x79
CompressVersi D F7406880     0  6824   6823                     (NOTLB)
       c9d8dea8 00000082 deed1ab0 f7406880 00000000 00000001 deee4030
c18084e0 
       c04ea4e0 c985e680 00000000 00000127 0517fc12 000001df deee4030
c985e570 
       f7406800 c9d8ded4 f7406860 00025918 c01a847b 00000000 00000000
c985e570 
Call Trace:
 [<c01a847b>] log_wait_commit+0xc3/0xfe
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c02d071e>] schedule_timeout+0x77/0x8e
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c01234b2>] process_timeout+0x0/0x9
 [<c01a4085>] journal_stop+0x199/0x1c9
 [<c01a40d5>] journal_force_commit+0x20/0x26
 [<c019d7ed>] ext3_force_commit+0x22/0x24
 [<c019341a>] ext3_sync_file+0x82/0xb4
 [<c013d95b>] filemap_fdatawrite+0x16/0x1a
 [<c015ae2c>] do_fsync+0x41/0x65
 [<c015ae70>] __do_fsync+0x20/0x30
 [<c015ae8b>] sys_fsync+0xb/0xe
 [<c01028e5>] sysenter_past_esp+0x56/0x79
in.telnetd    S C041C998     0  6829   4054  6830    6902  6556 (NOTLB)
       ce2dbb58 00000082 c041c9a0 c041c998 00000000 00000000 c2395030
c18084e0 
       c04ea4e0 f7e76bc0 00000000 00001a1c f158733f 00000180 c2395030
f7e76ab0 
       7fffffff 00000000 00000010 00000000 c02d06ba 00000104 c02d16a0
c01eb51f 
Call Trace:
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c01eb51f>] tty_poll+0x4a/0x54
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0217ba7>] e100_xmit_prepare+0x0/0x90
 [<c027eef7>] __qdisc_run+0x34/0x1a3
 [<c011eec7>] local_bh_enable+0x7b/0x91
 [<c027277d>] dev_queue_xmit+0x230/0x237
 [<c028e934>] ip_output+0x1c6/0x1fc
 [<c028ed28>] ip_queue_xmit+0x3be/0x40c
 [<c02167fb>] e100_enable_irq+0x13/0x31
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0218503>] e100_poll+0x91/0xab
 [<c0272ef2>] net_rx_action+0x97/0x17f
 [<c01edc7c>] n_tty_receive_buf+0x83d/0x899
 [<c011f059>] irq_exit+0x36/0x41
 [<c029d448>] tcp_cwnd_restart+0x1e/0xb4
 [<c02a244a>] tcp_v4_send_check+0x83/0xc4
 [<c01221bd>] lock_timer_base+0x19/0x33
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0122266>] __mod_timer+0x8f/0x99
 [<c026c695>] sk_reset_timer+0x12/0x1e
 [<c029ee52>] tcp_write_xmit+0x1bc/0x212
 [<c029ee7e>] tcp_write_xmit+0x1e8/0x212
 [<c029eecb>] __tcp_push_pending_frames+0x23/0x80
 [<c011ed36>] local_bh_disable+0xa/0xb
 [<c011ef1d>] local_bh_enable_ip+0x40/0x56
 [<c02d16eb>] _spin_unlock_bh+0x15/0x17
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c01ece51>] opost+0x197/0x1a0
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c02698ef>] sock_aio_write+0x56/0x64
 [<c0115ba1>] __wake_up+0x27/0x3b
 [<c0159ab0>] do_sync_write+0xbe/0xf1
 [<c01ee5b1>] read_chan+0x4b8/0x4c5
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c011eb3a>] current_fs_time+0x44/0x4e
 [<c016a882>] sys_select+0x9d/0x161
 [<c0159c9e>] sys_write+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
login         S 00000004     0  6830   6829  6836               (NOTLB)
       c9eb1f44 00000082 00000004 00000004 c9eb1f54 00000000 deee4030
c18084e0 
       c04ea4e0 dfca3140 00000000 000001b1 650f3c84 00000170 deee4030
dfca3030 
       fffffe00 dfca3030 dfca30e8 00000000 c011db3a 00000001 00000000
dfca3030 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011216e>] do_page_fault+0x225/0x565
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c01028e5>] sysenter_past_esp+0x56/0x79
CompressVersi S 0000001D     0  6832   6831                     (NOTLB)
       c4a91b50 00000086 f3140a24 0000001d c029c65c 00000000 f7fbb030
c18084e0 
       c04ea4e0 c985e140 00000000 000012b7 55fdf817 000001cc f7fbb030
c985e030 
       c4a91b60 003d4a14 00000200 00000000 c02d0716 c4a91b60 003d4a14
c04fdda8 
Call Trace:
 [<c029c65c>] tcp_rcv_established+0x5ab/0x5da
 [<c02d0716>] schedule_timeout+0x6f/0x8e
 [<c01234b2>] process_timeout+0x0/0x9
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c02cfee7>] schedule+0x60b/0x625
 [<c02cff42>] preempt_schedule+0x41/0x53
 [<c027277d>] dev_queue_xmit+0x230/0x237
 [<c028e934>] ip_output+0x1c6/0x1fc
 [<c028ed28>] ip_queue_xmit+0x3be/0x40c
 [<c0195275>] ext3_getblk+0xdf/0x22a
 [<c015bd02>] __find_get_block+0x45/0x4c
 [<c015bd26>] __getblk+0x1d/0x35
 [<c029d448>] tcp_cwnd_restart+0x1e/0xb4
 [<c01221bd>] lock_timer_base+0x19/0x33
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0122266>] __mod_timer+0x8f/0x99
 [<c029e4aa>] tcp_init_tso_segs+0x2f/0x40
 [<c029ecef>] tcp_write_xmit+0x59/0x212
 [<c011ed36>] local_bh_disable+0xa/0xb
 [<c011ef1d>] local_bh_enable_ip+0x40/0x56
 [<c02d16eb>] _spin_unlock_bh+0x15/0x17
 [<c0295db0>] tcp_recvmsg+0x65c/0x693
 [<c0295db0>] tcp_recvmsg+0x65c/0x693
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c0269723>] sock_aio_read+0x56/0x64
 [<c01cab77>] _atomic_dec_and_lock+0x2b/0x4c
 [<c01598a2>] do_sync_read+0xbe/0xf1
 [<c0162191>] cp_new_stat64+0xef/0xff
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a882>] sys_select+0x9d/0x161
 [<c0159c3b>] sys_read+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
bash          S 07757686     0  6836   6830  6895               (NOTLB)
       cd503f30 00000086 00000000 07757686 00000172 00000002 e4502ab0
c18084e0 
       c04ea4e0 c20bb680 00000000 00003a4f 077c36df 00000172 e4502ab0
c20bb570 
       fffffe00 c20bb570 c20bb628 00000000 c011db3a 00000001 00000000
c20bb570 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c01cf017>] copy_to_user+0x38/0x42
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c011dc7d>] sys_waitpid+0x13/0x1a
 [<c01028e5>] sysenter_past_esp+0x56/0x79
DConsole      S 00000000     0  6895   6836          6896       (NOTLB)
       cf219ec4 00000086 e4509030 00000000 00000ae5 00000001 f7b0a570
c18084e0 
       c04ea4e0 ebd84140 00000000 000001d2 1007788c 000001df f7b0a570
ebd84030 
       e6f3bc00 e6f3bc00 cf219eec e6f3bc00 c016415d 00000000 ebd84030
c012bc09 
Call Trace:
 [<c016415d>] pipe_wait+0x6d/0x8e
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c026d1c3>] __alloc_skb+0x49/0xf0
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c01645e0>] pipe_readv+0x209/0x275
 [<c0217da3>] e100_tx_clean+0xa4/0xcb
 [<c0164671>] pipe_read+0x25/0x29
 [<c015995c>] vfs_read+0x87/0x11d
 [<c0159c3b>] sys_read+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
DConsole      S D3ECBF68     0  6896   6836                6895 (NOTLB)
       d3ecbf2c 00000086 c012e032 d3ecbf68 c180905c c1809050 c1809050
c18084e0 
       c04ea4e0 d38fabc0 00000000 000005e2 211ec3cc 000001d4 c040e3e0
d38faab0 
       d3ecbf68 00000000 00000001 00000000 c02d0aec d3ecbf68 c804672a
000001df 
Call Trace:
 [<c012e032>] enqueue_hrtimer+0x58/0x7f
 [<c02d0aec>] do_nanosleep+0x40/0x6d
 [<c012e3e1>] hrtimer_nanosleep+0x4c/0xe9
 [<c01621c1>] sys_stat64+0x20/0x27
 [<c012e366>] hrtimer_wakeup+0x0/0x1c
 [<c012e4c2>] sys_nanosleep+0x44/0x4f
 [<c01028e5>] sysenter_past_esp+0x56/0x79
in.telnetd    S C041C998     0  6902   4054  6903          6829 (NOTLB)
       e5a49b58 00000082 c041c9a0 c041c998 00000000 00000001 e5a49b54
c18084e0 
       c04ea4e0 ebd84bc0 00000000 00000912 7f3133ce 000001de c040e3e0
ebd84ab0 
       7fffffff 00000000 00000010 00000000 c02d06ba 00000104 c02d16a0
c01eb51f 
Call Trace:
 [<c02d06ba>] schedule_timeout+0x13/0x8e
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c01eb51f>] tty_poll+0x4a/0x54
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0216e82>] e100_exec_cb+0xf6/0xfe
 [<c0217c97>] e100_xmit_frame+0x60/0xc8
 [<c0217ba7>] e100_xmit_prepare+0x0/0x90
 [<c027eef7>] __qdisc_run+0x34/0x1a3
 [<c011eec7>] local_bh_enable+0x7b/0x91
 [<c027277d>] dev_queue_xmit+0x230/0x237
 [<c028e934>] ip_output+0x1c6/0x1fc
 [<c028ed28>] ip_queue_xmit+0x3be/0x40c
 [<c0141d95>] get_page_from_freelist+0x70/0x88
 [<c01468fe>] __mod_zone_page_state+0x10/0x58
 [<c014695b>] mod_zone_page_state+0x15/0x1c
 [<c0156373>] kmem_getpages+0x67/0x8e
 [<c0156e83>] cache_grow+0xe2/0x135
 [<c029d448>] tcp_cwnd_restart+0x1e/0xb4
 [<c02a244a>] tcp_v4_send_check+0x83/0xc4
 [<c029e4aa>] tcp_init_tso_segs+0x2f/0x40
 [<c029ecef>] tcp_write_xmit+0x59/0x212
 [<c029eecb>] __tcp_push_pending_frames+0x23/0x80
 [<c011ed36>] local_bh_disable+0xa/0xb
 [<c011ef1d>] local_bh_enable_ip+0x40/0x56
 [<c02d16eb>] _spin_unlock_bh+0x15/0x17
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c029532b>] tcp_sendmsg+0x954/0xa02
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c02698ef>] sock_aio_write+0x56/0x64
 [<c02cfee7>] schedule+0x60b/0x625
 [<c0159ab0>] do_sync_write+0xbe/0xf1
 [<c01ee5b1>] read_chan+0x4b8/0x4c5
 [<c012bc09>] autoremove_wake_function+0x0/0x3a
 [<c011eb3a>] current_fs_time+0x44/0x4e
 [<c016a882>] sys_select+0x9d/0x161
 [<c0159c9e>] sys_write+0x3b/0x63
 [<c01028e5>] sysenter_past_esp+0x56/0x79
login         S C04EA4E0     0  6903   6902  6908               (NOTLB)
       da65bf44 00000082 00000012 c04ea4e0 c115db6c 353b5065 00000000
c18084e0 
       c04ea4e0 f7e76680 00000000 00000656 8ba1b5c4 00000176 c040e3e0
f7e76570 
       fffffe00 f7e76570 f7e76628 00000000 c011db3a 00000001 00000000
f7e76570 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011216e>] do_page_fault+0x225/0x565
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c01028e5>] sysenter_past_esp+0x56/0x79
bash          S 0000AC34     0  6908   6903  6954               (NOTLB)
       d497df30 00000082 00000000 0000ac34 df8fdf7f 00000000 e6672570
c18084e0 
       c04ea4e0 f43aa680 00000000 000041bb df9146d7 00000176 e6672570
f43aa570 
       fffffe00 f43aa570 f43aa628 00000000 c011db3a 00000001 00000000
f43aa570 
Call Trace:
 [<c011db3a>] do_wait+0x287/0x31e
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c01cf017>] copy_to_user+0x38/0x42
 [<c011dc66>] sys_wait4+0x28/0x2c
 [<c011dc7d>] sys_waitpid+0x13/0x1a
 [<c01028e5>] sysenter_past_esp+0x56/0x79
top           S D152F000     0  6954   6908                     (NOTLB)
       c2257b50 00000082 c01e93d8 d152f000 c041c9a0 00000000 ebd84ab0
c18084e0 
       c04ea4e0 c2395bc0 00000000 000001a8 7f2cf5a8 000001de ebd84ab0
c2395ab0 
       c2257b60 0006aaca 00000002 00000000 c02d0716 c2257b60 0006aaca
c04fd7e0 
Call Trace:
 [<c01e93d8>] tty_ldisc_try+0x33/0x38
 [<c02d0716>] schedule_timeout+0x6f/0x8e
 [<c01234b2>] process_timeout+0x0/0x9
 [<c016a42f>] do_select+0x2fa/0x34b
 [<c016a020>] __pollwait+0x0/0x4c
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c0216d84>] e100_exec_cmd+0x8a/0x92
 [<c0216e37>] e100_exec_cb+0xab/0xfe
 [<c0101555>] __switch_to+0x29/0x1cb
 [<c02cfee7>] schedule+0x60b/0x625
 [<c02d171e>] _read_unlock_irq+0xe/0x22
 [<c015bc2b>] bh_lru_install+0xa3/0xac
 [<c01a349e>] do_get_write_access+0x55a/0x57d
 [<c015bd26>] __getblk+0x1d/0x35
 [<c02d13a6>] _spin_lock+0xd/0x59
 [<c011356f>] task_rq_lock+0x2c/0x52
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c011401e>] try_to_wake_up+0x2ab/0x2b6
 [<c02d13a6>] _spin_lock+0xd/0x59
 [<c011356f>] task_rq_lock+0x2c/0x52
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c011401e>] try_to_wake_up+0x2ab/0x2b6
 [<c0115b5e>] __wake_up_common+0x2f/0x4b
 [<c0115b5e>] __wake_up_common+0x2f/0x4b
 [<c01edc7c>] n_tty_receive_buf+0x83d/0x899
 [<c01edc7c>] n_tty_receive_buf+0x83d/0x899
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a705>] core_sys_select+0x285/0x365
 [<c0115b1d>] default_wake_function+0x0/0x12
 [<c022c060>] ide_execute_command+0x99/0xae
 [<c02cf87f>] __down_failed+0x7/0xc
 [<c0115ba1>] __wake_up+0x27/0x3b
 [<c0115ba1>] __wake_up+0x27/0x3b
 [<c0115ba1>] __wake_up+0x27/0x3b
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c01e94e7>] tty_ldisc_deref+0x52/0x61
 [<c02d16a0>] _spin_unlock_irqrestore+0xf/0x23
 [<c01ebfca>] tty_ioctl+0x42b/0x43b
 [<c01cf05b>] copy_from_user+0x3a/0x5f
 [<c016a882>] sys_select+0x9d/0x161
 [<c016944e>] sys_fcntl64+0x55/0x68
 [<c01028e5>] sysenter_past_esp+0x56/0x79
IntegrityChec D 14CB896D     0  7275   7274                     (NOTLB)
       ca3f9e20 00000086 d64c1680 14cb896d 000001df 00000002 e4502ab0
c18084e0 
       c04ea4e0 d8d9abc0 00000000 00000501 14cbd373 000001df e4502ab0
d8d9aab0 
       c18084e0 00000000 ca3f9e8c ca3f9e2c c02d065a ca3f9e84 c1803400
c013d8c9 
Call Trace:
 [<c02d065a>] io_schedule+0x26/0x30
 [<c013d8c9>] sync_page+0x3b/0x3e
 [<c02d085f>] __wait_on_bit_lock+0x31/0x58
 [<c013d88e>] sync_page+0x0/0x3e
 [<c013df25>] __lock_page+0x6a/0x71
 [<c012bc43>] wake_bit_function+0x0/0x34
 [<c012bc43>] wake_bit_function+0x0/0x34
 [<c013ee5b>] filemap_nopage+0x263/0x346
 [<c014a83c>] do_no_page+0x86/0x2a7
 [<c026d1c3>] __alloc_skb+0x49/0xf0
 [<c014acb0>] __handle_mm_fault+0x19e/0x28c
 [<c011216e>] do_page_fault+0x225/0x565
 [<c0111f49>] do_page_fault+0x0/0x565
 [<c0103419>] error_code+0x39/0x40
xdelta        D 00000000     0  7341   5384                     (NOTLB)
       d5cb3bc8 00000086 00000000 00000000 00000000 c6574f40 00000000
c18084e0 
       c04ea4e0 f5cf0bc0 00000000 0000150b db597c17 000001de c040e3e0
f5cf0ab0 
       c18084e0 00000000 c1800740 d5cb3bd4 c02d065a d5cb3c2c c015a9f7
c015aa2f 
Call Trace:
 [<c02d065a>] io_schedule+0x26/0x30
 [<c015a9f7>] sync_buffer+0x0/0x3b
 [<c015aa2f>] sync_buffer+0x38/0x3b
 [<c02d0792>] __wait_on_bit+0x2b/0x51
 [<c02d0826>] out_of_line_wait_on_bit+0x6e/0x76
 [<c015a9f7>] sync_buffer+0x0/0x3b
 [<c012bc43>] wake_bit_function+0x0/0x34
 [<c015d944>] submit_bh+0x139/0x15f
 [<c012bc43>] wake_bit_function+0x0/0x34
 [<c015bb72>] __bread_slow+0x50/0x66
 [<c015bda8>] __bread+0x2a/0x30
 [<c019478f>] ext3_get_branch+0x5f/0xbc
 [<c0194e32>] ext3_get_blocks_handle+0xac/0x362
 [<c0195180>] ext3_get_block+0x98/0xae
 [<c0178384>] do_mpage_readpage+0x23e/0x586
 [<c01cc424>] radix_tree_node_alloc+0x1c/0x54
 [<c0146974>] __inc_zone_state+0x12/0x72
 [<c017877d>] mpage_readpages+0xb1/0x123
 [<c01950e8>] ext3_get_block+0x0/0xae
 [<c011401e>] try_to_wake_up+0x2ab/0x2b6
 [<c02cfee7>] schedule+0x60b/0x625
 [<c02d1637>] _spin_unlock+0xd/0x21
 [<c01417dd>] rmqueue_bulk+0x52/0x59
 [<c0195d57>] ext3_readpages+0x16/0x1a
 [<c01950e8>] ext3_get_block+0x0/0xae
 [<c014368f>] read_pages+0x26/0xc0
 [<c0141d95>] get_page_from_freelist+0x70/0x88
 [<c0141df3>] __alloc_pages+0x46/0x26b
 [<c014383f>] __do_page_cache_readahead+0x116/0x136
 [<c01438a8>] force_page_cache_readahead+0x49/0x5f
 [<c01410df>] sys_fadvise64_64+0x157/0x1d9
 [<c014117e>] sys_fadvise64+0x1d/0x23
 [<c01028e5>] sysenter_past_esp+0x56/0x79
pdflush       S D0E8BF48     0  7363      7          7365  3798 (L-TLB)
       d0e8bf88 00000046 00000000 d0e8bf48 d0e8bf48 00000000 f7fe4ab0
c18084e0 
       c04ea4e0 e4d15680 00000000 000000c8 f1f5f0dd 000001dc f7fe4ab0
e4d15570 
       d0e8bfb4 d0e8bfa8 c014345a fffffffc c0143374 cc23bf34 00000000
c014348d 
Call Trace:
 [<c014345a>] pdflush+0x0/0x37
 [<c0143374>] __pdflush+0x88/0x16e
 [<c014348d>] pdflush+0x33/0x37
 [<c014345a>] pdflush+0x0/0x37
 [<c012b889>] kthread+0x85/0xaa
 [<c012b804>] kthread+0x0/0xaa
 [<c0100e9d>] kernel_thread_helper+0x5/0xb
pdflush       S DE591F48     0  7365      7          7376  7363 (L-TLB)
       de591f88 00000046 00000000 de591f48 00000000 00000000 f7fe4ab0
c18084e0 
       c04ea4e0 c5fde140 00000000 000000b3 f1ec1bed 000001dc f7fe4ab0
c5fde030 
       de591fb4 de591fa8 c014345a fffffffc c0143374 cc23bf34 00000000
c014348d 
Call Trace:
 [<c014345a>] pdflush+0x0/0x37
 [<c0143374>] __pdflush+0x88/0x16e
 [<c014348d>] pdflush+0x33/0x37
 [<c014345a>] pdflush+0x0/0x37
 [<c012b889>] kthread+0x85/0xaa
 [<c012b804>] kthread+0x0/0xaa
 [<c0100e9d>] kernel_thread_helper+0x5/0xb
pdflush       S CA7EFF48     0  7376      7          7398  7365 (L-TLB)
       ca7eff88 00000046 00000000 ca7eff48 00000000 00000000 f7fe4ab0
c18084e0 
       c04ea4e0 c2395140 00000000 0000007e f1f63258 000001dc f7fe4ab0
c2395030 
       ca7effb4 ca7effa8 c014345a fffffffc c0143374 cc23bf34 00000000
c014348d 
Call Trace:
 [<c014345a>] pdflush+0x0/0x37
 [<c0143374>] __pdflush+0x88/0x16e
 [<c014348d>] pdflush+0x33/0x37
 [<c014345a>] pdflush+0x0/0x37
 [<c012b889>] kthread+0x85/0xaa
 [<c012b804>] kthread+0x0/0xaa
 [<c0100e9d>] kernel_thread_helper+0x5/0xb
pdflush       S F1EC3A74     0  7398      7          7399  7376 (L-TLB)
       d1601f88 00000046 00000000 f1ec3a74 000001dc 00000003 e6672570
c18084e0 
       c04ea4e0 c657b680 00000000 00000160 f1ec3a74 000001dc e6672570
c657b570 
       d1601fb4 d1601fa8 c014345a fffffffc c0143374 de591f34 00000000
c014348d 
Call Trace:
 [<c014345a>] pdflush+0x0/0x37
 [<c0143374>] __pdflush+0x88/0x16e
 [<c014348d>] pdflush+0x33/0x37
 [<c014345a>] pdflush+0x0/0x37
 [<c012b889>] kthread+0x85/0xaa
 [<c012b804>] kthread+0x0/0xaa
 [<c0100e9d>] kernel_thread_helper+0x5/0xb
pdflush       S CA7EDF98     0  7399      7                7398 (L-TLB)
       ca7edf88 00000046 00000000 ca7edf98 ca7edf98 00000000 d38fa570
c18084e0 
       c04ea4e0 c2395680 00000000 000002c3 f1f63d2d 000001dc d38fa570
c2395570 
       ca7edfb4 ca7edfa8 c014345a fffffffc c0143374 d0e8bf34 00000000
c014348d 
Call Trace:
 [<c014345a>] pdflush+0x0/0x37
 [<c0143374>] __pdflush+0x88/0x16e
 [<c014348d>] pdflush+0x33/0x37
 [<c014345a>] pdflush+0x0/0x37
 [<c012b889>] kthread+0x85/0xaa
 [<c012b804>] kthread+0x0/0xaa
 [<c0100e9d>] kernel_thread_helper+0x5/0xb


-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Friday, January 26, 2007 6:17 AM
To: Matthew Kirk
Cc: linux-kernel@vger.kernel.org
Subject: Re: fsync occasionally very slow

On Fri, 26 Jan 2007 05:37:38 -0500
"Matthew Kirk" <mkirk01@rcn.com> wrote:

> I am working on an application that fsync(2) files and directories as
> needed.    I’m seeing intermittent stalls on fsync that can last many
> seconds.

Please generate an all-task backtrace during the stall via:

dmesg -n 8
<wait for a stall>
echo t > /prov/sysrq-trigger
dmesg -s 1000000 > foo

and send foo.

-- 
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.410 / Virus Database: 268.17.11/652 - Release Date: 1/25/2007
 

-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.410 / Virus Database: 268.17.14/658 - Release Date: 1/29/2007
 
