Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0CAPRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:17:18 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38336 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0CAPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:14 -0500
Message-ID: <4B8BDA6E.6000902@cs.helsinki.fi>
Date: Mon, 01 Mar 2010 17:17:02 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>, "" <joern@logfs.org>
Subject: Re: linux-next: current pending merge fix patches
References: <20100301160445.5e281f11.sfr@canb.auug.org.au>
In-Reply-To: <20100301160445.5e281f11.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 4) The slab[7] tree adds a percpu variable usage case (commit
> 9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864 "SLUB: Use this_cpu operations in
> slub"), but the percpu[8] tree removes the prefixing of percpu variables
> (commit dd17c8f72993f9461e9c19250e3f155d6d99df22 "percpu: remove per_cpu__
> prefix"), thus the fooling patch after mergeing these trees:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6e34309..9e86e6b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2071,7 +2071,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
>  		 * Boot time creation of the kmalloc array. Use static per cpu data
>  		 * since the per cpu allocator is not available yet.
>  		 */
> -		s->cpu_slab = per_cpu_var(kmalloc_percpu) + (s - kmalloc_caches);
> +		s->cpu_slab = kmalloc_percpu + (s - kmalloc_caches);
>  	else
>  		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);

Thanks for the reminder Stephen! I'll add this to slab.git as soon as 
the per-cpu changes land into Linus' tree.

			Pekka
