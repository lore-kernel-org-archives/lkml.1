Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZGXLGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZGXLGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZGXLGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:06:09 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46538 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZGXLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:06:08 -0400
Message-ID: <4A69955D.2040000@in.ibm.com>
Date: Fri, 24 Jul 2009 16:35:01 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot panic in serial init
References: <20090724171841.b128f8be.sfr@canb.auug.org.au>
In-Reply-To: <20090724171841.b128f8be.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Alan,
>
> Today's linux-next on a pSeries PowerPC machine panics during boot like
> this:
>   
Similar problem on x86 as well.

Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
IP: [<ffffffff8132d15a>] mutex_lock+0xc/0x2d
PGD 0 
Oops: 0002 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.31-rc4-autotest-next-20090724-5-default #1 BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff8132d15a>]  [<ffffffff8132d15a>] mutex_lock+0xc/0x2d
RSP: 0018:ffff88012b319da0  EFLAGS: 00010286
RAX: ffff88012b319e10 RBX: 0000000000000070 RCX: ffffffff85d06ad0
RDX: 0000000000000008 RSI: ffffffff85d06ad0 RDI: 0000000000000070
RBP: ffff88012b319db0 R08: 0000000000000001 R09: ffff88012b319d40
R10: 0000000300000000 R11: 0000000000018600 R12: ffffffff85d06ad0
R13: ffff88012846a000 R14: ffffffff8154bd00 R15: 0000000000000070
FS:  0000000000000000(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000070 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88012b318000, task ffff88012b316000)
Stack:
 ffff88012b319e10 00000000ffffffea ffff88012b319e40 ffffffff8126c572
<0> 0000000000000000 0000000000000000 ffff88012b319de0 ffffffff811e9ea7
<0> ffff8801284c6a10 ffff8801284c6a00 0000000000000000 00000000ffffffea
Call Trace:
 [<ffffffff8126c572>] uart_add_one_port+0x72/0x332
 [<ffffffff811e9ea7>] ? kobject_init+0x43/0x83
 [<ffffffff81686a2e>] ? serial8250_init+0x0/0x143
 [<ffffffff81686b2c>] serial8250_init+0xfe/0x143
 [<ffffffff8100905c>] do_one_initcall+0x56/0x12b
 [<ffffffff8108b3ca>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff81120000>] ? sys_quotactl+0x7c/0x748
 [<ffffffff8165b691>] kernel_init+0x181/0x1db
 [<ffffffff8100ca1a>] child_rip+0xa/0x20
 [<ffffffff8165b510>] ? kernel_init+0x0/0x1db
 [<ffffffff8100ca10>] ? child_rip+0x0/0x20
Code: c0 b0 b1 05 81 48 89 45 c8 48 89 45 d0 e8 1d ff ff ff 48 83 c4 40 5b 41 5c 41 5d 41 5e c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 <f0> ff 0f 79 05 e8 97 00 00 00 65 48 8b 04 25 b8 b4 00 00 48 2d 
RIP  [<ffffffff8132d15a>] mutex_lock+0xc/0x2d
 RSP <ffff88012b319da0>
CR2: 0000000000000070
---[ end trace b19b3a85649e706b ]---

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

