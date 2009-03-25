Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbZCYAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbZCYAx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbZCYAdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:33:20 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56284 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755143AbZCYAdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:33:19 -0400
Date: Wed, 25 Mar 2009 08:32:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090325003235.GC2297@gondor.apana.org.au>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324153616.GA31143@elte.hu> <20090324154717.GA7506@elte.hu> <20090324155911.GA30824@gondor.apana.org.au> <20090324160241.GA11060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160241.GA11060@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 05:02:41PM +0100, Ingo Molnar wrote:
> 
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> > What's the NIC and config on this one? If it's still using the 
> > legacy/netif_rx path, where GRO is off by default, this patch 
> > should make it exactly the same as with my original patch 
> > reverted.
> 
> Same forcedeth box i reported before. Config below. (note: if you 
> want to use it you need to run it through 'make oldconfig', with all 
> defaults accepted)
>
> CONFIG_FORCEDETH=y
> CONFIG_FORCEDETH_NAPI=y

This means that we shouldn't even invoke netif_rx/process_backlog,
so something else is going on.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
