Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYCJQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYCJQ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYCJQ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:26:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbYCJQ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:26:03 -0400
Date: Mon, 10 Mar 2008 09:24:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
Message-Id: <20080310092413.6102c965.akpm@linux-foundation.org>
In-Reply-To: <20080310093024.55a4ff90@bree.surriel.com>
References: <20080309221458.20642e48@bree.surriel.com>
	<20080309224759.6fead9af.akpm@linux-foundation.org>
	<20080310093024.55a4ff90@bree.surriel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 09:30:24 -0400 Rik van Riel <riel@surriel.com> wrote:

> On Sun, 9 Mar 2008 22:47:59 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 9 Mar 2008 22:14:58 -0400 Rik van Riel <riel@surriel.com> wrote:
> > 
> > > SysRP-P is not all that useful on SMP systems, since the sysrq
> > > irq rarely ends up on the CPU that we actually want to investigate.
> 
> > Doesn't everyone have a copy of this somewhere? ;)
> 
> Yes, but the old version of the patch calls on_each_cpu from
> sysrq context, which is illegal since it could cause a deadlock.

My version did queue_work(), iirc, but I seem to have lost it.

I have an old patch here from Brice Goglin which does it via an NMI, but
that's arch-specific, I guess.

afaict, we _could_ implement an IPI call which isn't deadlockable (on x86,
at least) if we were to make it an asynchronous one.

Even if the hardware doesn't support queueing, this could still be done in
software via suitable locking and software queueing.

Whatever.

> > However it does have the downside that info can scroll away on large cpu
> > counts.  Maybe it should be a new sysrq command?
> 
> It used to be sysrq-w in the patches that everybody has, but that
> letter got taken for sysrq_showstate_blocked_op.
> 
> Only sysrq h, j, l, y and z are still free.  H is needed for help,
> leaving just j, l, y and z.
> 
> I can see your point about overflowing the screen,

iirc, this was the reason for not doing this years ago.  I don't know how
real that is.

> however just
> sysrq-p seems like a waste to have because it will probably not
> print anything useful on a large CPU system...

Yeah, sometimes it helps to keep hitting it until you get the right CPU,
but that rather depends on interrupt distribution.

It would be neat to suppress the trace for idle CPUs.  I don't _think_
there's a need to display the trace for idle CPUs in sysrq-P?

> If you still want it to be a separate letter, just let me know
> which one of the last four I should take.

l :)
