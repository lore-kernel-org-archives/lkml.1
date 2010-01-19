Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701Ab0ASI4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0ASI4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660Ab0ASI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:56:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:59227 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab0ASI4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:56:17 -0500
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
In-Reply-To: <4B556D44.1060101@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-7-git-send-email-tj@kernel.org>
	 <1263808633.4283.152.camel@laptop>  <4B5446A1.7070306@kernel.org>
	 <1263818967.4283.459.camel@laptop> <4B55050B.5020600@kernel.org>
	 <4B556D44.1060101@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:55:02 +0100
Message-ID: <1263891302.4283.641.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 17:28 +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/19/2010 10:04 AM, Tejun Heo wrote:
> >> I'm thinking that we can place it next to activate_task(), if it makes
> >> you feel better you can place them both at the end up ttwu_activate()
> >> instead of in the middle.
> >>
> >> Esp. with the callback you have it really doesn't matter.
> > 
> > Alright, if it's safe, there's no reason to keep it separate with an
> > extra branch.  I'll move it.
> 
> Alright, was trying to convert it and I'm still a bit worried.  One of
> the reasons I put it at the end of post_activation() is to allow
> calling try_to_wake_up_local() from wakeup callback.  This won't be
> used by cmwq right now but making it symmetrical to sleep callback
> would be more consistent, so...  If we fire wakeup callback right
> after activate_task() and allow try_to_wake_up_local() to be called
> from it, wake up logic ends up being nested inside outer wake up which
> is still in progress.  Would that be safe too?

I think so, still doing a wakeup from a wakeup sounds like trouble in
that it has the potential to a thundering herd, so I'd really rather
you'd not do something like that.

