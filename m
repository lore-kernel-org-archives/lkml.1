Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXIHQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXIHQkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXIHQkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:40:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:54675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbXIHQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:40:41 -0400
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709081136.46605.nickpiggin@yahoo.com.au>
References: <20070906184011.GA1776@Krystal>
	 <20070906160009.fa52e8d2.akpm@linux-foundation.org>
	 <200709081136.46605.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Sat, 08 Sep 2007 18:42:10 +0200
Message-Id: <1189269730.5972.163.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > If so, the finger points at this:
> >
> > static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long
> > *addr) {
> > 	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
> > 	__clear_bit(nr, addr);
> > }
> >
> > which was added by Nick's powerpc-lock-bitops.patch.  I am suspecting that
> > this isn't pp32 code?
> 
> Hmm, when LWSYNC_ON_SMP is a noop, it seems like it should probably
> be an empty string instead of nothing? ("") That should make behaviour
> more consistent I think.

The wormhole is arch/ppc's hack to get to include/asm-powerpc...

As for having LWSYNC_ON_SMP be "" ... that might be the best way but I'd
rather not take chances right now and go for the quick fix of making
__clear_bit_unlock() do

	LWSYNC_ON_SMP ""

instead.

Ben.


