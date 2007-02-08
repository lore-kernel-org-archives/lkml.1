Return-Path: <linux-kernel-owner+w=401wt.eu-S1161528AbXBHEsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161528AbXBHEsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161529AbXBHEsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:48:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161528AbXBHEsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:48:08 -0500
Date: Wed, 7 Feb 2007 20:47:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukasz Trabinski <lukasz@wsisiz.edu.pl>
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-Id: <20070207204745.a2640c43.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 00:02:10 +0100 (CET) Lukasz Trabinski <lukasz@wsisiz.edu.pl> wrote:

> Hello
> 
> On 2.6.19 I had about 60 days uptime, on 2.6.20 2 days :(
> 

Did the machine actually fail?  Or did it just print these messages and
keep going?


> 
> oceanic:~$ uname -a
> Linux oceanic.wsisiz.edu.pl 2.6.20-oceanic #2 SMP Sun Feb 4 21:55:29 CET 
> 2007 x86_64 x86_64 x86_64 GNU/Linux
> 
> Feb  7 22:46:00 oceanic kernel: BUG: soft lockup detected on CPU#0! 
> Feb  7 22:46:00 oceanic kernel: 
> Feb  7 22:46:00 oceanic kernel: Call Trace: 
> Feb  7 22:46:00 oceanic kernel:  <IRQ>  [<ffffffff80250550>] softlockup_tick+0xdb/0xed 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022ea87>] __do_softirq+0x55/0xc4 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023256c>] update_process_times+0x42/0x68 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80213e36>] smp_local_timer_interrupt+0x34/0x55 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80214316>] smp_apic_timer_interrupt+0x51/0x68 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
> Feb  7 22:46:00 oceanic kernel:  <EOI>  [<ffffffff804393c3>] _spin_unlock_irqrestore+0x8/0x9 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff804393c3>] _spin_unlock_irqrestore+0x8/0x9 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023dddd>] hrtimer_try_to_cancel+0x4a/0x53 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023ddf2>] hrtimer_cancel+0xc/0x16 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023ddf2>] hrtimer_cancel+0xc/0x16 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022cc66>] do_exit+0x1c8/0x800 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022d31d>] sys_exit_group+0x0/0xe 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020995c>] tracesys+0xdc/0xe1 
> Feb  7 22:46:00 oceanic kernel: 
> Feb  7 22:46:00 oceanic kernel: BUG: soft lockup detected on CPU#1! 
> Feb  7 22:46:00 oceanic kernel: 
> Feb  7 22:46:00 oceanic kernel: Call Trace: 
> Feb  7 22:46:00 oceanic kernel:  <IRQ>  [<ffffffff80250550>] softlockup_tick+0xdb/0xed 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023256c>] update_process_times+0x42/0x68 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80213e36>] smp_local_timer_interrupt+0x34/0x55 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80214316>] smp_apic_timer_interrupt+0x51/0x68 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff802338c8>] __group_send_sig_info+0x35/0x8b 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022e0f1>] it_real_fn+0x0/0x4f 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff802164da>] flat_send_IPI_mask+0x0/0x3d 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023dc52>] hrtimer_run_queues+0x105/0x164 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80231d0f>] run_timer_softirq+0x21/0x19f 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022eb49>] tasklet_action+0x53/0x9d 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022ea87>] __do_softirq+0x55/0xc4 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a8fc>] call_softirq+0x1c/0x28 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020c3b1>] do_softirq+0x2c/0x7d 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8021431b>] smp_apic_timer_interrupt+0x56/0x68 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80208a55>] default_idle+0x0/0x3d 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
> Feb  7 22:46:00 oceanic kernel:  <EOI>  [<ffffffff80208a7e>] default_idle+0x29/0x3d 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff80208ae4>] cpu_idle+0x52/0x71 
> Feb  7 22:46:00 oceanic kernel:  [<ffffffff8057fbbc>] start_secondary+0x465/0x474
> 

The softlock detector has a long history of false positives and precious
few true positives, in my experience.

