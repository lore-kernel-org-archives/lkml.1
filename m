Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXFZA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXFZA2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXFZA2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:28:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbXFZA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:28:18 -0400
Date: Mon, 25 Jun 2007 17:27:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 22/28] x86_64: Convert to cleckevents
Message-Id: <20070625172751.3b8cf548.akpm@linux-foundation.org>
In-Reply-To: <20070623124031.119498199@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	<20070623124031.119498199@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:32:47 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Convert x86_64 to the clockevents code. Share code with i386 for
> hpet and PIT.
> 
> Build and whitespace fixups from:
>  Venki Pallipadi <venkatesh.pallipadi@intel.com>
> and
>  Chris Wright <chrisw@sous-sol.org>

semi-fixes.

>         if (no_ctr_free) {
> -               i = 3;
> -               rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
> -               wrmsrl(MSR_K7_EVNTSEL3, 0);
> -               rdmsrl(MSR_K7_PERFCTR3, pmc3);
> +	       i = 3;
> +	       rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
> +	       wrmsrl(MSR_K7_EVNTSEL3, 0);
> +	       rdmsrl(MSR_K7_PERFCTR3, pmc3);
>         } else {
> -               reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> -               reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
> +	       reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> +	       reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
>         }
>         local_irq_save(flags);
>         /* start meauring cycles, incrementing from 0 */
> @@ -275,119 +236,38 @@ static unsigned int __init tsc_calibrate
>         wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
>         rdtscl(tsc_start);
>         do {
> -               rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
> -               tsc_now = get_cycles_sync();
> +	       rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
> +	       tsc_now = get_cycles_sync();
>         } while ((tsc_now - tsc_start) < TICK_COUNT);
>  
>         local_irq_restore(flags);
>         if (no_ctr_free) {
> -               wrmsrl(MSR_K7_EVNTSEL3, 0);
> -               wrmsrl(MSR_K7_PERFCTR3, pmc3);
> -               wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
> +	       wrmsrl(MSR_K7_EVNTSEL3, 0);
> +	       wrmsrl(MSR_K7_PERFCTR3, pmc3);
> +	       wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
>         } else {
> -               release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> -               release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
> +	       release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
> +	       release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
>         }

There's still bulk whitespace bustage in here.

(However checkpatch only says

Use #include <linux/hpet.h> instead of <asm/hpet.h>
#1913: FILE: arch/x86_64/kernel/tsc.c:11:
+#include <asm/hpet.h>
)

<edits the diff, fixes it>
