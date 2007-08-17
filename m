Return-Path: <linux-kernel-owner+w=401wt.eu-S1765594AbXHQCT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765594AbXHQCT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbXHQCTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:19:47 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37713 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759535AbXHQCTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:19:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=tPQc/WK3umlUr+yPpn7yGADtLLZj/6StsTUwBP9414/2WteUNSTln3AV7Ia/AEK8/hRqXKGx27bwuTmY6nv9KI8PPeqNDjxw/c5qngk3jbU8jKtZOumjJ6AD75z0oOD8Z/JZUyFkaUmS00rZjEYGVwKET1uwrCUMbvHaVby+pYo=  ;
X-YMail-OSG: aBdBu5AVM1lVJDUHsjX3_eyXpZSNb.znK1IRiBqnZCYtYc.PmWQ.b6yASBsQV6ieNp2fJ3poEw--
Message-ID: <46C505B2.6030704@yahoo.com.au>
Date: Fri, 17 Aug 2007 12:19:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jesper.juhl@gmail.com,
       linux-arch@vger.kernel.org, zlynx@acm.org, satyam@infradead.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org> <46C3B50E.7010702@yahoo.com.au> <194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org>
In-Reply-To: <194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>>>>> Part of the motivation here is to fix heisenbugs.  If I knew where 
>>>>> they
>>>>
>>>>
>>>>
>>>> By the same token we should probably disable optimisations
>>>> altogether since that too can create heisenbugs.
>>>
>>> Almost everything is a tradeoff; and so is this.  I don't
>>> believe most people would find disabling all compiler
>>> optimisations an acceptable price to pay for some peace
>>> of mind.
>>
>>
>> So why is this a good tradeoff?
> 
> 
> It certainly is better than disabling all compiler optimisations!

It's easy to be better than something really stupid :)

So i386 and x86-64 don't have volatiles there, and it saves them a
few K of kernel text. What you need to justify is why it is a good
tradeoff to make them volatile (which btw, is much harder to go
the other way after we let people make those assumptions).


>> I also think that just adding things to APIs in the hope it might fix
>> up some bugs isn't really a good road to go down. Where do you stop?
> 
> 
> I look at it the other way: keeping the "volatile" semantics in
> atomic_XXX() (or adding them to it, whatever) helps _prevent_ bugs;

Yeah, but we could add lots of things to help prevent bugs and
would never be included. I would also contend that it helps _hide_
bugs and encourages people to be lazy when thinking about these
things.

Also, you dismiss the fact that we'd actually be *adding* volatile
semantics back to the 2 most widely tested architectures (in terms
of test time, number of testers, variety of configurations, and
coverage of driver code). This is a very important different from
just keeping volatile semantics because it is basically a one-way
API change.


> certainly most people expect that behaviour, and also that behaviour
> is *needed* in some places and no other interface provides that
> functionality.

I don't know that most people would expect that behaviour. Is there
any documentation anywhere that would suggest this?

Also, barrier() most definitely provides the required functionality.
It is overkill in some situations, but volatile is overkill in _most_
situations. If that's what you're worried about, we should add a new
ordering primitive.


> [some confusion about barriers wrt atomics snipped]

What were you confused about?

-- 
SUSE Labs, Novell Inc.
