Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYDUKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYDUKTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYDUKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:19:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50689 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbYDUKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:19:25 -0400
Date: Mon, 21 Apr 2008 18:19:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: poor network loopback performance and scalability
Message-ID: <20080421101908.GC9295@gondor.apana.org.au>
References: <E1JnmdQ-0001qO-00@gondolin.me.apana.org.au> <20080420.203810.183610437.davem@davemloft.net> <20080421081103.GA31328@elte.hu> <20080421.011623.67335122.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421.011623.67335122.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 01:16:23AM -0700, David Miller wrote:
>
> What's being discussed is having the top of the transmit call path
> getting a socket "buffer" pointer, that it can feed back into the
> packet input path directly.  Loopback would return buffer pointers
> from ->hard_start_xmit() instead of passing them netif_rx().  The top
> of the transmit call path, upon getting a non-NULL buffer returned,
> would pass it to netif_receive_skb().

Yes this will definitely reduce the per-packet cost.  The other
low-hanging fruit is to raise the loopback MTU to just below 64K.
I belive the current value is a legacy from the days when we didn't
support skb page frags so everything had to be physically contiguous.

Longer term we could look at generating packets > 64K on lo, for
IPv6 anyway.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
