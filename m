Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYH1QP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYH1QP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYH1QPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:15:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYH1QPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:15:42 -0400
Date: Thu, 28 Aug 2008 12:15:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <1219939502.17355.30.camel@twins>
Message-ID: <alpine.DEB.1.10.0808281212590.14580@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl>  <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu>  <20080828141513.GC31444@goodmis.org> <1219939502.17355.30.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Peter Zijlstra wrote:

> On Thu, 2008-08-28 at 10:15 -0400, Steven Rostedt wrote:
> 
> > My biggest concern about adding a limit to FIFO is that an RT developer
> > would spend weeks trying to debug their system wondering why their
> > planned CPU RT hog, is being preempted by a non-RT task.
> > 
> > For this, if this time limit does kick in, we should at the very least
> > print something out to let the user know this happened. After all, this
> > is more of a safety net anyway, and if we are hitting the limit, the
> > user should be notified. Perhaps even tell the user that if this
> > behaviour is expected, to up the sysctl <var> by more.
> 
> Should be easy enough to do - 
> 
> > Peter, another question. Is this limit for a single RT task running, or
> > all RT tasks. I'm assuming here that it is a single RT task. If you have
> > 20 RT tasks all running, would this let non RT tasks in? In that case,
> > this could be even a bigger issues.
> 
> No its not per task. Its per group (and trivially the !group case is one
> group).

Does this mean, if I have 100 RT tasks, that will together run for 10secs
secs, they will only run for 9.5secs?

This looks like an even bigger issue. Now we don't have one RT FIFO CPU 
hog, we are now hitting 100 RT FIFO tasks that try to get a bunch done in 
10 secs.

-- Steve

