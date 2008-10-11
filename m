Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYJKNzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYJKNzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYJKNzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:55:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYJKNzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:55:40 -0400
Date: Sat, 11 Oct 2008 09:55:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH] sched: fair scheduler should not resched rt tasks
In-Reply-To: <1223722959.8485.13.camel@twins>
Message-ID: <alpine.DEB.1.10.0810110952190.12625@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810110258310.12625@gandalf.stny.rr.com> <1223722959.8485.13.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 11 Oct 2008, Peter Zijlstra wrote:

> On Sat, 2008-10-11 at 03:01 -0400, Steven Rostedt wrote:
> > Using ftrace, I noticed latencies in real-time tasks where they were
> > needlessly calling schedule due to sched_fair sending out time slices.
> > 
> > This patch prevents a call to resched_task by the sched fair class if
> > the task it wants to reschedule is an rt task.
> 
> Right, thats not a good thing, however this patch looks wrong, we should
> never call hrtick_start_fair() on a rt task to begin with.

Great! I don't care which way we fix this. This was making noticeable
latencies against rt tasks.

> 
> The way I can see that happening is through enqueue/dequeue_task_fair()
> where we want to re-programm the hrtick because nr_running changes (and
> thus the current tasks desired runtime).

My original patch was more like this one, but I wasn't sure if I was 
skipping any calculations that were assumed to be made. Thus, I wrote the 
bare minimum and sent it out CC'ing the experts. Looks like my plan worked 
;-)

-- Steve


> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Steven Rostedt <srostedt@redhat.com>

