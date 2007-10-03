Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXJCTy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXJCTy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXJCTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:54:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbXJCTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:54:18 -0400
Date: Wed, 3 Oct 2007 12:54:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Neil Romig <neil@romig.demon.co.uk>, linux-kernel@vger.kernel.org,
       hyoshiok@miraclelinux.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
In-Reply-To: <84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710031247030.3579@woody.linux-foundation.org>
References: <46FFC371.9040805@romig.demon.co.uk> 
 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com> 
 <4702B28F.5050404@romig.demon.co.uk>  <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
  <4703E287.3070705@romig.demon.co.uk>  <84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
  <alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
 <84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Pekka Enberg wrote:
> 
> On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > I would bet that the reason the intel-optimized memcpy triggers this is
> > that the non-temporal stores just means that you go out directly on the
> > bus, and it probably just shows a weakness in the chipset or bus that
> > doesn't show with the normal cacheline accesses.
> 
> But that should show up with memtest too, no?

Not unless memtest uses non-temporal stores with the same (or similar) 
access patterns.

The thing is, the CPU cache hides a *lot* of activity from the chipset, 
and changes the access patterns radically. 

With normal cached accesses, you'd normally see just the "fill cacheline" 
and "write out cacheline" pattern. With movnt, you'd see non-cacheline 
accesses to memory. If the chipset was tested under mostly normal loads, 
the movnt cases have been getting a lot less coverage.

Now, I do agree that it certainly *can* be a CPU bug too.  I doubt it, 
though. 

I'd check the power supply (brownouts cause random corruption, and it 
might have a "peak power pattern" thing to it), and it's worth re-seating 
any DIMM's etc. And it's definitely worth going into the BIOS setup screen 
and making sure that nothing is even close to debatable (ie take RAM 
timings down to non-aggressive levels, make sure bus frequencies and 
multipliers are not even close to borderline, etc etc).

			Linus
