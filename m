Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZL1Hmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZL1Hmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZL1Hmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:42:46 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36223 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZL1Hmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:42:45 -0500
Subject: Re: linux-next: slab/percpu tree build failure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091224095848.f1586d1e.sfr@canb.auug.org.au>
References: <20091224095848.f1586d1e.sfr@canb.auug.org.au>
Date: Mon, 28 Dec 2009 09:42:43 +0200
Message-Id: <1261986163.4641.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 2009-12-24 at 09:58 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> mm/slub.c: In function 'alloc_kmem_cache_cpus':
> mm/slub.c:2074: error: implicit declaration of function 'per_cpu_var'
> mm/slub.c:2074: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit 9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864 ("SLUB: Use
> this_cpu operations in slub") from the slab interacting with commit
> dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu: remove per_cpu__
> prefix") from the percpu tree.
> 
> I have added the following patch for today and (can carry it as
> necessary).
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 24 Dec 2009 09:56:29 +1100
> Subject: [PATCH] slab: update for percpu API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/slub.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
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

Looks good to me, thanks! I guess you should carry it in linux-next so
that I don't need to pull percpu.git in slab.git?

			Pekka

