Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZCZH7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZCZH7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZCZH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:59:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44057
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbZCZH7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:59:40 -0400
Date: Thu, 26 Mar 2009 00:59:27 -0700 (PDT)
Message-Id: <20090326.005927.175146349.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325120840.GA6351@gondor.apana.org.au>
References: <20090324.191134.05205089.davem@davemloft.net>
	<20090325073349.GF25833@elte.hu>
	<20090325120840.GA6351@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 25 Mar 2009 20:08:40 +0800

> GRO: Disable GRO on legacy netif_rx path
> 
> When I fixed the GRO crash in the legacy receive path I used
> napi_complete to replace __napi_complete.  Unfortunately they're
> not the same when NETPOLL is enabled, which may result in us
> not calling __napi_complete at all.
> 
> What's more, we really do need to keep the __napi_complete call
> within the IRQ-off section since in theory an IRQ can occur in
> between and fill up the backlog to the maximum, causing us to
> lock up.
> 
> Since we can't seem to find a fix that works properly right now,
> this patch reverts all the GRO support from the netif_rx path.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, and will push to -stable.
