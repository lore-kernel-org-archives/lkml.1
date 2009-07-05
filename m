Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZGEJEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZGEJEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZGEJEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:04:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZGEJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:04:43 -0400
Date: Sun, 5 Jul 2009 11:04:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3]mempool.c : clean up type-casting twice
Message-ID: <20090705090441.GA24502@elte.hu>
References: <1246762120.15308.3.camel@myhost> <1246766651.15308.13.camel@myhost> <1246784484.4358.3.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246784484.4358.3.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Figo.zhang <figo1802@gmail.com> wrote:

> clean up type-casting twice. "size_t" typedef as "unsigned long" in 64-bit system,
> and "unsigned int" in 32-bit system.

[
  You should line-length limit your changelogs btw., to 60 
  characters or so. git log will add another 4 characters. The 
  ~/.vimrc magic for this is:

  autocmd BufNewFile,BufRead *.patch setlocal textwidth=60
]

> 
> in v3, remove the space to casts.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---    
> mm/mempool.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index a46eb1b..32e75d4 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -303,14 +303,14 @@ EXPORT_SYMBOL(mempool_free_slab);
>   */
>  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
>  {
> -	size_t size = (size_t)(long)pool_data;
> +	size_t size = (size_t)pool_data;
>  	return kmalloc(size, gfp_mask);
>  }
>  EXPORT_SYMBOL(mempool_kmalloc);
>  
>  void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
>  {
> -	size_t size = (size_t) pool_data;
> +	size_t size = (size_t)pool_data;
>  	return kzalloc(size, gfp_mask);
>  }
>  EXPORT_SYMBOL(mempool_kzalloc);

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
