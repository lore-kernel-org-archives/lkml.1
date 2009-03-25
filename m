Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZCYCJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZCYCJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbZCYCJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:09:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49390
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756839AbZCYCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:27 -0400
Date: Tue, 24 Mar 2009 19:09:14 -0700 (PDT)
Message-Id: <20090324.190914.117958201.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325003235.GC2297@gondor.apana.org.au>
References: <20090324155911.GA30824@gondor.apana.org.au>
	<20090324160241.GA11060@elte.hu>
	<20090325003235.GC2297@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 25 Mar 2009 08:32:35 +0800

> On Tue, Mar 24, 2009 at 05:02:41PM +0100, Ingo Molnar wrote:
> > 
> > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > > What's the NIC and config on this one? If it's still using the 
> > > legacy/netif_rx path, where GRO is off by default, this patch 
> > > should make it exactly the same as with my original patch 
> > > reverted.
> > 
> > Same forcedeth box i reported before. Config below. (note: if you 
> > want to use it you need to run it through 'make oldconfig', with all 
> > defaults accepted)
> >
> > CONFIG_FORCEDETH=y
> > CONFIG_FORCEDETH_NAPI=y
> 
> This means that we shouldn't even invoke netif_rx/process_backlog,
> so something else is going on.

There is always loopback which does netif_rx().

Combine that with the straight NAPI receive that forcedeth
is doing here and I'm sure there are all kinds of race
scenerios possible :-)

You're right about GRO not being relevant here.  To be honest
I wouldn't be disappointed if GRO was simply on by default
even for the legacy paths.
