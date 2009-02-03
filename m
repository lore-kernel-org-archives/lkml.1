Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZBCLZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZBCLZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCLZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:25:30 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43866 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751961AbZBCLZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:25:30 -0500
Date: Tue, 3 Feb 2009 22:24:31 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       w@1wt.eu, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203112431.GA8746@gondor.apana.org.au>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203111012.GA16878@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 02:10:12PM +0300, Evgeniy Polyakov wrote:
>
> I even believe that for some hardware it is the only way to deal
> with the jumbo frames.

Not necessarily.  Even if the hardware can only DMA into contiguous
memory, we can always allocate a sufficient number of contiguous
buffers initially, and then always copy them into fragmented skbs
at receive time.  This way the contiguous buffers are never
depleted.

Granted copying sucks, but this is really because the underlying
hardware is badly designed.  Also copying is way better than
not receiving at all due to memory fragmentation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
