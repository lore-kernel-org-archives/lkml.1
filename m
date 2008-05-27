Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYE0Djq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYE0Djq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 23:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYE0Djg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 23:39:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:42393 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYE0Djf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 23:39:35 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
In-Reply-To: <20080526.192812.184590464.davem@davemloft.net>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 27 May 2008 13:39:02 +1000
Message-Id: <1211859542.3286.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-26 at 19:28 -0700, David Miller wrote:
> > But heh, it's you who was telling me that it would be a bad
> engineering
> > decision and we had to make everybody look like x86 & fully
> ordered :-)
> > I decided to agree back then and stuck all those nasty heavy
> barriers
> > in the powerpc variants of readl/writel/...
> 
> I still believe this.
> 
> It's just another complicated thing for driver authors to get wrong.
> The other side of the coin is of course the cost.
> 
> The only thing I am absolutely sure of is that we should make a
> decision fast, document it, and just stick to it.

Yes. As it is today, tg3 for example is potentially broken on all archs
with newer gcc unless we either add "memory" clobber to readl/writel or
stick some wmb's in there (just a random driver I picked).

So Linus, what is your take on that matter ?

Cheers,
Ben.


