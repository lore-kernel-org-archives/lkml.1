Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZGTIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZGTIuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZGTIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:50:15 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42668 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869AbZGTIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:50:14 -0400
Date: Mon, 20 Jul 2009 16:50:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       netdev@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 2/7] crypto: authenc - convert to ahash
Message-ID: <20090720085004.GA5018@gondor.apana.org.au>
References: <20090716111548.GP20288@secunet.com> <20090716111747.GR20288@secunet.com> <20090717.100334.160030992.davem@davemloft.net> <20090720062643.GA20288@secunet.com> <20090720065514.GB4026@gondor.apana.org.au> <20090720075701.GC20288@secunet.com> <20090720082116.GA4797@gondor.apana.org.au> <20090720083640.GD20288@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720083640.GD20288@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:36:40AM +0200, Steffen Klassert wrote:
> 
> For the crypto-layer it's just scatterwalk_sg_chain() that removes the
> termination bit. 

The history behind this is that the crypto layer has used chaining
way before generic chaining was invented.  When the generic code
was added I tried to convert crypto over to that, however, that
failed because generic chaining was not ported to every architecture.

So that's why the crypto layer still retains its own chaining.

> For the block-layer it's blk_rq_map_integrity_sg() and two times in
> blk_rq_map_sg().

I suppose we should ask Jens whether he thinks this is worth adding
an interface over?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
