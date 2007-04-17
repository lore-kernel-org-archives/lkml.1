Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXDQITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXDQITU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXDQITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:19:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:55149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbXDQITS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:19:18 -0400
Date: Tue, 17 Apr 2007 10:18:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417081857.GD20026@wotan.suse.de>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 01:03:46AM -0700, Davide Libenzi wrote:
> On Tue, 17 Apr 2007, Ingo Molnar wrote:
> 
> > ok - fortunately the delta between -v2-rc0 and -v2-final is pretty 
> > small. One difference is the child-runs-first fix. To restore the 
> > parent-runs-first logic, do this: 
> > 
> > 	echo 0 > /proc/sys/kernel/sched_child_runs_first
> 
> Sorry, I did not follow the latest developments, but how many tunables we 
> have so far in CFS? Are those for debug only or they're supposed to stay?
> Weren't those listed inside the Axis of Evil (just to remain in topic :) 
> till yesterday?

Actually I think this is something that makes sense to add, even if
just for debugging, but maybe also for production, depending on how
much it impacts things. Child runs first is an heuristic optimisation
that exploits a VM detail (however fundamental). But for things that
don't exec right after forking (and maybe some things that do), it
can be nicer to reduce context switches, improve cache patterns, and
allow children to be load balanced away before touching memory, if
child_runs_first is turned off.

