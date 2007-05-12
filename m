Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbXELCed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbXELCed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbXELCe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:34:27 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3210 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755745AbXELCe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:34:26 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: bhalevy@panasas.com (Benny Halevy)
Subject: Re: [PATCH 1/12] crypto: don't pollute the global namespace with  sg_next()
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <4643FD1C.1040401@panasas.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HmhQy-0003lu-00@gondolin.me.apana.org.au>
Date: Sat, 12 May 2007 12:34:12 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy <bhalevy@panasas.com> wrote:
>
> I was trying to say that the methods should be compatible, otherwise
> bugs can happen, and that your scheme is better since it can
> handle sglists with zero length entries that aren't the last.
> A case that might be valid after dma mapping and merging.
> If indeed this case is possible, this seems to be the right time
> to converge to your scheme.

Well right now this isn't possible because the crypto layer is not
directly hooked to any DMA code since it's (mostly) software only.

However, I completely agree that it should be converted to this new
scheme.  The only user of chaining right now is crypto/hmac.c so it
should be easy to fix.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
