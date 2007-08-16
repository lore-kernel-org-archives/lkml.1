Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbXHPTic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbXHPTic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbXHPTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:38:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55537 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508AbXHPTiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:38:19 -0400
In-Reply-To: <46C3B50E.7010702@yahoo.com.au>
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org> <46C3B50E.7010702@yahoo.com.au>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jesper.juhl@gmail.com,
       linux-arch@vger.kernel.org, zlynx@acm.org, satyam@infradead.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 16 Aug 2007 21:32:03 +0200
To: Nick Piggin <nickpiggin@yahoo.com.au>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Part of the motivation here is to fix heisenbugs.  If I knew where 
>>>> they
>>>
>>>
>>> By the same token we should probably disable optimisations
>>> altogether since that too can create heisenbugs.
>> Almost everything is a tradeoff; and so is this.  I don't
>> believe most people would find disabling all compiler
>> optimisations an acceptable price to pay for some peace
>> of mind.
>
> So why is this a good tradeoff?

It certainly is better than disabling all compiler optimisations!

> I also think that just adding things to APIs in the hope it might fix
> up some bugs isn't really a good road to go down. Where do you stop?

I look at it the other way: keeping the "volatile" semantics in
atomic_XXX() (or adding them to it, whatever) helps _prevent_ bugs;
certainly most people expect that behaviour, and also that behaviour
is *needed* in some places and no other interface provides that
functionality.


[some confusion about barriers wrt atomics snipped]


Segher

