Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZBWQRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZBWQRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBWQRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:17:39 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60461 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbZBWQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:17:38 -0500
Date: Mon, 23 Feb 2009 11:09:22 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] slub: move min_partial to struct kmem_cache
In-Reply-To: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0902231108200.22276@qirst.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, David Rientjes wrote:

> +static void calculate_min_partial(struct kmem_cache *s, unsigned long min)
> +{
> +	if (min < MIN_PARTIAL)
> +		min = MIN_PARTIAL;
> +	else if (min > MAX_PARTIAL)
> +		min = MAX_PARTIAL;
> +	s->min_partial = min;
> +}
> +
>  /*
>   * calculate_sizes() determines the order and the distribution of data within
>   * a slab object.
> @@ -2319,6 +2317,11 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
>  	if (!calculate_sizes(s, -1))
>  		goto error;
>
> +	/*
> +	 * The larger the object size is, the more pages we want on the partial
> +	 * list to avoid pounding the page allocator excessively.
> +	 */
> +	calculate_min_partial(s, ilog2(s->size));
>  	s->refcount = 1;
>  #ifdef CONFIG_NUMA
>  	s->remote_node_defrag_ratio = 1000;
>

Move the ilog2 use into calculate_min_partial()? Otherweise
calculate_min_partial is merely enforcing limits and not doing any
calculations.

