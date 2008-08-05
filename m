Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbYHEMUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbYHEMUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbYHEMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:20:34 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:57214
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbYHEMUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:20:34 -0400
Date: Tue, 5 Aug 2008 14:20:24 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080805122024.GK12464@duo.random>
References: <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <adar694rzks.fsf@cisco.com> <20080805021812.GI12464@duo.random> <adak5evsm9s.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak5evsm9s.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:02:07AM -0700, Roland Dreier wrote:
> check_deadlock operates on classes of locks, so it can warn about
> potential deadlocks, eg if we have
> 
> 	foo(obj1, obj2)
> 	{
> 		lock(obj1);
> 		lock(obj2);
> 		...
> 
> then foo(obj, obj); is a deadlock but lockdep can warn about foo(obj,
> different_obj) without triggering the deadlock in reality.  Of course
> this leads to false positives, and we sometimes have to change correct
> code to help lockdep, but usually such rewriting leads to simpler
> clearer better locking anyway.

It surely doesn't lead to simpler and clearer better locking in the
case we're discussing here, and I don't know of other cases where it
leads to better locking but feel free to make examples.
