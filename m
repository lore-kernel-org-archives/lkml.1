Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZALM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZALM72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZALM7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:59:17 -0500
Received: from kandzendo.ru ([195.178.208.66]:48287 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZALM7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:59:16 -0500
Date: Mon, 12 Jan 2009 15:59:14 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090112125914.GA12142@ioremap.net>
References: <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au> <20090112120257.GA5697@gondor.apana.org.au> <20090112124545.GA10893@ioremap.net> <20090112125607.GA6370@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112125607.GA6370@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:56:07PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > As a long-term solution this sounds as the best case, but introduces
> > quite heavy overhead for the allocators. Right now we allocate
> > 1500+shared_info rounded up to the nearest power of the two (2k), but
> > then we will either need to have own network allocator (I have one :) or
> > allocate PAGE_SIZE+shared_info rounded up to the pwoer of the two (i.e.
> > 8k), which is unfeasible.
> 
> No that's not what I was suggesting.  The page split model allocates
> an skb with a very small head that accomodates only the headers.
> All payload is stored in the frags structure.
> 
> For 1500-byte packets, we can manage the payload area efficiently
> by dividing each allocated page into 2K chunks.  The page will
> then be automatically freed once all the 2K chunks on it have been
> freed through the page ref count mechanism.

That's the part I referred to as a network own allocator. We can have
multiple kmem_caches though for the popular MTUs and round up the
requested size otherwise.

-- 
	Evgeniy Polyakov
