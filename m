Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZC3Opm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZC3Opm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZC3OpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:45:20 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:38451 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZC3OpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:45:19 -0400
Date: Mon, 30 Mar 2009 10:41:03 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] slub: sort parital list when thrashing
In-Reply-To: <alpine.DEB.2.00.0903292243200.15813@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903301040160.13333@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>
 <alpine.DEB.2.00.0903292243200.15813@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, David Rientjes wrote:

> @@ -1720,6 +1727,15 @@ checks_ok:
>  	if (unlikely(!prior)) {
>  		add_partial(get_node(s, page_to_nid(page)), page, 1);
>  		stat(c, FREE_ADD_PARTIAL);
> +	} else if (c->slowpath_allocs >= SLAB_THRASHING_THRESHOLD) {
> +		/*
> +		 * If the cache is actively slab thrashing, it's necessary to
> +		 * move partial slabs to the head of the list so there isn't
> +		 * excessive partial list scanning while holding list_lock.
> +		 */
> +		if (!skip_partial(s, page))
> +			move_partial_to_head(get_node(s, page_to_nid(page)),
> +					     page);
>  	}
>
>  out_unlock:
>

This again adds code to a pretty hot path.

What is the impact of the additional hot path code?

