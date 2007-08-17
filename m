Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXHQH0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXHQH0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXHQH02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:26:28 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33902 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751253AbXHQH00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:26:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=j7wnqhYOwV/53IPyhetm3XDiawl7FToqg0+nhtSjPuslR1SHdUIX5bAHcAD4smwvCu3VZSdUgJDJgVygOKN1uCy+tZLPRRe+YQgLqjz51rKcVRgcZAuUfYqpFycyXNBKEfw3vR9liYUpXajY4AuUGoWrHLZx0AuHBGeOH+ZSX7w=  ;
X-YMail-OSG: 56o_y8oVM1m5xuhKot6DC5kMYodfdxDikqMSR.WIg.JhV1BFK0WTKkogOBm0x4sexNhbtTxHUQ--
Message-ID: <46C54D94.5080803@yahoo.com.au>
Date: Fri, 17 Aug 2007 17:26:12 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       heiko.carstens@de.ibm.com, horms@verge.net.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rpjday@mindspring.com, ak@suse.de, netdev@vger.kernel.org,
       cfriesen@nortel.com, Andrew Morton <akpm@linux-foundation.org>,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org> <46C3B50E.7010702@yahoo.com.au> <194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org> <46C505B2.6030704@yahoo.com.au> <18117.4848.695269.72976@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708162033400.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708171016160.3666@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708171016160.3666@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:

> #define atomic_read_volatile(v)				\
> 	({						\
> 		forget((v)->counter);			\
> 		((v)->counter);				\
> 	})
> 
> where:

*vomit* :)

Not only do I hate the keyword volatile, but the barrier is only a
one-sided affair so its probable this is going to have slightly
different allowed reorderings than a real volatile access.

Also, why would you want to make these insane accessors for atomic_t
types? Just make sure everybody knows the basics of barriers, and they
can apply that knowledge to atomic_t and all other lockless memory
accesses as well.


> #define forget(a)	__asm__ __volatile__ ("" :"=m" (a) :"m" (a))

I like order(x) better, but it's not the most perfect name either.

-- 
SUSE Labs, Novell Inc.
