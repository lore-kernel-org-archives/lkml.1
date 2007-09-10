Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXIJUyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXIJUyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760513AbXIJUyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:54:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57119 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbXIJUyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:54:41 -0400
Date: Mon, 10 Sep 2007 13:54:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       ak@suse.de, cfriesen@nortel.com, rpjday@mindspring.com,
       Netdev <netdev@vger.kernel.org>, jesper.juhl@gmail.com,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       zlynx@acm.org, schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070910205434.GF11801@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <Pine.LNX.4.64.0708161743500.13267@kivilampi-30.cs.helsinki.fi> <46C4ABA5.9010804@redhat.com> <Pine.LNX.4.64.0708161319000.17777@schroedinger.engr.sgi.com> <c298f0e3f9e49c9dd2d326115d156084@kernel.crashing.org> <Pine.LNX.4.64.0709101157060.24491@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709101157060.24491@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:59:29AM -0700, Christoph Lameter wrote:
> On Fri, 17 Aug 2007, Segher Boessenkool wrote:
> 
> > "volatile" has nothing to do with reordering.  atomic_dec() writes
> > to memory, so it _does_ have "volatile semantics", implicitly, as
> > long as the compiler cannot optimise the atomic variable away
> > completely -- any store counts as a side effect.
> 
> Stores can be reordered. Only x86 has (mostly) implicit write ordering. So 
> no atomic_dec has no volatile semantics and may be reordered on a variety 
> of processors. Writes to memory may not follow code order on several 
> processors.

The one exception to this being the case where process-level code is
communicating to an interrupt handler running on that same CPU -- on
all CPUs that I am aware of, a given CPU always sees its own writes
in order.

							Thanx, Paul
