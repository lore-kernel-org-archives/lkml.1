Return-Path: <linux-kernel-owner+w=401wt.eu-S938801AbXHILJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938801AbXHILJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763045AbXHILJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:09:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2147 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762331AbXHILJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:09:06 -0400
Date: Thu, 9 Aug 2007 16:30:55 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Message-ID: <20070809083055.GA19048@gondor.apana.org.au>
References: <E1IIwQx-000468-00@gondolin.me.apana.org.au> <46BAC6AD.7050603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BAC6AD.7050603@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:47:57AM -0400, Chris Snook wrote:
>
> If they're not doing anything, sure.  Plenty of loops actually do some sort 
> of real work while waiting for their halt condition, possibly even work 
> which is necessary for their halt condition to occur, and you definitely 
> don't want to be doing cpu_relax() in this case.  On register-rich 
> architectures you can do quite a lot of work without needing to reuse the 
> register containing the result of the atomic_read().  Those are precisely 
> the architectures where barrier() hurts the most.

I have a problem with this argument.  The same loop could be
using a non-atomic as long as the updaters are serialised.  Would
you suggest that we turn such non-atomics into volatiles too?

Any loop that's waiting for an external halt condition either
has to schedule away (which is a barrier) or you'd be busy
waiting in which case you should use cpu_relax.

Do you have an example where this isn't the case?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
