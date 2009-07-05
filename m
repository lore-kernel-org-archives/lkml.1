Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZGEItD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZGEItD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 04:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZGEIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 04:48:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33014 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZGEIsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 04:48:52 -0400
Date: Sun, 5 Jul 2009 10:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]mempool.c : clean up type-casting twice
Message-ID: <20090705084849.GA21067@elte.hu>
References: <1246762120.15308.3.camel@myhost> <1246766651.15308.13.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246766651.15308.13.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Figo.zhang <figo1802@gmail.com> wrote:

> clean up type-casting twice. "size_t" typedef as "unsigned long" in 64-bit system,
> and "unsigned int" in 32-bit system.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---   
> mm/mempool.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index a46eb1b..bd22982 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -303,7 +303,7 @@ EXPORT_SYMBOL(mempool_free_slab);
>   */
>  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
>  {
> -	size_t size = (size_t)(long)pool_data;
> +	size_t size = (size_t) pool_data;
>  	return kmalloc(size, gfp_mask);
>  }
>  EXPORT_SYMBOL(mempool_kmalloc);

(Style detail: please dont add spaces to casts. That should be fixed 
in mempool_kzalloc() too btw.)

Looks good otherwise - size_t ought to be long on all 64-bit 
architectures.

	Ingo
