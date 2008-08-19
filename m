Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYHSLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYHSLSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYHSLS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:18:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYHSLS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:18:26 -0400
Date: Tue, 19 Aug 2008 13:20:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Message-ID: <20080819112013.GI9807@one.firstfloor.org>
References: <patchbomb.1219083817@localhost> <200808191956.59898.nickpiggin@yahoo.com.au> <20080819103100.GH9807@one.firstfloor.org> <200808192104.05322.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808192104.05322.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > AFAIK mmap flushing hasn't changed much in 2.6 and it tends
> > to batch well anyways in this case (unlike vmscan swapping). I would be
> > careful to really optimize the real culprits which are likely elsewhere.
> 
> It wasn't actually the TLB flushing side of it that was causing
> the slowdown IIRC. It's just all over the map.

The nastiest slowdowns.

> Notifier hooks; accounting statistics; 4lpt; cond_resched and
> low latency code causing functions to spill more to stack; cache
> misses from data structures increasing or becoming unaligned...

Hmm, on a benchmark here a simple anonymous mmap+munmap is ~3800 cycles.
Was it ever really that much faster? 

BTW even simple open+close is about twice as slow.
> 
> Basically just lots of little straws that added up to kill the
> camel. I didn't even get to the bottom of the whole thing. But
> my point is that even 1% here and there eventually adds up to a
> big headache for someone. 

There is a great classical email floating around how such 1% regressions
killed Irix eventually. Need to dig that out.

> inevitable to slowdown, but in all other cases we should always
> be aiming to make the kernel faster rather than slower.

It's hard to catch such regressions later. I wonder if we really need
some kind of mini benchmark collection that is regularly run
and that checks latency of such micro operation and points
out regressions when they happen.
AFAIK the OpenSolaris people have something like that.

-Andi
> 
