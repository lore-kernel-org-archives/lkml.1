Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZJLKU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZJLKU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZJLKU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:20:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:41572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZJLKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:20:58 -0400
Message-ID: <4AD302A8.4010409@kernel.org>
Date: Mon, 12 Oct 2009 19:19:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org>
In-Reply-To: <20091007211052.614790286@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 10:19:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cl@linux-foundation.org wrote:
> @@ -1507,7 +1498,7 @@ static inline void flush_slab(struct kme
>   */
>  static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
>  {
> -	struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
> +	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
>  
>  	if (likely(c && c->page))
>  		flush_slab(s, c);
> @@ -1673,7 +1661,7 @@ new_slab:
>  		local_irq_disable();
>  
>  	if (new) {
> -		c = get_cpu_slab(s, smp_processor_id());
> +		c = __this_cpu_ptr(s->cpu_slab);

Shouldn't this be this_cpu_ptr() without the double underscore?

Thanks.

-- 
tejun
