Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZCOCA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZCOCA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 22:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZCOCAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 22:00:11 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:41073
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751635AbZCOCAJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 22:00:09 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 22:00:09 EDT
X-BigFish: VPS-20(zz14c3M9370P98dR4cd6kzz1202hzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <49BC5D8C.209@am.sony.com>
Date: Sat, 14 Mar 2009 18:44:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 15 Mar 2009 01:44:45.0761 (UTC) FILETIME=[9E6A0310:01C9A50F]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
> boot on many maschines.  It would be great if this change would make it
> into .29.

I'd like to ACK this patch (not sure if my opinion matters).

Without the patch, enabling the function tracer causes my ARM
board to panic on boot.  (See below for gory details).

With the patch, the board boots and function tracing works
(In a simple test, anyway.)

My board is an OMAP Starter Kit (with a TI OMAP 5912 processor).

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

Here is the panic without the patch:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c1414000
[00000000] *pgd=11407031, *pte=00000000, *ppte=00000000
Internal error: Oops: 0 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.29-rc7 #8)
PC is at 0x0
LR is at 0x0
pc : [<00000000>]    lr : [<00000000>]    psr: 60000013
sp : c1c1db28  ip : 00000000  fp : c1c1db44
r10: 0005b000  r9 : 00000000  r8 : 00000204
r7 : c14060b0  r6 : c04ecb7c  r5 : 00564000  r4 : c0565000
r3 : 00000000  r2 : 00000000  r1 : c0566000  r0 : c0567000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 11414000  DAC: 00000015
Process init (pid: 1, stack limit = 0xc1c1c268)
Stack: (0xc1c1db28 to 0xc1c1e000)
db20:                   c14060b0 c1414000 00000000 c0512ca0 c1c1db94 c1c1db48
db40: c009f01c c0035f90 c1fe9000 00000001 00000000 c1414000 00000001 0000004b
db60: 0005b000 c0512c80 c1fe9034 c1407800 00000000 c140796c c1fe9034 c14060b0
db80: 00000000 0005b000 c1c1dbf4 c1c1db98 c00a0400 c009eeec 0000004b 00000001
dba0: 00000000 c1c1dbb0 c00449b4 00000800 c1fe9000 60000013 c1414000 c1414000
dbc0: c1c1c000 0000016c c00cfe48 ffffffff c14060b0 c1c1a000 c1fe9034 0005b910
dbe0: c1c1dd00 c1fe9000 c1c1dc34 c1c1dbf8 c0033b54 c00a016c c1812e80 c1406058
dc00: c1406074 00000805 c1c1dc2c ffffffff 00000000 00000805 c1c1dd00 0005b910
dc20: 60000013 0006b68c c1c1dc4c c1c1dc38 c0033d4c c0033a64 ffffffff c048c8a4
dc40: c1c1dcfc c1c1dc50 c002c284 c0033d3c c013f488 c1fe9000 08101877 c1f30400
dc60: 00000001 c00a3fe0 c1c1dce4 c1406108 c1fe9000 00000000 c14060b0 c1406108
dc80: c1406018 c14060c8 00000001 c1406108 c140613c 00000000 00000001 c00a4518
dca0: c1406108 c1fe9000 c1c1dce4 c1c1dcb8 c00a5800 c00a4518 c1406018 c1c1c000
dcc0: 00000000 00000001 c021a014 c1c1c000 00000001 c1fe9038 c1fe9034 ffffffff
dce0: c1c1dd34 00000000 0005b910 c1f30e80 c1c1dd5c c1c1dd00 c002ca6c c002c254
dd00: 0005b910 000006e8 00000000 00000000 0005b910 0006b68c 00000000 0005b910
dd20: c1f30e80 00000001 0006b68c c1c1dd5c 00000000 c1c1dd48 c00ef194 c02122bc
dd40: 20000013 ffffffff 000006f0 c00ef194 c1c1ddfc c1c1dd60 c00efd10 c00ef158
dd60: 00001812 00000000 c00c0f78 c1c1c000 c1c1df50 c1400000 00000003 00008000
dd80: 00000000 c1ff69c0 00000000 00008000 00052c1c 0005b000 0005b910 c1f30f80
dda0: c1f38cc0 c1812de8 00000080 00000000 00000000 c00ee8fc c1c1ddec 00000006
ddc0: c00bba78 c1c1c000 00000001 c1400000 c1c1c000 00000000 c049d3c8 c1400000
dde0: c1c1c000 00000001 00000000 c00ef574 c1c1de34 c1c1de00 c00bbb1c c00ef584
de00: c1c1df50 fffffffe c1c1de34 c1400000 c1c1de38 c1c1df50 c1c1c000 00000000
de20: 00000000 c00ee8fc c1c1dedc c1c1de38 c00eeb04 c00bba28 6e69622f 7375622f
de40: 786f6279 00000000 c1400000 00000001 c1c1df50 c1400000 0000000b 00000000
de60: c1c1de94 c1c1de70 fffffff8 c00a0874 00000003 c1c1deac 00000000 c1f30400
de80: 0074696e c1c1c000 c1c1decc c0512ae0 c048c230 00000000 00000069 00000001
dea0: c00bbbe4 c1c1c000 00000001 c1400000 c1c1c000 00000000 c140000f c1400002
dec0: c00449b4 00000000 c049d370 c1400000 c1c1df14 c1c1dee0 c00bbb1c c00ee90c
dee0: c1c1df50 fffffff8 c1c1df50 00000000 c1400000 c042ad9c c1c1c000 c048c1a8
df00: c1c1df50 c048c234 c1c1df4c c1c1df18 c00bcf34 c00bba28 c048a6f0 00000000
df20: c00ccb34 c042ad9c c048c234 c048c1a8 c1c1df50 00000000 00000000 00000000
df40: c1c1dfb4 c1c1df50 c003045c c00bcdd8 00000000 00000000 00000000 00000000
df60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
df80: 00000000 00000000 00000000 00000000 00000000 00000000 c04c1514 c0025ef4
dfa0: 00000000 00000000 c1c1dfc4 c1c1dfb8 c002c4f0 c0030428 c1c1dfdc c1c1dfc8
dfc0: c002c5bc c002c4dc c04c1518 c04c1518 c1c1dff4 c1c1dfe0 c0008788 c002c50c
dfe0: 00000000 00000000 00000000 c1c1dff8 c004ec70 c00086dc e1a00007 e58d3010
Backtrace:
[<c0035f80>] (v4wb_copy_user_highpage+0x0/0xa0) from [<c009f01c>] (__do_fault+0x140/0x3e8)
 r6:c0512ca0 r5:00000000 r4:c1414000
[<c009eedc>] (__do_fault+0x0/0x3e8) from [<c00a0400>] (handle_mm_fault+0x2a4/0x708)
[<c00a015c>] (handle_mm_fault+0x0/0x708) from [<c0033b54>] (do_page_fault+0x100/0x23c)
[<c0033a54>] (do_page_fault+0x0/0x23c) from [<c0033d4c>] (do_translation_fault+0x20/0x80)
[<c0033d2c>] (do_translation_fault+0x0/0x80) from [<c002c284>] (do_DataAbort+0x40/0xa4)
 r5:c048c8a4 r4:ffffffff
[<c002c244>] (do_DataAbort+0x0/0xa4) from [<c002ca6c>] (__dabt_svc+0x4c/0x60)
Exception stack(0xc1c1dd00 to 0xc1c1dd48)
dd00: 0005b910 000006e8 00000000 00000000 0005b910 0006b68c 00000000 0005b910
dd20: c1f30e80 00000001 0006b68c c1c1dd5c 00000000 c1c1dd48 c00ef194 c02122bc
dd40: 20000013 ffffffff
 r8:c1f30e80 r7:0005b910 r6:00000000 r5:c1c1dd34 r4:ffffffff
[<c00ef148>] (padzero+0x0/0x64) from [<c00efd10>] (load_elf_binary+0x79c/0x11f0)
[<c00ef574>] (load_elf_binary+0x0/0x11f0) from [<c00bbb1c>] (search_binary_handler+0x104/0x2f4)
[<c00bba18>] (search_binary_handler+0x0/0x2f4) from [<c00eeb04>] (load_script+0x208/0x21c)
[<c00ee8fc>] (load_script+0x0/0x21c) from [<c00bbb1c>] (search_binary_handler+0x104/0x2f4)
 r6:c1400000 r5:c049d370 r4:00000000
[<c00bba18>] (search_binary_handler+0x0/0x2f4) from [<c00bcf34>] (do_execve+0x16c/0x224)
[<c00bcdc8>] (do_execve+0x0/0x224) from [<c003045c>] (kernel_execve+0x44/0x8c)
[<c0030418>] (kernel_execve+0x0/0x8c) from [<c002c4f0>] (run_init_process+0x24/0x30)
 r7:00000000 r6:00000000 r5:c0025ef4 r4:c04c1514
[<c002c4cc>] (run_init_process+0x0/0x30) from [<c002c5bc>] (init_post+0xc0/0x110)
[<c002c4fc>] (init_post+0x0/0x110) from [<c0008788>] (kernel_init+0xbc/0xe0)
 r4:c04c1518
[<c00086cc>] (kernel_init+0x0/0xe0) from [<c004ec70>] (do_exit+0x0/0x83c)
 r5:00000000 r4:00000000
Code: bad PC value.
---[ end trace 9795c27e141651b4 ]---
note: init[1] exited with preempt_count 2
BUG: scheduling while atomic: init/1/0x40000003
Modules linked in:
[<c00313c8>] (dump_stack+0x0/0x18) from [<c0044ca0>] (__schedule_bug+0x64/0x70)
[<c0044c3c>] (__schedule_bug+0x0/0x70) from [<c0385354>] (schedule+0x78/0x398)
 r5:c1c1a000 r4:c1c1c000
[<c03852dc>] (schedule+0x0/0x398) from [<c0044cf4>] (__cond_resched+0x34/0x54)
[<c0044cc0>] (__cond_resched+0x0/0x54) from [<c0385cd8>] (_cond_resched+0x4c/0x58)
 r4:00000001
[<c0385c8c>] (_cond_resched+0x0/0x58) from [<c004d864>] (put_files_struct+0x90/0xe4)
 r4:c1c01b40
[<c004d7d4>] (put_files_struct+0x0/0xe4) from [<c004d910>] (exit_files+0x58/0x5c)
 r8:00000000 r7:00000000 r6:c1c1a000 r5:c1c01b40 r4:c1c1a000
[<c004d8b8>] (exit_files+0x0/0x5c) from [<c004ee70>] (do_exit+0x200/0x83c)
 r5:0000000b r4:c1c1c000
[<c004ec70>] (do_exit+0x0/0x83c) from [<c00312ac>] (die+0x1c0/0x224)
[<c00310ec>] (die+0x0/0x224) from [<c0033a44>] (__do_kernel_fault+0x70/0x80)
[<c00339d4>] (__do_kernel_fault+0x0/0x80) from [<c0033c70>] (do_page_fault+0x21c/0x23c)
 r7:c14060b0 r6:c1c1a000 r5:00000000 r4:ffffffff
[<c0033a54>] (do_page_fault+0x0/0x23c) from [<c0033d4c>] (do_translation_fault+0x20/0x80)
[<c0033d2c>] (do_translation_fault+0x0/0x80) from [<c002c240>] (do_PrefetchAbort+0x1c/0x20)
 r5:c1c1db14 r4:ffffffff
[<c002c224>] (do_PrefetchAbort+0x0/0x20) from [<c002cc0c>] (__pabt_svc+0x4c/0x80)
Exception stack(0xc1c1dae0 to 0xc1c1db28)
dae0: c0567000 c0566000 00000000 00000000 c0565000 00564000 c04ecb7c c14060b0
db00: 00000204 00000000 0005b000 c1c1db44 00000000 c1c1db28 00000000 00000000
db20: 60000013 ffffffff
[<c0035f80>] (v4wb_copy_user_highpage+0x0/0xa0) from [<c009f01c>] (__do_fault+0x140/0x3e8)
 r6:c0512ca0 r5:00000000 r4:c1414000
[<c009eedc>] (__do_fault+0x0/0x3e8) from [<c00a0400>] (handle_mm_fault+0x2a4/0x708)
[<c00a015c>] (handle_mm_fault+0x0/0x708) from [<c0033b54>] (do_page_fault+0x100/0x23c)
[<c0033a54>] (do_page_fault+0x0/0x23c) from [<c0033d4c>] (do_translation_fault+0x20/0x80)
[<c0033d2c>] (do_translation_fault+0x0/0x80) from [<c002c284>] (do_DataAbort+0x40/0xa4)
 r5:c048c8a4 r4:ffffffff
[<c002c244>] (do_DataAbort+0x0/0xa4) from [<c002ca6c>] (__dabt_svc+0x4c/0x60)
Exception stack(0xc1c1dd00 to 0xc1c1dd48)
dd00: 0005b910 000006e8 00000000 00000000 0005b910 0006b68c 00000000 0005b910
dd20: c1f30e80 00000001 0006b68c c1c1dd5c 00000000 c1c1dd48 c00ef194 c02122bc
dd40: 20000013 ffffffff
 r8:c1f30e80 r7:0005b910 r6:00000000 r5:c1c1dd34 r4:ffffffff
[<c00ef148>] (padzero+0x0/0x64) from [<c00efd10>] (load_elf_binary+0x79c/0x11f0)
[<c00ef574>] (load_elf_binary+0x0/0x11f0) from [<c00bbb1c>] (search_binary_handler+0x104/0x2f4)
[<c00bba18>] (search_binary_handler+0x0/0x2f4) from [<c00eeb04>] (load_script+0x208/0x21c)
[<c00ee8fc>] (load_script+0x0/0x21c) from [<c00bbb1c>] (search_binary_handler+0x104/0x2f4)
 r6:c1400000 r5:c049d370 r4:00000000
[<c00bba18>] (search_binary_handler+0x0/0x2f4) from [<c00bcf34>] (do_execve+0x16c/0x224)
[<c00bcdc8>] (do_execve+0x0/0x224) from [<c003045c>] (kernel_execve+0x44/0x8c)
[<c0030418>] (kernel_execve+0x0/0x8c) from [<c002c4f0>] (run_init_process+0x24/0x30)
 r7:00000000 r6:00000000 r5:c0025ef4 r4:c04c1514
[<c002c4cc>] (run_init_process+0x0/0x30) from [<c002c5bc>] (init_post+0xc0/0x110)
[<c002c4fc>] (init_post+0x0/0x110) from [<c0008788>] (kernel_init+0xbc/0xe0)
 r4:c04c1518
[<c00086cc>] (kernel_init+0x0/0xe0) from [<c004ec70>] (do_exit+0x0/0x83c)
 r5:00000000 r4:00000000
Kernel panic - not syncing: Attempted to kill init!
eth0: no IPv6 routers present

