Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXGIV5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXGIV5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbXGIV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:57:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46506 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755826AbXGIV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:57:00 -0400
Date: Mon, 9 Jul 2007 14:55:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Martin Bligh <mbligh@mbligh.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <20070709214426.GC1026@Krystal>
Message-ID: <Pine.LNX.4.64.0707091451200.18780@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
 <46925B5D.8000507@google.com> <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
 <4692A1D0.50308@mbligh.org> <20070709214426.GC1026@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Mathieu Desnoyers wrote:

> > >Okay the source for these numbers is in his paper for the OLS 2006: Volume 
> > >1 page 208-209? I do not see the exact number that you referred to there.
> > 
> 
> Hrm, the reference page number is wrong: it is in OLS 2006, Vol. 1 page
> 216 (section 4.5.2 Scalability). I originally pulled out the page number
> from my local paper copy. oops.

4.5.2 is on page 208 in my copy of the proceedings.


> > >He seems to be comparing spinlock acquire / release vs. cmpxchg. So I 
> > >guess you got your material from somewhere else?
> > >
> 
> I ran a test specifically for this paper where I got this result
> comparing the local irq enable/disable to local cmpxchg.


The numbers are pretty important and suggest that we can obtain 
a significant speed increase by avoid local irq disable enable in the slab 
allocator fast paths. Do you some more numbers? Any other publication that 
mentions these?


> Yep, I volountarily used the variant without lock prefix because the
> data is per cpu and I disable preemption.

local_cmpxchg generates this?

> Yes, preempt disabling or, eventually, the new thread migration
> disabling I just proposed as an RFC on LKML. (that would make -rt people
> happier)

Right.

> Sure, also note that the UP cmpxchg (see asm-$ARCH/local.h in 2.6.22) is
> faster on architectures like powerpc and MIPS where it is possible to
> remove some memory barriers.

UP cmpxchg meaning local_cmpxchg?

> See 2.6.22 Documentation/local_ops.txt for a thorough discussion. Don't
> hesitate ping me if you have more questions.

That is pretty thin and does not mention atomic_cmpxchg. You way want to 
expand on your ideas a bit.
