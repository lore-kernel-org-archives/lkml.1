Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYDUDi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYDUDi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbYDUDiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:38:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54967
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbYDUDiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:38:09 -0400
Date: Sun, 20 Apr 2008 20:38:10 -0700 (PDT)
Message-Id: <20080420.203810.183610437.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: poor network loopback performance and scalability
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1JnmdQ-0001qO-00@gondolin.me.apana.org.au>
References: <20080331113602.GA13526@elte.hu>
	<E1JnmdQ-0001qO-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 21 Apr 2008 11:24:04 +0800

> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> >   # ifconfig lo mtu 1048576
> 
> Chiming in late here, but 1048576 can't possibly work with IP
> which uses a 16-bit quantity as the length header.  In fact a
> quick test seems to indicate that an 1048576 mtu doesn't generate
> anything bigger than the default 16K mtu.

Right.

To move things forward, we should look into doing something
similar to what Al Viro suggested, which would be to return
an SKB pointer from the transmit path and call back into
netif_receive_skb() using that.
