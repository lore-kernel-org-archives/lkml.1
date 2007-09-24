Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXIXLJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXIXLJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbXIXLJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:09:34 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:32801 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbXIXLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:09:33 -0400
Message-ID: <46F79AC4.9010308@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 16:38:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <3339.1190630150@turing-police.cc.vt.edu>
In-Reply-To: <3339.1190630150@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 24 Sep 2007 02:17:16 PDT, Andrew Morton said:
> 
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> 
> It lived fast, it died young, it didn't leave a pretty corpse...
> 
> Something in the startup scripts did a 'touch', and ker-blam.
> 
> [   15.668000] Unable to handle kernel NULL pointer dereference at 0000000000000252 RIP: 
> [   15.668000]  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
> [   15.668000] PGD 52be067 PUD 5645067 PMD 0 
> [   15.668000] Oops: 0000 [1] PREEMPT SMP 
> [   15.668000] last sysfs file: /block/dm-13/dev
> [   15.668000] CPU 0 
> [   15.668000] Modules linked in: rtc
> [   15.668000] Pid: 528, comm: touch Not tainted 2.6.23-rc7-mm1 #1
> [   15.668000] RIP: 0010:[<ffffffff802a1dd1>]  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
> [   15.668000] RSP: 0018:ffff8100045fddd8  EFLAGS: 00010202
> [   15.668000] RAX: 0000000000000001 RBX: ffff810002c10680 RCX: 0000000000000001
> [   15.668000] RDX: ffff810082504000 RSI: ffff810005243168 RDI: 0000000000000202
> [   15.668000] RBP: ffff8100045fddd8 R08: 0000000000000001 R09: 0000000000000002
> [   15.668000] R10: 0000000000000000 R11: ffff8100045fde68 R12: 0000000000000202
> [   15.668000] R13: 00000000ffffffe2 R14: ffff8100052c1d80 R15: ffff8100039aa8a0
> [   15.668000] FS:  00007f9527f596f0(0000) GS:ffffffff806b6000(0000) knlGS:0000000000000000
> [   15.668000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   15.668000] CR2: 0000000000000252 CR3: 00000000052cb000 CR4: 00000000000006e0
> [   15.668000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   15.668000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   15.668000] Process touch (pid: 528, threadinfo ffff8100045fc000, task ffff8100047517e0)
> [   15.668000] last branch before last exception/interrupt
> [   15.668000]  from  [<ffffffff802a4d1b>] mnt_want_write+0x44/0xb5
> [   15.668000]  to  [<ffffffff802a1dc8>] __mnt_is_readonly+0x0/0x1e
> [   15.668000] Stack:  ffff8100045fde08 ffffffff802a4d20 ffff8100045fddf8 0000000000000000
> [   15.668000]  00000000fffffff7 ffff810005243140 ffff8100045fdf28 ffffffff802ad288
> [   15.668000]  ffff8100045fde58 0000000000000202 ffff8100045fde58 ffffffff8035437b
> [   15.668000] Call Trace:
> [   15.668000]  [<ffffffff802a4d20>] mnt_want_write+0x49/0xb5
> [   15.668000]  [<ffffffff802ad288>] do_utimes+0xd0/0x220
> [   15.668000]  [<ffffffff8035437b>] __up_read+0x7a/0x83
> [   15.668000]  [<ffffffff8024b1af>] up_read+0x9/0xb
> [   15.668000]  [<ffffffff8051977c>] do_page_fault+0x421/0x7d0
> [   15.668000]  [<ffffffff8028b370>] do_filp_open+0x36/0x46
> [   15.668000]  [<ffffffff802ad519>] sys_utimensat+0x8b/0xa5
> [   15.668000]  [<ffffffff80517a4d>] error_exit+0x0/0x84
> [   15.668000]  [<ffffffff8020c10e>] system_call+0x7e/0x83
> [   15.668000] 
> [   15.668000] 
> [   15.668000] Code: f6 47 50 40 75 0d 48 8b 47 28 8a 40 58 83 e0 01 0f b6 c0 c9 
> [   15.668000] RIP  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
> [   15.668000]  RSP <ffff8100045fddd8>
> [   15.668000] CR2: 0000000000000252
> 

CC'ing Dave, he might be interested in looking into this. Do you know
which file was touched. I suspect either mnt or mnt_sb is NULL in
__mnt_is_readonly(). mnt is extracted from the nameidata structure.
It's interesting to see utimenstat in the stack, I suspect that
the filename was probably NULL and dfd was something other than
AT_FDCWD (Just a wild guess). I'll try to reproduce your problem.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
