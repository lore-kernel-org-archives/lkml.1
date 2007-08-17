Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbXHQWuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbXHQWuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXHQWu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:50:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:33158 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXHQWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:50:26 -0400
In-Reply-To: <alpine.LFD.0.999.0708171016160.3666@enigma.security.iitk.ac.in>
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org> <46C3B50E.7010702@yahoo.com.au> <194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org> <46C505B2.6030704@yahoo.com.au> <18117.4848.695269.72976@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708162033400.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708171016160.3666@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f5796b5aa38ae6305c65ffa0340ba295@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, heiko.carstens@de.ibm.com,
       horms@verge.net.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rpjday@mindspring.com, ak@suse.de, netdev@vger.kernel.org,
       cfriesen@nortel.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-arch@vger.kernel.org, jesper.juhl@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, Linus Torvalds <torvalds@linux-foundation.org>,
       wensong@linux-vs.org, wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Sat, 18 Aug 2007 00:49:08 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> #define forget(a)	__asm__ __volatile__ ("" :"=m" (a) :"m" (a))
>
> [ This is exactly equivalent to using "+m" in the constraints, as 
> recently
>   explained on a GCC list somewhere, in response to the patch in my 
> bitops
>   series a few weeks back where I thought "+m" was bogus. ]

[It wasn't explained on a GCC list in response to your patch, as
far as I can see -- if I missed it, please point me to an archived
version of it].

One last time: it isn't equivalent on older (but still supported
by Linux) versions of GCC.  Current versions of GCC allow it, but
it has no documented behaviour at all, so use it at your own risk.


Segher

