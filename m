Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZAIKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZAIKQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZAIKQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:16:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46612 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZAIKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DXdN5HySW2zvxbq992xLLZII7IRPFevDoDJtXs7P6LEf3evWJgjhYB4x2uel70gWeU
         mltNmBdRl+lNiaq8+CC/Q2zv7KMxoLMXX5YGALKsqlYIH29R3JdINXoEOvkEdtMYQjlo
         eSsqpIFcophQSmo2OibZP8YRcQ5XRpdRP6obQ=
Message-ID: <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
Date: Fri, 9 Jan 2009 13:09:22 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Laurent Riffard" <laurent.riffard@free.fr>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435 sub_preempt_count
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4966897E.5020302@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4966897E.5020302@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
Added Ingo Molnar to CC.

On Fri, Jan 9, 2009 at 02:17, Laurent Riffard <laurent.riffard@free.fr> wrote:
> hello,
>
> I'm getting this warning in dmesg since 2.6.28-next-20081229:
>
> WARNING: at kernel/sched.c:4435 sub_preempt_count+0x7e/0x8f()
> Hardware name: M68SM-S2L
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.28-next-20090107-09542-gdbcea38 #71
> Call Trace:
>  [<c0224f35>] warn_slowpath+0x80/0xb6
>  [<c024140d>] lock_acquire+0x76/0x7e
>  [<c03be817>] _spin_unlock_irq+0x20/0x51
>  [<c0240278>] trace_hardirqs_on_caller+0xf8/0x12e
>  [<c03be81f>] _spin_unlock_irq+0x28/0x51
>  [<c03be83c>] _spin_unlock_irq+0x45/0x51
>  [<c022c865>] run_timer_softirq+0x178/0x180
>  [<c022211c>] run_rebalance_domains+0x27/0x8f
>  [<c023ef58>] trace_hardirqs_off_caller+0x2c/0x87
>  [<c0220788>] sub_preempt_count+0x7e/0x8f
>  <IRQ>  [<c024ef74>] handle_level_irq+0x0/0x9d
>  [<c022950e>] irq_exit+0x43/0x87
>  [<c0204d9e>] do_IRQ+0xec/0x102
>  [<c02035ec>] common_interrupt+0x2c/0x34
>  [<c02168dc>] native_safe_halt+0x2/0x3
>  [<c04aadd3>] check_bugs+0x9f/0xd8
>  [<c04a47e8>] start_kernel+0x2f9/0x306
> ---[ end trace 4eaa2a86a8e2da22 ]---
>
> In previous releases (2.6.27-next-20081020 to 2.6.28-rc7-next-20081203), I was getting "WARNING: at kernel/sched.c:4354 do_softirq" with more or less the same stack trace:

Rinning -next and not reporting bugs sounds a bit counter-productive. ;(

> Checking 'hlt' instruction... <4>------------[ cut here ]------------
> WARNING: at kernel/sched.c:4332 do_softirq+0x61/0xb3()
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.28-rc2-next-20081027-02513-g5362c2b #46
> Call Trace:
>  [<c02234b8>] warn_on_slowpath+0x40/0x59
>  [<c023e07b>] trace_hardirqs_on_caller+0xe3/0x12d
>  [<c03b295a>] _spin_unlock_irq+0x3c/0x48
>  [<c0220deb>] run_rebalance_domains+0x29/0x96
>  [<c022793f>] __do_softirq+0xc5/0xf9
>  [<c022787a>] __do_softirq+0x0/0xf9
>  <IRQ>  [<c024bf72>] handle_level_irq+0x0/0x9f
>  [<c02279b6>] irq_exit+0x43/0x8b
>  [<c0205eec>] do_IRQ+0xef/0x107
>  [<c0204628>] common_interrupt+0x28/0x30
>  [<c04cfadf>] check_bugs+0x91/0xbb
>  [<c04c782c>] start_kernel+0x308/0x318
> ---[ end trace 4eaa2a86a8e2da22 ]---
> OK.
>
>
> Full dmesg and .config for 2.6.28-next-20090107 are attached (actually this is linux-next tree + reiser4 patches, but I verified that this WARNING does appear without reiser4 patches in 2.6.28-next-20081230).
>
