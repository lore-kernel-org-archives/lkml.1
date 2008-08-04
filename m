Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbYHDOcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbYHDOcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYHDOcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:32:18 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:60549 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbYHDOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:32:17 -0400
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <aday73cua99.fsf@cisco.com>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com>
	 <1217859571.3589.7.camel@twins>  <aday73cua99.fsf@cisco.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 16:32:12 +0200
Message-Id: <1217860332.3589.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 07:26 -0700, Roland Dreier wrote:
> > No more than 48 locks (mutexes, rwlocks, spinlock, RCU, everything
>  > covered by lockdep) held by any one code-path; including nested
>  > interrupt contexts.
> 
> Does that mean that something like the new mm_take_all_locks() operation
> is going to explode if someone tries to use it with lockdep on?

Gah - yes, clearly nobody tried this.. :-/

Just looking at the code it will not only run into this limit, but it
would warn about recursion on the second file/anon vma due to utter lack
of annotation.

Why are people still developing without lockdep?

/me sad

