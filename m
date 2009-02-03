Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZBCMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZBCMHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZBCMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:07:22 -0500
Received: from genesysrack.ru ([195.178.208.66]:46721 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZBCMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:07:20 -0500
Date: Tue, 3 Feb 2009 15:07:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       w@1wt.eu, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203120715.GA22427@ioremap.net>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203112431.GA8746@gondor.apana.org.au> <20090203114944.GA21957@ioremap.net> <20090203115313.GA9018@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203115313.GA9018@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:53:13PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > How many such preallocated frames is enough? Does it enough to have all
> > sockets recv buffer sizes divided by the MTU size? Or just some of them,
> > or... That will work but there are way too many corner cases.
> 
> Easy, the driver is already allocating them right now so we don't
> have to change a thing :)

How many? A hundred or so descriptors (or even several thousands) -
this really does not scale for the somewhat loaded IO servers, that's
why we frequently get questions why dmesg is filler with order-3 and
higher allocation failure dumps.

> All we have to do is change the refill mechanism to always allocate
> a replacement skb in the rx path, and if that fails, allocate a
> fragmented skb instead and copy the received data into it so that
> the contiguous skb can be reused.

Having a 'reserve' skb per socket is a good idea, but what if numbr of
sockets is way too big?

-- 
	Evgeniy Polyakov
