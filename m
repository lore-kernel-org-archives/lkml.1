Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZKPUaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZKPUaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZKPUaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:30:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZKPUaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:30:02 -0500
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, andi@firstfloor.org,
       fweisbec@gmail.com
In-Reply-To: <4B019FC9.4080309@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
	 <1258391726-30264-5-git-send-email-tj@kernel.org>
	 <1258396864.4372.55.camel@twins>  <4B019FC9.4080309@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 21:29:25 +0100
Message-ID: <1258403365.3961.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 03:54 +0900, Tejun Heo wrote:
> Peter Zijlstra wrote:
> > I really hate exposing activate/deactivate.
> > 
> > You say:
> > 
> >> Activated and deactivated are called
> >> when a task's readiness to run changes.
> > 
> > How is that not clear from the out hook? It would seem to me that when
> > you get scheduled out with a p->state != TASK_RUNNING you're not ready.
> 
> In that in OUT hook the next task to switch to is already determined
> and it wouldn't be symmetric with activate (but I suppose we can match
> the symmetry from activate side).  If deactivate/activate/in/out
> events are too low level,

Not too low, just wrong. Most functions operating on the scheduler state
like sys_renice(), sys_sched_setscheduler() etc.. all do a
deactivate/activate series, even though the task at hand never goes
through a sleep or blocking state.

>  we can have sleep/ready/run hooks instead.

I would much prefer that, sleep/ready are significantly different from
deactivate/activate.

