Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbZDBVne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbZDBVne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760909AbZDBVmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:42:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761888AbZDBVmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:42:46 -0400
Date: Thu, 2 Apr 2009 23:42:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix slab corruption caused by
	alloc_cpumask_var_node()
Message-ID: <20090402214219.GC21070@elte.hu>
References: <20090402212751.GA11495@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402212751.GA11495@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Fix for slab corruption caused by alloc_cpumask_var_node() overwriting
> the tail end of an off-stack cpumask.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> Acked-by: Mike Travis <travis.sgi.com>
> 
> 
> ---
> 
> Corrruption was found in latest linux-next (4/1)
> 	v2.6.29-12081-g421a9f3
> 
> 
> 
>  lib/cpumask.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/lib/cpumask.c
> ===================================================================
> --- linux.orig/lib/cpumask.c	2009-04-02 15:30:05.000000000 -0500
> +++ linux/lib/cpumask.c	2009-04-02 15:57:44.000000000 -0500
> @@ -109,10 +109,10 @@ bool alloc_cpumask_var_node(cpumask_var_
>  #endif
>  	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
>  	if (*mask) {
> +		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
>  		unsigned int tail;
>  		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
> -		memset(cpumask_bits(*mask) + cpumask_size() - tail,
> -		       0, tail);
> +		memset(ptr + cpumask_size() - tail, 0, tail);

Nice,

Acked-by: Ingo Molnar <mingo@elte.hu>

Note: it also needs a Cc: <stable@kernel.org> tag as v2.6.29 is 
affected by this bug too.

	Ingo
