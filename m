Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYIZMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYIZMDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIZMDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:03:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54054 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYIZMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:03:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 26 Sep 2008 08:03:02 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
In-reply-to: <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
Message-id: <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
References: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Peter Zijlstra wrote:

> On Wed, 2008-09-24 at 17:48 +0100, David Howells wrote:
> > Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make use of it
> > too.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  arch/arm/mach-pxa/time.c       |    2 +
> >  arch/arm/mach-sa1100/generic.c |    2 +
> >  arch/arm/mach-versatile/core.c |    2 +
> >  include/linux/cnt32_to_63.h    |   80 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 83 insertions(+), 3 deletions(-)
> >  create mode 100644 include/linux/cnt32_to_63.h
> 
> Didn't you forget to remove the old one?
> 
> 
> > +#define cnt32_to_63(cnt_lo) \
> > +({ \
> > +	static volatile u32 __m_cnt_hi; \
> > +	union cnt32_to_63 __x; \
> > +	__x.hi = __m_cnt_hi; \
> > +	__x.lo = (cnt_lo); \
> > +	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> > +		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> > +	__x.val; \
> > +})
> > +
> > +#endif
> 
> That code is way to smart :-)
> 
> Better make sure that non of its users are SMP capable though.

Why would that matter?


Nicolas
