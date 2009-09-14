Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZINKpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZINKpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZINKpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:45:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:47298 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZINKpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:45:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Arkadiusz =?UTF-8?B?TWnFm2tpZXdpY3o=?= <arekm@maven.pl>
Subject: Re: PROBLEM: oops
Followup-To: gmane.linux.kernel
Date: Mon, 14 Sep 2009 12:21:19 +0200
Message-ID: <h8l5ev$u2p$1@ger.gmane.org>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy> <1251209206.7538.1159.camel@twins> <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy> <1251209734.7538.1160.camel@twins> <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> <1251211483.7538.1162.camel@twins> <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy> <1251212859.7538.1166.camel@twins> <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy> <1251265742.7538.1192.camel@twins> <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy> <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy> <1251364230.18584.52.camel@twins> <alpine.LNX.2.00.0908271121100.16876@fgnss.gnfx.tqn.cy> <1251366017.18584.62.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.238.65.58
User-Agent: KNode/4.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> I'm not sure what was available in .27
> 
> looking at your config, the things you can try are:
> 
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_DEBUG_PAGEALLOC=y
> 
> I'm not seeing kmemcheck.

I'm fighting the same problem as blues is. The problem, in my case, is 
visible on intel x86_64 and amd x86_64 machines (so different hardware than 
his i686).

I get oops on 2.6.27.31 and 2.6.27.30 (see below). 2.6.31 with debug options 
and kmemcheck didn't really work (see last log below).

I don't know how to trigger that oops. In my case it takes ~1 week for the 
oops to happen. These kernels aren't (unfortunately) vanilla. They have 
vserver patch applied. I'm also using grsecurity patch but I tested without 
it, too - oops did happen.

I'm unable to test these without vserver patch.

************************************************************************************
2.6.27.31 on intel machine:

[ 3952.746892] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000080
[ 3952.747315] IP: [<ffffffff80227e04>] pick_next_task_fair+0x64/0xf0
[ 3952.747315] PGD 2865eb067 PUD 2a3d60067 PMD 0 
[ 3952.747315] Oops: 0000 [1] SMP 
[ 3952.747315] CPU 5 
[ 3952.747315] Modules linked in: ipmi_watchdog sch_sfq dm_mod e1000e 
ipmi_devintf ipmi_si ipmi_msghandler xfs scsi_wait_scan sd_mod crc_t10dif 
aacraid scsi_mod
[ 3952.747315] Pid: 14053, comm: exim Not tainted 2.6.27.31-1 #1
[ 3952.747315] RIP: 0010:[<ffffffff80227e04>]  [<ffffffff80227e04>] 
pick_next_task_fair+0x64/0xf0
[ 3952.747315] RSP: 0018:ffff880286511a18  EFLAGS: 00210046
[ 3952.747315] RAX: 0000000000000000 RBX: ffff88002805fe70 RCX: 
ffff880314dda260
[ 3952.747315] RDX: ffff88035e4e3780 RSI: ffff880314dda260 RDI: 
ffff88002805fe00
[ 3952.747315] RBP: ffff880286511a58 R08: ffff8800280606e8 R09: 
0000000000000000
[ 3952.747315] R10: 0000000000000000 R11: 0000000000000001 R12: 
0000000000000000
[ 3952.747315] R13: ffff88035919a950 R14: 0000000000000000 R15: 
ffff88035919a950
[ 3952.747315] FS:  0000000000000000(0000) GS:ffff88035e4e3780(0063) 
knlGS:00000000f7217910
[ 3952.747315] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 3952.747315] CR2: 0000000000000080 CR3: 0000000286459000 CR4: 
00000000000006e0
[ 3952.747315] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 3952.747315] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 3952.747315] Process exim (pid: 14053, threadinfo ffff880286510000, task 
ffff880314dda260)
[ 3952.747315] Stack:  ffff880286511a38 ffff88002805fe00 0000000000000005 
ffff88002805fe00
[ 3952.747315]  ffffffff80550b80 ffff88035919a950 ffff8800280606e8 
ffff88035919a950
[ 3952.747315]  ffff880286511b38 ffffffff8050d2ee 0000000000000000 
0000000000001000
[ 3952.747315] Call Trace:
[ 3952.747315]  [<ffffffff8050d2ee>] thread_return+0x29d/0x88f
[ 3952.747315]  [<ffffffff802f7dc1>] ? __block_prepare_write+0x2a1/0x540
[ 3952.747315]  [<ffffffff802f6442>] ? __set_page_dirty+0x92/0x150
[ 3952.747315]  [<ffffffff802f65ea>] ? __block_commit_write+0x6a/0xd0
[ 3952.747315]  [<ffffffff8050dcfa>] schedule_timeout+0x8a/0xd0
[ 3952.747315]  [<ffffffff802f67d9>] ? block_write_end+0x39/0x90
[ 3952.747315]  [<ffffffff8050f9e9>] ? _spin_lock_bh+0x9/0x20
[ 3952.747315]  [<ffffffff80436f53>] ? release_sock+0x13/0xb0
[ 3952.747315]  [<ffffffff804376d1>] ? sk_wait_data+0xe1/0xf0
[ 3952.747315]  [<ffffffff8024b220>] ? autoremove_wake_function+0x0/0x30
[ 3952.747315]  [<ffffffff80479cad>] ? tcp_recvmsg+0x65d/0xd90
[ 3952.747315]  [<ffffffffa00b6a60>] ? 
xfs_address_space_operations+0x0/0x1a0 [xfs]
[ 3952.747315]  [<ffffffff80436332>] ? sock_common_recvmsg+0x32/0x50
[ 3952.747315]  [<ffffffff80433582>] ? sock_aio_read+0x192/0x200
[ 3952.747315]  [<ffffffff802cb222>] ? do_sync_read+0xe2/0x120
[ 3952.747315]  [<ffffffff805120a9>] ? do_page_fault+0x339/0x960
[ 3952.747315]  [<ffffffff8024dfce>] ? enqueue_hrtimer+0x6e/0xf0
[ 3952.747315]  [<ffffffff8024b220>] ? autoremove_wake_function+0x0/0x30
[ 3952.747315]  [<ffffffff80238c38>] ? do_setitimer+0x2f8/0x3a0
[ 3952.747315]  [<ffffffff802cbf3a>] ? vfs_read+0x16a/0x180
[ 3952.747315]  [<ffffffff80238df5>] ? alarm_setitimer+0x35/0x70
[ 3952.747315]  [<ffffffff802cc03e>] ? sys_read+0x4e/0x90
[ 3952.747315]  [<ffffffff80222776>] ? sysenter_dispatch+0x7/0x27
[ 3952.747315] 
[ 3952.747315] 
[ 3952.747315] Code: 74 24 f0 4c 89 6b 28 45 8b 56 38 45 85 d2 75 68 48 8b 
43 70 48 8b 80 e0 07 00 00 49 89 46 40 4c 89 73 58 49 8b 46 48 49 89 46 58 
<49> 8b 9e 80 00 00 00 48 85 db 74 50 4c 8b 63 38 45 31 f6 4d 85 
[ 3952.747315] RIP  [<ffffffff80227e04>] pick_next_task_fair+0x64/0xf0
[ 3952.747315]  RSP <ffff880286511a18>
[ 3952.747315] CR2: 0000000000000080
[ 3952.747315] ---[ end trace 82f82983f40cc2e1 ]---

2.6.27.31 on amd machine:

[91371.385760] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000080
[91371.387743] IP: [<ffffffff80227e04>] pick_next_task_fair+0x64/0xf0
[91371.387743] PGD 217516067 PUD 217515067 PMD 0 
[91371.387743] Oops: 0000 [1] SMP 
[91371.387743] CPU 1 
[91371.387743] Modules linked in: sg xt_multiport xt_tcpudp 
nf_conntrack_ipv4 xt_state iptable_filter ip_tables ipt_ULOG x_tables 
ipmi_watchdog sch_sfq forcedeth ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
ff_memless nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si 
ipmi_msghandler ehci_hcd usbcore amd74xx ide_core xfs scsi_wait_scan sd_mod 
crc_t10dif aacraid scsi_mod
[91371.387743] Pid: 3710, comm: java Not tainted 2.6.27.31-1 #1
[91371.387743] RIP: 0010:[<ffffffff80227e04>]  [<ffffffff80227e04>] 
pick_next_task_fair+0x64/0xf0
[91371.387743] RSP: 0000:ffff88010b043b58  EFLAGS: 00010046
[91371.387743] RAX: 0000000000000000 RBX: ffff880028029e70 RCX: 
ffff88010b043c18
[91371.387743] RDX: 0000000000000011 RSI: ffff88002802a6d0 RDI: 
ffff880028029e00
[91371.387743] RBP: ffff88010b043b98 R08: ffff88002802a6e8 R09: 
0000000000000002
[91371.387743] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[91371.387743] R13: ffff88011e9b0000 R14: 0000000000000000 R15: 
00000000ffffffff
[91371.387743] FS:  00007f626e5716f0(0000) GS:ffff88011fc02a80(0063) 
knlGS:00000000ade06bb0
[91371.387743] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[91371.387743] CR2: 0000000000000080 CR3: 00000002174f2000 CR4: 
00000000000006e0
[91371.387743] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[91371.387743] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[91371.387743] Process java (pid: 3710, threadinfo ffff88010b042000, task 
ffff88011e64e720)
[91371.387743] Stack:  ffff88010b043b78 ffff880028029e00 0000000000000001 
ffff880028029e00
[91371.387743]  ffffffff80550b80 ffff88011e9b0000 ffff88002802a6e8 
00000000ffffffff
[91371.387743]  ffff88010b043c78 ffffffff8050d2ee 0000000000000096 
ffffffff80257eb8
[91371.387743] Call Trace:
[91371.387743]  [<ffffffff8050d2ee>] thread_return+0x29d/0x88f
[91371.387743]  [<ffffffff80257eb8>] ? vx_update_load+0x18/0x170
[91371.387743]  [<ffffffff80257eb8>] ? vx_update_load+0x18/0x170
[91371.387743]  [<ffffffff80228e05>] ? enqueue_entity+0xd5/0x120
[91371.387743]  [<ffffffff80263eb5>] futex_wait+0x435/0x4c0
[91371.387743]  [<ffffffff802275b3>] ? __wake_up+0x43/0x70
[91371.387743]  [<ffffffff802638ca>] ? get_futex_key+0x5a/0x180
[91371.387743]  [<ffffffff80394721>] ? __up_read+0x21/0xc0
[91371.387743]  [<ffffffff8022d3b0>] ? default_wake_function+0x0/0x10
[91371.387743]  [<ffffffff8026559f>] ? do_futex+0xff/0xaa0
[91371.387743]  [<ffffffff80227e70>] ? pick_next_task_fair+0xd0/0xf0
[91371.387743]  [<ffffffff8050d2ee>] ? thread_return+0x29d/0x88f
[91371.387743]  [<ffffffff8050d09e>] ? thread_return+0x4d/0x88f
[91371.387743]  [<ffffffff80266238>] ? compat_sys_futex+0xb8/0x160
[91371.387743]  [<ffffffff80222ba2>] ? ia32_sysret+0x0/0xa
[91371.387743] 
[91371.387743] 
[91371.387743] Code: 74 24 f0 4c 89 6b 28 45 8b 56 38 45 85 d2 75 68 48 8b 
43 70 48 8b 80 e0 07 00 00 49 89 46 40 4c 89 73 58 49 8b 46 48 49 89 46 58 
<49> 8b 9e 80 00 00 00 48 85 db 74 50 4c 8b 63 38 45 31 f6 4d 85 
[91371.387743] RIP  [<ffffffff80227e04>] pick_next_task_fair+0x64/0xf0
[91371.387743]  RSP <ffff88010b043b58>
[91371.387743] CR2: 0000000000000080
[91371.387743] ---[ end trace 70e3e5544a76f116 ]---

2.6.30 on amd machine:

[328109.962383] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000038
[328109.964692] IP: [<ffffffff802357eb>] pick_next_task_fair+0x9b/0x120
[328109.964692] PGD 216478067 PUD 2129cc067 PMD 0 
[328109.964692] Oops: 0000 [#1] SMP 
[328109.964692] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq
[328109.964692] CPU 4 
[328109.964692] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328109.964692] Pid: 16435, comm: php Not tainted 2.6.30.6_nogrsecurity-0.1 
#1 H8DMU
[328109.964692] RIP: 0010:[<ffffffff802357eb>]  [<ffffffff802357eb>] 
pick_next_task_fair+0x9b/0x120
[328109.964692] RSP: 0000:ffff8801ee9bd968  EFLAGS: 00210046
[328109.964692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff8801ee9bda08
[328109.964692] RDX: 000000000000008d RSI: 0000000000000001 RDI: 
0000000000000000
[328109.964692] RBP: ffffc20000061168 R08: ffffc20000061a08 R09: 
0000000000000000
[328109.964692] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[328109.964692] R13: ffffc20000061100 R14: ffff880169b18a00 R15: 
ffffc20000061a18
[328109.964692] FS:  00007f4601b03790(0000) GS:ffffc20000050000(0063) 
knlGS:00000000f78716c0
[328109.964692] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[328109.964692] CR2: 0000000000000038 CR3: 000000012c2c5000 CR4: 
00000000000006e0
[328109.964692] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328109.964692] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328109.964692] Process php (pid: 16435, threadinfo ffff8801ee9bc000, task 
ffff88021e97bcc0)
[328109.964692] Stack:
[328109.964692]  0000000000000000 ffffc20000061100 0000000000000000 
ffffffff80586aa0
[328109.964692]  ffffc20000061a18 ffffffff8056ed93 0000000000000004 
ffff8801655230f8
[328109.964692]  ffff88021f047000 ffffffff8025db8c ffff88021e97bcc0 
ffff8801ee9bda88
[328109.964692] Call Trace:
[328109.964692]  [<ffffffff8056ed93>] ? thread_return+0x26d/0x8ea
[328109.964692]  [<ffffffff8025db8c>] ? ktime_get_real+0xc/0x40
[328109.964692]  [<ffffffff8025cb1e>] ? enqueue_hrtimer+0x6e/0x80
[328109.964692]  [<ffffffff8025d454>] ? __hrtimer_start_range_ns+0x124/0x2b0
[328109.964692]  [<ffffffff8056f419>] ? schedule+0x9/0x20
[328109.964692]  [<ffffffff80570755>] ? schedule_hrtimeout_range+0xc5/0x160
[328109.964692]  [<ffffffff8025cbf0>] ? hrtimer_wakeup+0x0/0x30
[328109.964692]  [<ffffffff8057073b>] ? schedule_hrtimeout_range+0xab/0x160
[328109.964692]  [<ffffffff803021ec>] ? poll_schedule_timeout+0x2c/0x50
[328109.964692]  [<ffffffff8030263b>] ? do_sys_poll+0x37b/0x460
[328109.964692]  [<ffffffff804dbe0b>] ? tcp_write_xmit+0x1fb/0xa20
[328109.964692]  [<ffffffff803036c0>] ? __pollwait+0x0/0x120
[328109.964692]  [<ffffffff803037e0>] ? pollwake+0x0/0x50
[328109.964692]  [<ffffffff80482946>] ? sock_sendmsg+0x146/0x210
[328109.964692]  [<ffffffff80259d40>] ? autoremove_wake_function+0x0/0x30
[328109.964692]  [<ffffffff802af610>] ? find_lock_page+0x30/0x80
[328109.964692]  [<ffffffff802afd66>] ? filemap_fault+0x156/0x420
[328109.964692]  [<ffffffff802c5fea>] ? __do_fault+0x42a/0x510
[328109.964692]  [<ffffffff80483a8d>] ? sys_sendto+0x11d/0x180
[328109.964692]  [<ffffffff802c82e9>] ? handle_mm_fault+0x1b9/0xb00
[328109.964692]  [<ffffffff80484457>] ? sys_getsockname+0xd7/0xf0
[328109.964692]  [<ffffffff8026ea6e>] ? getnstimeofday+0x4e/0xe0
[328109.964692]  [<ffffffff8025d898>] ? ktime_get_ts+0x28/0x60
[328109.964692]  [<ffffffff80302194>] ? poll_select_set_timeout+0x74/0xa0
[328109.964692]  [<ffffffff80302921>] ? sys_poll+0x71/0x110
[328109.964692]  [<ffffffff80230272>] ? ia32_sysret+0x0/0xa
[328109.964692] Code: e4 ff ff 85 c0 7e 49 48 8b 7d 60 48 85 ff 74 38 48 89 
de e8 a8 e4 ff ff 85 c0 7e 44 48 8b 45 60 48 39 c3 74 3f 48 3b 5d 58 74 4d 
<8b> 73 38 85 f6 74 86 48 89 de 48 89 ef e8 93 f3 ff ff e9 76 ff 
[328109.964692] RIP  [<ffffffff802357eb>] pick_next_task_fair+0x9b/0x120
[328109.964692]  RSP <ffff8801ee9bd968>
[328109.964692] CR2: 0000000000000038
[328109.964692] ---[ end trace 22ebb73050974e75 ]---
[328192.410933] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328192.427185] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328192.533849] CPU 2:
[328192.540518] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328192.647185] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328192.673851] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328192.700518] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328192.717185] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328192.737185] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328192.760518] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328192.780518] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328192.803851] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328192.823851] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328192.847185] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328192.867185] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328192.887185] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328192.910518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328192.930518] Call Trace:
[328192.937185]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328192.957185]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328192.977185]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328192.993851]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328193.013851]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328193.033851]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328193.050518]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328257.910925] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328257.927176] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328258.033843] CPU 2:
[328258.040509] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328258.147176] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328258.173843] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328258.200509] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328258.217176] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328258.237176] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328258.260509] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328258.280509] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328258.300509] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328258.323843] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328258.347176] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328258.367176] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328258.387176] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328258.410509] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328258.430509] Call Trace:
[328258.437176]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328258.457176]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328258.477176]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328258.493843]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328258.513843]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328258.533843]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328258.550509]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328323.407585] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328323.423836] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328323.530503] CPU 2:
[328323.537170] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328323.643836] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328323.670503] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328323.697170] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328323.713836] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328323.733836] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328323.757170] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328323.777170] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328323.797170] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328323.820503] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328323.843836] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328323.863836] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328323.883836] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328323.907170] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328323.927170] Call Trace:
[328323.933836]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328323.953836]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328323.973836]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328323.990503]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328324.010503]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328324.030503]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328324.047170]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328388.907578] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328388.923830] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328389.030496] CPU 2:
[328389.037163] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328389.143830] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328389.170496] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328389.197163] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328389.213830] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328389.233830] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328389.257163] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328389.277163] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328389.300496] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328389.320496] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328389.343830] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328389.363830] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328389.383830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328389.407163] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328389.427163] Call Trace:
[328389.433830]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328389.453830]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328389.473830]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328389.490496]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328389.510496]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328389.530496]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328389.547163]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328454.404238] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328454.420490] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328454.527157] CPU 2:
[328454.533823] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328454.640490] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328454.667157] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328454.693823] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328454.710490] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328454.730490] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328454.753823] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328454.773823] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328454.797157] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328454.817157] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328454.840490] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328454.860490] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328454.880490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328454.903823] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328454.923823] Call Trace:
[328454.930490]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328454.950490]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328454.970490]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328454.987156]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328455.007157]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328455.027157]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328455.043823]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328519.904232] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328519.920483] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328520.027150] CPU 2:
[328520.033817] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328520.140483] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328520.167150] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328520.193817] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328520.210483] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328520.230483] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328520.253817] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328520.273817] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328520.293817] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328520.317150] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328520.340483] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328520.360483] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328520.380483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328520.403817] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328520.423817] Call Trace:
[328520.430483]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328520.450483]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328520.470483]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328520.487150]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328520.507150]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328520.527150]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328520.543817]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328585.400892] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328585.417144] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328585.523810] CPU 2:
[328585.530477] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328585.637143] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328585.663810] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328585.690477] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328585.707143] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328585.727143] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328585.750477] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328585.770477] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328585.790477] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328585.813811] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328585.837144] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328585.857143] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328585.877143] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328585.900477] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328585.920477] Call Trace:
[328585.927143]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328585.947143]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328585.967143]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328585.983810]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328586.003810]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328586.023810]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328586.040477]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328650.897552] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328650.913804] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328651.020470] CPU 2:
[328651.027137] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328651.133804] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328651.160470] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328651.187137] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328651.203803] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328651.223803] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328651.243803] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328651.267137] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328651.287137] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328651.310470] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328651.333804] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328651.353803] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328651.373803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328651.397137] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328651.417137] Call Trace:
[328651.423803]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328651.443803]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328651.463803]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328651.480470]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328651.500470]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328651.520470]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328651.537137]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328716.397545] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328716.413797] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328716.520464] CPU 2:
[328716.527130] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328716.633797] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328716.660464] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328716.687130] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328716.700464] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328716.723797] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328716.743797] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328716.767130] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328716.787130] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328716.810464] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328716.833797] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328716.853797] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328716.873797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328716.897130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328716.917130] Call Trace:
[328716.923797]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328716.943797]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328716.963797]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328716.980463]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328717.000464]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328717.020464]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328717.037130]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328781.894206] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328781.910457] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328782.017124] CPU 2:
[328782.023791] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328782.130457] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328782.157124] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328782.183790] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328782.200457] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328782.220457] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328782.243790] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328782.263790] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328782.283790] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328782.307124] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328782.330457] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328782.350457] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328782.370457] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328782.393790] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328782.413791] Call Trace:
[328782.420457]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328782.440457]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328782.460457]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328782.477124]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328782.497124]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328782.517124]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328782.533790]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30

************************************************************************************

2.6.30 on amd machine:

[328109.962383] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000038
[328109.964692] IP: [<ffffffff802357eb>] pick_next_task_fair+0x9b/0x120
[328109.964692] PGD 216478067 PUD 2129cc067 PMD 0 
[328109.964692] Oops: 0000 [#1] SMP 
[328109.964692] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq
[328109.964692] CPU 4 
[328109.964692] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328109.964692] Pid: 16435, comm: php Not tainted 2.6.30.6_nogrsecurity-0.1 
#1 H8DMU
[328109.964692] RIP: 0010:[<ffffffff802357eb>]  [<ffffffff802357eb>] 
pick_next_task_fair+0x9b/0x120
[328109.964692] RSP: 0000:ffff8801ee9bd968  EFLAGS: 00210046
[328109.964692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff8801ee9bda08
[328109.964692] RDX: 000000000000008d RSI: 0000000000000001 RDI: 
0000000000000000
[328109.964692] RBP: ffffc20000061168 R08: ffffc20000061a08 R09: 
0000000000000000
[328109.964692] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[328109.964692] R13: ffffc20000061100 R14: ffff880169b18a00 R15: 
ffffc20000061a18
[328109.964692] FS:  00007f4601b03790(0000) GS:ffffc20000050000(0063) 
knlGS:00000000f78716c0
[328109.964692] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[328109.964692] CR2: 0000000000000038 CR3: 000000012c2c5000 CR4: 
00000000000006e0
[328109.964692] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328109.964692] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328109.964692] Process php (pid: 16435, threadinfo ffff8801ee9bc000, task 
ffff88021e97bcc0)
[328109.964692] Stack:
[328109.964692]  0000000000000000 ffffc20000061100 0000000000000000 
ffffffff80586aa0
[328109.964692]  ffffc20000061a18 ffffffff8056ed93 0000000000000004 
ffff8801655230f8
[328109.964692]  ffff88021f047000 ffffffff8025db8c ffff88021e97bcc0 
ffff8801ee9bda88
[328109.964692] Call Trace:
[328109.964692]  [<ffffffff8056ed93>] ? thread_return+0x26d/0x8ea
[328109.964692]  [<ffffffff8025db8c>] ? ktime_get_real+0xc/0x40
[328109.964692]  [<ffffffff8025cb1e>] ? enqueue_hrtimer+0x6e/0x80
[328109.964692]  [<ffffffff8025d454>] ? __hrtimer_start_range_ns+0x124/0x2b0
[328109.964692]  [<ffffffff8056f419>] ? schedule+0x9/0x20
[328109.964692]  [<ffffffff80570755>] ? schedule_hrtimeout_range+0xc5/0x160
[328109.964692]  [<ffffffff8025cbf0>] ? hrtimer_wakeup+0x0/0x30
[328109.964692]  [<ffffffff8057073b>] ? schedule_hrtimeout_range+0xab/0x160
[328109.964692]  [<ffffffff803021ec>] ? poll_schedule_timeout+0x2c/0x50
[328109.964692]  [<ffffffff8030263b>] ? do_sys_poll+0x37b/0x460
[328109.964692]  [<ffffffff804dbe0b>] ? tcp_write_xmit+0x1fb/0xa20
[328109.964692]  [<ffffffff803036c0>] ? __pollwait+0x0/0x120
[328109.964692]  [<ffffffff803037e0>] ? pollwake+0x0/0x50
[328109.964692]  [<ffffffff80482946>] ? sock_sendmsg+0x146/0x210
[328109.964692]  [<ffffffff80259d40>] ? autoremove_wake_function+0x0/0x30
[328109.964692]  [<ffffffff802af610>] ? find_lock_page+0x30/0x80
[328109.964692]  [<ffffffff802afd66>] ? filemap_fault+0x156/0x420
[328109.964692]  [<ffffffff802c5fea>] ? __do_fault+0x42a/0x510
[328109.964692]  [<ffffffff80483a8d>] ? sys_sendto+0x11d/0x180
[328109.964692]  [<ffffffff802c82e9>] ? handle_mm_fault+0x1b9/0xb00
[328109.964692]  [<ffffffff80484457>] ? sys_getsockname+0xd7/0xf0
[328109.964692]  [<ffffffff8026ea6e>] ? getnstimeofday+0x4e/0xe0
[328109.964692]  [<ffffffff8025d898>] ? ktime_get_ts+0x28/0x60
[328109.964692]  [<ffffffff80302194>] ? poll_select_set_timeout+0x74/0xa0
[328109.964692]  [<ffffffff80302921>] ? sys_poll+0x71/0x110
[328109.964692]  [<ffffffff80230272>] ? ia32_sysret+0x0/0xa
[328109.964692] Code: e4 ff ff 85 c0 7e 49 48 8b 7d 60 48 85 ff 74 38 48 89 
de e8 a8 e4 ff ff 85 c0 7e 44 48 8b 45 60 48 39 c3 74 3f 48 3b 5d 58 74 4d 
<8b> 73 38 85 f6 74 86 48 89 de 48 89 ef e8 93 f3 ff ff e9 76 ff 
[328109.964692] RIP  [<ffffffff802357eb>] pick_next_task_fair+0x9b/0x120
[328109.964692]  RSP <ffff8801ee9bd968>
[328109.964692] CR2: 0000000000000038
[328109.964692] ---[ end trace 22ebb73050974e75 ]---
[328192.410933] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328192.427185] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328192.533849] CPU 2:
[328192.540518] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328192.647185] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328192.673851] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328192.700518] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328192.717185] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328192.737185] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328192.760518] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328192.780518] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328192.803851] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328192.823851] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328192.847185] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328192.867185] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328192.887185] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328192.910518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328192.930518] Call Trace:
[328192.937185]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328192.957185]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328192.977185]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328192.993851]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328193.013851]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328193.033851]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328193.050518]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328257.910925] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328257.927176] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328258.033843] CPU 2:
[328258.040509] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328258.147176] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328258.173843] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328258.200509] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328258.217176] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328258.237176] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328258.260509] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328258.280509] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328258.300509] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328258.323843] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328258.347176] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328258.367176] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328258.387176] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328258.410509] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328258.430509] Call Trace:
[328258.437176]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328258.457176]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328258.477176]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328258.493843]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328258.513843]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328258.533843]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328258.550509]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328323.407585] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328323.423836] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328323.530503] CPU 2:
[328323.537170] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328323.643836] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328323.670503] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328323.697170] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328323.713836] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328323.733836] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328323.757170] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328323.777170] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328323.797170] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328323.820503] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328323.843836] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328323.863836] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328323.883836] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328323.907170] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328323.927170] Call Trace:
[328323.933836]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328323.953836]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328323.973836]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328323.990503]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328324.010503]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328324.030503]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328324.047170]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328388.907578] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328388.923830] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328389.030496] CPU 2:
[328389.037163] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328389.143830] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328389.170496] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328389.197163] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328389.213830] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328389.233830] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328389.257163] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328389.277163] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328389.300496] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328389.320496] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328389.343830] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328389.363830] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328389.383830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328389.407163] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328389.427163] Call Trace:
[328389.433830]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328389.453830]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328389.473830]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328389.490496]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328389.510496]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328389.530496]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328389.547163]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328454.404238] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328454.420490] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328454.527157] CPU 2:
[328454.533823] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328454.640490] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328454.667157] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328454.693823] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328454.710490] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328454.730490] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328454.753823] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328454.773823] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328454.797157] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328454.817157] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328454.840490] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328454.860490] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328454.880490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328454.903823] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328454.923823] Call Trace:
[328454.930490]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328454.950490]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328454.970490]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328454.987156]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328455.007157]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328455.027157]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328455.043823]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328519.904232] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328519.920483] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328520.027150] CPU 2:
[328520.033817] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328520.140483] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328520.167150] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328520.193817] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328520.210483] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328520.230483] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328520.253817] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328520.273817] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328520.293817] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328520.317150] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328520.340483] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328520.360483] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328520.380483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328520.403817] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328520.423817] Call Trace:
[328520.430483]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328520.450483]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328520.470483]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328520.487150]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328520.507150]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328520.527150]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328520.543817]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328585.400892] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328585.417144] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328585.523810] CPU 2:
[328585.530477] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328585.637143] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328585.663810] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328585.690477] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328585.707143] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328585.727143] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328585.750477] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328585.770477] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328585.790477] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328585.813811] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328585.837144] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328585.857143] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328585.877143] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328585.900477] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328585.920477] Call Trace:
[328585.927143]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328585.947143]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328585.967143]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328585.983810]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328586.003810]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328586.023810]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328586.040477]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328650.897552] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328650.913804] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328651.020470] CPU 2:
[328651.027137] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328651.133804] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328651.160470] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328651.187137] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328651.203803] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328651.223803] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328651.243803] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328651.267137] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328651.287137] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328651.310470] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328651.333804] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328651.353803] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328651.373803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328651.397137] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328651.417137] Call Trace:
[328651.423803]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328651.443803]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328651.463803]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328651.480470]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328651.500470]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328651.520470]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328651.537137]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328716.397545] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328716.413797] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328716.520464] CPU 2:
[328716.527130] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328716.633797] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328716.660464] RIP: 0010:[<ffffffff8022f142>]  [<ffffffff8022f142>] 
flush_tlb_others_ipi+0x112/0x120
[328716.687130] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328716.700464] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328716.723797] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328716.743797] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328716.767130] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328716.787130] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328716.810464] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328716.833797] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328716.853797] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328716.873797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328716.897130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328716.917130] Call Trace:
[328716.923797]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328716.943797]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328716.963797]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328716.980463]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328717.000464]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328717.020464]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328717.037130]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30
[328781.894206] BUG: soft lockup - CPU#2 stuck for 61s! [java:4933]
[328781.910457] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328782.017124] CPU 2:
[328782.023791] Modules linked in: sg forcedeth ipmi_watchdog sch_sfq 
ipt_ULOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state xt_multiport 
iptable_filter ip_tables x_tables ohci_hcd ssb pcmcia pcmcia_core usbhid hid 
nf_conntrack_ftp nf_conntrack dm_mod ipmi_devintf ipmi_si ipmi_msghandler 
ehci_hcd usbcore amd74xx ide_core xfs exportfs sd_mod crc_t10dif aacraid 
scsi_mod [last unloaded: forcedeth]
[328782.130457] Pid: 4933, comm: java Tainted: G      D    
2.6.30.6_nogrsecurity-0.1 #1 H8DMU
[328782.157124] RIP: 0010:[<ffffffff8022f146>]  [<ffffffff8022f146>] 
flush_tlb_others_ipi+0x116/0x120
[328782.183790] RSP: 0000:ffff8802100e7d88  EFLAGS: 00000202
[328782.200457] RAX: 0000000000000080 RBX: 0000000000000080 RCX: 
0000000000000020
[328782.220457] RDX: 0000000000000081 RSI: 00000000000000f2 RDI: 
ffffffff807c2b98
[328782.243790] RBP: ffffffff8020c98e R08: ffff88021e8e90a8 R09: 
0000000000000000
[328782.263790] R10: 3880000000000000 R11: ffff880212870df8 R12: 
0000000000000000
[328782.283790] R13: ffffe20003ad1dc8 R14: ffffffff802af4ce R15: 
000000000000d580
[328782.307124] FS:  00007f3e462786f0(0000) GS:ffffc20000028000(0063) 
knlGS:00000000a73a4bb0
[328782.330457] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[328782.350457] CR2: 00000000f7f57168 CR3: 0000000210dd3000 CR4: 
00000000000006e0
[328782.370457] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[328782.393790] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[328782.413791] Call Trace:
[328782.420457]  [<ffffffff8022f12f>] ? flush_tlb_others_ipi+0xff/0x120
[328782.440457]  [<ffffffff8022e6ea>] ? ptep_set_access_flags+0x1a/0x20
[328782.460457]  [<ffffffff802c6480>] ? do_wp_page+0xd0/0x840
[328782.477124]  [<ffffffff802ed4a1>] ? 
__mem_cgroup_commit_charge_swapin+0x1d1/0x250
[328782.497124]  [<ffffffff802c8790>] ? handle_mm_fault+0x660/0xb00
[328782.517124]  [<ffffffff80573f9b>] ? do_page_fault+0xfb/0x390
[328782.533790]  [<ffffffff80571bdf>] ? page_fault+0x1f/0x30

************************************************************************************
2.6.31 with debug options didn't work at all:

[   23.165601] Trying to unpack rootfs image as initramfs...
[   23.319343] BUG: unable to handle kernel NULL pointer dereference at 
(null)
[   23.320011] IP: [<(null)>] (null)
[   23.320011] PGD 0 
[   23.320011] Oops: 0010 [#1] SMP 
[   23.320011] last sysfs file: 
[   23.320011] CPU 0 
[   23.320011] Modules linked in:
[   23.320011] Pid: 1, comm: swapper Not tainted 2.6.31-0.testcrap.1 #1 
H8DMU
[   23.320011] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[   23.320011] RSP: 0018:ffff88021ba13d18  EFLAGS: 00010246
[   23.320011] RAX: 0000000000008000 RBX: 0000000000000000 RCX: 
ffffffff00006558
[   23.320011] RDX: 0000000000006558 RSI: 0000000000004000 RDI: 
ffff880000e76000
[   23.320011] RBP: ffff88021ba13d90 R08: 0000000000000000 R09: 
0000000000000000
[   23.320011] R10: 0000000000006558 R11: 0000000000000000 R12: 
ffff88011b116960
[   23.320011] R13: ffff88021ace0000 R14: ffffffff81644ba2 R15: 
ffff880000e76000
[   23.320011] FS:  0000000000000000(0000) GS:ffffc90000000000(0000) 
knlGS:0000000000000000
[   23.320011] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   23.320011] CR2: 0000000000000000 CR3: 00000000013e6000 CR4: 
00000000000006f0
[   23.320011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   23.320011] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 
0000000000000400
[   23.320011] Process swapper (pid: 1, threadinfo ffff88021ba12000, task 
ffff88011ba90000)
[   23.320011] Stack:
[   23.320011]  ffffffff81664d01 ffff88021ba13d30 ffffffff00006558 
0000800000e76000
[   23.320011] <0> ffffffff816b22d8 0000000000000000 ffff880000e76000 
ffff880000e76000
[   23.320011] <0> 00000000811043e4 0000000000089bff 0000000000089bff 
ffff880000e76000
[   23.320011] Call Trace:
[   23.320011]  [<ffffffff81664d01>] ? gunzip+0x30a/0x42b
[   23.320011]  [<ffffffff81645067>] unpack_to_rootfs+0x22e/0x34b
[   23.320011]  [<ffffffff81644997>] ? error+0x0/0x17
[   23.320011]  [<ffffffff8164598e>] populate_rootfs+0x70/0x2eb
[   23.320011]  [<ffffffff81178000>] ? proc_create_data+0x70/0xc0
[   23.320011]  [<ffffffff8117c1d8>] ? proc_net_fops_create+0x18/0x20
[   23.320011]  [<ffffffff813cc419>] ? mutex_unlock+0x9/0x10
[   23.320011]  [<ffffffff812e0245>] ? register_pernet_subsys+0x35/0x40
[   23.320011]  [<ffffffff8164591e>] ? populate_rootfs+0x0/0x2eb
[   23.320011]  [<ffffffff81001047>] do_one_initcall+0x37/0x170
[   23.320011]  [<ffffffff81643137>] kernel_init+0x162/0x1bd
[   23.320011]  [<ffffffff81004f5a>] child_rip+0xa/0x20
[   23.320011]  [<ffffffff81642fd5>] ? kernel_init+0x0/0x1bd
[   23.320011]  [<ffffffff81004f50>] ? child_rip+0x0/0x20
[   23.320011] Code:  Bad RIP value.
[   23.320011] RIP  [<(null)>] (null)
[   23.320011]  RSP <ffff88021ba13d18>
[   23.320011] CR2: 0000000000000000
[   24.037117] ---[ end trace 9865ac5b5ee90b51 ]---
[   24.051068] Kernel panic - not syncing: Attempted to kill init!
[   24.068818] Pid: 1, comm: swapper Tainted: G      D    
2.6.31-0.testcrap.1 #1
[   24.090305] Call Trace:
[   24.097647]  [<ffffffff813ca8f4>] panic+0x73/0x125
[   24.112001]  [<ffffffff8104b0a4>] do_exit+0x744/0x830
[   24.127136]  [<ffffffff8104b1d5>] do_group_exit+0x45/0xb0
[   24.143408]  [<ffffffff813cebed>] oops_end+0x9d/0xe0
[   24.158277]  [<ffffffff810282aa>] no_context+0xea/0x260
[   24.173926]  [<ffffffff81028596>] __bad_area_nosemaphore+0x176/0x290
[   24.192961]  [<ffffffff8102dbc5>] ? kmemcheck_read+0x45/0x70
[   24.209994]  [<ffffffff8102e471>] ? kmemcheck_pte_lookup+0x11/0x60
[   24.228524]  [<ffffffff8102d821>] ? kmemcheck_show_addr+0x11/0x30
[   24.246776]  [<ffffffff8102d87b>] ? kmemcheck_show_all+0x3b/0x60
[   24.264768]  [<ffffffff81644ba2>] ? flush_buffer+0x0/0xa3
[   24.280991]  [<ffffffff810286be>] bad_area_nosemaphore+0xe/0x10
[   24.298721]  [<ffffffff813d051b>] do_page_fault+0x31b/0x3c0
[   24.315411]  [<ffffffff81644ba2>] ? flush_buffer+0x0/0xa3
[   24.331583]  [<ffffffff813cdfef>] page_fault+0x1f/0x30
[   24.347079]  [<ffffffff81644ba2>] ? flush_buffer+0x0/0xa3
[   24.363249]  [<ffffffff81664d01>] ? gunzip+0x30a/0x42b
[   24.378647]  [<ffffffff81645067>] unpack_to_rootfs+0x22e/0x34b
[   24.396483]  [<ffffffff81644997>] ? error+0x0/0x17
[   24.410851]  [<ffffffff8164598e>] populate_rootfs+0x70/0x2eb
[   24.427802]  [<ffffffff81178000>] ? proc_create_data+0x70/0xc0
[   24.445273]  [<ffffffff8117c1d8>] ? proc_net_fops_create+0x18/0x20
[   24.463890]  [<ffffffff813cc419>] ? mutex_unlock+0x9/0x10
[   24.480060]  [<ffffffff812e0245>] ? register_pernet_subsys+0x35/0x40
[   24.499090]  [<ffffffff8164591e>] ? populate_rootfs+0x0/0x2eb
[   24.516304]  [<ffffffff81001047>] do_one_initcall+0x37/0x170
[   24.533358]  [<ffffffff81643137>] kernel_init+0x162/0x1bd
[   24.549528]  [<ffffffff81004f5a>] child_rip+0xa/0x20
[   24.564400]  [<ffffffff81642fd5>] ? kernel_init+0x0/0x1bd
[   24.580570]  [<ffffffff81004f50>] ? child_rip+0x0/0x20
[   24.596041] Rebooting in 30 seconds..

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

