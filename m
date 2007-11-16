Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXKPKYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXKPKYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbXKPKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:24:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbXKPKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:24:04 -0500
Subject: large lockdep bss (was: Re: [patch 01/28] cpu alloc: The allocator)
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com,
       akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071114022832.GC20365@one.firstfloor.org>
References: <20071106195157.878563669@sgi.com>
	 <20071113.031510.151440585.davem@davemloft.net>
	 <p73wssly6sr.fsf@bingen.suse.de>
	 <20071113.175208.168903694.davem@davemloft.net>
	 <20071114022832.GC20365@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 11:23:53 +0100
Message-Id: <1195208633.3059.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 03:28 +0100, Andi Kleen wrote:
> On Tue, Nov 13, 2007 at 05:52:08PM -0800, David Miller wrote:
> > Yes, I've run into similar problems with lockdep as well.
> > I had to build an ultra minimalized kernel to get it to
> > boot on my Niagara boxes.
> > 
> > I think I even looked at the same lockdep code, and I'd
> > appreciate it if you'd submit your fix for this if you
> > haven't already.
> 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/lockdep-early-alloc
> 
> I didn't plan to submit it for .24, just .25. Or do you need it 
> urgently?
> 
> Also it would require you to write a sparc specific arch_early_alloc()
> of course.  I've only done the x86-64 version.

Would've been nice to have heard about this lockdep problem. Anyway,
thanks for tackling it.

How about moving this bit:

+#ifndef ARCH_HAS_EARLY_ALLOC
+#define LARGEVAR(x,y) { static typeof(*x) __ ## x[y];  x = __ ## x; }
+#else
+#define LARGEVAR(x,y) x = arch_early_alloc(sizeof(*x) * y)
+#endif

out of the lockdep code and into the generic early alloc code?

