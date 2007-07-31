Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbXGaPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbXGaPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXGaPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:40:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34879 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXGaPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:40:16 -0400
Subject: Re: [PATCH 0/2][RFC] VFCIPI v3
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <46AF1DA6.BA47.005A.0@novell.com>
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
	 <1185891957.12034.12.camel@twins>  <46AF1DA6.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 17:40:12 +0200
Message-Id: <1185896412.12034.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:33 -0400, Gregory Haskins wrote:
> >>> On Tue, Jul 31, 2007 at 10:25 AM, in message <1185891957.12034.12.camel@twins>,
> Peter Zijlstra <peterz@infradead.org> wrote: 

> >(with mistakes).
> 
> If there was anything more than what you already mention here, please
> point them out so I don't "port" them over to the workqueues
> implemenation ;)

The two that jumped out at me while skimming over the code were:

 - use of raw_spinlock_t (while not always a bug, it does need _very_
   good justification)
 - not cpu hotplug safe


> > Your idea that GFP_ATOMIC is broken in -rt is unfortunate, it isn't. The
> > whole allocator is preemptable - that is a feature!
> 
> Heh...that may be, and I can see how it is useful to have the
> allocatorr be generally preemptible.  However, I would have thought
> that "GFP_ATOMIC" means I can call it from atomic code, which is not
> the case apparently.  It's probably just my own ignorance again of
> what that flag should really mean ;)
> 
> In any case I abstracted the heap_allocator away so that I could make
> an in_atomic friendly allocation.  If the GFP_ATOMIC allocator ever
> supports in_atomic in the future, all we have to do is change
> vfcipi/heap.h.  I am open to other suggestions to this problem, of
> course.

The thing is, we should never need to allocate from a real atomic
context, every time you end up in that situation, ask yourself if the
problem can be solved differently. That is, it often points at a design
flaw.

Peter

