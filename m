Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZEHN4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZEHN4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZEHNzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:55:53 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61052 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZEHNzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:55:52 -0400
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: ftrace 2.6.30-rc4: possible circular locking dependency
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200905082255.BGE18711.LJQVStFHOFOOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 8 May 2009 22:55:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this.

[    7.153662] Write protecting the kernel read-only data: 2172k
[    7.155593] Testing CPA: undo c0718000-c0937000
[    7.156809] Testing CPA: write protecting again
[    7.677561] 
[    7.677570] =======================================================
[    7.678536] [ INFO: possible circular locking dependency detected ]
[    7.678536] 2.6.30-rc4 #1
[    7.678536] -------------------------------------------------------
[    7.678536] insmod/571 is trying to acquire lock:
[    7.678536]  (ftrace_lock){+.+.+.}, at: [<c048e862>] ftrace_convert_nops+0x1f/0x1dc
[    7.678536] 
[    7.678536] but task is already holding lock:
[    7.678536]  (module_mutex){+.+.+.}, at: [<c0472637>] sys_init_module+0x3a/0x1ff
[    7.678536] 
[    7.678536] which lock already depends on the new lock.
[    7.678536] 
[    7.678536] 
[    7.678536] the existing dependency chain (in reverse order) is:
[    7.678536] 
[    7.678536] -> #1 (module_mutex){+.+.+.}:
[    7.678536]        [<c046762e>] __lock_acquire+0x931/0xad4
[    7.678536]        [<c0467861>] lock_acquire+0x90/0xad
[    7.678536]        [<c0710d46>] __mutex_lock_common+0x3a/0x4b6
[    7.678536]        [<c0711269>] mutex_lock_nested+0x33/0x3b
[    7.678536]        [<c0470709>] module_update_tracepoints+0x15/0x6d
[    7.678536]        [<c048bd7c>] tracepoint_update_probes+0x1c/0x1e
[    7.678536]        [<c048c186>] tracepoint_probe_register+0x50/0x5f
[    7.678536]        [<c048e6f1>] register_ftrace_graph+0x1ec/0x245
[    7.678536]        [<c0493763>] trace_selftest_startup_function_graph+0x23/0x9d
[    7.678536]        [<c0493e38>] register_tracer+0xf7/0x1fe
[    7.678536]        [<c0abb66d>] init_graph_trace+0xd/0xf
[    7.678536]        [<c040116a>] do_one_initcall+0x78/0x1d5
[    7.678536]        [<c0aa26de>] kernel_init+0x13b/0x1a9
[    7.678536]        [<c0403f9b>] kernel_thread_helper+0x7/0x10
[    7.678536]        [<ffffffff>] 0xffffffff
[    7.678536] 
[    7.678536] -> #0 (ftrace_lock){+.+.+.}:
[    7.678536]        [<c0467540>] __lock_acquire+0x843/0xad4
[    7.678536]        [<c0467861>] lock_acquire+0x90/0xad
[    7.678536]        [<c0710d46>] __mutex_lock_common+0x3a/0x4b6
[    7.678536]        [<c0711269>] mutex_lock_nested+0x33/0x3b
[    7.678536]        [<c048e862>] ftrace_convert_nops+0x1f/0x1dc
[    7.678536]        [<c048ea34>] ftrace_init_module+0x15/0x17
[    7.678536]        [<c0471cbc>] load_module+0x1122/0x17c1
[    7.678536]        [<c0472661>] sys_init_module+0x64/0x1ff
[    7.678536]        [<c0403575>] syscall_call+0x7/0xb
[    7.678536]        [<ffffffff>] 0xffffffff
[    7.678536] 
[    7.678536] other info that might help us debug this:
[    7.678536] 
[    7.678536] 1 lock held by insmod/571:
[    7.678536]  #0:  (module_mutex){+.+.+.}, at: [<c0472637>] sys_init_module+0x3a/0x1ff
[    7.678536] 
[    7.678536] stack backtrace:
[    7.678536] Pid: 571, comm: insmod Not tainted 2.6.30-rc4 #1
[    7.678536] Call Trace:
[    7.678536]  [<c0465d39>] print_circular_bug_tail+0x5d/0x68
[    7.678536]  [<c0467540>] __lock_acquire+0x843/0xad4
[    7.678536]  [<c0467861>] lock_acquire+0x90/0xad
[    7.678536]  [<c048e862>] ? ftrace_convert_nops+0x1f/0x1dc
[    7.678536]  [<c0710d46>] __mutex_lock_common+0x3a/0x4b6
[    7.678536]  [<c048e862>] ? ftrace_convert_nops+0x1f/0x1dc
[    7.678536]  [<c0403fc7>] ? ftrace_call+0x5/0x8
[    7.678536]  [<c0711269>] mutex_lock_nested+0x33/0x3b
[    7.678536]  [<c048e862>] ? ftrace_convert_nops+0x1f/0x1dc
[    7.678536]  [<c048e862>] ftrace_convert_nops+0x1f/0x1dc
[    7.678536]  [<c048ea34>] ftrace_init_module+0x15/0x17
[    7.678536]  [<c0471cbc>] load_module+0x1122/0x17c1
[    7.678536]  [<c0464125>] ? debug_mutex_free_waiter+0x25/0x81
[    7.678536]  [<c0472661>] sys_init_module+0x64/0x1ff
[    7.678536]  [<c0403575>] syscall_call+0x7/0xb
[    7.807546] insmod used greatest stack depth: 2328 bytes left
[    7.912357] Fusion MPT base driver 3.04.07

Environment is CentOS 5.3(i686) on VMware.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc4
Full message is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc4.txt

Regards.
