Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbZJ1I1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbZJ1I1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbZJ1I1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:27:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbZJ1I1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:27:03 -0400
Date: Wed, 28 Oct 2009 09:27:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/5] cfq-iosched: improve latency for no-idle queues
	(v3)
Message-ID: <20091028082706.GT10727@kernel.dk>
References: <200910262243.41327.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910262243.41327.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Corrado Zoccolo wrote:
> [rebased on top of Jeff's latest changes for 2.6.33. Various code style improvements over v1 & v2]
> 
> This patch series is intended to improve I/O latency, addressing an often
> neglected, important subset of workloads: the ones for which cfq currently
> prefers not to do any idling.
> 
> Those are the ones that would benefit most from having low latency, in fact
> they are any of:
> * processes with large think times (e.g. interactive ones like file managers)
> * seeky (e.g. programs faulting in their code at startup)
> * or marked as no-idle from upper levels.
> 
> The patch series addresses this by:
> * reducing queues' timeslice when many queues have pending I/O
> * separating queues with different priorities and different characteristics in
> different service trees, each with an allocated time slice
> * enable idling when switching between service trees, even for queues that
> would not have idling enabled otherwise.
> 
> This provides various benefits:
> * service tree insertion code is simplified, since it doesn't need to cope with
> priorities any more.
> * high priority no_idle queues are no longer penalized when competing with
> lower priority, idling queues
> * seeky and no_idle queues have their fair share of disk time, without
> penalizing NCQ drives' performances, since they can all dispatch together,
> filling up the available NCQ slots.
> 
> On a non-NCQ capable drive, a workload of 4 random readers competing with
> sequential writer, the maximum latency experienced by readers decreased from >
> 500ms to about 160ms.

Thanks Corrado, this is indeed good stuff. Only style issue left was the
one in cfq_get_avg_queues(), I just corrected that manually.

I have committed this in a test branch based off for-2.6.33 and will do
some testing with it, then merge it into for-2.6.33 if it looks good.

-- 
Jens Axboe

