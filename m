Return-Path: <linux-kernel-owner+w=401wt.eu-S937474AbXGRAAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937474AbXGRAAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765606AbXGRAAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:00:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:58523 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760173AbXGQX77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:59:59 -0400
Date: Tue, 17 Jul 2007 16:58:33 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
Message-ID: <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> 
 <1184662429.12353.426.camel@chaos>  <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 17 Jul 2007 23:58:34.0025 (UTC) FILETIME=[623BC190:01C7C8CE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Katz wrote:

> On Tue, 17 Jul 2007, Thomas Gleixner wrote:
>
>> With 2.6.14 or with current mainline ?
>
> I haven't been keeping notes quite as studiously as I should have been, but 
> this just occurred with 2.6.22.1 + the hrt6 patch + your proposed fix:

Scratch that.  I had infrastructure problems, and ended up using the wrong 
build.

This is with the patch (and 2.6.22.1 and hrt6):

------------[ cut here ]------------
Kernel BUG at c0125adb [verbose debug info unavailable]
invalid opcode: 0000 [#1]
SMP
Modules linked in:
CPU:    3
EIP:    0060:[<c0125adb>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22.1-WR1.4aq_cgl #2)
EIP is at sigqueue_free+0x23/0x72
eax: 00000000   ebx: f6eaf1a8   ecx: f6d4b888   edx: 00000202
esi: f73e2ba8   edi: 00000000   ebp: f7c7bf8c   esp: f7c7bf84
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process hrtm_test (pid: 15340, ti=f7c7b000 task=f6c0f030 task.ti=f7c7b000)
Stack: 00000202 f73e2ba8 f7c7bf9c c012c941 f73e2ba8 000002fb f7c7bfb0 
c012d1c0
        00000286 000002fb 00000000 f7c7b000 c01027ca 000002fb 466afff4 
08064190
        00000000 00000000 ae8d43c8 00000107 ffff007b c010007b 00000000 
00000107
Call Trace:
  [<c0103504>] show_trace_log_lvl+0x1a/0x30
  [<c01035bb>] show_stack_log_lvl+0x8d/0xaa
  [<c01037f5>] show_registers+0x1cd/0x2cb
  [<c0103a4a>] die+0x113/0x207
  [<c039aab5>] do_trap+0x8f/0xc6
  [<c0103d35>] do_invalid_op+0x88/0x92
  [<c039a882>] error_code+0x72/0x78
  [<c012c941>] release_posix_timer+0x1b/0x7a
  [<c012d1c0>] sys_timer_delete+0xd7/0x10c
  [<c01027ca>] syscall_call+0x7/0xb
  =======================
Code: 74 04 83 48 08 01 5d c3 55 89 e5 56 53 89 c3 8b 40 08 a8 01 74 15 39 
1b 75 15 83 e0 fe 89 43 08 89 d8 e8 1d ec ff ff 5b 5e 5d c3 <0f> 0b eb fe 
64 a1 00 c0 4a c0 8b b0 50 04 00 00 b8 00 1e 46 c0

