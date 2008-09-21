Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYIUGGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYIUGGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 02:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYIUGGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 02:06:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48400 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbYIUGGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 02:06:13 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
Cc: dwalker@mvista.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
Organization: Core
In-Reply-To: <20080920.125949.193703969.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
Date: Sun, 21 Sep 2008 15:05:45 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
> receive using multiple RX queues and MSI-X interrupts.  It's
> also for things like IPSEC where the per-packet cpu usage
> is so huge (to do the crypto) that it makes sense to even
> split up the work to multiple cpus within the same flow.

Unfortunately doing this with IPsec is going to be non-trivial
since we still want to maintain packet ordering inside IPsec
and you don't get the inner flow information until you decrypt
the packet.

So if we want to process IPsec packets in parallel it's best to
implement that from within the crypto API where we can queue the
result in order to ensure proper ordering.

Of course, we need to balance any effort spent on this with the
likelihood that hardware improvements will soon make this obsolete
(for IPsec anyway).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
