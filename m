Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbYHDO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYHDO4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYHDO4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:56:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65530 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753984AbYHDO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:56:07 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Jones <davej@redhat.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrea Arcangeli <andrea@qumranet.com>
In-Reply-To: <20080804145318.GA17867@redhat.com>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com>
	 <1217859571.3589.7.camel@twins> <aday73cua99.fsf@cisco.com>
	 <1217860332.3589.11.camel@twins>  <20080804145318.GA17867@redhat.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 16:56:03 +0200
Message-Id: <1217861763.3589.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 10:53 -0400, Dave Jones wrote:
> On Mon, Aug 04, 2008 at 04:32:12PM +0200, Peter Zijlstra wrote:
>  > On Mon, 2008-08-04 at 07:26 -0700, Roland Dreier wrote:
>  > > > No more than 48 locks (mutexes, rwlocks, spinlock, RCU, everything
>  > >  > covered by lockdep) held by any one code-path; including nested
>  > >  > interrupt contexts.
>  > > 
>  > > Does that mean that something like the new mm_take_all_locks() operation
>  > > is going to explode if someone tries to use it with lockdep on?
>  > 
>  > Gah - yes, clearly nobody tried this.. :-/
>  > 
>  > Just looking at the code it will not only run into this limit, but it
>  > would warn about recursion on the second file/anon vma due to utter lack
>  > of annotation.
>  > 
>  > Why are people still developing without lockdep?
> 
> More puzzling, is why hasn't this triggered in the Fedora rawhide kernels,
> which do have lockdep enabled.

My guess is that the kvm thing attaches before there are any vma, and
leaves after all the vma are gone. So it would never actually trigger.



