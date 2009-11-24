Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbZKXLWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbZKXLWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbZKXLWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:22:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbZKXLWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:22:06 -0500
Date: Tue, 24 Nov 2009 12:20:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Blechmann <tim@klingt.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
Message-ID: <20091124112058.GA23765@elte.hu>
References: <cover.1259059549.git.tim@klingt.org>
 <4B0BBBA8.2090604@klingt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BBBA8.2090604@klingt.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Pekka Cc:-ed)

* Tim Blechmann <tim@klingt.org> wrote:

> branch profiling on my nehalem machine showed 99% incorrect branch hints:
> 
>    28459  7678524  99 __cache_alloc_node             slab.c
>   3551
> 
> Signed-off-by: Tim Blechmann <tim@klingt.org>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index f70b326..4125fcd 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
> gfp_t flags, int nodeid,
>  	slab_irq_save(save_flags, this_cpu);
>   	this_node = cpu_to_node(this_cpu);
> -	if (unlikely(nodeid == -1))
> +	if (nodeid == -1)
>  		nodeid = this_node;
>   	if (unlikely(!cachep->nodelists[nodeid])) {
> -- 
> 1.6.4.2
> 
> 


