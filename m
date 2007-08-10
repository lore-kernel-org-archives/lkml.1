Return-Path: <linux-kernel-owner+w=401wt.eu-S936618AbXHJPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936618AbXHJPCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbXHJPCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:02:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52731 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXHJPCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:02:17 -0400
Date: Fri, 10 Aug 2007 08:02:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, csnook@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
Message-ID: <20070810150213.GB8511@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1IJPkg-0000x0-00@gondolin.me.apana.org.au> <200708101108.20897.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708101108.20897.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 11:08:20AM +0200, Andi Kleen wrote:
> On Friday 10 August 2007 10:21:46 Herbert Xu wrote:
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > The compiler is within its rights to read a 32-bit quantity 16 bits at
> > > at time, even on a 32-bit machine.  I would be glad to help pummel any
> > > compiler writer that pulls such a dirty trick, but the C standard really
> > > does permit this.
> > 
> > Code all over the kernel assumes that 32-bit reads/writes
> > are atomic so while such a compiler might be legal it certainly
> > can't compile Linux.
> 
> Yes, the kernel requirements are much stricter than ISO-C. And besides
> it is a heavy user of C extensions anyways. On the other hand some of the
> C99 extensions are not allowed. And then there is sparse, which enforces
> a language which sometimes is quite far from standard C. You could say it is 
> written in Linux-C, not ISO C. 

Understood.  My question is "why do we want the semantics of atomic_read()
and atomic_set() to differ?"

						Thanx, Paul
