Return-Path: <linux-kernel-owner+w=401wt.eu-S1765733AbYB1UPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765733AbYB1UPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761756AbYB1UO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:14:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760463AbYB1UO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:14:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 February 2008 18:36:55 +0300 <20080228153655.GC11484@tv-sign.ru>
References: <47BEC663.7050904@openvz.org>
	<20080222144155.GA4349@tv-sign.ru>
	<alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de>
	<20080228061723.GB108@tv-sign.ru>
	<20080228113633.7431C2700FD@magilla.localdomain>
	<20080228153655.GC11484@tv-sign.ru>
X-Zippy-Says: I had pancake makeup for brunch!
Message-Id: <20080228201450.F23BB2700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 12:14:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not clear on how the already-queued case could ever happen.  Do we
> > really need that check at all?  It shouldn't be possible for the timer to
> > be firing when it's already queued, because it won't have been reloaded.
> > It only reloads via do_schedule_next_timer after it's dequeued, or because
> > a 1 return value said it never was queued.
> 
> This is true for the posix timers, but posix cpu timers case is different.
> Note the run_posix_cpu_timers()->cpu_timer_fire().

Really?  It too reloads the CPU timer only when posix_timer_event returns
nonzero, and otherwise expects do_schedule_next_timer to be called from
signal dequeuing and call posix_cpu_timer_schedule to do the reload.  I
must be missing something (having written the code I am easily deluded into
thinking I know what it's doing).


Thanks,
Roland
