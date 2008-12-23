Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbYLWMbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbYLWMbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYLWMbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:31:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:10476 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AjzGDejYLZrFmSVbXhl7OtJ1C1V4O0ajOjZU3jEvgwmZgzVUbqkz7kV3OHTsGJzSNA
         +NbVe0ATlqyFUmeladJ/E4j2q95kqY4W7lkwrEqzRcxbPht8LaDoWSyD08SHtqaNg18U
         sjWU2KxO2PFNxfLqqmgfSLcCReHDCcx4MdYpQ=
Message-ID: <c62985530812230431y539f1768lec68e44c187e7068@mail.gmail.com>
Date: Tue, 23 Dec 2008 13:31:11 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: strip ending newlines on comments
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081223081855.GA6009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494FD967.2000002@gmail.com> <20081223064804.GA24956@elte.hu>
	 <20081223081855.GA6009@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/23 Ingo Molnar <mingo@elte.hu>:
>
> btw., ftrace_printk() is not NMI safe:
> x
> BUG: spinlock recursion on CPU#1, loop_yield/3360
>  lock: ffffffff807a0c60, .magic: dead4ead, .owner: loop_yield/3360, .owner_cpu: 1
> Pid: 3360, comm: loop_yield Not tainted 2.6.28-rc9-tip #48
> Call Trace:
>  <NMI>  [<ffffffff8038ba23>] spin_bug+0xa2/0xaa
>  [<ffffffff8038baf8>] _raw_spin_lock+0x42/0x134
>  [<ffffffff8059f0fc>] _spin_lock_irqsave+0x44/0x50
>  [<ffffffff802890c4>] ? trace_vprintk+0x8e/0x164
>  [<ffffffff8059eeea>] ? _spin_unlock_irqrestore+0x3d/0x4c
>  [<ffffffff802890c4>] trace_vprintk+0x8e/0x164
>  [<ffffffff802182a6>] ? __hw_perf_counter_set_period+0x1ed/0x280
>  [<ffffffff802892ef>] __ftrace_printk+0x55/0x57
>  [<ffffffff802182cc>] __hw_perf_counter_set_period+0x213/0x280
>  [<ffffffff80218d8c>] __smp_perf_counter_interrupt+0x21c/0x3c2
>  [<ffffffff805a043a>] perf_counter_nmi_handler+0x35/0x3f
>  [<ffffffff805a1cc9>] notifier_call_chain+0x5e/0x92
>  [<ffffffff805a1d5b>] __atomic_notifier_call_chain+0x5e/0x87
>  [<ffffffff805a1cfd>] ? __atomic_notifier_call_chain+0x0/0x87
>  [<ffffffff805a1d93>] atomic_notifier_call_chain+0xf/0x11
>  [<ffffffff80258e9d>] notify_die+0x2e/0x30
>  [<ffffffff8059fdd2>] do_nmi+0x9f/0x25f
>  [<ffffffff8059f7fa>] nmi+0x1a/0x2c
>  [<ffffffff80287104>] ? __rb_reserve_next+0x4b/0x3c8
>  [<ffffffff802871dd>] ? __rb_reserve_next+0x124/0x3c8
>  <<EOE>>  <IRQ>  [<ffffffff80287628>] rb_reserve_next_event+0x1a7/0x307
>  [<ffffffff8028796c>] ring_buffer_lock_reserve+0x8b/0xd3
>  [<ffffffff8028910b>] trace_vprintk+0xd5/0x164
>  [<ffffffff80260fb3>] ? trace_hardirqs_on_caller+0xfd/0x138
>  [<ffffffff8028dd2b>] ? __perf_counter_remove_from_context+0x60/0x179
>  [<ffffffff802892ef>] __ftrace_printk+0x55/0x57
>  [<ffffffff802180a6>] ? pmc_generic_disable+0x266/0x279
>  [<ffffffff8028dd59>] __perf_counter_remove_from_context+0x8e/0x179
>  [<ffffffff8026835d>] generic_smp_call_function_single_interrupt+0x87/0xc0
>  [<ffffffff8021fd8d>] smp_call_function_single_interrupt+0x24/0x34
>  [<ffffffff8020d053>] call_function_single_interrupt+0x13/0x20
>  <EOI>
>
> caused by:
>
>        spin_lock_irqsave(&trace_buf_lock, irq_flags);
>
> which locking is necessiated by:
>
>        static DEFINE_SPINLOCK(trace_buf_lock);
>        static char trace_buf[TRACE_BUF_SIZE];
>
> i think this should be changed to a PER_CPU data structure - and if an NMI
> context mixes up the buffer, that's not a big issue. (i'd not complicate
> it by using a NMI specific buffer)
>
>        Ingo
>

Ok. That would be great if the nmi context detection implemented
inside arch/x86/kernel/ftrace.c could be standardized,
we could also make easy the handling of such situations.

For now I will fix it with a per_cpu buffer.

Thanks.
