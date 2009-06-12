Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbZFLBBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbZFLBBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZFLBBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:01:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:55987 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbZFLBBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:01:07 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       Ingo Molnar <mingo@elte.hu>, ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612102427.32582baa.sfr@canb.auug.org.au>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:00:06 +1000
Message-Id: <1244768406.7172.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 10:24 +1000, Stephen Rothwell wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 12 Jun 2009 10:14:22 +1000
> Subject: [PATCH] perfcounters: remove powerpc definitions of perf_counter_do_pending
> 
> Commit 925d519ab82b6dd7aca9420d809ee83819c08db2 ("perf_counter:
> unify and fix delayed counter wakeup") added global definitions.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Linus, please apply. BTW, This is _EXACTLY_ why this should have been in
-next for a few days before being merged :-(

Cheers,
Ben.

> ---
>  arch/powerpc/include/asm/hw_irq.h |    3 ---
>  arch/powerpc/kernel/irq.c         |    1 +
>  2 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
> index 20a44d0..5351237 100644
> --- a/arch/powerpc/include/asm/hw_irq.h
> +++ b/arch/powerpc/include/asm/hw_irq.h
> @@ -156,8 +156,6 @@ static inline void clear_perf_counter_pending(void)
>  		"i" (offsetof(struct paca_struct, perf_counter_pending)));
>  }
>  
> -extern void perf_counter_do_pending(void);
> -
>  #else
>  
>  static inline unsigned long test_perf_counter_pending(void)
> @@ -167,7 +165,6 @@ static inline unsigned long test_perf_counter_pending(void)
>  
>  static inline void set_perf_counter_pending(void) {}
>  static inline void clear_perf_counter_pending(void) {}
> -static inline void perf_counter_do_pending(void) {}
>  #endif /* CONFIG_PERF_COUNTERS */
>  
>  #endif	/* __KERNEL__ */
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index feff792..844d3f8 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -53,6 +53,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/pci.h>
>  #include <linux/debugfs.h>
> +#include <linux/perf_counter.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/system.h>

