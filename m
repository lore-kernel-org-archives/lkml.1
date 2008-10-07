Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJGSTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJGSTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYJGSTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:19:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbYJGSTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:19:01 -0400
Date: Tue, 7 Oct 2008 11:18:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] SLOB's krealloc() seems bust
In-Reply-To: <1223403082.26330.78.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.0810071116050.3208@nehalem.linux-foundation.org>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>  <48EB6D2C.30806@linux-foundation.org>  <1223391655.13453.344.camel@calx>  <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>  <1223397455.13453.385.camel@calx> 
 <alpine.LFD.2.00.0810071053540.3208@nehalem.linux-foundation.org> <1223403082.26330.78.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Oct 2008, Peter Zijlstra wrote:

> On Tue, 2008-10-07 at 10:57 -0700, Linus Torvalds wrote:
> 
> > Peter - can you check with that
> > 
> > >  	if (slob_page(sp))
> > > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > > +		return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;
> > 
> > thing using
> > 
> > -		return ((slob_t *)block - 1)->units + SLOB_UNIT;
> > +		return ((slob_t *)block - 1)->units * SLOB_UNIT;
> > 
> > instead? 
> 
> went splat on the second run...

Well, that makes it simple. I'll take Matt's patch as being "tested", and 
somebody can hopefully explain where the extra unit comes from later.

			Linus


