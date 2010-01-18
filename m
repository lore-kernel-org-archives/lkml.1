Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118Ab0ARLmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0ARLmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842Ab0ARLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:42:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0ARLmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:42:08 -0500
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <4B54445E.302@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-5-git-send-email-tj@kernel.org>
	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 12:41:09 +0100
Message-ID: <1263814869.4283.296.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 20:22 +0900, Tejun Heo wrote:
> On 01/18/2010 06:56 PM, Peter Zijlstra wrote:
> >> NOTE: It would be nice to implement kthread_bind() in terms of
> >>       __set_cpus_allowed() if we can drop the capability to bind to a
> >>       dead CPU from kthread_bind(), which doesn't seem too popular
> >>       anyway.  With such change, we'll have set_cpus_allowed_ptr() for
> >>       regular tasks and kthread_bind() for kthreads and can use
> >>       PF_THREAD_BOUND instead of passing @force parameter around.
> > 
> > 
> > And your changelog still sucks... it only says what it does, not why.
> > 
> > still hate the patch too.
> 
> These part haven't changed at all since the last posting so if you
> disliked it before it's kind of expected you still do so.

You could at least have augmented the changelog with the why.. my memory
thinks it had to so with that silly move back on up story.

> Anyways, I'm not the greatest fan of this patch either.  Let's see how
> the whole series fares out first and try to make this better.  What do
> you think about doing what's described in the NOTE?

I'm still not sure we need any of this. For new threads we have the
stopped state and kthread_bind() should work in its current form (except
you need patch 1 in your series when you're creating new threads when
the cpu is currently going down).



