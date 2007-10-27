Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXJ0N5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXJ0N5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXJ0N5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:57:30 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:10927 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750823AbXJ0N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:57:29 -0400
Message-ID: <472343AC.9040502@manicmethod.com>
Date: Sat, 27 Oct 2007 09:57:00 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory
 Access Control Kernel
References: <47201183.1090107@schaufler-ca.com>
In-Reply-To: <47201183.1090107@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2007 13:57:28.0081 (UTC) FILETIME=[4F63F010:01C818A1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> The Smack patch and Paul Moore's netlabel API patch,
> together for 2.6.24-rc1. Paul's changes are identical
> to the previous posting, but it's been a while so they're
> here again.
>
> The sole intent of change has been to address locking
> and/or list processing issues. Please don't hesitate to
> point out any problems that you might see or suggest
> alternatives where things might not be to your liking.
>
> This version is aimed at 2.6.24, and has been tested
> against 2.6.24-rc1.
>   
with both of these patches applied to 2.6.24-rc1 I get the following 
oops when nfsd starts:

BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000013c
printing eip: c01d7e39 *pde = 00000000
Oops: 0000 [#1] SMP

Pid: 4094, comm: lockd Not tainted (2.6.24-rc1 #3)
EIP: 0060:[<c01d7e39>] EFLAGS: 00010246 CPU: 0
EIP is at smack_socket_post_create+0x46/0xd2
EAX: c19440c0 EBX: 00000000 ECX: 00000001 EDX: c168ddd8
ESI: 00000002 EDI: 00000000 EBP: 00000006 ESP: c168ddd8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process lockd (pid: 4094, ti=c168c000 task=c1577ab0 task.ti=c168c000)
Stack: c1464c00 c01d7ac6 c19440e8 c01d4fb4 c016544c c038c660 c19440c0 
00000001
       c01d53eb 00000006 00000001 fffffff4 c0283374 00000006 00000001 
00000002
       c1944540 c168df34 c1944540 00000800 c02833b6 c168df34 c1944540 
c2039d8c
Call Trace:
 [<c01d7ac6>] smack_inode_alloc_security+0x14/0x24
 [<c01d4fb4>] security_inode_alloc+0x16/0x17
 [<c016544c>] alloc_inode+0x118/0x170
 [<c01d53eb>] security_socket_post_create+0x1f/0x23
 [<c0283374>] sock_create_lite+0x4d/0x6c
 [<c02833b6>] kernel_accept+0x23/0x5a
 [<c02d8aac>] svc_tcp_recvfrom+0xf9/0x7e7
 [<c0120be5>] run_timer_softirq+0x2f/0x154
 [<c01125df>] __update_rq_clock+0x19/0x156
 [<c012e30c>] clocksource_get_next+0x39/0x3f
 [<c012d55b>] update_wall_time+0x54b/0x6af
 [<c02e2852>] schedule+0x575/0x58f
 [<c02d87c1>] svc_udp_recvfrom+0x175/0x367
 [<c01279fc>] __rcu_process_callbacks+0xeb/0x153
 [<c02e294d>] schedule_timeout+0x13/0x8d
 [<c02d7b4d>] svc_sock_release+0xdd/0x149
 [<c02d8596>] svc_recv+0x2df/0x395
 [<c0103078>] apic_timer_interrupt+0x28/0x30
 [<c0114e8f>] default_wake_function+0x0/0x8
 [<c01c881c>] lockd+0xe3/0x1f3
 [<c0116fa2>] schedule_tail+0x18/0x52
 [<c01024f6>] ret_from_fork+0x6/0x1c
 [<c01c8739>] lockd+0x0/0x1f3
 [<c01c8739>] lockd+0x0/0x1f3
 [<c01031fb>] kernel_thread_helper+0x7/0x10
 =======================
Code: 38 c0 75 0c 64 a1 00 c0 3d c0 8b 80 c0 04 00 00 e8 31 f5 ff ff 89 
83 64 01 00 00 31 ff 83 fe 02 0f 85 88 00 00 00 8b 5b 14 89 e2 <8b> 83 
3c 01 00 00 c7 04 24 00 00 00 00 c7 44 24 04 00 00 00 00
EIP: [<c01d7e39>] smack_socket_post_create+0x46/0xd2 SS:ESP 0068:c168ddd8
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000013c
printing eip: c01d7e39 *pde = 00000000
Oops: 0000 [#2] SMP

Pid: 4095, comm: nfsd Tainted: G      D (2.6.24-rc1 #3)
EIP: 0060:[<c01d7e39>] EFLAGS: 00010246 CPU: 0
EIP is at smack_socket_post_create+0x46/0xd2
EAX: c1944240 EBX: 00000000 ECX: 00000001 EDX: c1603e00
ESI: 00000002 EDI: 00000000 EBP: 00000006 ESP: c1603e00
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process nfsd (pid: 4095, ti=c1602000 task=c1559ab0 task.ti=c1602000)
Stack: c1464c00 c01d7ac6 c1944268 c01d4fb4 c016544c c038c660 c1944240 
00000001
       c01d53eb 00000006 00000001 fffffff4 c0283374 00000006 00000001 
00000002
       c19443c0 c1603f5c c19443c0 00000800 c02833b6 c1603f5c c19443c0 
c16c9e00
Call Trace:
 [<c01d7ac6>] smack_inode_alloc_security+0x14/0x24
 [<c01d4fb4>] security_inode_alloc+0x16/0x17
 [<c016544c>] alloc_inode+0x118/0x170
 [<c01d53eb>] security_socket_post_create+0x1f/0x23
 [<c0283374>] sock_create_lite+0x4d/0x6c
 [<c02833b6>] kernel_accept+0x23/0x5a
 [<c02d8aac>] svc_tcp_recvfrom+0xf9/0x7e7
 [<c0111b7b>] __wake_up_common+0x32/0x5c
 [<c02e37c3>] _spin_lock_bh+0x8/0x18
 [<c0284761>] lock_sock_nested+0x84/0x8c
 [<c02d87c1>] svc_udp_recvfrom+0x175/0x367
 [<c02d7b4d>] svc_sock_release+0xdd/0x149
 [<c02d8596>] svc_recv+0x2df/0x395
 [<c0113210>] sched_move_task+0xa0/0xa7
 [<c0114e8f>] default_wake_function+0x0/0x8
 [<c01bb125>] nfsd+0xcc/0x27b
 [<c01bb059>] nfsd+0x0/0x27b
 [<c01031fb>] kernel_thread_helper+0x7/0x10
 =======================
Code: 38 c0 75 0c 64 a1 00 c0 3d c0 8b 80 c0 04 00 00 e8 31 f5 ff ff 89 
83 64 01 00 00 31 ff 83 fe 02 0f 85 88 00 00 00 8b 5b 14 89 e2 <8b> 83 
3c 01 00 00 c7 04 24 00 00 00 00 c7 44 24 04 00 00 00 00
EIP: [<c01d7e39>] smack_socket_post_create+0x46/0xd2 SS:ESP 0068:c1603e00


