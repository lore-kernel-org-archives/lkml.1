Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZCYA01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZCYA01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZCYAZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:25:26 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59040 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755168AbZCYAZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:25:25 -0400
Date: Wed, 25 Mar 2009 08:24:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325002459.GA2297@gondor.apana.org.au>
References: <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090324.154743.200977253.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324.154743.200977253.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 03:47:43PM -0700, David Miller wrote:
>
> > I think the problem is that we need to do the GRO flush before the
> > list delete and clearing the NAPI_STATE_SCHED bit.
> 
> Ok Herbert, I'm even more sure of this because in your original commit
> log message you mention:
> 
> 	This simply doesn't work since we need to flush the held
> 	GRO packets first.

That's only because I was calling __napi_complete, which is used
by drivers in general so I added the check to ensure that GRO
packets have been flushed.  Now that we're open-coding it this is
no longer a requirement.

But what's more GRO should be off on Ingo's test machines because
we haven't added anything to turn it on by default for non-NAPI
drivers.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
