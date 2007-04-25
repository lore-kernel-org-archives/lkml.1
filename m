Return-Path: <linux-kernel-owner+w=401wt.eu-S1423177AbXDYGfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423177AbXDYGfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423230AbXDYGfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:35:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:48162 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423177AbXDYGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TdjPZKGDn2conXn4wnpXwgG0dxFZ8kq4INw1NxhQhAwof3o8pqvRkHr2Zmh46/p64EEP86+VU84gmS5VfCZ3l+iSlIfh/hLU0B4nz9GC336QxMGPUhZGy6iRjOs2PlsVmSnpWH/W9oQ2oQfpqEHaJfa2NSof2XPBBCweal8RbrY=
Message-ID: <a44ae5cd0704242335n637b1b5cwd027a3d253820f91@mail.gmail.com>
Date: Tue, 24 Apr 2007 23:35:37 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7-mm1 + sysfs patch -- RTNL: assertion failed at net/ipv6/addrconf.c (2123)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, I get the s_active problem that Tejun is working on:

[  195.006522] [ INFO: possible recursive locking detected ]
[...]

And then this:
[  278.835674] RTNL: assertion failed at net/ipv6/addrconf.c (2123)
[  278.835684]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.835701]  [<c0105a26>] show_trace+0x12/0x14
[  278.835713]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.835723]  [<f95c660a>] addrconf_notify+0x5dd/0x7d0 [ipv6]
[  278.835795]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.835809]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.835822]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.835834]  [<c025041e>] netdev_state_change+0x23/0x35
[  278.835849]  [<c0258e76>] rtnl_setlink+0x34f/0x3ef
[  278.835861]  [<c025845e>] rtnetlink_rcv_msg+0x198/0x1b2
[  278.835873]  [<c025f4b3>] netlink_run_queue+0x6f/0xe1
[  278.835885]  [<c0258277>] rtnetlink_rcv+0x29/0x44
[  278.835896]  [<c025f82c>] netlink_data_ready+0x15/0x55
[  278.835907]  [<c025e877>] netlink_sendskb+0x22/0x53
[  278.835918]  [<c025f1f0>] netlink_unicast+0x1bb/0x1d5
[  278.835929]  [<c025f80b>] netlink_sendmsg+0x246/0x252
[  278.835940]  [<c02472e6>] sock_sendmsg+0xcc/0xe5
[  278.835951]  [<c0247beb>] sys_sendto+0xcc/0xec
[  278.835961]  [<c0247c41>] sys_send+0x36/0x38
[  278.835971]  [<c02483f6>] sys_socketcall+0x13e/0x241
[  278.835982]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.835993]  =======================
[  278.836002] RTNL: assertion failed at net/ipv6/addrconf.c (1569)
[  278.836009]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.836020]  [<c0105a26>] show_trace+0x12/0x14
[  278.836031]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.836041]  [<f95c5ba2>] addrconf_add_dev+0x39/0x5d [ipv6]
[  278.836098]  [<f95c6635>] addrconf_notify+0x608/0x7d0 [ipv6]
[  278.836146]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.836159]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.836171]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.836183]  [<c025041e>] netdev_state_change+0x23/0x35
[  278.836195]  [<c0258e76>] rtnl_setlink+0x34f/0x3ef
[  278.836207]  [<c025845e>] rtnetlink_rcv_msg+0x198/0x1b2
[  278.836218]  [<c025f4b3>] netlink_run_queue+0x6f/0xe1
[  278.836229]  [<c0258277>] rtnetlink_rcv+0x29/0x44
[  278.836240]  [<c025f82c>] netlink_data_ready+0x15/0x55
[  278.836251]  [<c025e877>] netlink_sendskb+0x22/0x53
[  278.836262]  [<c025f1f0>] netlink_unicast+0x1bb/0x1d5
[  278.836273]  [<c025f80b>] netlink_sendmsg+0x246/0x252
[  278.836284]  [<c02472e6>] sock_sendmsg+0xcc/0xe5
[  278.836294]  [<c0247beb>] sys_sendto+0xcc/0xec
[  278.836304]  [<c0247c41>] sys_send+0x36/0x38
[  278.836313]  [<c02483f6>] sys_socketcall+0x13e/0x241
[  278.836324]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.836334]  =======================
[  278.836343] RTNL: assertion failed at net/ipv6/addrconf.c (373)
[  278.836352]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.836363]  [<c0105a26>] show_trace+0x12/0x14
[  278.836374]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.836384]  [<f95c5b37>] ipv6_find_idev+0x39/0x6b [ipv6]
[  278.836432]  [<f95c5ba9>] addrconf_add_dev+0x40/0x5d [ipv6]
[  278.836480]  [<f95c6635>] addrconf_notify+0x608/0x7d0 [ipv6]
[  278.836527]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.836539]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.836551]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.836563]  [<c025041e>] netdev_state_change+0x23/0x35
[  278.836576]  [<c0258e76>] rtnl_setlink+0x34f/0x3ef
[  278.836587]  [<c025845e>] rtnetlink_rcv_msg+0x198/0x1b2
[  278.836599]  [<c025f4b3>] netlink_run_queue+0x6f/0xe1
[  278.836610]  [<c0258277>] rtnetlink_rcv+0x29/0x44
[  278.836621]  [<c025f82c>] netlink_data_ready+0x15/0x55
[  278.836632]  [<c025e877>] netlink_sendskb+0x22/0x53
[  278.836642]  [<c025f1f0>] netlink_unicast+0x1bb/0x1d5
[  278.836896]  [<c025f80b>] netlink_sendmsg+0x246/0x252
[  278.836907]  [<c02472e6>] sock_sendmsg+0xcc/0xe5
[  278.836918]  [<c0247beb>] sys_sendto+0xcc/0xec
[  278.836928]  [<c0247c41>] sys_send+0x36/0x38
[  278.836937]  [<c02483f6>] sys_socketcall+0x13e/0x241
[  278.836948]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.836959]  =======================
[  278.902596] RTNL: assertion failed at net/ipv4/devinet.c (1055)
[  278.902609]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.902625]  [<c0105a26>] show_trace+0x12/0x14
[  278.902636]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.902647]  [<c0285917>] inetdev_event+0x46/0x2be
[  278.902660]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.902673]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.902686]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.902698]  [<c025101f>] dev_close+0x68/0x6e
[  278.902709]  [<c0250561>] dev_change_flags+0x57/0x10b
[  278.902719]  [<c0285ee0>] devinet_ioctl+0x23a/0x54b
[  278.902730]  [<c028674f>] inet_ioctl+0x89/0xaa
[  278.902868]  [<c0246c73>] sock_ioctl+0x1ac/0x1ca
[  278.902879]  [<c0173ade>] do_ioctl+0x22/0x68
[  278.902892]  [<c0173d63>] vfs_ioctl+0x23f/0x252
[  278.902903]  [<c0173da7>] sys_ioctl+0x31/0x4a
[  278.902914]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.902925]  =======================
[  278.902935] RTNL: assertion failed at net/ipv4/igmp.c (1313)
[  278.902941]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.902953]  [<c0105a26>] show_trace+0x12/0x14
[  278.902963]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.902974]  [<c0288698>] ip_mc_down+0x39/0x5f
[  278.902984]  [<c0285a0e>] inetdev_event+0x13d/0x2be
[  278.902995]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.903007]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.903019]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.903031]  [<c025101f>] dev_close+0x68/0x6e
[  278.903041]  [<c0250561>] dev_change_flags+0x57/0x10b
[  278.903051]  [<c0285ee0>] devinet_ioctl+0x23a/0x54b
[  278.903062]  [<c028674f>] inet_ioctl+0x89/0xaa
[  278.903072]  [<c0246c73>] sock_ioctl+0x1ac/0x1ca
[  278.903082]  [<c0173ade>] do_ioctl+0x22/0x68
[  278.903093]  [<c0173d63>] vfs_ioctl+0x23f/0x252
[  278.903104]  [<c0173da7>] sys_ioctl+0x31/0x4a
[  278.903115]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.903126]  =======================
[  278.903139] RTNL: assertion failed at net/ipv4/igmp.c (1286)
[  278.903146]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  278.903157]  [<c0105a26>] show_trace+0x12/0x14
[  278.903168]  [<c0105ab3>] dump_stack+0x16/0x18
[  278.903178]  [<c0288555>] ip_mc_dec_group+0x3d/0x9d
[  278.903189]  [<c02886b7>] ip_mc_down+0x58/0x5f
[  278.903199]  [<c0285a0e>] inetdev_event+0x13d/0x2be
[  278.903210]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  278.903222]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  278.903234]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  278.903246]  [<c025101f>] dev_close+0x68/0x6e
[  278.903256]  [<c0250561>] dev_change_flags+0x57/0x10b
[  278.903266]  [<c0285ee0>] devinet_ioctl+0x23a/0x54b
[  278.903277]  [<c028674f>] inet_ioctl+0x89/0xaa
[  278.903287]  [<c0246c73>] sock_ioctl+0x1ac/0x1ca
[  278.903297]  [<c0173ade>] do_ioctl+0x22/0x68
[  278.903307]  [<c0173d63>] vfs_ioctl+0x23f/0x252
[  278.903319]  [<c0173da7>] sys_ioctl+0x31/0x4a
[  278.903329]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  278.903339]  =======================
[  279.063658] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  285.824018] RTNL: assertion failed at net/ipv6/addrconf.c (2361)
[  285.824029]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  285.824044]  [<c0105a26>] show_trace+0x12/0x14
[  285.824070]  [<c0105ab3>] dump_stack+0x16/0x18
[  285.824078]  [<f95c40ac>] addrconf_ifdown+0x3e/0x35e [ipv6]
[  285.824122]  [<f95c6770>] addrconf_notify+0x743/0x7d0 [ipv6]
[  285.824158]  [<c0125572>] notifier_call_chain+0x2b/0x4a
[  285.824170]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
[  285.824179]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
[  285.824188]  [<c025101f>] dev_close+0x68/0x6e
[  285.824198]  [<c0250561>] dev_change_flags+0x57/0x10b
[  285.824206]  [<c0285ee0>] devinet_ioctl+0x23a/0x54b
[  285.824215]  [<c028674f>] inet_ioctl+0x89/0xaa
[  285.824223]  [<c0246c73>] sock_ioctl+0x1ac/0x1ca
[  285.824231]  [<c0173ade>] do_ioctl+0x22/0x68
[  285.824241]  [<c0173d63>] vfs_ioctl+0x23f/0x252
[  285.824250]  [<c0173da7>] sys_ioctl+0x31/0x4a
[  285.824258]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  285.824266]  =======================
[  286.414903] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  291.925317] RTNL: assertion failed at net/ipv4/devinet.c (344)
[  291.925330]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[  291.925344]  [<c0105a26>] show_trace+0x12/0x14
[  291.925352]  [<c0105ab3>] dump_stack+0x16/0x18
[  291.925360]  [<c0284d85>] __inet_insert_ifa+0x42/0x113
[  291.925371]  [<c02857c0>] inet_rtm_newaddr+0x18a/0x192
[  291.925379]  [<c025845e>] rtnetlink_rcv_msg+0x198/0x1b2
[  291.925390]  [<c025f4b3>] netlink_run_queue+0x6f/0xe1
[  291.925400]  [<c0258277>] rtnetlink_rcv+0x29/0x44
[  291.925408]  [<c025f82c>] netlink_data_ready+0x15/0x55
[  291.925416]  [<c025e877>] netlink_sendskb+0x22/0x53
[  291.925424]  [<c025f1f0>] netlink_unicast+0x1bb/0x1d5
[  291.925433]  [<c025f80b>] netlink_sendmsg+0x246/0x252
[  291.925441]  [<c02472e6>] sock_sendmsg+0xcc/0xe5
[  291.925449]  [<c0247452>] sys_sendmsg+0x153/0x1b1
[  291.925457]  [<c02484d8>] sys_socketcall+0x220/0x241
[  291.925465]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[  291.925473]  =======================
