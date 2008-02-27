Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbYB0XeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbYB0XeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYB0XeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:34:08 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38965 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbYB0XeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:34:07 -0500
Date: Wed, 27 Feb 2008 15:34:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080219200358.GB11197@Krystal>
Message-ID: <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
 <20080219200358.GB11197@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Mathieu Desnoyers wrote:

> I think you are right. A way to fix this would use the fact that the
> freelist is only useful to point to the first free object in a page. We
> could change it to an offset rather than an address.
> 
> The freelist would become a counter of type "long" which increments
> until it wraps at 2^32 or 2^64. A PAGE_MASK bitmask could then be used
> to get low order bits which would get the page offset of the first free
> object, while the high order bits would insure we can detect this type
> of object reuse when doing a cmpxchg. Upon free, the freelist counter
> should always be incremented; this would be provided by adding PAGE_SIZE
> to the counter and setting the LSBs to the correct offset.

Urgh.... That sounds way too complicated. Do you have an experimental 
patch that would allow us to see the impact?

