Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYH1Q3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYH1Q3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYH1Q3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:29:42 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:44817 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYH1Q3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:29:41 -0400
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0808281212590.14580@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl>
	 <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu>
	 <20080828141513.GC31444@goodmis.org> <1219939502.17355.30.camel@twins>
	 <alpine.DEB.1.10.0808281212590.14580@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 18:29:38 +0200
Message-Id: <1219940978.17355.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 12:15 -0400, Steven Rostedt wrote:
> 
> On Thu, 28 Aug 2008, Peter Zijlstra wrote:
> 
> > On Thu, 2008-08-28 at 10:15 -0400, Steven Rostedt wrote:
> > 
> > > My biggest concern about adding a limit to FIFO is that an RT developer
> > > would spend weeks trying to debug their system wondering why their
> > > planned CPU RT hog, is being preempted by a non-RT task.
> > > 
> > > For this, if this time limit does kick in, we should at the very least
> > > print something out to let the user know this happened. After all, this
> > > is more of a safety net anyway, and if we are hitting the limit, the
> > > user should be notified. Perhaps even tell the user that if this
> > > behaviour is expected, to up the sysctl <var> by more.
> > 
> > Should be easy enough to do - 
> > 
> > > Peter, another question. Is this limit for a single RT task running, or
> > > all RT tasks. I'm assuming here that it is a single RT task. If you have
> > > 20 RT tasks all running, would this let non RT tasks in? In that case,
> > > this could be even a bigger issues.
> > 
> > No its not per task. Its per group (and trivially the !group case is one
> > group).
> 
> Does this mean, if I have 100 RT tasks, that will together run for 10secs
> secs, they will only run for 9.5secs?
> 
> This looks like an even bigger issue. Now we don't have one RT FIFO CPU 
> hog, we are now hitting 100 RT FIFO tasks that try to get a bunch done in 
> 10 secs.

Yes.

But say you were doing rate monotonic scheduling (as is not uncommonly
done on top of SCHED_FIFO) then you could not get 100% cpu utilisation
anyway, as RMS has a ~69% utility bound.



