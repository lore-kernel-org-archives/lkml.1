Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbXHTNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbXHTNjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXHTNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:39:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbXHTNjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:39:42 -0400
Message-ID: <46C99945.9080303@redhat.com>
Date: Mon, 20 Aug 2007 09:38:13 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Herbert Xu <herbert.xu@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Christoph Lameter <clameter@sgi.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <18117.6495.397597.582736@cargo.ozlabs.ibm.com> <20070817035342.GA14744@gondor.apana.org.au> <alpine.LFD.0.999.0708171142550.3666@enigma.security.iitk.ac.in> <46C55E90.7010407@yahoo.com.au> <alpine.LFD.0.999.0708171431150.3666@enigma.security.iitk.ac.in> <46C56ADF.8010501@cyberone.com.au> <alpine.LFD.0.999.0708171612440.3666@enigma.security.iitk.ac.in> <46C59717.4020108@cyberone.com.au> <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org> <46C993DF.4080400@redhat.com> <20070820133207.GA13835@gondor.apana.org.au>
In-Reply-To: <20070820133207.GA13835@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Mon, Aug 20, 2007 at 09:15:11AM -0400, Chris Snook wrote:
>> Linus Torvalds wrote:
>>> So the only reason to add back "volatile" to the atomic_read() sequence is 
>>> not to fix bugs, but to _hide_ the bugs better. They're still there, they 
>>> are just a lot harder to trigger, and tend to be a lot subtler.
>> What about barrier removal?  With consistent semantics we could optimize a 
>> fair amount of code.  Whether or not that constitutes "premature" 
>> optimization is open to debate, but there's no question we could reduce our 
>> register wiping in some places.
> 
> If you've been reading all of Linus's emails you should be
> thinking about adding memory barriers, and not removing
> compiler barriers.
> 
> He's just told you that code of the kind
> 
> 	while (!atomic_read(cond))
> 		;
> 
> 	do_something()
> 
> probably needs a memory barrier (not just compiler) so that
> do_something() doesn't see stale cache content that occured
> before cond flipped.

Such code generally doesn't care precisely when it gets the update, just that 
the update is atomic, and it doesn't loop forever.  Regardless, I'm convinced we 
just need to do it all in assembly.

	-- Chris
