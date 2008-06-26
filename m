Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYFZG6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYFZG6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFZG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:57:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYFZG5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:57:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for June 25
Date: Thu, 26 Jun 2008 08:59:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <20080626003554.b2623aba.sfr@canb.auug.org.au> <20080626120212.c8caa005.sfr@canb.auug.org.au> <200806260801.13131.rjw@sisk.pl>
In-Reply-To: <200806260801.13131.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260859.26270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 of June 2008, Rafael J. Wysocki wrote:
> On Thursday, 26 of June 2008, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > On Thu, 26 Jun 2008 02:28:38 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > >
> > > This tree is completely broken on my test box (x86-64 HP nx6325) and I can't
> > > even bisect it. :-(
> > 
> > Config?
> 
> Attached.

BTW, I reproduced it on another x86-64 machine (guess everything x86-64 is
broken).  Below is the oops, full dmesg log is at:
http://www.sisk.pl/kernel/debug/20080625/next-20080625-oops.log

debug: unmapping init memory ffffffff80621000..ffffffff8066d000
Write protecting the kernel read-only data: 3864k
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80264230>] find_symbol+0x230/0x260
PGD 5c817067 PUD 5cccf067 PMD 0
Oops: 0002 [1] SMP DEBUG_PAGEALLOC
last sysfs file:
CPU 0
Modules linked in:
Pid: 912, comm: modprobe Not tainted 2.6.26-rc7-next #4
RIP: 0010:[<ffffffff80264230>]  [<ffffffff80264230>] find_symbol+0x230/0x260
RSP: 0018:ffff81005cbddc68  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 000000000000003d RCX: ffffffff805b8568
RDX: 0000000000000000 RSI: ffffffff80573e0f RDI: ffffffff805c0bcc
RBP: ffff81005cbddda8 R08: ffff81005cbddd48 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000000003c R12: fffffffffffffff2
R13: 00000000000b2507 R14: 00000000006181e0 R15: ffffc20000689240
FS:  00007f5820fed6f0(0000) GS:ffffffff80613f40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000005c87f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 912, threadinfo ffff81005cbdc000, task ffff81005c9f6840)
Stack:  ffff81005c9f6840 0000000000000000 0000000000000000 00000000006180f8
 ffff81005cbddf40 0000000000000000 ffff81005c9f6840 ffffffff8049728f
 00000000000b2507 00000000006181e0 ffff81005cbddcd8 ffffffff8025c70a
Call Trace:
 [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8025c70a>] ? trace_hardirqs_on_caller+0xca/0x160
 [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020f167>] ? do_softirq+0x47/0xa0
 [<ffffffff8020bc9f>] ? restore_args+0x0/0x30
 [<ffffffff80263c80>] ? struct_module+0x0/0x10
 [<ffffffff802648f3>] ? find_sec+0x53/0x70
 [<ffffffff80265c04>] sys_init_module+0x6b4/0x1e00
 [<ffffffff802afc11>] ? do_sync_read+0xf1/0x130
 [<ffffffff802505e0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80323791>] ? security_file_permission+0x11/0x20
 [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8025c70a>] ? trace_hardirqs_on_caller+0xca/0x160
 [<ffffffff8049728f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b65b>] system_call_after_swapgs+0x7b/0x80


Code: 49 8b 43 08 0f 18 08 49 8d 43 08 48 3d c0 a5 5d 80 0f 85 47 fe ff ff 48 c7 c0 fe ff ff ff eb 20 48 8b 45 b0 48 8b 95 e8 fe ff ff <48> 89 02 48
RIP  [<ffffffff80264230>] find_symbol+0x230/0x260
 RSP <ffff81005cbddc68>
CR2: 0000000000000000
---[ end trace 81cec6311b0e1cee ]---
modprobe used greatest stack depth: 4688 bytes left
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x926eb1, caps: 0x804719/0x0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input3

This is where the oops happens:

(gdb) l *find_symbol+0x230
0xffffffff80264230 is in find_symbol (/home/rafael/src/linux-next/kernel/module.c:315).
310             fsa.name = name;
311             fsa.gplok = gplok;
312             fsa.warn = warn;
313
314             if (each_symbol(find_symbol_in_section, &fsa)) {
315                     *owner = fsa.owner;
316                     *crc = fsa.crc;
317                     return fsa.value;
318             }
319
(gdb)

