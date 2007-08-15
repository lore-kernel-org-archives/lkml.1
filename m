Return-Path: <linux-kernel-owner+w=401wt.eu-S934889AbXHORxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbXHORxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXHORx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:53:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXHORxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:53:25 -0400
Date: Wed, 15 Aug 2007 23:35:45 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <20070815173326.GF9645@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.999.0708152325270.16414@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <46C2FADB.7020407@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151906330.16414@enigma.security.iitk.ac.in>
 <20070815142516.GB9645@linux.vnet.ibm.com> <20070815153335.GA23593@gondor.apana.org.au>
 <20070815160830.GC9645@linux.vnet.ibm.com>
 <alpine.LFD.0.999.0708152244310.16414@enigma.security.iitk.ac.in>
 <20070815173326.GF9645@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Aug 2007, Paul E. McKenney wrote:

> On Wed, Aug 15, 2007 at 10:48:28PM +0530, Satyam Sharma wrote:
> > [...]
> > Not for i386 and x86_64 -- those have atomic ops without any "volatile"
> > semantics (currently as per existing definitions).
> 
> I claim unit volumes with arm, and the majority of the architectures, but
> I cannot deny the popularity of i386 and x86_64 with many developers.  ;-)

Hmm, does arm really need that "volatile int counter;"? Hopefully RMK will
take a patch removing that "volatile" ... ;-)


> However, I am not aware of code in the kernel that would benefit
> from the compiler coalescing multiple atomic_set() and atomic_read()
> invocations, thus I don't see the downside to volatility in this case.
> Are there some performance-critical code fragments that I am missing?

I don't know, and yes, code with multiple atomic_set's and atomic_read's
getting optimized or coalesced does sound strange to start with. Anyway,
I'm not against "volatile semantics" per se. As replied elsewhere, I do
appreciate the motivation behind this series (to _avoid_ gotchas, not to
fix existing ones). Just that I'd like to avoid using "volatile", for
aforementioned reasons, especially given that there are perfectly
reasonable alternatives to achieve the same desired behaviour.


Satyam
