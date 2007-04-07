Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXDGIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXDGIui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965679AbXDGIuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:50:37 -0400
Received: from www.osadl.org ([213.239.205.134]:34067 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965673AbXDGIug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:50:36 -0400
Subject: Re: [patch] high-res timers: UP resume fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20070407081244.GA28284@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <1175899460.5393.9.camel@localhost>
	 <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
	 <20070407081244.GA28284@elte.hu>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 10:51:05 +0200
Message-Id: <1175935865.28263.512.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 10:12 +0200, Ingo Molnar wrote:
> Subject: [patch] high-res timers: UP resume fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> Soeren Sonnenburg reported that upon resume he is getting
> this backtrace:
> 
>  [<c0119637>] smp_apic_timer_interrupt+0x57/0x90
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0104d30>] apic_timer_interrupt+0x28/0x30
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0140068>] __kfifo_put+0x8/0x90
>  [<c0130fe5>] on_each_cpu+0x35/0x60
>  [<c0143538>] clock_was_set+0x18/0x20
>  [<c0135cdc>] timekeeping_resume+0x7c/0xa0
>  [<c02aabe1>] __sysdev_resume+0x11/0x80
>  [<c02ab0c7>] sysdev_resume+0x47/0x80
>  [<c02b0b05>] device_power_up+0x5/0x10
> 
> it turns out that on UP we mistakenly re-enable interrupts,
> so do the timer retrigger only on the current CPU.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


