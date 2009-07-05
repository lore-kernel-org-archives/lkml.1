Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGEDBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGEDBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 23:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZGEDBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 23:01:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZGEDBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 23:01:05 -0400
Date: Sun, 5 Jul 2009 05:01:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]mempool.c : clean up type-casting twice
Message-ID: <20090705030100.GA9341@elte.hu>
References: <1246762120.15308.3.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246762120.15308.3.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0047]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Figo.zhang <figo1802@gmail.com> wrote:

> clean up type-casting twice
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---   
> mm/mempool.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index a46eb1b..0aec628 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -303,7 +303,7 @@ EXPORT_SYMBOL(mempool_free_slab);
>   */
>  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
>  {
> -	size_t size = (size_t)(long)pool_data;
> +	size_t size = (size_t)pool_data;
>  	return kmalloc(size, gfp_mask);
>  }
>  EXPORT_SYMBOL(mempool_kmalloc);
> @@ -327,14 +327,14 @@ EXPORT_SYMBOL(mempool_kfree);
>   */
>  void *mempool_alloc_pages(gfp_t gfp_mask, void *pool_data)
>  {
> -	int order = (int)(long)pool_data;
> +	int order = (int)pool_data;
>  	return alloc_pages(gfp_mask, order);
>  }
>  EXPORT_SYMBOL(mempool_alloc_pages);
>  
>  void mempool_free_pages(void *element, void *pool_data)
>  {
> -	int order = (int)(long)pool_data;
> +	int order = (int)pool_data;
>  	__free_pages(element, order);

What's the motivation?

On 64-bit platforms, casting from a pointer (64-bit) straight to int 
(32-bit) can lose information and is thus a potential source of 
bugs, so certain compilers will warn about it with:

   warning: cast from pointer to integer of different size

The double cast is a "I know what I'm doing" signal.

	Ingo
