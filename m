Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYBXLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYBXLIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYBXLI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:08:27 -0500
Received: from aun.it.uu.se ([130.238.12.36]:65486 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbYBXLI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:08:26 -0500
Date: Sun, 24 Feb 2008 12:07:37 +0100 (MET)
Message-Id: <200802241107.m1OB7bHb022801@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel for this 486 has CONFIG_M486=y and CONFIG_M586TSC=n,
but the 2.6.25 kernels still try to access the TSC. Here's the
oops from 2.6.25-rc2-git8:

Pid: 0, comm: swapper Not tainted (2.6.25-rc2-git8 #1)
EIP: 0060:[<c0106216>] EFLAGS: 00010002 CPU: 0
EIP is at native_read_tsc+0x6/0x10
EAX: ffff8ce6 EBX: c19f8620 ECX: c19f8620 EDX: 00300100
ESI: 00300100 EDI: 00000001 EBP: c19f7578 ESP: c02a7eec
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c02a6000 task=c028d300 task.ti=c02a6000)
Stack: c01b37e5 00000000 00001000 ffff8ce6 00000000 c19f7578 00000000 c019a2e7 
       c02e05cc c02e05cc c01da229 00000016 c01da302 00001000 00000001 c029d4e0 
       c02e05cc 00000050 c01dee35 00000000 c02e05cc c01dfc18 c02e0580 c1834ca0 
Call Trace:
 [<c01b37e5>] add_timer_randomness+0x115/0x170
 [<c019a2e7>] __blk_end_request+0x17/0x50
 [<c01da229>] __ide_end_request+0x39/0xe0
 [<c01da302>] ide_end_request+0x32/0x50
 [<c01dee35>] task_end_request+0x25/0x70
 [<c01dfc18>] task_in_intr+0xd8/0xe0
 [<c01db4fa>] ide_intr+0x7a/0x1a0
 [<c01dfb40>] task_in_intr+0x0/0xe0
 [<c01171f2>] run_timer_softirq+0x12/0x150
 [<c012ccf0>] handle_IRQ_event+0x30/0x70
 [<c012e0b2>] handle_level_irq+0x42/0x90
 [<c0104571>] do_IRQ+0x41/0x70
 [<c0102e23>] common_interrupt+0x23/0x30
 [<c0120000>] arm_timer+0xa0/0x2b0
 [<c010195d>] default_idle+0x3d/0x60
 [<c0101920>] default_idle+0x0/0x60
 [<c01017e0>] cpu_idle+0x20/0x70
 [<c02a8a83>] start_kernel+0x1e3/0x260
 =======================
Code: 90 90 90 90 90 b8 8e 21 00 00 e9 a6 28 0a 00 8d b6 00 00 00 00 e6 ed c3 90 90 90 90 90 90 90 90 9 
EIP: [<c0106216>] native_read_tsc+0x6/0x10 SS:ESP 0068:c02a7eec
Kernel panic - not syncing: Fatal exception in interrupt

This bug is also seen with 2.6.25-rc1.
Kernels up to and including 2.6.24 did not have this bug.
