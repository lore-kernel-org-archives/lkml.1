Return-Path: <linux-kernel-owner+w=401wt.eu-S1031208AbXDSIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031208AbXDSIeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031220AbXDSIeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:34:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031208AbXDSIeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:34:17 -0400
Date: Thu, 19 Apr 2007 10:33:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419083343.GA14885@wotan.suse.de>
References: <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070419031807.GA24512@wotan.suse.de> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419063810.GA22418@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 08:38:10AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > And yes, by fairly, I mean fairly among all threads as a base 
> > > resource class, because that's what Linux has always done
> > 
> > Yes, there are potential compatibility problems.  Example: a machine 
> > with 100 busy httpd processes and suddenly a big gzip starts up from 
> > console or cron.
> > 
> > Under current kernels, that gzip will take ages and the httpds will 
> > take a 1% slowdown, which may well be exactly the behaviour which is 
> > desired.
> > 
> > If we were to schedule by UID then the gzip suddenly gets 50% of the 
> > CPU and those httpd's all take a 50% hit, which could be quite 
> > serious.
> > 
> > That's simple to fix via nicing, but people have to know to do that, 
> > and there will be a transition period where some disruption is 
> > possible.
> 
> hmmmm. How about the following then: default to nice -10 for all 
> (SCHED_NORMAL) kernel threads and all root-owned tasks. Root _is_ 
> special: root already has disk space reserved to it, root has special 
> memory allocation allowances, etc. I dont see a reason why we couldnt by 
> default make all root tasks have nice -10. This would be instantly loved 
> by sysadmins i suspect ;-)

I have no problem with doing fancy new fairness classes and things.

But considering that we _need_ to have per-thread fairness and that
is also what the current scheduler has and what we need to do well for
obvious reasons, the best path to take is to get per-thread scheduling
up to a point where it is able to replace the current scheduler, then
look at more complex things after that.
 
