Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZCWNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZCWNhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZCWNhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:37:33 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41919 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCWNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:37:32 -0400
Date: Mon, 23 Mar 2009 09:33:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
In-Reply-To: <1237794502.6313.21.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0903230931570.4095@qirst.com>
References: <49AD3433.9000001@cn.fujitsu.com> <1237794502.6313.21.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Pekka Enberg wrote:

> > +static inline void *portion_to_obj(void *portion)
> > +{
> > +	struct page *page = virt_to_head_page(portion);
> > +	struct slab *slab = page_get_slab(page);
> > +	struct kmem_cache *cache = page_get_cache(page);
> > +	unsigned int offset = portion - slab->s_mem;
> > +	unsigned int index = offset / cache->buffer_size;
> > +
> > +	return index_to_obj(cache, slab, index);
> > +}
>
> A minor nit: I think this would be more readable if you separated
> variable declarations from the initializations. Also, you can probably
> drop the inline from the function declaration and let GCC decide what to
> do.

Thats debatable. I find the setting up a number of variables
that are all dependend in the above manner very readable. They are usually
repetitive. Multiple functions use similar initializations.

