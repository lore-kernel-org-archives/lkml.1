Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0AVXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0AVXxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0AVXw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:52:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab0AVXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:52:58 -0500
Date: Fri, 22 Jan 2010 15:52:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@suse.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-Id: <20100122155237.e93a1c55.akpm@linux-foundation.org>
In-Reply-To: <4B50FC78.9010107@gmail.com>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
	<4B50C2FA.4020100@gmail.com>
	<4B50FC78.9010107@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 00:38:32 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> (fixed subject)
> 
> On 01/15/2010 08:33 PM, Jiri Slaby wrote:
> > On 01/13/2010 09:17 PM, akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> > 
> > Hi, it crashes on my machine while booting up. It is a regression
> > against 2010-01-06-14-34. Doesn't it ring a bell by a chance?
> 
> Well, memcpying to something like this:
> char *uevent_helper = CONFIG_UEVENT_HELPER_PATH;
> doesn't sound like a good idea :).
> 
> And it's racy with sysctl path anyway.
> 
> Looks like added by:
> sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
> 
> Andi, did you forget to change uevent_helper_store?

Jiri did you forget to Cc Andi? ;)

> > BUG: unable to handle kernel paging request at ffffffff816efe8e
> > IP: [<ffffffff811acf60>] memcpy_c+0x10/0x20
> > PGD 1807067 PUD 180b063 PMD 80000000016001e1
> > Oops: 0003 [#1] SMP
> > last sysfs file: /sys/kernel/uevent_helper
> > CPU 0
> > Pid: 957, comm: boot.udev Not tainted 2.6.33-rc4-mm1_64 #928 To be
> > filled by O.E.M./To Be Filled By O.E.M.
> > RIP: 0010:[<ffffffff811acf60>]  [<ffffffff811acf60>] memcpy_c+0x10/0x20
> > RSP: 0018:ffff8801c3127e80  EFLAGS: 00010202
> > RAX: ffffffff816efe8e RBX: 0000000000000001 RCX: 0000000000000001
> > RDX: 0000000000000001 RSI: ffff8801c30b9000 RDI: ffffffff816efe8e
> > RBP: ffff8801c3127e98 R08: ffffffff81058620 R09: 00000000000c2c7e
> > R10: 0000000000000001 R11: 0000000000000246 R12: ffff8801c3127f48
> > R13: ffff8801cbc26688 R14: ffffffff81829d10 R15: ffff8801cbc903b8
> > FS:  00007fe572b106f0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffffff816efe8e CR3: 00000001c30f2000 CR4: 00000000000006f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process boot.udev (pid: 957, threadinfo ffff8801c3126000, task
> > ffff8801cbcdbf90)
> > Stack:
> >  ffffffff8105865f ffff8801c3127ea8 ffff8801c4a3faa0 ffff8801c3127ea8
> > <0> ffffffff811a51b7 ffff8801c3127ef8 ffffffff811224ec 0000000000000001
> > <0> ffff8801c4a3fa80 ffff8801c3127ee8 0000000000000001 00007fe572b4c000
> > Call Trace:
> >  [<ffffffff8105865f>] ? uevent_helper_store+0x3f/0x80
> >  [<ffffffff811a51b7>] kobj_attr_store+0x17/0x20
> >  [<ffffffff811224ec>] sysfs_write_file+0x9c/0xf0
> >  [<ffffffff810c9ba8>] vfs_write+0xc8/0x190
> >  [<ffffffff810ca4ec>] sys_write+0x4c/0x80
> >  [<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
> > Code: 00 48 3b 42 20 73 07 48 8b 50 f9 31 c0 c3 31 d2 48 c7 c0 f2 ff ff
> > ff c3 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 <f3> a4
> > c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 eb de f8 89 d1
> > RIP  [<ffffffff811acf60>] memcpy_c+0x10/0x20
> >  RSP <ffff8801c3127e80>
> > CR2: ffffffff816efe8e
> > ---[ end trace 309d1f0b04265911 ]---
> 

