Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYHDOzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYHDOzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYHDOyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:54:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140AbYHDOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:54:38 -0400
Date: Mon, 4 Aug 2008 10:53:18 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
Message-ID: <20080804145318.GA17867@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Roland Dreier <rdreier@cisco.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, jeremy@goop.org,
	hugh@veritas.com, mingo@elte.hu, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com> <1217859571.3589.7.camel@twins> <aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217860332.3589.11.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 04:32:12PM +0200, Peter Zijlstra wrote:
 > On Mon, 2008-08-04 at 07:26 -0700, Roland Dreier wrote:
 > > > No more than 48 locks (mutexes, rwlocks, spinlock, RCU, everything
 > >  > covered by lockdep) held by any one code-path; including nested
 > >  > interrupt contexts.
 > > 
 > > Does that mean that something like the new mm_take_all_locks() operation
 > > is going to explode if someone tries to use it with lockdep on?
 > 
 > Gah - yes, clearly nobody tried this.. :-/
 > 
 > Just looking at the code it will not only run into this limit, but it
 > would warn about recursion on the second file/anon vma due to utter lack
 > of annotation.
 > 
 > Why are people still developing without lockdep?

More puzzling, is why hasn't this triggered in the Fedora rawhide kernels,
which do have lockdep enabled.

	Dave

-- 
http://www.codemonkey.org.uk
