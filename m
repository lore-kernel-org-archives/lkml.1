Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZCEQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZCEQ55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZCEQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:57:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbZCEQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:57:48 -0500
Date: Thu, 5 Mar 2009 17:53:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 1/4] timers: framework to identify pinned timers.
Message-ID: <20090305165340.GA6984@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121456.GB9855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304121456.GB9855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Arun R Bharadwaj wrote:
>
> +static inline unsigned long tbase_get_flag_bits(struct timer_list *timer)
> +{
> +	return tbase_get_deferrable(timer->base) |
> +				tbase_get_pinned(timer->base);
> +}

I'd say this looks a bit strange. Hopefully compiler can optimize this code
to return (unsigned long)base & (TBASE_DEFERRABLE_FLAG | TBASE_PINNED_FLAG).

> @@ -736,6 +759,7 @@ void add_timer_on(struct timer_list *tim
>  	struct tvec_base *base = per_cpu(tvec_bases, cpu);
>  	unsigned long flags;
>
> +	timer_set_pinned(timer);

But we never clear TBASE_PINNED_FLAG?

If we use mod_timer() next time, the timer remains "pinned". I do not say
this is really wrong, but a bit strange imho.

Oleg.

