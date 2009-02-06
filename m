Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZBFK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZBFK6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZBFK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:58:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:28751 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZBFK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:58:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xOvyNQsBf7DLPiKdURlHoP1oNL5i0fEFp2aeUjWy0EuBxSWsxHsgHgFmOCPChpdiNy
         o10qtn3i2eSQncoF9SQk+1GgnclruXeOkIemZLlZFnsS0kdYPyXETZn7s4abq/SnK5c4
         ugLjJV5ePVezOgtTiN2bmCluVCebgw4cMa/4g=
Date: Fri, 6 Feb 2009 10:58:07 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090206105807.GD4879@ff.dom.local>
References: <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090205.235258.257422341.davem@davemloft.net> <20090206091034.GA4879@ff.dom.local> <20090206092326.GC6645@gondor.apana.org.au> <20090206095119.GC4879@ff.dom.local> <20090206102822.GB7175@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206102822.GB7175@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 09:28:22PM +1100, Herbert Xu wrote:
> On Fri, Feb 06, 2009 at 09:51:20AM +0000, Jarek Poplawski wrote:
> >
> > OK, but since there is not so much difference, and we need to waste
> > it in some cases anyway, plus handle it later some special way, I'm
> > a bit in doubt.
> 
> Well the thing is cards that don't support SG on tx probably
> don't support jumbo frames either.

?? I mean this 128 byte chunk would be hard to reuse after copying
to skb->data, and if reused, we could miss this for some NICs on TX,
so the whole packed would need a copy.

BTW, David mentioned something simple like sk_sndmsg_page would be
enough, but I guess not for these non-SG NICs. We have to allocate
bigger chunks for them, so more fragmentation to handle.

Cheers,
Jarek P.
