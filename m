Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXCUPi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXCUPi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXCUPi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:38:28 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:33348 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbXCUPi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:38:27 -0400
Date: Wed, 21 Mar 2007 16:36:35 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
Message-Id: <20070321163635.82697f08.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0703210737400.1573@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703210737400.1573@graphe.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 07:41:46 -0700 (PDT)
Christoph Lameter <christoph@lameter.com> wrote:

> On Wed, 21 Mar 2007, Eric Dumazet wrote:
> 
> > In order to avoid a cache miss in kmem_cache_free() on NUMA and reduce hot path length, we could exploit the following common facts.
> > 
> > 1) MAX_NUMNODES <= 64
> 
> MAX_NUMNODES == 1024 on IA64 and may be on x86_64 in the future.

So what ? I am very happy for you Christoph.

Average linux machines (ie more than 99.99 % on this planet) are using MAX_NUMNODES <= 64

If you read my patch, your lovely 1024 nodes machines will run as before : No change at all for big machines.

>  
> > 2) alignment of 'struct kmem_cache *' can be >= 64
> > 
> > The following patch changes the page->lru.next to contain not only the 
> > 'struct kmem_cache *' pointer, but also the nodeid in the low order 
> > bits.
> 
> Nack.
> 
> I would suggest you audit slab and make sure that we never fall back and 
> always enter a slab on the node of page_to_nid(page). If 
> all allocations use GFP_THISNODE then you should be safe and then we can 
> remove the nodeid from the slab structure and simply use the available 
> node information in the page struct.
> 

Last time I checked 'struct page', they was no nodeid in it.

I cooked this patch because you told me it was possible to have a 'slab nodeid' different than page_to_nid(obj). Now you want me to prove the contrary. Me confused.

