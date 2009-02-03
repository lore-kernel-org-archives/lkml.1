Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZBCMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZBCMe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBCMeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:34:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34386 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbZBCMen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:34:43 -0500
Date: Tue, 3 Feb 2009 23:33:38 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: david@lang.hm, Jarek Poplawski <jarkao2@gmail.com>,
       David Miller <davem@davemloft.net>, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203123338.GA9446@gondor.apana.org.au>
References: <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203112431.GA8746@gondor.apana.org.au> <20090203114944.GA21957@ioremap.net> <alpine.DEB.1.10.0902030458390.28633@asgard.lang.hm> <20090203121219.GB22427@ioremap.net> <20090203121808.GA9218@gondor.apana.org.au> <20090203123015.GA23746@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203123015.GA23746@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 03:30:15PM +0300, Evgeniy Polyakov wrote:
>
> But we can proceed the discussion in case something interesting will
> appear. For example I can hack up e1000e driver to do a dumb copy of 9k
> each time it has received a jumbo frame and compare it with usual 1.5k
> MTU performance. But getting that modern CPUs are loafing with noticebly
> big IO chunks, this may only show that CPU was increased with the copy.
> But still may work.

Comparing performance is pointless because the only time you need
to do the copy is when the allocator has failed.  So there is *no*
alternative to copying, regardless of how slow it is.

You can always improve the allocator whether we do this copying
fallback or not.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
