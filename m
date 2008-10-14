Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYJNEmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYJNEmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 00:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYJNElu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 00:41:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:9272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJNElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 00:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ObGvcXQkJuo2hOMZtE8Jr4WQA9jYcsD785K7EUMc44h6oMBP+dvgfSxHuN9ESk0IOU
         UDBHkHimauW0vr5oGFUrv9P3rVyK7cugtua6LHpZyqsXD1cnd7nixW/iarOoCQ7v7nPG
         /syQnscrpQMq4vCR3mTMTesvASei/O4SnAS14=
Message-ID: <48F42305.9000507@gmail.com>
Date: Tue, 14 Oct 2008 12:41:41 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: lockdep warning: inconsistent hardirq-on-W -> in-hardirq-R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kernel built from today's linux-2.6 git, lockdep warnings as following:

[   52.984024] =================================
[   52.984030] [ INFO: inconsistent lock state ]
[   52.984034] 2.6.27-smp #3
[   52.984037] ---------------------------------
[   52.984040] inconsistent {hardirq-on-W} -> {in-hardirq-R} usage.
[   52.984045] pulseaudio/3400 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   52.984048]  (tasklist_lock){--?-}, at: [<c0142552>] run_posix_cpu_timers+0x52/0x9a0
[   52.984064] {hardirq-on-W} state was registered at:
[   52.984068]   [<c01507a0>] mark_held_locks+0x30/0x80
[   52.984075]   [<c015090a>] trace_hardirqs_on_caller+0x7a/0x140
[   52.984081]   [<c01509db>] trace_hardirqs_on+0xb/0x10
[   52.984086]   [<c043a9b2>] _spin_unlock_irq+0x22/0x30
[   52.984093]   [<c02aea15>] proc_clear_tty+0x45/0x60
[   52.984099]   [<c013b8a6>] sys_setsid+0x96/0xa0
[   52.984105]   [<c0103e22>] syscall_call+0x7/0xb
[   52.984111]   [<ffffffff>] 0xffffffff
[   52.984124] irq event stamp: 636
[   52.984127] hardirqs last  enabled at (635): [<c0264294>] trace_hardirqs_on_thunk+0xc/0x10
[   52.984135] hardirqs last disabled at (636): [<c02642a4>] trace_hardirqs_off_thunk+0xc/0x18
[   52.984141] softirqs last  enabled at (0): [<c012bcfa>] copy_process+0x26a/0x1160
[   52.984149] softirqs last disabled at (0): [<00000000>] 0x0
[   52.984155] 
[   52.984155] other info that might help us debug this:
[   52.984160] no locks held by pulseaudio/3400.
[   52.984162] 
[   52.984163] stack backtrace:
[   52.984168] Pid: 3400, comm: pulseaudio Not tainted 2.6.27-smp #3
[   52.984171] Call Trace:
[   52.984178]  [<c014ebc6>] print_usage_bug+0x166/0x1a0
[   52.984183]  [<c01506f6>] mark_lock+0xa96/0xb10
[   52.984189]  [<c014d83b>] ? trace_hardirqs_off+0xb/0x10
[   52.984196]  [<c010a53f>] ? native_sched_clock+0x7f/0xb0
[   52.984202]  [<c0152452>] __lock_acquire+0x552/0x9a0
[   52.984208]  [<c01507d5>] ? mark_held_locks+0x65/0x80
[   52.984213]  [<c0152916>] lock_acquire+0x76/0xa0
[   52.984219]  [<c0142552>] ? run_posix_cpu_timers+0x52/0x9a0
[   52.984224]  [<c043a826>] _read_lock+0x36/0x60
[   52.984229]  [<c0142552>] ? run_posix_cpu_timers+0x52/0x9a0
[   52.984234]  [<c0142552>] run_posix_cpu_timers+0x52/0x9a0
[   52.984239]  [<c014d83b>] ? trace_hardirqs_off+0xb/0x10
[   52.984245]  [<c0132b55>] ? raise_softirq+0x65/0x90
[   52.984251]  [<c012b11c>] ? scheduler_tick+0x13c/0x1b0
[   52.984256]  [<c01370ef>] update_process_times+0x4f/0x60
[   52.984262]  [<c014c250>] tick_sched_timer+0x50/0xc0
[   52.984266]  [<c014c200>] ? tick_sched_timer+0x0/0xc0
[   52.984271]  [<c014c200>] ? tick_sched_timer+0x0/0xc0
[   52.984276]  [<c01442d5>] __run_hrtimer+0x75/0x90
[   52.984282]  [<c0144d1d>] hrtimer_interrupt+0x11d/0x180
[   52.984287]  [<c0115996>] smp_apic_timer_interrupt+0x56/0x90
[   52.984293]  [<c02642a4>] ? trace_hardirqs_off_thunk+0xc/0x18
[   52.984298]  [<c01048d1>] apic_timer_interrupt+0x2d/0x34

