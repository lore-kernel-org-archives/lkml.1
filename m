Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYIUG5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYIUG5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 02:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYIUG5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 02:57:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59948
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbYIUG5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 02:57:39 -0400
Date: Sat, 20 Sep 2008 23:57:27 -0700 (PDT)
Message-Id: <20080920.235727.247411045.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: dwalker@mvista.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
References: <20080920.125949.193703969.davem@davemloft.net>
	<E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 21 Sep 2008 15:05:45 +0900

> Unfortunately doing this with IPsec is going to be non-trivial
> since we still want to maintain packet ordering inside IPsec
> and you don't get the inner flow information until you decrypt
> the packet.

Steffen has mechanisms by which to deal with this in his patches.

> So if we want to process IPsec packets in parallel it's best to
> implement that from within the crypto API where we can queue the
> result in order to ensure proper ordering.

That's another option, of course.  And crypto could use remote
softirqs even for that :-)

> Of course, we need to balance any effort spent on this with the
> likelihood that hardware improvements will soon make this obsolete
> (for IPsec anyway).

True, but old hardware will always exist.

A lot of very reasonable machines out there will benefit from software
RX flow seperation.
