Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZBCLuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZBCLuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZBCLty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:49:54 -0500
Received: from corega.com.ru ([195.178.208.66]:56675 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZBCLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:49:54 -0500
Date: Tue, 3 Feb 2009 14:49:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       w@1wt.eu, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203114944.GA21957@ioremap.net>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203112431.GA8746@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203112431.GA8746@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:24:31PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > I even believe that for some hardware it is the only way to deal
> > with the jumbo frames.
> 
> Not necessarily.  Even if the hardware can only DMA into contiguous
> memory, we can always allocate a sufficient number of contiguous
> buffers initially, and then always copy them into fragmented skbs
> at receive time.  This way the contiguous buffers are never
> depleted.

How many such preallocated frames is enough? Does it enough to have all
sockets recv buffer sizes divided by the MTU size? Or just some of them,
or... That will work but there are way too many corner cases.

> Granted copying sucks, but this is really because the underlying
> hardware is badly designed.  Also copying is way better than
> not receiving at all due to memory fragmentation.

Maybe just do not allow jumbo frames when memory is fragmented enough
and fallback to the smaller MTU in this case? With LRO/GRO stuff there
should be not that much of the overhead compared to multiple-page
copies.

-- 
	Evgeniy Polyakov
