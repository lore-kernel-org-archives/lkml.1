Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYHDOUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYHDOUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYHDOTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:19:30 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:60851 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbYHDOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:19:29 -0400
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <ada63qgvppx.fsf@cisco.com>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl>  <ada63qgvppx.fsf@cisco.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 16:19:31 +0200
Message-Id: <1217859571.3589.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 07:07 -0700, Roland Dreier wrote:
> > NOTE: we're still bound to the MAX_LOCK_DEPTH (48) limit.
> 
> A) It is probably a good idea to put this in a comment somewhere near
>    where spin_lock_nest_lock() is declared.

Its not particular to this annotation - its true for anything lockdep.

> B) It is probably a good idea to write that comment in such a way that
>    dumb people like me understand what the limit is.  The sentence I
>    quoted above is too telegraphic for me to get.  Is the point that no
>    more than 48 spinlocks can be held at once, even if the inner locks
>    are protected by some top level lock?  Or do you mean something else?

No more than 48 locks (mutexes, rwlocks, spinlock, RCU, everything
covered by lockdep) held by any one code-path; including nested
interrupt contexts.

