Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZLWKWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZLWKWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZLWKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:22:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbZLWKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:22:10 -0500
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 11:21:27 +0100
Message-ID: <1261563687.4937.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 16:14 +0600, Rakib Mullick wrote:
> Is task migration necessary in sched_exec()?
> 
>  In sched_exec function's comment it says:
> 
>  "sched_exec - execve() is a valuable balancing opportunity, because at
>   this point the task has the smallest effective memory and cache footprint."
> 
> Right, but - when a execve() is called then this task will start execution (that
> means this task will not waiting on the runqueue as TASK_RUNNING/WAKING,
> it will get the CPU). At this point - what is the necessity to try
> making it balance.
> By looking at point of "smallest effective memory and cache footprint" , we are
> missing the point that we are unnecessarily pushing task when its
> about to execute.
> 
> Isn't it? Or I'm missing anything?

Well, if there's an imbalance the 'slow' load-balancer will move it
around eventually anyway, and since it will then have build up a larger
cache footprint it will be even more expensive.

So moving it when its cheapest is the best all-round trade-off, isn't
it?

