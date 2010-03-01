Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab0CAPyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0CAPyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:54:39 -0500
Date: Mon, 1 Mar 2010 16:50:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 16/43] workqueue: kill cpu_populated_map
Message-ID: <20100301155018.GA12031@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-17-git-send-email-tj@kernel.org> <20100228160005.GA16144@redhat.com> <4B8BDE02.1050208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BDE02.1050208@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> >> @@ -1127,47 +1091,30 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
> >> ...
> >>  	list_for_each_entry(wq, &workqueues, list) {
> >
> > this becomes unsafe. create/destroy can modify workqueues list
> > in parallel.
>
> Yeap, has always been like that.  Will be fixed by later changes.
>
> ...
>
> >>  		case CPU_POST_DEAD:
> >> -			cleanup_workqueue_thread(cwq);
> >> +			lock_map_acquire(&cwq->wq->lockdep_map);
> >> +			lock_map_release(&cwq->wq->lockdep_map);
> >> +			flush_cpu_workqueue(cwq);
> >
> > This can race with destroy_workqueue(), no?
>
> Yes, it can and, again, has been always like that and will be fixed by
> later patches.

Hmm. not sure I understand... but before this patch the code was OK.
cpu_maps_update_begin() in create/destroy protected us from the races
with hotplug.

> I don't
> think it's worth fixing them at this point with all the pending
> changes.

OK, agreed.

Oleg.

