Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZA3WQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZA3WQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbZA3WQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:16:47 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60191 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522AbZA3WQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:16:46 -0500
Date: Sat, 31 Jan 2009 09:16:04 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, zbr@ioremap.net, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090130221604.GD11381@gondor.apana.org.au>
References: <20090126212130.GA4338@ioremap.net> <20090126.221056.174077798.davem@davemloft.net> <20090127074048.GA4197@ff.dom.local> <20090130.134227.123379239.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130.134227.123379239.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 01:42:27PM -0800, David Miller wrote:
> 
> Hmmm, Jarek's comments here made me realize that we might be
> able to do some hack with cooperation with SLAB.
> 
> Basically the idea is that if the page count of a SLAB page
> is greater than one, SLAB will not use that page for new
> allocations.
> 
> It's cheesy and the SLAB developers will likely barf at the
> idea, but it would certainly work.

I'm not going anywhere near that discussion :)

> Back to real life, I think long term the thing to do is to just do the
> cached page allocator thing we'll be doing after Jarek's socket page
> patch is integrated, and for best performance the driver has to
> receive it's data into pages, only explicitly pulling the ethernet
> header into the linear area, like NIU does.

Yes that sounds like the way to go.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
