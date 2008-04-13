Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYDMMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYDMMFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYDMMFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:05:08 -0400
Received: from main.gmane.org ([80.91.229.2]:60937 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYDMMFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:05:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lorenzo Allegrucci <l_allegrucci@yahoo.it>
Subject: Kernel panic with 2.6.24.4 and L7filter patch
Date: Sun, 13 Apr 2008 11:26:40 +0200
Message-ID: <ftsjkg$2gg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-222-178-136.cust-adsl.tiscali.it
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everyone, I got this a kernel panic with a 2.6.24.4 patched with 
netfilter-layer7 (http://l7-filter.sourceforge.net/)
This is not a machine I directly administer and for now I don't know
how to reproduce the panic, but if necessary I may investigate more.
I'll submit this to the l7-filter-users ML but I was wondering if this
a known bug unrelated to l7-filter.


[77608.589596] BUG: soft lockup - CPU#0 stuck for 11s! [pdnsd:4069]
[77608.589653]
[77608.589677] Pid: 4069, comm: pdnsd Not tainted (2.6.24.4-l7 #1)
[77608.589712] EIP: 0060:[<c01dc7b0>] EFLAGS: 00000246 CPU: 0
[77608.589767] EIP is at strcmp+0x10/0x30
[77608.589794] EAX: dd8ee02e EBX: db2360f8 ECX: d4234dbc EDX: e1645be8
[77608.589828] ESI: dd8ee9c1 EDI: e16465a9 EBP: e1645be8 ESP: dfa379f8
[77608.589862]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[77608.589893] CR0: 8005003b CR2: b7fad600 CR3: 1f8f9000 CR4: 00000690
[77608.589927] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[77608.589960] DR6: ffff0ff0 DR7: 00000400
[77608.590014]  [<e0adc326>] match+0x176/0x620 [xt_layer7]
[77608.590100]  [<e0a575b9>] ipt_do_table+0x1e9/0x350 [ip_tables]
[77608.590184]  [<e0ad5000>] ipt_route_hook+0x0/0x20 [iptable_mangle]
[77608.590237]  [<c026eb67>] nf_iterate+0x67/0x90
[77608.590301]  [<c026ec29>] nf_hook_slow+0x59/0xe0
[77608.590344]  [<c0275b30>] ip_forward_finish+0x0/0x30
[77608.590406]  [<c0275de6>] ip_forward+0x286/0x320
[77608.590448]  [<c0275b30>] ip_forward_finish+0x0/0x30
[77608.590499]  [<c027488f>] ip_rcv_finish+0xef/0x2a0
[77608.590545]  [<c0274ecf>] ip_rcv+0x1cf/0x250
[77608.590585]  [<c02747a0>] ip_rcv_finish+0x0/0x2a0
[77608.590633]  [<c02555d7>] netif_receive_skb+0x237/0x400
[77608.590701]  [<e0883d39>] e100_poll+0x159/0x2c0 [e100]
[77608.590805]  [<c0257a59>] net_rx_action+0xd9/0x190
[77608.590851]  [<c025bc70>] neigh_periodic_timer+0x0/0x110
[77608.590911]  [<c011b352>] __do_softirq+0x42/0x90
[77608.590967]  [<c011b3c6>] do_softirq+0x26/0x30
[77608.591004]  [<c011b59d>] local_bh_enable+0x3d/0x90
[77608.591041]  [<e0a5b458>] __nf_conntrack_find+0x18/0xf0 [nf_conntrack]
[77608.591154]  [<e0a5b67d>] nf_conntrack_find_get+0x2d/0x40 [nf_conntrack]
[77608.591225]  [<e0a5c61b>] nf_conntrack_in+0x18b/0x420 [nf_conntrack]
[77608.591318]  [<c025007b>] pskb_expand_head+0x10b/0x170
[77608.591386]  [<c0251c26>] csum_partial_copy_fromiovecend+0x186/0x220
[77608.591459]  [<e0a711e0>] ipv4_conntrack_local+0x0/0x60 
[nf_conntrack_ipv4]
[77608.591526]  [<c026eb67>] nf_iterate+0x67/0x90
[77608.591565]  [<c0276fc0>] dst_output+0x0/0x10
[77608.591617]  [<c026ec29>] nf_hook_slow+0x59/0xe0
[77608.591659]  [<c0276fc0>] dst_output+0x0/0x10
[77608.591708]  [<c0277420>] ip_push_pending_frames+0x300/0x3d0
[77608.591755]  [<c0276fc0>] dst_output+0x0/0x10
[77608.591807]  [<c0294719>] raw_sendmsg+0x6c9/0x7c0
[77608.591890]  [<c024fdd8>] __kfree_skb+0x8/0x80
[77608.591978]  [<c029c5e7>] inet_sendmsg+0x37/0x70
[77608.592035]  [<c024a851>] sock_sendmsg+0x101/0x120
[77608.592076]  [<c0114538>] dequeue_task_fair+0x28/0x40
[77608.592162]  [<c0128090>] autoremove_wake_function+0x0/0x50
[77608.592225]  [<c012ace0>] hrtimer_wakeup+0x0/0x20
[77608.592282]  [<c0131398>] futex_wait+0x1b8/0x2b0
[77608.592343]  [<c0130eb0>] get_futex_key+0x50/0x150
[77608.592401]  [<c024ac1f>] sys_sendto+0x12f/0x180
[77608.592454]  [<c0132553>] do_futex+0x3b3/0xa30
[77608.592501]  [<e09b7810>] scsi_next_command+0x30/0x50 [scsi_mod]
[77608.592664]  [<e09b7964>] scsi_end_request+0x94/0xc0 [scsi_mod]
[77608.592768]  [<e09b86b5>] scsi_io_completion+0xa5/0x3f0 [scsi_mod]
[77608.592871]  [<c02937e9>] raw_setsockopt+0x69/0x80
[77608.592944]  [<c024bd88>] sys_socketcall+0x198/0x280
[77608.593009]  [<c0103eee>] sysenter_past_esp+0x5f/0x85

