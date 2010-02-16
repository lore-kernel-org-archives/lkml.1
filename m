Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0BPQYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:24:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0BPQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:24:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=MoMkPeoT_ukA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=4AG6nlf5fu4lirvqlWcA:9 a=5U9HVCd0LhpTx1vDGrcA:7 a=TYWSM4zEiKAH6lXfFssboK0NPnoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: LTTng0.158 Linux-2629-RT kernel BUG: sleeping function called
 from  invalid context at kernel/rtmutex.c:685
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 16 Feb 2010 11:24:10 -0500
Message-ID: <1266337450.24271.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 20:47 +0530, naresh kamboju wrote:
> Hi,
> 
> After applying LTTng 0.158 patches on 2.6.29-RT with SMP and NON-SMP
> found BUG on ARM target.
> LTTng 0.158 patches with 2.6.29 is working fine.
> 
> Linux kernel: 2.6.29-RT
> RT patches: patch-2.6.29.6-rt24-broken-out.tar.bz2
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.6-rt24-broken-out.tar.bz2
> 
> LTTng 0.158 patches are applied.
> ARCH: ARM
> Glibc: 2.9
> gcc: 4.3.3

Do you get this without the LTTng patches applied?

> 
> dmesg
> {{{
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:685
> in_atomic(): 1, irqs_disabled(): 128, pid: 720, name: lttd
> Backtrace:
> [<c002d434>] (dump_backtrace+0x0/0x10c) from [<c03a75d8>] (dump_stack+0x18/0x1c)
>  r7:000002ad r6:c045da78 r5:00001116 r4:c04ba400
> [<c03a75c0>] (dump_stack+0x0/0x1c) from [<c0041028>] (__might_sleep+0x120/0x14c)
> [<c0040f08>] (__might_sleep+0x0/0x14c) from [<c03a9b18>]
> (rt_spin_lock+0x38/0x68)
>  r7:ce319d04 r6:c0763660 r5:c05107a0 r4:c05107a0
> [<c03a9ae0>] (rt_spin_lock+0x0/0x68) from [<c00570b0>]
> (lock_timer_base+0x30/0x54)
>  r4:c05107a0
> [<c0057080>] (lock_timer_base+0x0/0x54) from [<c00571b4>] (del_timer+0x2c/0x6c)
>  r8:c0023570 r7:ce319d38 r6:00740000 r5:ceb19ca4 r4:c0763660
> [<c0057188>] (del_timer+0x0/0x6c) from [<c008e5ec>]
> (disable_synthetic_tsc_ipi+0x24/0x30)
>  r5:ceb19ca4 r4:00000001
> [<c008e5c8>] (disable_synthetic_tsc_ipi+0x0/0x30) from [<c0072e00>]
> (generic_smp_call_function_single_interrupt+0x98/0xf4)
> [<c0072d68>] (generic_smp_call_function_single_interrupt+0x0/0xf4)
> from [<c0028368>] (do_IPI+0xc8/0x15c)
> [<c00282a0>] (do_IPI+0x0/0x15c) from [<c00280c4>] (_text+0xc4/0x128)
> Exception stack(0xce319d98 to 0xce319de0)
> 9d80:                                                       ffffffff ce319df4
> 9da0: 00000001 00000001 00000000 c04f6600 ce319e4c ce319dc0 c03aafcc c002800c
> 9dc0: c0726f20 00000000 00000000 0000002c c0726f00 000006f8 00000001 00000001
>  r8:0000001d r7:00000000 r6:fc000000 r5:ce319dc0 r4:00000001
> [<c0028000>] (_text+0x0/0x128) from [<c03aafcc>] (__irq_svc+0x4c/0x74)
> Exception stack(0xce319dc0 to 0xce319e08)
> 9dc0: c0726f20 00000000 00000000 0000002c c0726f00 000006f8 00000001 00000001
> 9de0: 00000000 00000000 c04f6600 ce319e4c c04f6774 ce319e08 c00a4498 c0097220
> 9e00: 40000013 ffffffff
> [<c009701c>] (free_pages_bulk+0x0/0x2e4) from [<c00981b0>]
> (free_hot_cold_page+0x2e0/0x320)
> [<c0097ed0>] (free_hot_cold_page+0x0/0x320) from [<c009825c>]
> (free_hot_page+0x14/0x18)
>  r8:cf81bb20 r7:cf264400 r6:cd9f7e00 r5:cf12bee0 r4:00000007
> [<c0098248>] (free_hot_page+0x0/0x18) from [<c00982a4>] (__free_pages+0x44/0x50)
> [<c0098260>] (__free_pages+0x0/0x50) from [<c022ef5c>]
> (relay_destroy_buf+0x80/0xd4)
> [<c022eedc>] (relay_destroy_buf+0x0/0xd4) from [<c022f54c>]
> (relay_remove_buf+0x30/0x34)
>  r7:cf4fddb8 r6:cf4fddb8 r5:cf12bef4 r4:cf12bee0
> [<c022f51c>] (relay_remove_buf+0x0/0x34) from [<c0239a24>] (kref_put+0x74/0x84)
>  r4:c022f51c
> [<c02399b0>] (kref_put+0x0/0x84) from [<c022f56c>]
> (relay_file_release+0x1c/0x28)
>  r5:cf3cb500 r4:cf4fddb8
> [<c022f550>] (relay_file_release+0x0/0x28) from [<c022ced8>]
> (ltt_release+0x30/0x5c)
> [<c022cea8>] (ltt_release+0x0/0x5c) from [<c00bf46c>] (__fput+0xfc/0x1c0)
>  r5:00000010 r4:cf3cb500
> [<c00bf370>] (__fput+0x0/0x1c0) from [<c00bf56c>] (fput+0x3c/0x40)
> [<c00bf530>] (fput+0x0/0x40) from [<c00bbb2c>] (filp_close+0x7c/0x88)
> [<c00bbab0>] (filp_close+0x0/0x88) from [<c00bbc4c>] (sys_close+0x114/0x158)
>  r6:cdc0dc60 r5:0000009d r4:cf1018ec
> [<c00bbb38>] (sys_close+0x0/0x158) from [<c0028ca0>] (ret_fast_syscall+0x0/0x3c)
> 
> }}}
> 
> After searching about the problem in lkml list, found the below link
> 
> http://lkml.org/lkml/2009/9/25/29
> 
> After disabling below lines of code, BUG is disappeared.
> {{{
> kernel/timer.c |    4  2 +     2 -     0 !
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/kernel/timer.c
> ===================================================================
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -599,11 +599,11 @@ static struct tvec_base *lock_timer_base
>                 struct tvec_base *prelock_base = timer->base;
>                 base = tbase_get_base(prelock_base);
>                 if (likely(base != NULL)) {
> -                       spin_lock_irqsave(&base->lock, *flags);
>                         if (likely(prelock_base == timer->base))
>                                 return base;
>                         /* The timer has migrated to another CPU */
> -                       spin_unlock_irqrestore(&base->lock, *flags);
>                 }
>                 cpu_relax();
>         }
> }}}
> 
> Is this the right way to fix the BUG?
> I am not sure.

Heh, no it is not a fix, it just makes more bugs ;-)

That spinlock can not be removed. But I would be interested in knowing
if you can reproduce this without the LTTng patches.

Thanks,

-- Steve


