Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYGXNF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYGXNF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGXNFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:05:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39061 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751880AbYGXNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:05:12 -0400
Date: Thu, 24 Jul 2008 21:04:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Patrick McHardy <kaber@trash.net>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, Dave Jones <davej@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20080724130422.GB7426@gondor.apana.org.au>
References: <20080724060448.GA10203@elte.hu> <84144f020807240540vbe7ef50uee2cacabe8016546@mail.gmail.com> <20080724125004.GA7426@gondor.apana.org.au> <200807242256.09107.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807242256.09107.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 10:56:08PM +1000, Nick Piggin wrote:
>
> OTOH, skb allocation uses kmalloc don't they? So you could still use
> SLOB ksize for that I guess.

Yes I was referring to the data portion which is kmalloc'ed.
That is also why I'm interested in ksize because a priori we
don't know exactly how big it's going to be.  However, we do
know that statistically 1500 will dominate.

I'm not interested in ksize for kmem_cache at all.  So in fact
we could have something simpler that's based on kmalloc's rounding
algorithm instead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
