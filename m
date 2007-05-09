Return-Path: <linux-kernel-owner+w=401wt.eu-S935327AbXEIBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935327AbXEIBfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbXEIBf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:35:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755573AbXEIBf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:35:26 -0400
Date: Tue, 08 May 2007 18:35:26 -0700 (PDT)
Message-Id: <20070508.183526.108739707.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jeremy@goop.org, hch@infradead.org, ak@suse.de, akpm@linux-foundation.org,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org,
       shemminge@linux-foundation.org, rusty@rustcorp.com.au,
       Keir.Fraser@cl.cam.ac.uk
Subject: Re: [1/2] [NET] link_watch: Move link watch list into net_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070508121322.GA21647@gondor.apana.org.au>
References: <20070505102305.GA12771@gondor.apana.org.au>
	<463F95C3.60407@goop.org>
	<20070508121322.GA21647@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 8 May 2007 22:13:22 +1000

> [NET] link_watch: Move link watch list into net_device
> 
> These days the link watch mechanism is an integral part of the
> network subsystem as it manages the carrier status.  So it now
> makes sense to allocate some memory for it in net_device rather
> than allocating it on demand.
> 
> In fact, this is necessary because we can't tolerate a memory
> allocation failure since that means we'd have to potentially
> throw a link up event away.
> 
> It also simplifies the code greatly.
> 
> In doing so I discovered a subtle race condition in the use
> of singleevent.  This race condition still exists (and is
> somewhat magnified) without singleevent but it's now plugged
> thanks to an smp_mb__before_clear_bit.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
