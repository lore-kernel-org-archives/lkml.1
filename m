Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809AbXCDQvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbXCDQvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXCDQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:51:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51312 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbXCDQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rbeg4xi3+Mw+KZ8CfTZRKdhv49l9Ama6pxobrTbNvVxV0qc8n2IkVYGPTcUFWmAPzvkBne6Fw74Vea+132BHn8Sl3c3kG4u8zyNWZrxg4UdmKenH6rq+SMdKsN2TKjLBE1x30D2pSvVpNNWXzesHh3CbeoAxPnmFXad74HefDoQ=
Subject: Re: HR timers soft lockup on resume from suspend to ram
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1173025704.11244.22.camel@funkylaptop>
References: <1173025704.11244.22.camel@funkylaptop>
Content-Type: text/plain; charset=utf-8
Date: Sun, 04 Mar 2007 17:51:07 +0100
Message-Id: <1173027067.11244.31.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On dim, 2007-03-04 at 17:28 +0100, Frédéric RISS wrote:
> When the system is hung, and I press on the power button, I get this
> backtrace (copied from the screen, netconsole won't allow to capture
> it): 
> 
> BUG: soft lockup detected on CPU#0!
>   [<c0155c88>] softlockup_tick+0xa8/0x110
>   [<c0130283>] update_process_times+0x33/0x80
>   [<c014215b>] tick_sched_timer+0x5b/0xc0
>   [<c013e3f3>] hrtimer_interrupt+0x143/0x1d0
>   [<c01172e0>] smp_apic_timer_interrupt+0x50/0x80
>   [<c0104e4c>] apic_timer_interrupt+0x28/0x30
>   [<c0372926>] _spin_unlock_irq+0x6/0x30
>   [<c0370488>] __sched_text_start+0x308/0x880
>   [<c0372909>] _spin_unlock_irqrestore+0x19/0x30
>   [<c01378ee>] worker_thread+0x12e/0x170
>   [<c0120a50>] default_wake_function+0x0/0x10
>   [<c01377c0>] worker_thread+0x0/0x170
>   [<c013a88a>] kthread+0xba/0xf0
>   [<c013a7d0>] kthread+0x0/0xf0
>   [<c0104fb3>] kernel_thread_helper+0x7/0x14
>   ======================
> 
> I get it every time I press on the power button.

Turns, out this wasn't true. In fact multiple power button presses will
bring the system back to life. I hadn't the right console loglevel
setting when I first tested that.

With a higher loglevel I get this by pressing the power button at least
4 times:

Mar  4 17:43:58 minifunky kernel: [  580.222727] Enabling non-boot CPUs ...
Mar  4 17:43:58 minifunky kernel: [  597.696477] BUG: soft lockup detected on CPU#0!
Mar  4 17:43:58 minifunky kernel: [  597.698186]  [softlockup_tick+168/272] softlockup_tick+0xa8/0x110
Mar  4 17:43:58 minifunky kernel: [  597.699924]  [update_process_times+51/128] update_process_times+0x33/0x80
Mar  4 17:43:58 minifunky kernel: [  597.701676]  [tick_sched_timer+91/192] tick_sched_timer+0x5b/0xc0
Mar  4 17:43:58 minifunky kernel: [  597.703453]  [hrtimer_interrupt+323/464] hrtimer_interrupt+0x143/0x1d0
Mar  4 17:43:58 minifunky kernel: [  597.705255]  [smp_apic_timer_interrupt+80/128] smp_apic_timer_interrupt+0x50/0x80
Mar  4 17:43:58 minifunky kernel: [  597.707066]  [apic_timer_interrupt+40/48] apic_timer_interrupt+0x28/0x30
Mar  4 17:43:58 minifunky kernel: [  597.708885]  [scrdown+27/208] scrdown+0x1b/0xd0
Mar  4 17:43:58 minifunky kernel: [  597.710684]  [worker_thread+248/368] worker_thread+0xf8/0x170
Mar  4 17:43:58 minifunky kernel: [  597.712505]  [default_wake_function+0/16] default_wake_function+0x0/0x10
Mar  4 17:43:58 minifunky kernel: [  597.714317]  [worker_thread+0/368] worker_thread+0x0/0x170
Mar  4 17:43:58 minifunky kernel: [  597.716137]  [kthread+186/240] kthread+0xba/0xf0
Mar  4 17:43:58 minifunky kernel: [  597.717949]  [kthread+0/240] kthread+0x0/0xf0
Mar  4 17:43:58 minifunky kernel: [  597.719737]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
Mar  4 17:43:58 minifunky kernel: [  597.721562]  =======================
Mar  4 17:43:58 minifunky kernel: [  606.119695] SMP alternatives: switching to SMP code
Mar  4 17:43:58 minifunky kernel: [  606.121668] Booting processor 1/1 eip 3000
Mar  4 17:43:58 minifunky kernel: [  606.123518] CPU 1 irqstacks, hard=c04cf000 soft=c04cd000
Mar  4 17:43:58 minifunky kernel: [  606.135911] Initializing CPU#1
Mar  4 17:43:58 minifunky kernel: [  606.196496] Calibrating delay using timer specific routine.. 3333.89 BogoMIPS (lpj=1666945)
Mar  4 17:43:58 minifunky kernel: [  606.196503] CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
Mar  4 17:43:58 minifunky kernel: [  606.196508] monitor/mwait feature present.
Mar  4 17:43:58 minifunky kernel: [  606.196512] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  4 17:43:58 minifunky kernel: [  606.196514] CPU: L2 cache: 2048K
Mar  4 17:43:58 minifunky kernel: [  606.196517] CPU: Physical Processor ID: 0
Mar  4 17:43:58 minifunky kernel: [  606.196518] CPU: Processor Core ID: 1
Mar  4 17:43:58 minifunky kernel: [  606.196520] CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000
Mar  4 17:43:58 minifunky kernel: [  606.196526] Intel machine check architecture supported.
Mar  4 17:43:58 minifunky kernel: [  606.196532] Intel machine check reporting enabled on CPU#1.
Mar  4 17:43:58 minifunky kernel: [  606.197027] CPU1: Intel Genuine Intel(R) CPU           T2300  @ 1.66GHz stepping 08
Mar  4 17:43:58 minifunky kernel: [  606.223215] BUG: soft lockup detected on CPU#1!
Mar  4 17:43:58 minifunky kernel: [  606.225588]  [softlockup_tick+168/272] softlockup_tick+0xa8/0x110
Mar  4 17:43:58 minifunky kernel: [  606.228020]  [update_process_times+51/128] update_process_times+0x33/0x80
Mar  4 17:43:58 minifunky kernel: [  606.230450]  [tick_periodic+34/128] tick_periodic+0x22/0x80
Mar  4 17:43:58 minifunky kernel: [  606.232846]  [tick_handle_periodic+21/112] tick_handle_periodic+0x15/0x70
Mar  4 17:43:58 minifunky kernel: [  606.235299]  [smp_apic_timer_interrupt+80/128] smp_apic_timer_interrupt+0x50/0x80
Mar  4 17:43:58 minifunky kernel: [  606.237742]  [apic_timer_interrupt+40/48] apic_timer_interrupt+0x28/0x30
Mar  4 17:43:58 minifunky kernel: [  606.240237]  [_spin_unlock_irq+6/48] _spin_unlock_irq+0x6/0x30
Mar  4 17:43:58 minifunky kernel: [  606.242760]  [schedule+776/2176] __sched_text_start+0x308/0x880
Mar  4 17:43:58 minifunky kernel: [  606.245334]  [migration_thread+0/528] migration_thread+0x0/0x210
Mar  4 17:43:58 minifunky kernel: [  606.247907]  [kthread+173/240] kthread+0xad/0xf0
Mar  4 17:43:58 minifunky kernel: [  606.250478]  [kthread+0/240] kthread+0x0/0xf0
Mar  4 17:43:58 minifunky kernel: [  606.253069]  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
Mar  4 17:43:58 minifunky kernel: [  606.255677]  =======================
Mar  4 17:43:58 minifunky kernel: [  606.258301] Switched to high resolution mode on CPU 1
Mar  4 17:43:58 minifunky kernel: [  606.263491] CPU1 is up


