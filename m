Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXCUQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXCUQIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932710AbXCUQIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:08:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43984 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbXCUQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:08:50 -0400
Date: Wed, 21 Mar 2007 17:08:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <christoph@lameter.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Message-ID: <20070321160846.GA25583@one.firstfloor.org>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321102231.7288f231.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:22:31AM +0100, Eric Dumazet wrote:
> In order to avoid a cache miss in kmem_cache_free() on NUMA and reduce hot path length, we could exploit the following common facts.
> 
> 1) MAX_NUMNODES <= 64
> 
> 2) alignment of 'struct kmem_cache *' can be >= 64
> 
> The following patch changes the page->lru.next to contain not only the 'struct kmem_cache *' pointer, but also the nodeid in the low order bits.
> 

It might be cleaner to just put it into flags on 64bit. There is enough
space there and we don't really care about 32bit NUMA machines.

-Andi
