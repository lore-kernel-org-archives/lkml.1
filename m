Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZKCQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZKCQCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZKCQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:02:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33533 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZKCQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:02:46 -0500
Subject: Re: [-next regression] lockdep? tracing? BUG: unable to handle
 kernel paging request at
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       zhaolei@cn.fujitsu.com, mingo@elte.hu, lizf@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257263296.2891.97.camel@dhcp231-106.rdu.redhat.com>
References: <1257263296.2891.97.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 11:02:50 -0500
Message-Id: <1257264170.26028.3340.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter Zijlstra ]

On Tue, 2009-11-03 at 10:48 -0500, Eric Paris wrote:
> Linux-next from Oct 30 did not have this problem.  Linux next from
> yesterday (and today) I always hit this on boot.

Could you also give the SHA1 of Linux-next, as well as the config you
used.

> 
> [    7.989630] BUG: unable to handle kernel paging request at 00000000000160de
> [    7.990538] IP: [<ffffffff8123cdbf>] strcmp+0xf/0x30
> [    7.990538] PGD 77f7e067 PUD 77ff1067 PMD 0 
> [    7.990538] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    7.990538] last sysfs file: /sys/devices/platform/i8042/serio0/input/input2/event2/uevent
> [    7.990538] CPU 0 
> [    7.990538] Modules linked in: ata_piix(+)
> [    7.990538] Pid: 1024, comm: modprobe Not tainted 2.6.32-rc5-fanotify-next-20091102 #150 

Just curious, what module were you loading?

> [    7.990538] RIP: 0010:[<ffffffff8123cdbf>]  [<ffffffff8123cdbf>] strcmp+0xf/0x30
> [    7.990538] RSP: 0018:ffff8800774d5c78  EFLAGS: 00010086
> [    7.990538] RAX: 0000000000000026 RBX: ffffffff820fbe60 RCX: 00000000000001cc
> [    7.990538] RDX: 0000000000000026 RSI: 00000000000160de RDI: ffffffff81790728
> [    7.990538] RBP: ffff8800774d5c78 R08: 0000000000000000 R09: ffffffff820fbe70
> [    7.990538] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff820c4320
> [    7.990538] R13: ffffffff820c4520 R14: ffffffff824b11c0 R15: ffffffff81a63570
> [    7.990538] FS:  00007f043db3a700(0000) GS:ffff880006200000(0000) knlGS:0000000000000000
> [    7.990538] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    7.990538] CR2: 00000000000160de CR3: 0000000077519000 CR4: 00000000000006f0
> [    7.990538] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    7.990538] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    7.990538] Process modprobe (pid: 1024, threadinfo ffff8800774d4000, task ffff88007769a440)
> [    7.990538] Stack:
> [    7.990538]  ffff8800774d5cd8 ffffffff8108f9c7 ffff8800774d5ce8 ffffffff820fbe70
> [    7.990538] <0> ffff880000000000 0000000000000000 0000000000000002 0000000000000000
> [    7.990538] <0> 0000000000000002 ffff88007769a440 0000000000000002 ffffffff81a63570
> [    7.990538] Call Trace:
> [    7.990538]  [<ffffffff8108f9c7>] register_lock_class+0x237/0x5b0
> [    7.990538]  [<ffffffff810941c6>] __lock_acquire+0x76/0x6a0
> [    7.990538]  [<ffffffff810948a1>] lock_acquire+0xb1/0x150
> [    7.990538]  [<ffffffff810d9d25>] ? trace_module_notify+0x25/0x360
> [    7.990538]  [<ffffffff814a29d8>] __mutex_lock_common+0x58/0x510
> [    7.990538]  [<ffffffff810d9d25>] ? trace_module_notify+0x25/0x360
> [    7.990538]  [<ffffffff81081035>] ? sched_clock_local+0x15/0x80
> [    7.990538]  [<ffffffff8108115b>] ? sched_clock_cpu+0xbb/0x100
> [    7.990538]  [<ffffffff810d9d25>] ? trace_module_notify+0x25/0x360
> [    7.990538]  [<ffffffff814a2f6c>] mutex_lock_nested+0x3c/0x50
> [    7.990538]  [<ffffffff810d9d25>] trace_module_notify+0x25/0x360
> [    7.990538]  [<ffffffff810804d8>] ? __blocking_notifier_call_chain+0x48/0x90
> [    7.990538]  [<ffffffff814a8725>] notifier_call_chain+0x45/0x80
> [    7.990538]  [<ffffffff810804ee>] __blocking_notifier_call_chain+0x5e/0x90
> [    7.990538]  [<ffffffff81080531>] blocking_notifier_call_chain+0x11/0x20
> [    7.990538]  [<ffffffff810a2e01>] sys_init_module+0xb1/0x270
> [    7.990538]  [<ffffffff8100af02>] system_call_fastpath+0x16/0x1b
> [    7.990538] Code: 83 c6 01 84 c0 88 01 74 0d 48 83 c1 01 48 83 ea 01 75 e9 c6 01 00 c9 48 89 f8 c3 90 55 48 89 e5 eb 04 48 83 c7 01 0f b6 17 89 d0 <2a> 06 48 83 c6 01 84 c0 75 04 84 d2 75 e9 c9 0f be c0 c3 0f 1f 
> [    7.990538] RIP  [<ffffffff8123cdbf>] strcmp+0xf/0x30
> [    7.990538]  RSP <ffff8800774d5c78>
> [    7.990538] CR2: 00000000000160de
> [    7.990538] ---[ end trace c7a840a812150e3c ]---
> [    7.990538] note: modprobe[1024] exited with preempt_count 1
> [    8.270817] modprobe used greatest stack depth: 4376 bytes left
> udevd-work[919]: '/sbin/modprobe -b pci:v00008086d00007010sv00001AF4sd00001100bc01sc01i80' unexpected exit with status 0x0009
> 
> udevd-work[919]: '/sbin/modprobe -b pci:v00008086d00007010sv00001AF4sd00001100bc01sc01i80' unexpected exit with status 0x0009
> 
> 
> So it looks to me like we are locking the event_mutex (?for the first
> time?) in trace_module_load.  Eventually we get to __lock_acquire which
> calls register_lock_class() which gets into count_matching_names() which
> starts calling strcmp on lock_class->names.

Hmm, event_mutex is defined with

DEFINE_MUTEX(event_mutex);

in trace_events.c (well, in my kernel, I'm not looking at linux-next
right now). This should set up lockdep without any issues.

> 
> static int count_matching_names(struct lock_class *new_class)
> {
> [snip]
>                 if (class->name && !strcmp(class->name, new_class->name))
>                         count = max(count, class->name_version);
> 
> So, strcmp from lib/string.c
> 
> int strcmp(const char *cs, const char *ct)
> {
>         signed char __res;
> 
>         while (1) {
>                 if ((__res = *cs - *ct++) != 0 || !*cs++)
>                         break;
>         }
>         return __res;
> }
> 
> And it's assembly:
> ffffffff8123cdb0 <strcmp>:
> ffffffff8123cdb0:       55                      push   %rbp
> ffffffff8123cdb1:       48 89 e5                mov    %rsp,%rbp
> ffffffff8123cdb4:       eb 04                   jmp    ffffffff8123cdba <strcmp+0xa>
> ffffffff8123cdb6:       48 83 c7 01             add    $0x1,%rdi
> ffffffff8123cdba:       0f b6 17                movzbl (%rdi),%edx
> ffffffff8123cdbd:       89 d0                   mov    %edx,%eax
> ffffffff8123cdbf:       2a 06                   sub    (%rsi),%al
> ffffffff8123cdc1:       48 83 c6 01             add    $0x1,%rsi
> ffffffff8123cdc5:       84 c0                   test   %al,%al
> ffffffff8123cdc7:       75 04                   jne    ffffffff8123cdcd <strcmp+0x1d>
> ffffffff8123cdc9:       84 d2                   test   %dl,%dl
> ffffffff8123cdcb:       75 e9                   jne    ffffffff8123cdb6 <strcmp+0x6>
> ffffffff8123cdcd:       c9                      leaveq
> ffffffff8123cdce:       0f be c0                movsbl %al,%eax
> ffffffff8123cdd1:       c3                      retq
> ffffffff8123cdd2:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> ffffffff8123cdd9:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> 
> Looks to me like %rdi is the first argument to strcmp (cs) and %rsi is
> the second argument (ct).  %rsi has the crap value.  This means that
> new_class->name was != NULL, but wasn't valid.  So it's something to do
> with the event_lock....
> 
> I'm sure someone who knows this code better than I can explain how that
> gets messed up.....

Would be better to get more info (as asked above). You can send
the .config privately to me, as not to spam LKML with it.

Thanks,

-- Steve


