Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbXKQPXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbXKQPXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXKQPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:22:58 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4021 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752130AbXKQPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:22:58 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: andi@firstfloor.org (Andi Kleen)
Subject: Re: [NET]: rt_check_expire() can take a long time, add a cond_resched()
Cc: arjan@infradead.org, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, netdev@vget.kernel.org, mingo@elte.hu
Organization: Core
In-Reply-To: <p73k5ohav4n.fsf@bingen.suse.de>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1ItPUJ-0005Ue-00@gondolin.me.apana.org.au>
Date: Sat, 17 Nov 2007 23:21:39 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
>
>>> > With the extra check (and *much* less function calls), each run
>>> > takes 25ms
> 
> ms?!? The numbers sound wrong. Wrong unit? 

That's quite possible with a huge routing cache.  I think that's
the reason Eric is doing this in the first place.

>> however... this is likely a good argument for making cond_resched() as a
>> whole a #define (or inline) that does this test and then calls the out
>> of line code (which then doesn't need to retest, so it avoids the
>> double test)...
> 
> Disadvantage would be that might_sleep would be commonly skipped then
> (unless you actually need to reschedule) 
> But perhaps that's not a big issue.

On a related note, would it be possible for cond_resched() to
be compiled out completely if we're doing real preemption as
opposed to voluntary preemption?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
