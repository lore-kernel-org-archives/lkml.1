Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXJRJgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXJRJgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXJRJf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:35:57 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2496 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXJRJfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:35:55 -0400
Date: Thu, 18 Oct 2007 10:35:56 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: s390x: getting ipv6 bugs on mainline since 2.6.23-git3
Message-ID: <20071018093556.GT21136@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems we are getting some kind of bug out of our s390x partition (lnxabat1)
when booting latest mainline releases, specifically since 2.6.23-git3.

Kernel BUG at 0000000000000002 Ýverbose debug info unavailable¨
illegal operation: 0001 Ý#1¨
Modules linked in: dm_mod sit tunnel4 ipv6 qeth ccwgroup qdio dasd_fba_mod dasd_
eckd_mod dasd_mod
CPU:    0    Not tainted
Process ip (pid: 2614, task: 000000003f42f680, ksp: 000000003cf2feb8)
Krnl PSW : 0704200180000000 0000000000000002 (0x2)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000000 000000003e6d5d00 000000003e01f000
           00000000000086dd 000000003cdac144 0000000000000000 0000000000000010
           000000003e01f000 000000003d97e3c0 0000000100eaaa00 000000003cdac100
           000000003e6d5d00 00000001018fb1d0 0000000000286da8 000000003cf2f5e8
Krnl Code:>0000000000000002: 0000               unknown
           0000000000000004: 0000               unknown
           0000000000000006: 0000               unknown
           0000000000000008: 0000               unknown
           000000000000000a: 0000               unknown
           000000000000000c: 0000               unknown
           000000000000000e: 0000               unknown
           0000000000000010: 0000               unknown
Call Trace:
(Ý<0000000000286d60>¨ neigh_connected_output+0x68/0xfc)
 Ý<00000001018cc7fe>¨ ip6_output2+0x416/0x4ac Ýipv6¨
 Ý<00000001018ceaa8>¨ ip6_output+0xfc4/0xfd4 Ýipv6¨
 Ý<00000001018dfe40>¨ __ndisc_send+0x52c/0x6f0 Ýipv6¨
 Ý<00000001018e0218>¨ ndisc_send_rs+0x4c/0x5c Ýipv6¨
 Ý<00000001018d40e6>¨ addrconf_dad_completed+0xa2/0xf0 Ýipv6¨
 Ý<00000001018d4880>¨ addrconf_dad_start+0xa0/0x124 Ýipv6¨
 Ý<00000001018d496a>¨ addrconf_add_linklocal+0x66/0x98 Ýipv6¨
 Ý<00000001018d7a3c>¨ addrconf_notify+0x6cc/0x898 Ýipv6¨
 Ý<000000000004ad7c>¨ notifier_call_chain+0x50/0x8c
 Ý<000000000004b0b6>¨ __raw_notifier_call_chain+0x1a/0x28
 Ý<000000000004b0e6>¨ raw_notifier_call_chain+0x22/0x30
 Ý<000000000027f014>¨ call_netdevice_notifiers+0x28/0x38
 Ý<0000000000281732>¨ dev_open+0xba/0xd0
 Ý<0000000000281cce>¨ dev_change_flags+0xbe/0x198
 Ý<00000000002d681c>¨ devinet_ioctl+0x2c8/0x6c0
 Ý<000000000027138a>¨ sock_ioctl+0x26e/0x2a0
 Ý<00000000000ab1ce>¨ do_ioctl+0x4a/0xac
 Ý<00000000000ab5f2>¨ vfs_ioctl+0x3c2/0x3d8
 Ý<00000000000ab676>¨ sys_ioctl+0x6e/0x94
 Ý<00000000000215c6>¨ sysc_noemu+0x10/0x16
 Ý<00000200001201ca>¨ 0x200001201ca

 <0>Kernel panic - not syncing: Fatal exception in interrupt
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 00.
02: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 00.
03: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 00.
00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 00015FDE

-apw
