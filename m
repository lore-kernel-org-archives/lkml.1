Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0CBRvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:51:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52069 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0CBRvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GhqBHdH7ALwQTcA5Ilreo9HCJx+0p3he3nSTiuTnBp6inrFMlTnpoqyMDtbLHHd446
         U5LM1bIn7Cge7Ng7mDd9DAm8p0mQQwU9jx++WB6y3PhVv1FGEk+/+sddYeLHO9g+bMSH
         swSoEVRWgDKCOyYgMtAQ1m6UQjXdK30PT3QeA=
MIME-Version: 1.0
In-Reply-To: <1267547013.4b8d3b8596461@imp.free.fr>
References: <1267547013.4b8d3b8596461@imp.free.fr>
Date: Tue, 2 Mar 2010 12:51:05 -0500
Message-ID: <817ecb6f1003020951v2926c819q7bd322c40a74b4bd@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: castet.matthieu@free.fr
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> At this point I need some help and guidance on how to track down what
>> exactly happens there, as I am not very familiar with what goes into
>> .data and why are we trying to execute it.
> Can't you add debug printk in the fault handler before any exception processing
>
> Something like that.

That does not really give any additional information. The message does
not show up in the output and the stack trace says that we are somehow
ended up in doublefault_fn.

any other ideas?

I really appreciate your help.
===========
...
[   17.652000] BUG: unable to handle kernel NULL pointer dereference at 00000014
[   17.652000] IP: [<c102e722>] vprintk+0x12/0x398
[   17.652000] *pdpt = 00000000018e7001 *pde = 0000000000000000
[   17.652000] Oops: 0000 [#1] SMP
[   17.652000] last sysfs file:
[   17.652000] Modules linked in:
[   17.652000]
[   17.652000] Pid: 314, comm: rcu_torture_rea Not tainted 2.6.33-tip+ #15 /
[   17.652000] EIP: 0060:[<c102e722>] EFLAGS: 00004082 CPU: 0
[   17.652000] EIP is at vprintk+0x12/0x398
[   17.652000] EAX: c171dc07 EBX: c2802000 ECX: 00000000 EDX: 00000000
[   17.652000] ESI: c18f1b90 EDI: 00000000 EBP: c18f1b74 ESP: c18f1b10
[   17.652000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   17.652000] Process rcu_torture_rea (pid: 314, ti=c18f1000
task=f797c000 task.ti=f791a000)
[   17.652000] Stack:
[   17.652000]  00000000 00000000 c171dc07 00000000 00000000 00000000
00000000 00000000
[   17.652000] <0> 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   17.652000] <0> 00000000 00000000 00000000 00000000 00000000
00000000 c2802000 00000000
[   17.652000] Call Trace:
[   17.652000]  [<c15babb1>] ? printk+0xf/0x16
[   17.652000]  [<c101458b>] ? doublefault_fn+0x2b/0xd8
[   17.652000] Code: 76 80 c1 e8 4e 8d 01 00 c7 05 f0 34 8f c1 00 00
00 00 e8 66 fc ff ff 5d c3 55 89 e5 57 56 53 83 ec 58 8b 45 08 89 45
a4 8b 75 0c <65> 8b 15 14 00 00 00 89 55 f0 31 d2 a1 a0 75 80 c1 89 45
a8 8b
[   17.652000] EIP: [<c102e722>] vprintk+0x12/0x398 SS:ESP 0068:c18f1b10
[   17.652000] CR2: 0000000000000014
[   17.652000] ---[ end trace 6164e4a9acb59023 ]---
[   17.656000] BUG: spinlock lockup on CPU#0, rcu_torture_rea/314, c2809800
[   17.656000] Pid: 314, comm: rcu_torture_rea Tainted: G      D
2.6.33-tip+ #15
[   17.656000] Call Trace:
[   17.656000]  [<c15babb1>] ? printk+0xf/0x16
[   17.656000]  [<c12758a5>] do_raw_spin_lock+0xfb/0x126
[   17.656000]  [<c15bd2d3>] _raw_spin_lock+0x22/0x2a
[   17.656000]  [<c102b5c2>] ? scheduler_tick+0x33/0x233
[   17.656000]  [<c102b5c2>] scheduler_tick+0x33/0x233
[   17.656000]  [<c1032e17>] ? raise_softirq+0x43/0x50
[   17.656000]  [<c1039a5b>] update_process_times+0x3c/0x48
[   17.656000]  [<c104e92f>] tick_periodic+0x66/0x72
[   17.656000]  [<c104e954>] tick_handle_periodic+0x19/0x71
[   17.656000]  [<c1010c19>] smp_apic_timer_interrupt+0x6a/0x7d
[   17.656000]  [<c15bdee6>] apic_timer_interrupt+0x36/0x40
[   17.656000]  [<c1060331>] ? acct_collect+0x12e/0x134
[   17.656000]  [<c15bd72e>] ? _raw_spin_unlock_irq+0x22/0x26
[   17.656000]  [<c15bd730>] ? _raw_spin_unlock_irq+0x24/0x26
[   17.656000]  [<c1060331>] acct_collect+0x12e/0x134
[   17.656000]  [<c1031000>] do_exit+0x187/0x625
[   17.656000]  [<c102eba7>] ? kmsg_dump+0xff/0x113
[   17.656000]  [<c102ddf5>] ? oops_exit+0x2a/0x2f
[   17.656000]  [<c15beaaa>] oops_end+0x92/0x9a
[   17.656000]  [<c1016c90>] no_context+0x15f/0x169
[   17.656000]  [<c1016dec>] __bad_area_nosemaphore+0x152/0x15a
[   17.656000]  [<c1016e01>] bad_area_nosemaphore+0xd/0x10
[   17.656000]  [<c15c053d>] do_page_fault+0x199/0x30a
[   17.656000]  [<c15c03a4>] ? do_page_fault+0x0/0x30a
[   17.656000]  [<c15be108>] error_code+0x78/0x80
[   17.656000]  [<c102e722>] ? vprintk+0x12/0x398
[   17.656000]  [<c15babb1>] printk+0xf/0x16
[   17.656000]  [<c101458b>] doublefault_fn+0x2b/0xd8
[   17.656000] sending NMI to all CPUs:
[   17.656000] NMI backtrace for cpu 0
[   17.656000] Modules linked in:
[   17.656000]
[   17.656000] Pid: 314, comm: rcu_torture_rea Tainted: G      D
2.6.33-tip+ #15 /
[   17.656000] EIP: 0060:[<c10112b6>] EFLAGS: 00000046 CPU: 0
[   17.656000] EIP is at default_send_IPI_mask_logical+0xc3/0xdb
[   17.656000] EAX: ffffb300 EBX: 01000000 ECX: c1011239 EDX: 00000c00
[   17.656000] ESI: 00000002 EDI: 00000002 EBP: c18f1848 ESP: c18f1838
[   17.656000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   17.656000] Process rcu_torture_rea (pid: 314, ti=c18f1000
task=f797c000 task.ti=f791a000)
[   17.656000] Stack:
[   17.656000]  00000800 08453000 00000000 c2809800 c18f1854 c101106a
08453000 c18f1864
[   17.656000] <0> c1011739 c171c7e2 08453000 c18f189c c12758aa
c175c91e 00000000 f797c318
[   17.656000] <0> 0000013a c2809800 f797c318 f797c000 08453000
00000001 c2809800 c2809800
[   17.656000] Call Trace:
[   17.656000]  [<c101106a>] ? default_send_IPI_all+0x22/0x62
[   17.656000]  [<c1011739>] ? arch_trigger_all_cpu_backtrace+0x2b/0x4f
[   17.656000]  [<c12758aa>] ? do_raw_spin_lock+0x100/0x126
[   17.656000]  [<c15bd2d3>] ? _raw_spin_lock+0x22/0x2a
[   17.656000]  [<c102b5c2>] ? scheduler_tick+0x33/0x233
[   17.656000]  [<c102b5c2>] ? scheduler_tick+0x33/0x233
[   17.656000]  [<c1032e17>] ? raise_softirq+0x43/0x50
[   17.656000]  [<c1039a5b>] ? update_process_times+0x3c/0x48
[   17.656000]  [<c104e92f>] ? tick_periodic+0x66/0x72
[   17.656000]  [<c104e954>] ? tick_handle_periodic+0x19/0x71
[   17.656000]  [<c1010c19>] ? smp_apic_timer_interrupt+0x6a/0x7d
[   17.656000]  [<c15bdee6>] ? apic_timer_interrupt+0x36/0x40
[   17.656000]  [<c1060331>] ? acct_collect+0x12e/0x134
[   17.656000]  [<c15bd72e>] ? _raw_spin_unlock_irq+0x22/0x26
[   17.656000]  [<c15bd730>] ? _raw_spin_unlock_irq+0x24/0x26
[   17.656000]  [<c1060331>] ? acct_collect+0x12e/0x134
[   17.656000]  [<c1031000>] ? do_exit+0x187/0x625
[   17.656000]  [<c102eba7>] ? kmsg_dump+0xff/0x113
[   17.656000]  [<c102ddf5>] ? oops_exit+0x2a/0x2f
[   17.656000]  [<c15beaaa>] ? oops_end+0x92/0x9a
[   17.656000]  [<c1016c90>] ? no_context+0x15f/0x169
[   17.656000]  [<c1016dec>] ? __bad_area_nosemaphore+0x152/0x15a
[   17.656000]  [<c1016e01>] ? bad_area_nosemaphore+0xd/0x10
[   17.656000]  [<c15c053d>] ? do_page_fault+0x199/0x30a
[   17.656000]  [<c15c03a4>] ? do_page_fault+0x0/0x30a
[   17.656000]  [<c15be108>] ? error_code+0x78/0x80
[   17.656000]  [<c102e722>] ? vprintk+0x12/0x398
[   17.656000]  [<c15babb1>] ? printk+0xf/0x16
[   17.656000]  [<c101458b>] ? doublefault_fn+0x2b/0xd8
[   17.656000] Code: 00 89 da 89 10 83 fe 02 74 07 8b 55 f0 09 f2 eb
06 8b 55 f0 80 ce 04 a1 2c 6c 80 c1 2d 00 3d 00 00 89 10 f7 c7 00 02
00 00 75 09 <57> 9d e8 0c 0c 04 00 eb 07 e8 9e 1a 04 00 57 9d 8d 65 f4
5b 5e
[   17.656000] Call Trace:
[   17.656000]  [<c101106a>] default_send_IPI_all+0x22/0x62
[   17.656000]  [<c1011739>] arch_trigger_all_cpu_backtrace+0x2b/0x4f
[   17.656000]  [<c12758aa>] do_raw_spin_lock+0x100/0x126
[   17.656000]  [<c15bd2d3>] _raw_spin_lock+0x22/0x2a
[   17.656000]  [<c102b5c2>] ? scheduler_tick+0x33/0x233
[   17.656000]  [<c102b5c2>] scheduler_tick+0x33/0x233
[   17.656000]  [<c1032e17>] ? raise_softirq+0x43/0x50
[   17.656000]  [<c1039a5b>] update_process_times+0x3c/0x48
[   17.656000]  [<c104e92f>] tick_periodic+0x66/0x72
[   17.656000]  [<c104e954>] tick_handle_periodic+0x19/0x71
[   17.656000]  [<c1010c19>] smp_apic_timer_interrupt+0x6a/0x7d
[   17.656000]  [<c15bdee6>] apic_timer_interrupt+0x36/0x40
[   17.656000]  [<c1060331>] ? acct_collect+0x12e/0x134
[   17.656000]  [<c15bd72e>] ? _raw_spin_unlock_irq+0x22/0x26
[   17.656000]  [<c15bd730>] ? _raw_spin_unlock_irq+0x24/0x26
[   17.656000]  [<c1060331>] acct_collect+0x12e/0x134
[   17.656000]  [<c1031000>] do_exit+0x187/0x625
[   17.656000]  [<c102eba7>] ? kmsg_dump+0xff/0x113
[   17.656000]  [<c102ddf5>] ? oops_exit+0x2a/0x2f
[   17.656000]  [<c15beaaa>] oops_end+0x92/0x9a
[   17.656000]  [<c1016c90>] no_context+0x15f/0x169
[   17.656000]  [<c1016dec>] __bad_area_nosemaphore+0x152/0x15a
[   17.656000]  [<c1016e01>] bad_area_nosemaphore+0xd/0x10
[   17.656000]  [<c15c053d>] do_page_fault+0x199/0x30a
[   17.656000]  [<c15c03a4>] ? do_page_fault+0x0/0x30a
[   17.656000]  [<c15be108>] error_code+0x78/0x80
[   17.656000]  [<c102e722>] ? vprintk+0x12/0x398
[   17.656000]  [<c15babb1>] printk+0xf/0x16
[   17.656000]  [<c101458b>] doublefault_fn+0x2b/0xd8
[   17.656000] Pid: 314, comm: rcu_torture_rea Tainted: G      D
2.6.33-tip+ #15
[   17.656000] Call Trace:
[   17.656000]  [<c10076eb>] ? show_regs+0x1a/0x20
[   17.656000]  [<c15bf177>] nmi_watchdog_tick+0xa3/0x181
[   17.656000]  [<c15be62c>] do_nmi+0xc6/0x2d1
[   17.656000]  [<c15be1d0>] nmi_stack_correct+0x2f/0x34
[   17.656000]  [<c1011239>] ? default_send_IPI_mask_logical+0x46/0xdb
[   17.656000]  [<c10112b6>] ? default_send_IPI_mask_logical+0xc3/0xdb
[   17.656000]  [<c101106a>] default_send_IPI_all+0x22/0x62
[   17.656000]  [<c1011739>] arch_trigger_all_cpu_backtrace+0x2b/0x4f
[   17.656000]  [<c12758aa>] do_raw_spin_lock+0x100/0x126
[   17.656000]  [<c15bd2d3>] _raw_spin_lock+0x22/0x2a
[   17.656000]  [<c102b5c2>] ? scheduler_tick+0x33/0x233
[   17.656000]  [<c102b5c2>] scheduler_tick+0x33/0x233
[   17.656000]  [<c1032e17>] ? raise_softirq+0x43/0x50
[   17.656000]  [<c1039a5b>] update_process_times+0x3c/0x48
[   17.656000]  [<c104e92f>] tick_periodic+0x66/0x72
[   17.656000]  [<c104e954>] tick_handle_periodic+0x19/0x71
[   17.656000]  [<c1010c19>] smp_apic_timer_interrupt+0x6a/0x7d
[   17.656000]  [<c15bdee6>] apic_timer_interrupt+0x36/0x40
[   17.656000]  [<c1060331>] ? acct_collect+0x12e/0x134
[   17.656000]  [<c15bd72e>] ? _raw_spin_unlock_irq+0x22/0x26
[   17.656000]  [<c15bd730>] ? _raw_spin_unlock_irq+0x24/0x26
[   17.656000]  [<c1060331>] acct_collect+0x12e/0x134
[   17.656000]  [<c1031000>] do_exit+0x187/0x625
[   17.656000]  [<c102eba7>] ? kmsg_dump+0xff/0x113
[   17.656000]  [<c102ddf5>] ? oops_exit+0x2a/0x2f
[   17.656000]  [<c15beaaa>] oops_end+0x92/0x9a
[   17.656000]  [<c1016c90>] no_context+0x15f/0x169
[   17.656000]  [<c1016dec>] __bad_area_nosemaphore+0x152/0x15a
[   17.656000]  [<c1016e01>] bad_area_nosemaphore+0xd/0x10
[   17.656000]  [<c15c053d>] do_page_fault+0x199/0x30a
[   17.656000]  [<c15c03a4>] ? do_page_fault+0x0/0x30a
[   17.656000]  [<c15be108>] error_code+0x78/0x80
[   17.656000]  [<c102e722>] ? vprintk+0x12/0x398
[   17.656000]  [<c15babb1>] printk+0xf/0x16
[   17.656000]  [<c101458b>] doublefault_fn+0x2b/0xd8
