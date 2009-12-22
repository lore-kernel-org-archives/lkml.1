Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZLVSVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZLVSVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZLVSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:21:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZLVSVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:21:36 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
In-Reply-To: <20091222180703.GI10314@basil.fritz.box>
References: <20091221091754.GG4489@kernel.dk>
	 <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261480220.4937.24.camel@laptop>
	 <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
	 <1261504042.4937.59.camel@laptop>  <20091222180703.GI10314@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 19:20:16 +0100
Message-ID: <1261506016.4937.65.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 19:07 +0100, Andi Kleen wrote:

> One reason I liked a more dynamic frame work for this is that it
> has the potential to be exposed to user space and allow automatic
> work partitioning there based on available cores.  User space
> has a lot more CPU consumption than the kernel.

What you want is something that does not block, but does not generate
more load than a single runnable task either. Otherwise you'll end up
with massive load issues.

The thing currently proposed only does the first, but does not guarantee
the latter. Meaning you can only use it if you know it will not do much
work (after blocking), which is a fine restriction in the kernel (not
something I think the current workqueue users all adhere to though).

However, it is not something you'd want to expose to userspace, not that
is, without the counterpart limiting wakeup parallelism.

> I think Grand Central Dispatch does something in this direction. 
> TBB would probably also benfit

What are those?

> Short term an alternative for the kernel would be also
> to generalize the simple framework that is in btrfs.

And here I though btrfs was one of those who did actually consume heaps
of CPU in its worklets doing data checksums and the like.

