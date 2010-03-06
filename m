Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0CFIK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 03:10:59 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55382 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0CFIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 03:10:52 -0500
Message-ID: <4B920E06.4060508@in.ibm.com>
Date: Sat, 06 Mar 2010 13:40:46 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, mhiramat@redhat.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PowerPC] 2.6.33-git11 : Badness at kernel/kprobes.c:264
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With latest 33 git(2.6.33-git11 : 64096c1741...) on a POWER6 box

type=2000 audit(1267853400.180:1): initialized
Kprobe smoke test started
------------[ cut here ]------------
Badness at kernel/kprobes.c:264
NIP: c0000000006251e0 LR: c000000000625190 CTR: c00000000007914c
REGS: c0000000fecc3680 TRAP: 0700   Not tainted  (2.6.33-git11-autotest)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000048  XER: 2000000b
TASK = c0000000feca0000[1] 'swapper' THREAD: c0000000fecc0000 CPU: 2
GPR00: 0000000000000001 c0000000fecc3900 c000000000b297b0 c0000000fc680000
GPR04: 0000000000000004 0000000000000000 0000000024022024 c000000000a2b9d0
GPR08: 0000000000004000 c0000000fc680004 0000000000010000 0000000000000004
GPR12: 0000000022000024 c000000000bc2b00 0000000000051bc3 0000000000051aa1
GPR16: 0000000000051bbb 0000000000d00000 c0000000008011f8 c0000000007f1ba1
GPR20: 00000000015e87a8 c0000000008e87a8 c0000000fecc3cc8 c0000000fecc3cd0
GPR24: c0000000fecc3cd8 c0000000fecc3cc0 c0000000fecc3be0 0000000000000000
GPR28: 0000000000000000 c000000000a2b8b8 c000000000a94888 d000000000bd0004
NIP [c0000000006251e0] .free_insn_slot+0x84/0x12c
LR [c000000000625190] .free_insn_slot+0x34/0x12c
Call Trace:
[c0000000fecc3900] [c000000000625190] .free_insn_slot+0x34/0x12c (unreliable)
[c0000000fecc3990] [c000000000622050] .arch_remove_kprobe+0x28/0x48
[c0000000fecc3a10] [c000000000623f58] .__unregister_kprobe_bottom+0x28/0x8c
[c0000000fecc3aa0] [c00000000062419c] .unregister_kprobes+0xc0/0xf0
[c0000000fecc3b40] [c0000000006241ec] .unregister_kprobe+0x20/0x30
[c0000000fecc3bb0] [c0000000000e081c] .init_test_probes+0xc4/0x66c
[c0000000fecc3c50] [c0000000008c288c] .init_kprobes+0x1f0/0x230
[c0000000fecc3e30] [c0000000000097a4] .do_one_initcall+0x88/0x1bc
[c0000000fecc3ee0] [c0000000008a0490] .kernel_init+0x220/0x2dc
[c0000000fecc3f90] [c00000000002c4d0] .kernel_thread+0x54/0x70
Instruction dump:
7c00f850 7c804b92 2fa40000 419c007c 7d0a5b92 7fa44000 409c0070 7d232214
88090020 68000002 7c0000d0 78000fe0 <0b000000> 2fbc0000 419e0044 8123001c

2.6.33-git10(64ba99267...) was OK.

This WARN_ON was introduced by commit 4610ee1d36...

kprobes: Introduce generic insn_slot framework

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

