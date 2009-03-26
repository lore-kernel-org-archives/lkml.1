Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZCZDlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZCZDlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZCZDlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:41:42 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:55395 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753124AbZCZDll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:41:41 -0400
Date: Thu, 26 Mar 2009 11:40:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326034059.GA14514@gondor.apana.org.au>
References: <20090325122635.GA6489@gondor.apana.org.au> <20090325225456.GA3271@ami.dom.local> <20090326024129.GA13982@gondor.apana.org.au> <20090325.202050.08183381.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325.202050.08183381.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:20:50PM -0700, David Miller wrote:
>
> There is still a difference compared to your fix Herbert.  Jarek's
> patch flushes GRO first before the unlink.
> 
> I still believe that's critical, although like you I can't pinpoint
> why.
> 
> I know that GRO ought to be disabled here, but what if for some reason
> it isn't? :-)

Sure, I can accept that somehow someone has enabled GRO :) But
I'd still like to know why flushing the GRO afterwards would
lead to a hang.

> Adam Richter has successfully tested Jarek's variant, and if Ingo's
> tests show that it makes his problem go away too then I'm definitely
> going with Jarek's patch.

I don't have a problem with that.

I've asked Adam to test my patch as well.  So far the only failure
case against it has been on Ingo's machine, where the process_backlog
path isn't involved.  Yes it's used for loopback, but he's seeing
the hang on eth0, which with that config uses netif_receive_skb
so it should continue to work even if process_backlog completely
seizes up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
