Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbXJ3OUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbXJ3OUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXJ3OU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:20:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19577 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXJ3OU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:20:27 -0400
Date: Tue, 30 Oct 2007 15:17:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing
	loops
Message-ID: <20071030141754.GT4993@kernel.dk>
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au> <20071029201627.GD7499@kernel.dk> <20071030000827.GA9037@gondor.apana.org.au> <20071030055056.GG7499@kernel.dk> <20071030141820.GA16501@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030141820.GA16501@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Herbert Xu wrote:
> On Tue, Oct 30, 2007 at 06:50:58AM +0100, Jens Axboe wrote:
> >
> > How so? The reason you changed it to sg_init_table() + sg_set_buf() is
> > exactly because sg_init_one() didn't properly init the entry (as they
> > name promised).
> 
> For one of the cases yes but the other one repeatedly calls
> sg_init_one on the same sg entry while we really only need
> to initialise it once and call sg_set_buf afterwards.
> 
> Normally this is irrelevant but the loops in question are
> trying to estimate the speed of the algorithms so it's good
> to exclude as much noise from them as possible.

Ah OK, I was referring to the replacement mentioned above.

-- 
Jens Axboe

