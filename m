Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZJSX47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZJSX47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZJSX46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:56:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52081 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbZJSX45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:56:57 -0400
Date: Tue, 20 Oct 2009 01:57:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/5] cfq-iosched: improve latency for no-idle queues
Message-ID: <20091019235701.GA10727@kernel.dk>
References: <200910192220.53203.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192220.53203.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
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

Thanks, interesting series. I'll look over the patches as time permits
and try and get some testing time in when I get back.

-- 
Jens Axboe

