Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbXHVUdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbXHVUdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbXHVUd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:33:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50981 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759288AbXHVUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:33:26 -0400
Date: Wed, 22 Aug 2007 13:33:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822202955.GA26612@Krystal>
Message-ID: <Pine.LNX.4.64.0708221330530.16037@schroedinger.engr.sgi.com>
References: <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
 <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
 <20070822134532.GA3769@Krystal> <Pine.LNX.4.64.0708221224550.14795@schroedinger.engr.sgi.com>
 <20070822200910.GA25687@Krystal> <Pine.LNX.4.64.0708221316240.15775@schroedinger.engr.sgi.com>
 <20070822202955.GA26612@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Mathieu Desnoyers wrote:

> > Then the thread could be preempted and rescheduled on a different cpu 
> > between put_cpu and local_irq_save() which means that we loose the
> > state information of the kmem_cache_cpu structure.
> > 
> 
> Maybe am I misunderstanding something, but kmem_cache_cpu does not seem
> to be passed to __slab_free() at all, nor any data referenced by it. So
> why do we care about being preempted there ?

Right it is only useful for __slab_alloc. I just changed them both to look 
the same. We could do it that way in __slab_free() to avoid the later 
preempt_check_resched().

> > We could do that but maybe the frequency of these checks would be too 
> > high? When should the resched checks be used?
> 
> Since we are only doing this on the slow path, it does not hurt.
> preempt_check_resched() is embedded in preempt_enable() and has a very
> low impact (simple thread flag check in the standard case).

Ok then lets add it.
