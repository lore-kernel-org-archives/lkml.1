Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbXHORdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbXHORdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbXHORdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:33:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34329 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762277AbXHORda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:33:30 -0400
Date: Wed, 15 Aug 2007 10:33:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070815173326.GF9645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <46C2FADB.7020407@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151906330.16414@enigma.security.iitk.ac.in> <20070815142516.GB9645@linux.vnet.ibm.com> <20070815153335.GA23593@gondor.apana.org.au> <20070815160830.GC9645@linux.vnet.ibm.com> <alpine.LFD.0.999.0708152244310.16414@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708152244310.16414@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 10:48:28PM +0530, Satyam Sharma wrote:
> On Wed, 15 Aug 2007, Paul E. McKenney wrote:
> > On Wed, Aug 15, 2007 at 11:33:36PM +0800, Herbert Xu wrote:
> > > On Wed, Aug 15, 2007 at 07:25:16AM -0700, Paul E. McKenney wrote:
> > > > 
> > > > Do we really need another set of APIs?  Can you give even one example
> > > > where the pre-existing volatile semantics are causing enough of a problem
> > > > to justify adding yet more atomic_*() APIs?
> > > 
> > > Let's turn this around.  Can you give a single example where
> > > the volatile semantics is needed in a legitimate way?
> > 
> > Sorry, but you are the one advocating for the change.
> 
> Not for i386 and x86_64 -- those have atomic ops without any "volatile"
> semantics (currently as per existing definitions).

I claim unit volumes with arm, and the majority of the architectures, but
I cannot deny the popularity of i386 and x86_64 with many developers.  ;-)

However, I am not aware of code in the kernel that would benefit
from the compiler coalescing multiple atomic_set() and atomic_read()
invocations, thus I don't see the downside to volatility in this case.
Are there some performance-critical code fragments that I am missing?

						Thanx, Paul
