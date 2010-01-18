Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207Ab0ARMum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0ARMum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043Ab0ARMul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:50:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0ARMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:50:40 -0500
Subject: Re: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and
 allow NULL notifier ops
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <4B5446A1.7070306@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-7-git-send-email-tj@kernel.org>
	 <1263808633.4283.152.camel@laptop>  <4B5446A1.7070306@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 13:49:27 +0100
Message-ID: <1263818967.4283.459.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 20:31 +0900, Tejun Heo wrote:
> On 01/18/2010 06:57 PM, Peter Zijlstra wrote:
> > On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> > 
> >> @@ -2439,6 +2440,8 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
> >>  		rq->idle_stamp = 0;
> >>  	}
> >>  #endif
> >> +	if (success)
> >> +		fire_sched_notifiers(p, wakeup);
> >>  }
> >>  
> >>  /**
> > 
> > So why can't you call fire_sched_notifier(p, wakeup) right next to
> > activate_task(rq, p, 1) in ttwu_activate() ?
> 
> I was worried about calling notifier callback before notifying the
> sched_class of the wakeup.  Conceptually, the notifier callback should
> be called after all sched internal stuff about the wakeup finish,
> so...

I'm thinking that we can place it next to activate_task(), if it makes
you feel better you can place them both at the end up ttwu_activate()
instead of in the middle.

Esp. with the callback you have it really doesn't matter.

