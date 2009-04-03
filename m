Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZDCJtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZDCJtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbZDCJsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:48:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64852 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbZDCJsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=n5/YzpQsy8w/QH6TzHGGNVmEDkZ0yiHy+IS6K2umvwhDAcF7Rlk5UxOagODZ3D+Y54
         3PTSHJBkRDicyiPeRRYAevZsYyHA9DvE2GyKcdrBqkXv1loLY/QNp8KwdzQATpbCObZP
         nQQPtwnZt0t9VoSPO8dQkokur1FyDbxlzc6DE=
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 11:48:49 +0200
X-Google-Sender-Auth: 515de57bbb6e83c0
Message-ID: <3efb10970904030248t39a13176led25b9dc7ff9383c@mail.gmail.com>
Subject: System deadlock on 2.6.24-rt20
From: Remy Bohmer <linux@bohmer.net>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

We encountered a nasty system lockup on an X86 system running
2.6.24.7-rt20. (Intel Core2Duo system)
What happens is that the system freezes completely after some time.
After a lot of testing we are now able to reproduce this problem
within 5 minutes of testing.

The backtrace was not printed to the serial terminal, but when we
accidentally used the VGA
terminal the backtrace was there. So we used/hacked the earlyprintk
mechanism to get the logging out.

Does anybody recognise these backtraces? And if so, is there a fix for
it already?

There are several independent processes involved, all with RT-priorities.

Kind regards,

Remy


============= Trace 1 ========================
<0>BUG: spinlock lockup on CPU#0, A_EngineNode/2487, f78c5004
<0>BUG: spinlock lockup on CPU#1, A_EngineNode/2296, c3e13400
<4>Pid: 2487, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4> [<c010657a>] Pid: 2296, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4> [<c010657a>] show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>] show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>] show_trace+0x12/0x20
<4> [<c010782c>] show_trace+0x12/0x20
<4> [<c010782c>] dump_stack+0x6c/0x80
<4> [<c04c2511>] dump_stack+0x6c/0x80
<4>_raw_spin_lock+0x141/0x180
<4> [<c04c2511>]  [<c04c16da>] _raw_spin_lock+0x141/0x180
<4> [<c04c19cd>] __spin_lock_irqsave+0x4a/0x60
<4> [<c016e5ea>] __spin_lock+0x3d/0x50
<4> [<c01270bc>] cpupri_set+0x4a/0xd0
<4> [<c0129f18>] task_rq_lock+0x3c/0x70
<4> [<c01273ac>] dequeue_task_rt+0xd8/0x1f0
<4> [<c01247f5>] try_to_wake_up+0x2c/0x110
<4> [<c01274a8>] dequeue_task+0x15/0x30
<4> [<c0124878>] default_wake_function+0x18/0x20
<4> [<c0124bd8>] deactivate_task+0x28/0x40
<4> [<c04bee0f>] __wake_up_common+0x48/0x70
<4> [<c012ba93>] __schedule+0x2ff/0x780
<4> [<c04bf3d3>] __wake_up+0x33/0x60
<4> [<c015380e>] schedule+0x33/0x120
<4> [<c015369f>] wake_futex+0x3e/0x50
<4>futex_wait+0x26f/0x3a0
<4> [<c015490c>]  [<c01538b8>] futex_wake+0x98/0x100
<4>do_futex+0x8c/0xb40
<4> [<c0155445>]  [<c0154c74>] do_futex+0x3f4/0xb40
<4>sys_futex+0x85/0x100
<4> [<c010547e>]  [<c0155445>] sys_futex+0x85/0x100
<4>sysenter_past_esp+0x5f/0x99
<4> =======================
<4> [<c010547e>] sysenter_past_esp+0x5f/0x99
<4> =======================


============= Trace 2 ========================
<0>BUG: spinlock lockup on CPU#0, A_EngineNode/3069, f78c5004
<4>Pid: 3069, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4> [<c010657a>] show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>] show_trace+0x12/0x20
<4> [<c010782c>] dump_stack+0x6c/0x80
<4> [<c04c2511>] _raw_spin_lock+0x141/0x180
<0>BUG: spinlock lockup on CPU#1, usbpui/2208, c3e13400
<4>Pid: 2208, comm: usbpui Not tainted 2.6.24.7-rt20 #4
<4> [<c04c16da>]  [<c010657a>] __spin_lock_irqsave+0x4a/0x60
<4> [<c016e5ea>] show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>] cpupri_set+0x4a/0xd0
<4>show_trace+0x12/0x20
<4> [<c010782c>]  [<c0129f18>] dump_stack+0x6c/0x80
<4> [<c04c2511>] dequeue_task_rt+0xd8/0x1f0
<4> [<c01247f5>] _raw_spin_lock+0x141/0x180
<4>dequeue_task+0x15/0x30
<4> [<c0124878>]  [<c04c19cd>] __spin_lock+0x3d/0x50
<4>deactivate_task+0x28/0x40
<4> [<c01270bc>]  [<c04bee0f>] task_rq_lock+0x3c/0x70
<4> [<c01273ac>] __schedule+0x2ff/0x780
<4>try_to_wake_up+0x2c/0x110
<4> [<c04bf3d3>]  [<c01274a8>] schedule+0x33/0x120
<4> [<c015369f>] default_wake_function+0x18/0x20
<4> [<c0124bd8>] futex_wait+0x26f/0x3a0
<4> [<c015490c>] __wake_up_common+0x48/0x70
<4>do_futex+0x8c/0xb40
<4> [<c0155445>]  [<c012ba93>] __wake_up+0x33/0x60
<4>sys_futex+0x85/0x100
<4> [<c010547e>]  [<c015380e>] sysenter_past_esp+0x5f/0x99
<4> =======================
<4>wake_futex+0x3e/0x50
<4> [<c01538b8>] futex_wake+0x98/0x100
<4> [<c0154c74>] do_futex+0x3f4/0xb40
<4> [<c0155445>] sys_futex+0x85/0x100
<4> [<c010547e>] sysenter_past_esp+0x5f/0x99
<4> =======================

============= Trace 3 ========================
<0>BUG: spinlock lockup on CPU#0, A_EngineNode/2525, f78c5004
<0>BUG: spinlock lockup on CPU#1, A_EngineNode/2498, c3e13400
<4>Pid: 2498, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4>Pid: 2525, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4> [<c010657a>]  [<c010657a>] show_trace_log_lvl+0x1a/0x30
<4>show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>]  [<c0107012>] show_trace+0x12/0x20
<4>show_trace+0x12/0x20
<4> [<c010782c>]  [<c010782c>] dump_stack+0x6c/0x80
<4>dump_stack+0x6c/0x80
<4> [<c04c2511>]  [<c04c2511>] _raw_spin_lock+0x141/0x180
<4> [<c04c19cd>] _raw_spin_lock+0x141/0x180
<4> [<c04c16da>] __spin_lock+0x3d/0x50
<4>__spin_lock_irqsave+0x4a/0x60
<4> [<c016e5ea>]  [<c01270bc>] task_rq_lock+0x3c/0x70
<4>cpupri_set+0x4a/0xd0
<4> [<c0129f18>]  [<c01273ac>] dequeue_task_rt+0xd8/0x1f0
<4>try_to_wake_up+0x2c/0x110
<4> [<c01274a8>]  [<c01247f5>] dequeue_task+0x15/0x30
<4>default_wake_function+0x18/0x20
<4> [<c0124bd8>]  [<c0124878>] deactivate_task+0x28/0x40
<4>__wake_up_common+0x48/0x70
<4> [<c012ba93>]  [<c04bee0f>] __wake_up+0x33/0x60
<4>__schedule+0x2ff/0x780
<4> [<c04bf3d3>]  [<c015380e>] schedule+0x33/0x120
<4> [<c015369f>] wake_futex+0x3e/0x50
<4> [<c01538b8>] futex_wait+0x26f/0x3a0
<4> [<c015490c>] futex_wake+0x98/0x100
<4>do_futex+0x8c/0xb40
<4> [<c0155445>]  [<c0154c74>] sys_futex+0x85/0x100
<4>do_futex+0x3f4/0xb40
<4> [<c0155445>]  [<c010547e>] sysenter_past_esp+0x5f/0x99
<4>sys_futex+0x85/0x100
<4> [<c010547e>]  =======================
<4>sysenter_past_esp+0x5f/0x99
<4> =======================

============= Trace 4 ========================
<0>BUG: spinlock lockup on CPU#0, A_EngineNode/3044, f78c5004
<0>BUG: spinlock lockup on CPU#1, A_EngineNode/3001, c3e13400
<4>Pid: 3044, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4>Pid: 3001, comm: A_EngineNode Not tainted 2.6.24.7-rt20 #4
<4> [<c010657a>]  [<c010657a>] show_trace_log_lvl+0x1a/0x30
<4>show_trace_log_lvl+0x1a/0x30
<4> [<c0107012>]  [<c0107012>] show_trace+0x12/0x20
<4>show_trace+0x12/0x20
<4> [<c010782c>]  [<c010782c>] dump_stack+0x6c/0x80
<4>dump_stack+0x6c/0x80
<4> [<c04c2511>]  [<c04c2511>] _raw_spin_lock+0x141/0x180
<4>_raw_spin_lock+0x141/0x180
<4> [<c04c16da>]  [<c04c19cd>] __spin_lock+0x3d/0x50
<4>__spin_lock_irqsave+0x4a/0x60
<4> [<c01270bc>]  [<c016e5ea>] task_rq_lock+0x3c/0x70
<4>cpupri_set+0x4a/0xd0
<4> [<c0129f18>]  [<c01273ac>] try_to_wake_up+0x2c/0x110
<4>dequeue_task_rt+0xd8/0x1f0
<4> [<c0127509>]  [<c01247f5>] wake_up_process_mutex+0x19/0x20
<4> [<c0155c6c>] dequeue_task+0x15/0x30
<4> [<c0124878>] wakeup_next_waiter+0x11c/0x1c0
<4> [<c04bfdbc>] deactivate_task+0x28/0x40
<4>rt_spin_lock_slowunlock+0x4c/0x70
<4> [<c04c1122>]  [<c04bee0f>] rt_spin_unlock+0x52/0x60
<4>__schedule+0x2ff/0x780
<4> [<c04bf3d3>]  [<c01538cb>] schedule+0x33/0x120
<4> [<c04c0b7c>] futex_wake+0xab/0x100
<4> [<c0154c74>] rt_spin_lock_slowlock+0x13c/0x1f4
<4> [<c04c101a>] do_futex+0x3f4/0xb40
<4>__lock_text_start+0x2a/0x50
<4> [<c0155445>]  [<c04c10c2>] sys_futex+0x85/0x100
<4> [<c010547e>] rt_spin_lock+0x32/0x40
<4> [<c01533a8>] sysenter_past_esp+0x5f/0x99
<4> =======================
<4>unqueue_me+0x18/0xa0
<4> [<c01536da>] futex_wait+0x2aa/0x3a0
<4> [<c015490c>] do_futex+0x8c/0xb40
<4> [<c0155445>] sys_futex+0x85/0x100
<4> [<c010547e>] sysenter_past_esp+0x5f/0x99
<4> =======================
