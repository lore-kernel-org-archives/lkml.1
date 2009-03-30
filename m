Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZC3Ooa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZC3Ooa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZC3OoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:44:21 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:58583 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZC3OoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:44:20 -0400
Date: Mon, 30 Mar 2009 10:30:41 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903301026580.13333@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, David Rientjes wrote:

> @@ -2291,10 +2292,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  	/*
>  	 * Determine the number of objects per slab
>  	 */
> +	if (oo_objects(s->oo))
> +		thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
>  	s->oo = oo_make(order, size);

s->oo is set *after* you check it. Check oo_objects after the value has
been set please.


