Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXHTWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXHTWuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbXHTWus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:50:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40587 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXHTWuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:50:46 -0400
Date: Mon, 20 Aug 2007 23:48:59 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Chris Snook <csnook@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Paul Mackerras <paulus@samba.org>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-arch@vger.kernel.org, jesper.juhl@gmail.com, satyam@infradead.org,
       zlynx@acm.org, schwidefsky@de.ibm.com,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070820224859.GA16162@flint.arm.linux.org.uk>
Mail-Followup-To: Segher Boessenkool <segher@kernel.crashing.org>,
	Chris Snook <csnook@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>, heiko.carstens@de.ibm.com,
	horms@verge.net.au, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ak@suse.de,
	netdev@vger.kernel.org, cfriesen@nortel.com,
	akpm@linux-foundation.org, rpjday@mindspring.com,
	Nick Piggin <nickpiggin@yahoo.com.au>, linux-arch@vger.kernel.org,
	jesper.juhl@gmail.com, satyam@infradead.org, zlynx@acm.org,
	schwidefsky@de.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net, Linus Torvalds <torvalds@linux-foundation.org>,
	wensong@linux-vs.org, wjiang@resilience.com
References: <46C505B2.6030704@yahoo.com.au> <18117.4848.695269.72976@cargo.ozlabs.ibm.com> <46C516BA.60700@yahoo.com.au> <alpine.LFD.0.999.0708162045150.30176@woody.linux-foundation.org> <20070817235912.GA24314@linux.vnet.ibm.com> <20070818000913.GA25585@gondor.apana.org.au> <20070818010818.GQ8464@linux.vnet.ibm.com> <Pine.LNX.4.64.0708171817050.15427@schroedinger.engr.sgi.com> <46C997B1.1010800@redhat.com> <417ebba299a7ad3c4b7a31c4f860a814@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <417ebba299a7ad3c4b7a31c4f860a814@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 12:04:17AM +0200, Segher Boessenkool wrote:
> And no, RMW on MMIO isn't "problematic" at all, either.
> 
> An RMW op is a read op, a modify op, and a write op, all rolled
> into one opcode.  But three actual operations.

Maybe for some CPUs, but not all.  ARM for instance can't use the
load exclusive and store exclusive instructions to MMIO space.

This means placing atomic_t or bitops into MMIO space is a definite
no-go on ARM.  It breaks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
