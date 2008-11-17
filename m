Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYKQXN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYKQXN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKQXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:13:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:60424 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYKQXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:13:48 -0500
Subject: Re: Large stack usage in fs code (especially for PPC64)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 10:13:16 +1100
Message-Id: <1226963596.7178.254.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, it's not unacceptable on good CPU's with 4kB blocks (just an 8-entry 
> array), but as you say:
> 
> > On PPC64 I'm told that the page size is 64K, which makes the above equal 
> > to: 64K / 512 = 128  multiply that by 8 byte words, we have 1024 bytes.
> 
> Yeah. Not good. I think 64kB pages are insane. In fact, I think 32kB 
> pages are insane, and 16kB pages are borderline. I've told people so.
> 
> The ppc people run databases, and they don't care about sane people 
> telling them the big pages suck.

Hehe :-)

Guess who is pushing for larger page sizes nowadays ? Embedded
people :-) In fact, we have patches submited on the list to offer the
option for ... 256K pages on some 44x embedded CPUs :-)

It makes some sort of sense I suppose on very static embedded workloads
with no swap nor demand paging.

> It's made worse by the fact that they 
> also have horribly bad TLB fills on their broken CPU's, and years and 
> years of telling people that the MMU on ppc's are sh*t has only been 
> reacted to with "talk to the hand, we know better".

Who are you talking about here precisely ? I don't think either Paul or
I every said something nearly around those lines ... Oh well.

But yeah, our existing server CPUs have pretty poor TLB refills and yes,
64K pages help. And yes, we would like things to be different, but they
aren't.

But there is also pressure to get larger page sizes from small embedded
field, where CPUs have even poorer TLB refill (software loaded
basically) :-)

> Quite frankly, 64kB pages are INSANE. But yes, in this case they actually 
> cause bugs. With a sane page-size, that *arr[MAX_BUF_PER_PAGE] thing uses 
> 64 bytes, not 1kB.

Come on, the code is crap to allocate that on the stack anyway :-)

> Of course, that would likely mean that FAT etc wouldn't work on ppc64, so 
> I don't think that's a valid model either. But if the 64kB page size is 
> just a "database server crazy-people config option", then maybe it's 
> acceptable.

Well, as I said, embedded folks are wanting that too ...

Cheers,
Ben.

