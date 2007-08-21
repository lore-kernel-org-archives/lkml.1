Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbXHUJNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbXHUJNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXHUJNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:13:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45051 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXHUJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:13:32 -0400
Date: Tue, 21 Aug 2007 08:08:37 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, ak@suse.de, netdev@vger.kernel.org,
       cfriesen@nortel.com, akpm@linux-foundation.org, rpjday@mindspring.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-arch@vger.kernel.org,
       jesper.juhl@gmail.com, satyam@infradead.org, zlynx@acm.org,
       schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070821070837.GB32036@flint.arm.linux.org.uk>
Mail-Followup-To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>, heiko.carstens@de.ibm.com,
	horms@verge.net.au, linux-kernel@vger.kernel.org, ak@suse.de,
	netdev@vger.kernel.org, cfriesen@nortel.com,
	akpm@linux-foundation.org, rpjday@mindspring.com,
	Nick Piggin <nickpiggin@yahoo.com.au>, linux-arch@vger.kernel.org,
	jesper.juhl@gmail.com, satyam@infradead.org, zlynx@acm.org,
	schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Linus Torvalds <torvalds@linux-foundation.org>,
	wensong@linux-vs.org, wjiang@resilience.com
References: <alpine.LFD.0.999.0708162045150.30176@woody.linux-foundation.org> <20070817235912.GA24314@linux.vnet.ibm.com> <20070818000913.GA25585@gondor.apana.org.au> <20070818010818.GQ8464@linux.vnet.ibm.com> <Pine.LNX.4.64.0708171817050.15427@schroedinger.engr.sgi.com> <46C997B1.1010800@redhat.com> <417ebba299a7ad3c4b7a31c4f860a814@kernel.crashing.org> <20070820224859.GA16162@flint.arm.linux.org.uk> <2bdb04581125f22122f1d230e991ea92@kernel.crashing.org> <20070821000518.GC7292@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821000518.GC7292@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 05:05:18PM -0700, Paul E. McKenney wrote:
> On Tue, Aug 21, 2007 at 01:02:01AM +0200, Segher Boessenkool wrote:
> > >>And no, RMW on MMIO isn't "problematic" at all, either.
> > >>
> > >>An RMW op is a read op, a modify op, and a write op, all rolled
> > >>into one opcode.  But three actual operations.
> > >
> > >Maybe for some CPUs, but not all.  ARM for instance can't use the
> > >load exclusive and store exclusive instructions to MMIO space.
> > 
> > Sure, your CPU doesn't have RMW instructions -- how to emulate
> > those if you don't have them is a totally different thing.
> 
> I thought that ARM's load exclusive and store exclusive instructions
> were its equivalent of LL and SC, which RISC machines typically use to
> build atomic sequences of instructions -- and which normally cannot be
> applied to MMIO space.

Absolutely correct.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
