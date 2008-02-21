Return-Path: <linux-kernel-owner+w=401wt.eu-S1765736AbYBULGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765736AbYBULGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbYBULGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:06:39 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:47210 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbYBULGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:06:37 -0500
Message-ID: <47BD5B30.103@allied-internet.ag>
Date: Thu, 21 Feb 2008 12:06:24 +0100
From: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>	<47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org>
In-Reply-To: <20080217125407.5b76a052@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I've done the (echo t > /proc/sysrq-trigger) now but i'm not able to get 
the whole output via dmesg.

Here is what i get:
# dmesg
3.432124]  [<c0165a11>] do_select+0x390/0x46e
[272363.432226]  [<c0166107>] __pollwait+0x0/0xcf
[272363.432319]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.432416]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.432513]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.432606]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.432711]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.432802]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.432917]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.433013]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.433109]  [<c0345ad0>] dst_output+0x0/0x7
[272363.433194]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.433290]  [<c0345ad0>] dst_output+0x0/0x7
[272363.433375]  [<c0114d72>] enqueue_entity+0x20/0x40
[272363.433465]  [<c0114da6>] enqueue_task_fair+0x14/0x29
[272363.433559]  [<c0113ee0>] enqueue_task+0xa/0x14
[272363.433646]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.433740]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.433836]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.433933]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.434024]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.434114]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.434208]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.434311]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.434404]  [<c0325af2>] lock_sock_nested+0xa3/0xab
[272363.434497]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.434588]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.434678]  [<c03259d1>] release_sock+0x12/0x90
[272363.434766]  [<c034e865>] tcp_recvmsg+0x1b7/0x7f0
[272363.434863]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.434959]  [<c03253b2>] sock_common_recvmsg+0x3e/0x54
[272363.435064]  [<c0323416>] sock_aio_read+0xd2/0xeb
[272363.435152]  [<c03295b1>] skb_release_all+0x4c/0xba
[272363.435252]  [<c015a530>] do_sync_read+0xd2/0x10e
[272363.435351]  [<c02b30ab>] speedo_interrupt+0x5e/0x6ed
[272363.435447]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.435547]  [<c017ee88>] inotify_inode_queue_event+0x31/0xe6
[272363.435651]  [<c0328e26>] __kfree_skb+0x8/0x71
[272363.435748]  [<c0166215>] sys_select+0x3f/0x1ab
[272363.435839]  [<c015b140>] sys_read+0x41/0x6a
[272363.435929]  [<c01027ae>] syscall_call+0x7/0xb
[272363.436026]  =======================
[272363.436092] imapd         S e3193b1c     0  5667   5657
[272363.436198]        ee1ab030 00200082 00000002 e3193b1c e3193b14 
00000000 00000000 00000001
[272363.436389]        ee1ab16c c2827c00 c04c3080 c04c3080 00000000 
00000000 00200286 c04c3080
[272363.436609]        e3193b40 040d856e 00000000 ffffffff 00000000 
00000000 00000000 e3193b40
[272363.436821] Call Trace:
[272363.436917]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.437017]  [<c01227b1>] process_timeout+0x0/0x5
[272363.437113]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.437209]  [<c0165a11>] do_select+0x390/0x46e
[272363.437309]  [<c0166107>] __pollwait+0x0/0xcf
[272363.437399]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.437499]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.437613]  [<c0114d72>] enqueue_entity+0x20/0x40
[272363.437709]  [<c0114da6>] enqueue_task_fair+0x14/0x29
[272363.437805]  [<c0113ee0>] enqueue_task+0xa/0x14
[272363.437893]  [<c01146cc>] update_curr+0xe1/0xe8
[272363.437986]  [<c0114d72>] enqueue_entity+0x20/0x40
[272363.438079]  [<c0114da6>] enqueue_task_fair+0x14/0x29
[272363.438173]  [<c0113ee0>] enqueue_task+0xa/0x14
[272363.438258]  [<c01146cc>] update_curr+0xe1/0xe8
[272363.438352]  [<c0114d72>] enqueue_entity+0x20/0x40
[272363.438442]  [<c0114da6>] enqueue_task_fair+0x14/0x29
[272363.438536]  [<c0113ee0>] enqueue_task+0xa/0x14
[272363.438623]  [<c0115b5a>] try_to_wake_up+0x42/0x278
[272363.438719]  [<c0115f25>] __wake_up_sync+0x35/0x4d
[272363.438813]  [<c03276bb>] sock_wfree+0x36/0x38
[272363.438904]  [<c01141f6>] __wake_up_common+0x46/0x68
[272363.439002]  [<c0115f6f>] __wake_up+0x32/0x42
[272363.439093]  [<c0327420>] sock_def_readable+0x66/0x68
[272363.439190]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.439287]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.439387]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.439489]  [<c011464f>] update_curr+0x64/0xe8
[272363.439591]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.439690]  [<c01027ae>] syscall_call+0x7/0xb
[272363.439786]  =======================
[272363.439854] du            D 00000806     0  5910      1
[272363.439958]        c0cdf570 00200082 cf811ef0 00000806 00000000 
00000000 0580eba0 000041c0
[272363.440147]        c0cdf6ac c281ec00 c04c3080 c04c3080 00000000 
00000000 00002000 c04c3080
[272363.440367]        00001000 00000018 00000000 47bd1e82 06ed11c0 
47bcd258 2b2a4ff7 c4bbd6f0
[272363.440589] Call Trace:
[272363.440685]  [<c03938f7>] __mutex_lock_slowpath+0x55/0x8b
[272363.440788]  [<c0164e28>] filldir64+0x0/0xc5
[272363.440877]  [<c0393786>] mutex_lock+0xa/0xb
[272363.440964]  [<c0164fef>] vfs_readdir+0x3d/0x80
[272363.441055]  [<c0165095>] sys_getdents64+0x63/0xa5
[272363.441151]  [<c01027ae>] syscall_call+0x7/0xb
[272363.441247]  =======================
[272363.441316] qmail-pop3d   D c281ba40     0  7478      1
[272363.441421]        ce864570 00000082 00000024 c281ba40 00000002 
d4f19f34 0580eba0 000041c0
[272363.441617]        ce8646ac c281ec00 c04c3080 c04c3080 00000000 
00000000 00002000 c04c3080
[272363.441829]        00001000 04074105 00000001 ffffffff 00000000 
00000000 00000024 c4bbd6f0
[272363.442046] Call Trace:
[272363.442139]  [<c03938f7>] __mutex_lock_slowpath+0x55/0x8b
[272363.442245]  [<c0164e28>] filldir64+0x0/0xc5
[272363.442332]  [<c0393786>] mutex_lock+0xa/0xb
[272363.442422]  [<c0164fef>] vfs_readdir+0x3d/0x80
[272363.442512]  [<c0165095>] sys_getdents64+0x63/0xa5
[272363.442611]  [<c01027ae>] syscall_call+0x7/0xb
[272363.442707]  =======================
[272363.442773] imapd         S e9d93b1c     0  8227      1
[272363.442876]        f7705570 00000086 00000002 e9d93b1c e9d93b14 
00000000 00000000 00000001
[272363.443068]        f77056ac c281ec00 c04c3080 c04c3080 00000000 
00000000 00000286 c04c3080
[272363.443283]        e9d93b40 040db74c 00000000 ffffffff 00000000 
00000000 00000000 e9d93b40
[272363.443497] Call Trace:
[272363.443593]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.443692]  [<c01227b1>] process_timeout+0x0/0x5
[272363.443788]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.443882]  [<c0165a11>] do_select+0x390/0x46e
[272363.443987]  [<c0166107>] __pollwait+0x0/0xcf
[272363.444078]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.444183]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.444282]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.444376]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.444476]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.444563]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.444681]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.444775]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.444871]  [<c0345ad0>] dst_output+0x0/0x7
[272363.444959]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.445055]  [<c0345ad0>] dst_output+0x0/0x7
[272363.445143]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.445251]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.445348]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.445444]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.445538]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.445634]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.445725]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.445818]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.445920]  [<c0230f45>] xfs_trans_tail_ail+0x13/0x2b
[272363.446011]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.446114]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.446207]  [<c03259d1>] release_sock+0x12/0x90
[272363.446298]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.446397]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.446496]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.446598]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.446700]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.446798]  [<c012e789>] ktime_get_ts+0x11/0x3a
[272363.446894]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.446988]  [<c01027ae>] syscall_call+0x7/0xb
[272363.447081]  =======================
[272363.447149] imapd         S c2824aa0     0  9058      1
[272363.447258]        f1476030 00000086 00000400 c2824aa0 00000002 
e993fb18 80000000 e99d6180
[272363.447452]        f147616c c2827c00 c04c3080 c04c3080 e99d6b80 
c0347dc3 00000286 c04c3080
[272363.447664]        e993fb40 040db3c1 00000001 ffffffff 00000000 
00000000 00000400 e993fb40
[272363.447884] Call Trace:
[272363.447974]  [<c0347dc3>] ip_send_reply+0x19b/0x1f5
[272363.451873]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.451970]  [<c01227b1>] process_timeout+0x0/0x5
[272363.452069]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.452165]  [<c0165a11>] do_select+0x390/0x46e
[272363.452267]  [<c0166107>] __pollwait+0x0/0xcf
[272363.452358]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.452460]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.452560]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.452656]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.452758]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.452849]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.452961]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.453055]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.453149]  [<c0345ad0>] dst_output+0x0/0x7
[272363.453236]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.453333]  [<c0345ad0>] dst_output+0x0/0x7
[272363.453417]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.453526]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.453623]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.453719]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.453818]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.453911]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.454007]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.454100]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.454201]  [<c0230f45>] xfs_trans_tail_ail+0x13/0x2b
[272363.454297]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.454399]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.454490]  [<c03259d1>] release_sock+0x12/0x90
[272363.454580]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.454682]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.454779]  [<c02b2d3c>] speedo_tx_buffer_gc+0x82/0x1ab
[272363.454881]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.454978]  [<c02b30ab>] speedo_interrupt+0x5e/0x6ed
[272363.455072]  [<c03295b1>] skb_release_all+0x4c/0xba
[272363.455169]  [<c0328e26>] __kfree_skb+0x8/0x71
[272363.455262]  [<c032ffd0>] net_tx_action+0x43/0xe0
[272363.455355]  [<c011f422>] __do_softirq+0x72/0xdf
[272363.455449]  [<c0104f29>] do_IRQ+0x40/0x77
[272363.455534]  [<c0103157>] common_interrupt+0x23/0x28
[272363.455633]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.455732]  [<c01027ae>] syscall_call+0x7/0xb
[272363.455823]  [<c0390000>] qword_get+0x14d/0x27c
[272363.455916]  =======================
[272363.455989] qmail-pop3d   D c2e2df38     0  9076      1
[272363.456099]        f1e71ab0 00000082 c2e2df30 c2e2df38 c2e2df30 
00000000 0580eba0 000041c0
[272363.456297]        f1e71bec c2830c00 c04c3080 c04c3080 00000000 
00000000 00002000 c04c3080
[272363.456517]        00001000 040819b1 00000000 ffffffff 00000000 
00000000 0000006e c4bbd6f0
[272363.456734] Call Trace:
[272363.456827]  [<c03938f7>] __mutex_lock_slowpath+0x55/0x8b
[272363.456933]  [<c0164e28>] filldir64+0x0/0xc5
[272363.457015]  [<c0393786>] mutex_lock+0xa/0xb
[272363.457102]  [<c0164fef>] vfs_readdir+0x3d/0x80
[272363.457196]  [<c0165095>] sys_getdents64+0x63/0xa5
[272363.457292]  [<c01027ae>] syscall_call+0x7/0xb
[272363.457388]  =======================
[272363.457456] imapd         S f6261b1c     0 10556      1
[272363.457559]        f73af570 00000086 00000002 f6261b1c f6261b14 
00000000 f55c0940 c2827c34
[272363.457753]        f73af6ac c2815c00 c04c3080 c04c3080 f73af570 
c04493a0 00000282 c04c3080
[272363.457976]        f6261b40 040db74d 00000000 ffffffff 00000000 
00000000 00000000 f6261b40
[272363.458190] Call Trace:
[272363.458284]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.458383]  [<c01227b1>] process_timeout+0x0/0x5
[272363.458479]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.458572]  [<c0165a11>] do_select+0x390/0x46e
[272363.458672]  [<c0166107>] __pollwait+0x0/0xcf
[272363.458764]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.458867]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.458969]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.459062]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.459165]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.459253]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.459365]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.459462]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.459558]  [<c0345ad0>] dst_output+0x0/0x7
[272363.459649]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.459745]  [<c0345ad0>] dst_output+0x0/0x7
[272363.459829]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.459942]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.460038]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.460135]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.460234]  [<c02b2d3c>] speedo_tx_buffer_gc+0x82/0x1ab
[272363.460333]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.460424]  [<c02b30ab>] speedo_interrupt+0x5e/0x6ed
[272363.460520]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.460629]  [<c03295b1>] skb_release_all+0x4c/0xba
[272363.460723]  [<c0220050>] xfs_iomap_write_direct+0x1a6/0x5b6
[272363.460828]  [<c0328e26>] __kfree_skb+0x8/0x71
[272363.460924]  [<c032ffd0>] net_tx_action+0x43/0xe0
[272363.461018]  [<c011f422>] __do_softirq+0x72/0xdf
[272363.461114]  [<c0104f29>] do_IRQ+0x40/0x77
[272363.461201]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.461300]  [<c032327f>] sock_aio_write+0x20/0xe5
[272363.461403]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.461505]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.461608]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.461704]  [<c01027ae>] syscall_call+0x7/0xb
[272363.461797]  [<c0390000>] qword_get+0x14d/0x27c
[272363.461893]  =======================
[272363.461961] imapd         S e31bfb1c     0 10557      1
[272363.462067]        eb633570 00000082 00000002 e31bfb1c e31bfb14 
00000000 00000000 00000001
[272363.462259]        eb6336ac c2827c00 c04c3080 c04c3080 00000000 
00000000 00000286 c04c3080
[272363.462479]        e31bfb40 040dcb3f 00000000 ffffffff 00000000 
00000000 00000000 e31bfb40
[272363.462693] Call Trace:
[272363.462786]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.462885]  [<c01227b1>] process_timeout+0x0/0x5
[272363.462978]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.463072]  [<c0165a11>] do_select+0x390/0x46e
[272363.463172]  [<c0166107>] __pollwait+0x0/0xcf
[272363.463262]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.463361]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.463463]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.463557]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.463654]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.463745]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.463853]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.463947]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.464035]  [<c0345ad0>] dst_output+0x0/0x7
[272363.464122]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.464212]  [<c0345ad0>] dst_output+0x0/0x7
[272363.464297]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.464395]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.464485]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.464578]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.464666]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.464754]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.464841]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.464931]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.465025]  [<c0230f45>] xfs_trans_tail_ail+0x13/0x2b
[272363.465118]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.465215]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.465299]  [<c03259d1>] release_sock+0x12/0x90
[272363.465389]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.465480]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.465576]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.465667]  [<c02b30ab>] speedo_interrupt+0x5e/0x6ed
[272363.465760]  [<c03295b1>] skb_release_all+0x4c/0xba
[272363.465850]  [<c0328e26>] __kfree_skb+0x8/0x71
[272363.465935]  [<c032ffd0>] net_tx_action+0x43/0xe0
[272363.466022]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.466112]  [<c011f422>] __do_softirq+0x72/0xdf
[272363.466205]  [<c0104f29>] do_IRQ+0x40/0x77
[272363.466289]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.466380]  [<c0103157>] common_interrupt+0x23/0x28
[272363.466473]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.466567]  [<c01027ae>] syscall_call+0x7/0xb
[272363.466660]  =======================
[272363.466725] qmail-pop3d   D ebec9f38     0 10992      1
[272363.466831]        f077cab0 00000086 00000002 ebec9f38 ebec9f30 
00000000 0580eba0 000041c0
[272363.467015]        f077cbec c2830c00 c04c3080 c04c3080 00000000 
00000000 00002000 c04c3080
[272363.467226]        00001000 0408e8c2 00000000 ffffffff 00000000 
00000000 00000000 c4bbd6f0
[272363.467436] Call Trace:
[272363.467530]  [<c03938f7>] __mutex_lock_slowpath+0x55/0x8b
[272363.467626]  [<c0164e28>] filldir64+0x0/0xc5
[272363.467710]  [<c0393786>] mutex_lock+0xa/0xb
[272363.467794]  [<c0164fef>] vfs_readdir+0x3d/0x80
[272363.467881]  [<c0165095>] sys_getdents64+0x63/0xa5
[272363.467977]  [<c01027ae>] syscall_call+0x7/0xb
[272363.468068]  =======================
[272363.468136] imapd         S f1c65f10     0 11091      1
[272363.468242]        f5174030 00000082 00000002 f1c65f10 f1c65f08 
00000000 f1c65f3c f56dde3c
[272363.468430]        f517416c c2827c00 c04c3080 c04c3080 c2824fd8 
f1c65f3c c2824fd8 c04c3080
[272363.468637]        00000286 040dce0f 00000000 ffffffff 00000000 
00000000 00000000 f1c65f3c
[272363.468853] Call Trace:
[272363.468946]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.469033]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.472941]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.473029]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.473122]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.473209]  [<c01027ae>] syscall_call+0x7/0xb
[272363.473297]  =======================
[272363.473363] imapd         S f0bf3f10     0 11876      1
[272363.473466]        ee817ab0 00000086 00000002 f0bf3f10 f0bf3f08 
00000000 f0bf3f3c c2ea9f3c
[272363.473649]        ee817bec c2830c00 c04c3080 c04c3080 c282dfd8 
f0bf3f3c c282dfd8 c04c3080
[272363.473863]        00000286 040dce61 00000000 ffffffff 00000000 
00000000 00000000 f0bf3f3c
[272363.474077] Call Trace:
[272363.474172]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.474260]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.474348]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.474435]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.474525]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.474613]  [<c01027ae>] syscall_call+0x7/0xb
[272363.474702]  =======================
[272363.474770] imapd         S f359fb1c     0 13163      1
[272363.474871]        f37d3570 00000086 00000002 f359fb1c f359fb14 
00000000 00000000 00000001
[272363.475051]        f37d36ac c2830c00 c04c3080 c04c3080 00000000 
00000000 00000286 c04c3080
[272363.475265]        f359fb40 040db748 00000000 ffffffff 00000000 
00000000 00000000 f359fb40
[272363.475485] Call Trace:
[272363.475578]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.475671]  [<c01227b1>] process_timeout+0x0/0x5
[272363.475761]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.475849]  [<c0165a11>] do_select+0x390/0x46e
[272363.475946]  [<c0166107>] __pollwait+0x0/0xcf
[272363.476033]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.476127]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.476223]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.476310]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.476407]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.476494]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.476601]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.476691]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.476784]  [<c0345ad0>] dst_output+0x0/0x7
[272363.476868]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.476959]  [<c0345ad0>] dst_output+0x0/0x7
[272363.477043]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.477146]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.477236]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.477329]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.477417]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.477507]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.477592]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.477682]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.477776]  [<c0230f45>] xfs_trans_tail_ail+0x13/0x2b
[272363.477866]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.477963]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.478050]  [<c03259d1>] release_sock+0x12/0x90
[272363.478140]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.478233]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.478329]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.478426]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.478522]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.478615]  [<c012e789>] ktime_get_ts+0x11/0x3a
[272363.478711]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.478801]  [<c01027ae>] syscall_call+0x7/0xb
[272363.478888]  [<c0390000>] qword_get+0x14d/0x27c
[272363.478981]  =======================
[272363.479047] imapd         S ebfb1f10     0 13192      1
[272363.479153]        e2102030 00000086 00000002 ebfb1f10 ebfb1f08 
00000000 ebfb1f3c f1c65f3c
[272363.479336]        e210216c c2827c00 c04c3080 c04c3080 c2824fd8 
ebfb1f3c c2824fd8 c04c3080
[272363.479548]        00000286 040dce0f 00000000 ffffffff 00000000 
00000000 00000000 ebfb1f3c
[272363.479761] Call Trace:
[272363.479854]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.479952]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.480043]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.480133]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.480224]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.480311]  [<c01027ae>] syscall_call+0x7/0xb
[272363.480401]  =======================
[272363.480469] imapd         S f4393f10     0 13326      1
[272363.480572]        f44e9570 00000086 00000002 f4393f10 f4393f08 
00000000 f4393f3c f24aff3c
[272363.480751]        f44e96ac c2815c00 c04c3080 c04c3080 c2812fd8 
f4393f3c c2812fd8 c04c3080
[272363.480960]        00000286 040dce1a 00000000 ffffffff 00000000 
00000000 00000000 f4393f3c
[272363.481168] Call Trace:
[272363.481263]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.481354]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.481444]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.481535]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.481625]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.481712]  [<c01027ae>] syscall_call+0x7/0xb
[272363.481802]  =======================
[272363.481868] qmail-pop3d   D ee83bf38     0 13387      1
[272363.481974]        dc4b8030 00000082 00000002 ee83bf38 ee83bf30 
00000000 0580eba0 000041c0
[272363.482155]        dc4b816c c2815c00 c04c3080 c04c3080 00000000 
00000000 00002000 c04c3080
[272363.482366]        00001000 040a075d 00000000 ffffffff 00000000 
00000000 00000000 c4bbd6f0
[272363.482576] Call Trace:
[272363.482670]  [<c03938f7>] __mutex_lock_slowpath+0x55/0x8b
[272363.482770]  [<c0164e28>] filldir64+0x0/0xc5
[272363.482854]  [<c0393786>] mutex_lock+0xa/0xb
[272363.482938]  [<c0164fef>] vfs_readdir+0x3d/0x80
[272363.483028]  [<c0165095>] sys_getdents64+0x63/0xa5
[272363.483113]  [<c01027ae>] syscall_call+0x7/0xb
[272363.483203]  =======================
[272363.483271] imapd         S c2ea9f10     0 13444      1
[272363.483375]        eda7d570 00000082 00000002 c2ea9f10 c2ea9f08 
00000000 c2ea9f3c f0bf3f3c
[272363.483555]        eda7d6ac c2830c00 c04c3080 c04c3080 c282dfd8 
c2ea9f3c c282dfd8 c04c3080
[272363.483762]        00000286 040dce61 00000000 ffffffff 00000000 
00000000 00000000 c2ea9f3c
[272363.483979] Call Trace:
[272363.484072]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.484164]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.484255]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.484348]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.484441]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.484531]  [<c01027ae>] syscall_call+0x7/0xb
[272363.484618]  =======================
[272363.484687] imapd         S d766ff10     0 13844      1
[272363.484792]        f700e030 00000086 00000002 d766ff10 d766ff08 
00000000 d766ff3c ebfb1f3c
[272363.484974]        f700e16c c2827c00 c04c3080 c04c3080 c2824fd8 
d766ff3c c2824fd8 c04c3080
[272363.485183]        00000286 040dce0f 00000000 ffffffff 00000000 
00000000 00000000 d766ff3c
[272363.485398] Call Trace:
[272363.485491]  [<c039397f>] do_nanosleep+0x52/0x6d
[272363.485578]  [<c012e5e9>] hrtimer_nanosleep+0x39/0xb9
[272363.485666]  [<c012e05c>] hrtimer_wakeup+0x0/0x18
[272363.485756]  [<c0393973>] do_nanosleep+0x46/0x6d
[272363.485849]  [<c012e6cd>] sys_nanosleep+0x64/0x99
[272363.485936]  [<c01027ae>] syscall_call+0x7/0xb
[272363.486027]  =======================
[272363.486095] imapd         S f4b43b1c     0 13994      1
[272363.486198]        e87a9570 00000086 00000002 f4b43b1c f4b43b14 
00000000 00000000 00000001
[272363.486381]        e87a96ac c2830c00 c04c3080 c04c3080 00000000 
00000000 00000286 c04c3080
[272363.486596]        f4b43b40 040db3aa 00000000 ffffffff 00000000 
00000000 00000000 f4b43b40
[272363.486812] Call Trace:
[272363.486905]  [<c0393568>] schedule_timeout+0x44/0xa1
[272363.486998]  [<c01227b1>] process_timeout+0x0/0x5
[272363.487091]  [<c0393563>] schedule_timeout+0x3f/0xa1
[272363.487178]  [<c0165a11>] do_select+0x390/0x46e
[272363.487275]  [<c0166107>] __pollwait+0x0/0xcf
[272363.487362]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.487462]  [<c02b3bc7>] speedo_start_xmit+0x174/0x2b5
[272363.487561]  [<c03945e8>] _read_lock_bh+0x8/0x17
[272363.487652]  [<c032e1dc>] dev_hard_start_xmit+0x1d6/0x2a3
[272363.487746]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.487831]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.487943]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.488034]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.488127]  [<c0345ad0>] dst_output+0x0/0x7
[272363.488214]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.488304]  [<c0345ad0>] dst_output+0x0/0x7
[272363.488386]  [<c0230204>] xfs_trans_unreserve_and_mod_sb+0xfb/0x3c5
[272363.488492]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.488585]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.488679]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.488770]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.488855]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.488956]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.489041]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.489144]  [<c0230f45>] xfs_trans_tail_ail+0x13/0x2b
[272363.489240]  [<c0222730>] xlog_assign_tail_lsn+0x1d/0x3e
[272363.489337]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.489428]  [<c03259d1>] release_sock+0x12/0x90
[272363.489515]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.489615]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.489709]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.493615]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.493709]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.493808]  [<c01662ba>] sys_select+0xe4/0x1ab
[272363.493901]  [<c01027ae>] syscall_call+0x7/0xb
[272363.493989]  =======================
[272363.494055] sshd          S d7651b1c     0 15678   1824
[272363.494161]        ce864ab0 00000086 00000002 d7651b1c d7651b14 
00000000 040dc536 00000001
[272363.494336]        ce864bec c2827c00 c04c3080 c04c3080 c04c6a80 
c011f422 0000000a c04c3080
[272363.494548]        00000046 040dcef1 00000000 ffffffff 00000000 
00000000 00000000 00000009
[272363.494758] Call Trace:
[272363.494846]  [<c011f422>] __do_softirq+0x72/0xdf
[272363.494942]  [<c039358d>] schedule_timeout+0x69/0xa1
[272363.495032]  [<c0294840>] normal_poll+0x0/0x130
[272363.495116]  [<c012b98c>] add_wait_queue+0xf/0x33
[272363.495203]  [<c037b4c9>] unix_poll+0x17/0x9c
[272363.495288]  [<c0165a11>] do_select+0x390/0x46e
[272363.495375]  [<c01178e6>] scheduler_tick+0xd3/0x11b
[272363.495472]  [<c0166107>] __pollwait+0x0/0xcf
[272363.495559]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.495653]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.495749]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.495842]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.495939]  [<c0115d90>] default_wake_function+0x0/0x8
[272363.496029]  [<c033a0dd>] __qdisc_run+0x75/0x197
[272363.496114]  [<f8a9f000>] ipt_local_out_hook+0x0/0x6c [iptable_filter]
[272363.496223]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.496313]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.496404]  [<c0345ad0>] dst_output+0x0/0x7
[272363.496491]  [<c0347fba>] ip_queue_xmit+0x19d/0x3aa
[272363.496581]  [<c0345ad0>] dst_output+0x0/0x7
[272363.496662]  [<c033037b>] dev_queue_xmit+0x89/0x2de
[272363.496750]  [<c034727d>] ip_finish_output+0x135/0x28e
[272363.496840]  [<c0345ad0>] dst_output+0x0/0x7
[272363.496924]  [<c035cb91>] tcp_v4_send_check+0x38/0xc2
[272363.497012]  [<c03576d0>] tcp_transmit_skb+0x39e/0x721
[272363.497103]  [<c0122919>] lock_timer_base+0x19/0x35
[272363.497188]  [<c035ab0e>] tcp_write_timer+0x0/0x6a2
[272363.497278]  [<c0122a33>] __mod_timer+0x9b/0xaa
[272363.497365]  [<c0325b24>] sk_reset_timer+0xc/0x16
[272363.497453]  [<c0359060>] __tcp_push_pending_frames+0x121/0x85f
[272363.497547]  [<c0114b79>] resched_task+0x51/0x57
[272363.497632]  [<c0115b5a>] try_to_wake_up+0x42/0x278
[272363.497725]  [<c039467f>] _spin_lock_bh+0x8/0x18
[272363.497810]  [<c03259d1>] release_sock+0x12/0x90
[272363.497900]  [<c034e16d>] tcp_sendmsg+0x7ab/0xb82
[272363.497990]  [<c0165ca8>] core_sys_select+0x1b9/0x2c3
[272363.498083]  [<c03253b2>] sock_common_recvmsg+0x3e/0x54
[272363.498177]  [<c032332a>] sock_aio_write+0xcb/0xe5
[272363.498273]  [<c015a422>] do_sync_write+0xd2/0x10e
[272363.498364]  [<c02b2d3c>] speedo_tx_buffer_gc+0x82/0x1ab
[272363.498463]  [<c02b30ab>] speedo_interrupt+0x5e/0x6ed
[272363.498551]  [<c012b7cc>] autoremove_wake_function+0x0/0x37
[272363.498645]  [<c03295b1>] skb_release_all+0x4c/0xba
[272363.498735]  [<c0328e26>] __kfree_skb+0x8/0x71
[272363.498825]  [<c0166215>] sys_select+0x3f/0x1ab
[272363.498912]  [<c0104f29>] do_IRQ+0x40/0x77
[272363.498996]  [<c015b1aa>] sys_write+0x41/0x6a
[272363.499083]  [<c01027ae>] syscall_call+0x7/0xb
[272363.499176]  =======================
[272363.499242] bash          R running      0 15683  15678


Regards,
Stefan
