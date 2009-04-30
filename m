Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbZD3Ibq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbZD3Ibq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZD3Ib0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:31:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZD3IbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:31:25 -0400
Date: Thu, 30 Apr 2009 10:31:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] atomic: fix atomic_long_cmpxchg/xchg for 64 bit
	architectures
Message-ID: <20090430083102.GB21699@elte.hu>
References: <20090429143601.1a79ab8f@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429143601.1a79ab8f@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> On a linux-next allyesconfig build:
> 
> kernel/trace/ring_buffer.c:1726:
> 	warning: passing argument 1 of 'atomic_cmpxchg' from incompatible pointer type
> linux-next/arch/s390/include/asm/atomic.h:112:
> 	note: expected 'struct atomic_t *' but argument is of type 'struct atomic64_t *'
> 
> atomic_long_cmpxchg and atomic_long_xchg are incorrectly defined for
> 64 bit architectures. They should be mapped to the atomic64_* variants.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/asm-generic/atomic.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-next/include/asm-generic/atomic.h
> ===================================================================
> --- linux-next.orig/include/asm-generic/atomic.h
> +++ linux-next/include/asm-generic/atomic.h
> @@ -132,9 +132,9 @@ static inline long atomic_long_add_unles
>  #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
>  
>  #define atomic_long_cmpxchg(l, old, new) \
> -	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
> +	(atomic64_cmpxchg((atomic64_t *)(l), (old), (new)))
>  #define atomic_long_xchg(v, new) \
> -	(atomic_xchg((atomic64_t *)(l), (new)))
> +	(atomic64_xchg((atomic64_t *)(l), (new)))

Acked-by: Ingo Molnar <mingo@elte.hu>

That's due to the local_cmpchg() use the tracing tree grew recently, 
right? It appears it was never used in generic code before.

	Ingo
