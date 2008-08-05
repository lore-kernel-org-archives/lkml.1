Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYHEMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYHEMCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbYHEMCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:02:13 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57958 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761220AbYHEMCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:02:11 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by mm_take_all_locks
References: <20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random> <adar694rzks.fsf@cisco.com>
	<20080805021812.GI12464@duo.random>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 05 Aug 2008 05:02:07 -0700
In-Reply-To: <20080805021812.GI12464@duo.random> (Andrea Arcangeli's message
	of "Tue, 5 Aug 2008 04:18:12 +0200")
Message-ID: <adak5evsm9s.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Aug 2008 12:02:07.0890 (UTC) FILETIME=[1589D720:01C8F6F3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Let's focus on check_deadlock->print_deadlock_bug and somebody who's
 > not beyond the point please explain what print_deadlock_bug reports
 > that does not actually occur and why it's a good idea to change the
 > common code to accommodate for its false positives instead of getting
 > rid of it for good.

check_deadlock operates on classes of locks, so it can warn about
potential deadlocks, eg if we have

	foo(obj1, obj2)
	{
		lock(obj1);
		lock(obj2);
		...

then foo(obj, obj); is a deadlock but lockdep can warn about foo(obj,
different_obj) without triggering the deadlock in reality.  Of course
this leads to false positives, and we sometimes have to change correct
code to help lockdep, but usually such rewriting leads to simpler
clearer better locking anyway.

 - R.
