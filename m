Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbZCaNay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbZCaNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbZCaNam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:30:42 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49537 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZCaNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:30:41 -0400
Date: Tue, 31 Mar 2009 09:26:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903310925130.24040@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301718080.25929@qirst.com> <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com> <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, David Rientjes wrote:

> @@ -3833,7 +3830,9 @@ static ssize_t order_store(struct kmem_cache *s,
>  	if (order > slub_max_order || order < slub_min_order)
>  		return -EINVAL;
>
> +	thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
>  	calculate_sizes(s, order);
> +	s->min_free_watermark = oo_objects(s->oo) * thrash_ratio / 100;
>  	return length;
>  }
>

Hmmm.. Still calculating the trash ratio based on existing objects per
slab and then resetting the objects per slab to a different number.
Shouldnt the trash_ratio simply be zapped to an initial value if the
number of objects per slab changes?

