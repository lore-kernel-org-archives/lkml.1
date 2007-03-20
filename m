Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXCTJqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXCTJqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXCTJqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:46:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4285 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXCTJqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:46:19 -0400
Message-ID: <45FFAD50.8060108@shadowen.org>
Date: Tue, 20 Mar 2007 09:45:52 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>, Con Kolivas <kernel@kolivas.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
> 
> 

[All of the below is from the pre hot-fix runs.  The very few results
which are in for the hot-fix runs seem worse if anything.  :(  All
results should be out on TKO.]

> - Restored the RSDL CPU scheduler (a new version thereof)

Unsure if the above is the culprit but there seems to be a smattering of
BUG's in kernbench from the schedular on several systems, and panics
which do not fully dump out.

elm3b239 is about 2/4 kernbench being the test in progress when we
blammo in both failed tests, elm3b234 doesn't boot at all.


>From elm3b239:
------------[ cut here ]------------
kernel BUG at kernel/sched.c:3505!
invalid opcode: 0000 [1] SMP
last sysfs file: devices/pci0000:00/0000:00:00.0/irq
CPU 19
Modules linked in: loop dm_mod md_mod sg
Pid: 59, comm: migration/19 Not tainted 2.6.21-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff804924f6>]  [<ffffffff804924f6>]
__sched_text_start+0x3a6/0x882
RSP: 0018:ffff810100cefe20  EFLAGS: 00010002
RAX: 000000000000008c RBX: ffff81002b0f64d8 RCX: 000000000000000c
RDX: 0000000000000000 RSI: 000000000000008c RDI: ffff81002b0f6da8
RBP: ffff810100cefeb0 R08: 000000000000008c R09: ffff81002b0f6d98
R10: 0000000000000034 R11: ffffffff8021ab20 R12: ffff81002b0f5a40
R13: 0000000000000002 R14: 000000725eb99ef7 R15: 0000000000000013
FS:  0000000000000000(0000) GS:ffff810100c42bc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ba9c431ab70 CR3: 00000001060fc000 CR4: 00000000000006e0
Process migration/19 (pid: 59, threadinfo ffff810100cee000, task
ffff810100ced8e0)
Stack:  0000000000000001 0000000000000001 ffff81010b681e98 ffff810100ced8e0
 ffff810100cefe80 ffff810100ceda78 0000000300000000 ffff81010b681e88
 ffff81010b681e90 0000000000000286 0000000000000013 0000000000000000
Call Trace:
 [<ffffffff80224a00>] migration_thread+0x1b0/0x250
 [<ffffffff80224850>] migration_thread+0x0/0x250
 [<ffffffff8023c85b>] kthread+0xdb/0x120
 [<ffffffff8020a7a8>] child_rip+0xa/0x12
 [<ffffffff8023c780>] kthread+0x0/0x120
 [<ffffffff8020a79e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 49 8b 94 24 b8 01 00 00 49 8b 84 24 b0 01 00 00
RIP  [<ffffffff804924f6>] __sched_text_start+0x3a6/0x882
 RSP <ffff810100cefe20>


------------[ cut here ]------------
kernel BUG at kernel/sched.c:3505!
invalid opcode: 0000 [1] SMP
last sysfs file: devices/pci0000:00/0000:00:00.0/irq
CPU 21
Modules linked in: loop dm_mod md_mod sg
Pid: 15583, comm: cc1 Not tainted 2.6.21-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff80496686>]  [<ffffffff80496686>]
__sched_text_start+0x3a6/0x882
RSP: 0000:ffff81010aca7ee0  EFLAGS: 00010002
RAX: 000000000000008c RBX: ffff81002b111358 RCX: 000000000000000c
RDX: 0000000000000000 RSI: 000000000000008c RDI: ffff81002b111c28
RBP: ffff81010aca7f70 R08: 000000000000008c R09: ffff81002b111c18
R10: 0000000000000034 R11: 0000000000000001 R12: ffff81002b1108c0
R13: 0000000000000002 R14: 0000006cb9bdff1a R15: 0000000000000015
FS:  00002b6ef0bc66d0(0000) GS:ffff810100d02e40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b6ef20c1000 CR3: 0000000106e2b000 CR4: 00000000000006e0
Process cc1 (pid: 15583, threadinfo ffff81010aca6000, task ffff810105b03620)
Stack:  0000000000000100 0000000000000100 ffff81010964c148 ffff810105b03620
 ffffffff8054c9b7 ffff810105b037c0 0000000b0000000e ffff81010b216d80
 0000000000000000 00002b6ef20b7d00 00002b6ef20c1000 0000000000000400
Call Trace:
 [<ffffffff80209f17>] retint_careful+0xd/0x21


Code: 0f 0b eb fe 49 8b 94 24 b8 01 00 00 49 8b 84 24 b0 01 00 00
RIP  [<ffffffff80496686>] __sched_text_start+0x3a6/0x882
 RSP <ffff81010aca7ee0>



>From elm3b245:

------------[ cut here ]------------
kernel BUG at kernel/sched.c:3505!
invalid opcode: 0000 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.21-rc4-mm1-autokern1 #1
RIP: 0010:[<ffffffff8049cbb7>]  [<ffffffff8049cbb7>]
__sched_text_start+0x377/0x819
RSP: 0018:ffff81010037dee0  EFLAGS: 00010002
RAX: 000000000000008c RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000000034 RSI: 000000000000008c RDI: ffff810002c15210
RBP: ffff81010037df70 R08: 000000000000008c R09: 000000000000000c
R10: ffff810002c15200 R11: ffffffff8020968e R12: ffff810002c14940
R13: 00007fff1da16360 R14: ffff810002c14780 R15: 0000000000000000
FS:  00002b428d88d6d0(0000) GS:ffffffff805af000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000586a48 CR3: 0000000008c2f000 CR4: 00000000000006e0
Process init (pid: 1, threadinfo ffff81010037c000, task ffff810003369450)
Stack:  000003e10059d1b0 ffff81010037df28 ffffffff80276dd3 ffff810003369450
 ffff810008313880 0000003727988fe6 ffff8100033695f0 00007fff1da16250
 00007fff1da16360 000000000059bb70 ffffffff8020968e ffff81010037df48
Call Trace:
 [<ffffffff80276dd3>] generic_file_llseek+0x87/0x96
 [<ffffffff8020968e>] system_call+0x7e/0x83
 [<ffffffff80207db2>] sys_clone+0x23/0x25
 [<ffffffff802096f8>] sysret_careful+0xd/0x10


Code: 0f 0b eb fe 49 8b 96 b8 01 00 00 49 8b 86 b0 01 00 00 be 8c
RIP  [<ffffffff8049cbb7>] __sched_text_start+0x377/0x819
 RSP <ffff81010037dee0>
