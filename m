Return-Path: <linux-kernel-owner+w=401wt.eu-S938040AbXHPCXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938040AbXHPCXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936463AbXHPCXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:23:23 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:39078 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755535AbXHPCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:23:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Oq+XREsqbAMIl7CpBIjmAY5bG10dWgKAmiOcS7hl83Z7oP3xhOl9DZ3t7M8ZNeVvdH3ZE31ajrWCVogkn/ssv8LrlTeoDwgicVE8KIQg1xssoFXx26w02XmKvvxOhzIcKP58PuIw40mBpbtUEtNaTbj7smN8eUky4myeLgUUKFs=  ;
X-YMail-OSG: tht85oAVM1nfwFiB8HxWh1DU5dhlzffts1tpqvS0y6oKaDCf
Message-ID: <46C3B50E.7010702@yahoo.com.au>
Date: Thu, 16 Aug 2007 12:23:10 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Herbert Xu <herbert.xu@redhat.com>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, linux-kernel@vger.kernel.org, rpjday@mindspring.com,
       ak@suse.de, netdev@vger.kernel.org, cfriesen@nortel.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       satyam@infradead.org, clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, davem@davemloft.net,
       wensong@linux-vs.org, wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org>
In-Reply-To: <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>>> Part of the motivation here is to fix heisenbugs.  If I knew where they
>>
>>
>> By the same token we should probably disable optimisations
>> altogether since that too can create heisenbugs.
> 
> 
> Almost everything is a tradeoff; and so is this.  I don't
> believe most people would find disabling all compiler
> optimisations an acceptable price to pay for some peace
> of mind.

So why is this a good tradeoff?

I also think that just adding things to APIs in the hope it might fix
up some bugs isn't really a good road to go down. Where do you stop?

On the actual proposal to make atomic_operators volatile: I think the
better approach in the long term, for both maintainability of the
code and education of coders, is to make the use of barriers _more_
explicit rather than sprinkling these "just in case" ones around.

You may get rid of a few atomic_read heisenbugs (in noise when
compared to all bugs), but if the coder was using a regular atomic
load, or a test_bit (which is also atomic), etc. then they're going
to have problems.

It would be better for Linux if everyone was to have better awareness
of barriers than to hide some of the cases where they're required.
A pretty large number of bugs I see in lock free code in the VM is
due to memory ordering problems. It's hard to find those bugs, or
even be aware when you're writing buggy code if you don't have some
feel for barriers.

-- 
SUSE Labs, Novell Inc.
