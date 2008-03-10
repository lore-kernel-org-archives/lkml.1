Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYCJRTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYCJRTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYCJRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:18:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYCJRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PV9Ciu9wmR9kb5vDMDkuVvJoH4IyeAMwPPOTXoM5P0KSwDEwDXKI0t+W2XcbATb7kwY/aGQQ5wBuKK4a/h1CBv1NNl01vQUE+nZKV2PArNLbQ7hoe5dMH64X7E4/qYbpJpmge++RnijpltksPH15OADGuW2F9NJMMsV2E2TVrnc=
Message-ID: <47D56D72.7000304@gmail.com>
Date: Mon, 10 Mar 2008 18:18:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc4 todays: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000138
References: <c4e36d110803100928o34e8cfa6o3087631f88762b7a@mail.gmail.com>
In-Reply-To: <c4e36d110803100928o34e8cfa6o3087631f88762b7a@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2008 05:28 PM, Zdenek Kabelac wrote:
> Hello
> 
> While trying to my other problem:
> http://thread.gmane.org/gmane.comp.emulators.kvm.devel/14023/focus=14330
> (previously mentioned even here but left unnoticed
> http://lkml.org/lkml/2008/2/23/130)

You should CC proper people to being noticed.

> I've got new oops today inside my qemu:
> (please check my comment about tainted bellow)
> 
> [   66.252118] p: module license 'unspecified' taints kernel.
> 
> [ 1935.986421] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000138
> 
> [ 1935.986421] IP: [<ffffffff8102e847>] pick_next_task_fair+0x37/0x60
> 
> [ 1935.986421] PGD 0
> 
> [ 1935.986421] Oops: 0000 [1] PREEMPT SMP
> 
> [ 1935.986421] CPU 1
> 
> [ 1935.986421] Modules linked in: p(P) nfs lockd nfs_acl sunrpc
> autofs4 dm_mod loop psmouse serio_raw pcnet32 i2c_piix4 rtc mii
> i2c_core button evdev [last unloaded: p]
> 
> [ 1935.986421] Pid: 0, comm: swapper Tainted: P
> 2.6.25-rc4-replic-server #5
> 
> [ 1935.986421] RIP: 0010:[<ffffffff8102e847>]  [<ffffffff8102e847>]
> pick_next_task_fair+0x37/0x60

Ingo Cced. Seems like pick_next_entity returns NULL.

> [ 1935.986421] RSP: 0000:ffff81001788bdd8  EFLAGS: 00010046
> 
> [ 1935.986421] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> 
> [ 1935.986421] RDX: ffff81001788c000 RSI: ffff81001788c000 RDI: ffff810001b4bb10
> 
> [ 1935.986421] RBP: ffff81001788bde8 R08: 0000000000000002 R09: 0000000000000000
> 
> [ 1935.986421] R10: 0000000000000001 R11: 0000000000000000 R12: ffff810001b4ba80
> 
> [ 1935.986421] R13: ffffffff8100b640 R14: ffff810001b4b9c0 R15: 0000000000000001
> 
> [ 1935.986421] FS:  0000000000000000(0000) GS:ffff81001780f500(0000)
> knlGS:0000000000000000
> 
> [ 1935.986421] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> 
> [ 1935.986421] CR2: 0000000000000138 CR3: 0000000001001000 CR4: 00000000000006e0
> 
> [ 1935.986421] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 
> [ 1935.986421] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> [ 1935.986421] Process swapper (pid: 0, threadinfo ffff81001788a000,
> task ffff81001788c000)
> 
> [ 1935.986421] Stack:  ffff810001b4ba80 ffffffff8130af60
> ffff81001788bea8 ffffffff812ed1dc
> 
> [ 1935.986421]  ffff81001788be38 ffff810001b4ba80 ffff81001788be38
> 0000000000000001
> 
> [ 1935.986421]  ffff81001788c000 0000000000000000 ffff81001788c360
> 00000001003a0ceb
> 
> [ 1935.986421] Call Trace:
> 
> [ 1935.986421]  [<ffffffff812ed1dc>] schedule+0x1dc/0x445
> 
> [ 1935.986421]  [<ffffffff8108683e>] ? touch_softlockup_watchdog+0x2e/0x50
> 
> [ 1935.986421]  [<ffffffff8103a1e3>] ? sched_clock_idle_wakeup_event+0x63/0x80
> 
> [ 1935.986421]  [<ffffffff8100b640>] ? default_idle+0x0/0x90
> 
> [ 1935.986421]  [<ffffffff8100b640>] ? default_idle+0x0/0x90
> 
> [ 1935.986421]  [<ffffffff8100b640>] ? default_idle+0x0/0x90
> 
> [ 1935.986421]  [<ffffffff8100b5ea>] cpu_idle+0xfa/0x150
> 
> [ 1935.986422]  [<ffffffff812e9f41>] start_secondary+0x405/0x464
> 
> [ 1935.986422]
> 
> [ 1935.986422]
> 
> [ 1935.986422] Code: 48 83 bf a0 00 00 00 00 74 3c 48 8d bf 90 00 00
> 00 0f 1f 00 48 8b 47 30 31 db 48 85 c0 74 0c 48 8d 58 f0 48 89 de e8
> 89 f7 ff ff <48> 8b bb 38 01 00 00 48 85 ff 75 dd 48 83 eb 38 4c 89 e7
> 48 89
> 
> [ 1935.986422] RIP  [<ffffffff8102e847>] pick_next_task_fair+0x37/0x60
> 
> [ 1935.986422]  RSP <ffff81001788bdd8>
> 
> [ 1935.986422] CR2: 0000000000000138
> 
> [ 1935.986422] BUG: spinlock lockup on CPU#1, swapper/0, ffff810001ae1a80
> 
> [ 1908.319004] BUG: spinlock lockup on CPU#0, bash/25859, ffff810001b4ba80
> 
> [ 1935.986422] BUG: spinlock lockup on CPU#1, swapper/0, ffffffff814502c0
> 
> [ 1908.319004] BUG: spinlock lockup on CPU#0, bash/25859, ffffffff814502c0
> 
> [ 1935.986422] BUG: spinlock lockup on CPU#1, swapper/0, ffffffff814502c0
> 
> [ 1908.319004] BUG: spinlock lockup on CPU#0, bash/25859, ffffffff814502c0
> 
> 
> 
> Before I'll be said to redone the report without tained kernel here is
> the source code for my test p module (of course I could add there GPL
> :) but what would be the point)
> 
> ---- p module ----
> #include <linux/module.h>
> #include <linux/vmalloc.h>
> 
> static int __init p_init(void)
> {
>     const int size = 16*1024;
>     char* b = vmalloc(size);
>     if (b) {
> 	int i;
> 
> 	for (i = 0; i < size; i++)
> 	    b[i] = 0;
> 
> 	vfree(b);
>     }
>     //WARN_ON(1);
>     //printk(KERN_WARNING "done\n");
>     return 0;
> }
> 
> static void __exit p_exit(void)
> {
> }
> 
> module_init(p_init);
> module_exit(p_exit);
> 
> ------------
> 
> As could be seen, nothing really special is here -
> 
> And how did I get the oops -
> 
> I've started two endless loops in bash:
> 
> while : ; do cat /dev/mapper/my_8GB_test_partition >/dev/null ; done
> while : ; do insmod p.ko  ; rmmod p ; done
> 
> this showed two things -  it get occasionaly busy looped in the for() loop

How did you find this out?

> (part of my problem I'm trying to be checked on the kvm list)
> secondly after some time - I've got this OOPS.
> 
> Attaching my config file.
> 
> Zdenek
> 
> PS: Also anyone could explain me why 'udevd'  gets mad and eats a lot
> of CPU while my insmod rmmod loop is running - I do not create any
> device - and udevd is getting quite crazy about this...

udevmonitor helps here. There are few events emitted for each module insertion 
and removal.

> PPS: in case anyone would be interested - I'm getting two call traces
> in my module busy loop pressing MagicSysrq +  'p'
> 
> [ 3475.339198] Call Trace:
> [ 3475.339198]  [<ffffffff880fe00e>] ? :p:p_init+0xe/0x37
> [ 3475.339198]  [<ffffffff8106ecce>] ? sys_init_module+0x14e/0x1e10
> [ 3475.339198]  [<ffffffff810a9300>] ? vmalloc+0x0/0x20
> [ 3475.339198]  [<ffffffff812f0041>] ? trace_hardirqs_on_thunk+0x35/0x3a
> [ 3475.339198]  [<ffffffff81029eb2>] ? sysenter_do_call+0x1b/0x70
> 
> [ 3625.967771] Call Trace:
> [ 3625.967771]  <IRQ>  [<ffffffff8100dc4c>] ? call_softirq+0x1c/0x30
> [ 3625.967771]  [<ffffffff8100f425>] ? do_softirq+0x95/0xd0
> [ 3625.967771]  [<ffffffff810439e5>] ? irq_exit+0xa5/0xb0
> [ 3625.967771]  [<ffffffff81021950>] ? smp_apic_timer_interrupt+0x90/0xe0
> [ 3625.967771]  [<ffffffff8100b640>] ? default_idle+0x0/0x90
> [ 3625.967771]  [<ffffffff8100d647>] ? apic_timer_interrupt+0x77/0x80
> [ 3625.967771]  <EOI>  [<ffffffff810253e6>] ? native_safe_halt+0x6/0x10
> [ 3625.967771]  [<ffffffff8100b68d>] ? default_idle+0x4d/0x90
> [ 3625.967771]  [<ffffffff8100b640>] ? default_idle+0x0/0x90
> [ 3625.967771]  [<ffffffff8100b563>] ? cpu_idle+0x73/0x150
> [ 3625.967771]  [<ffffffff812deb49>] ? rest_init+0x69/0x70

This trace is from other processor, I guess (keyboard irq was handled by the 
other one).
