Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0BYMwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:52:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:55924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab0BYMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:52:06 -0500
Subject: Re: Patch for tracing c states (power_end) on x86
From: Peter Zijlstra <peterz@infradead.org>
To: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1266999573.3415.8.camel@localhost>
References: <1266999573.3415.8.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 13:52:00 +0100
Message-ID: <1267102320.12790.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 09:19 +0100, Robert Schöne wrote:
> Hello,
> 
> Since noone replied to my last mail (Febr. 15th, 11:42), describing the
> way to fix the missing c-state tracing, here's a patch.
> Maybe its easier that way.
> 
> (I used the perf-fixes-for-linus git tree to obtain a
> more-then-up-to-date version)

Arjan, any comments?, you seem skilled with this power stuff ;-)

> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 02d6780..b1cfb88 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -384,6 +384,7 @@ void default_idle(void)
>                 else
>                         local_irq_enable();
>                 current_thread_info()->status |= TS_POLLING;
> +               trace_power_end(1);
>         } else {
>                 local_irq_enable();
>                 /* loop is done by the caller */
> @@ -451,6 +452,7 @@ void mwait_idle_with_hints(unsigned long ax,
> unsigned long cx)
>                 if (!need_resched())
>                         __mwait(ax, cx);
>         }
> +       trace_power_end((ax>>4)+1);
>  }
>  
>  /* Default MONITOR/MWAIT with no hints, used for default C1 state */
> @@ -467,6 +469,7 @@ static void mwait_idle(void)
>                         __sti_mwait(0, 0);
>                 else
>                         local_irq_enable();
> +               trace_power_end(1);
>         } else
>                 local_irq_enable();
>  }
> 


