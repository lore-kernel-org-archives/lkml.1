Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbZGWHxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbZGWHxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZGWHxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:53:40 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:38286 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZGWHxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:53:39 -0400
Date: Thu, 23 Jul 2009 09:53:36 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
Message-ID: <20090723095336.2cb4b1a4@skybase>
In-Reply-To: <1248308900.7592.36.camel@localhost.localdomain>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192057.177653956@de.ibm.com>
	<1248205851.14209.777.camel@desktop>
	<1248213607.3298.107.camel@localhost>
	<20090722092519.772b238b@skybase>
	<1248284733.18789.32.camel@work-vm>
	<1248308900.7592.36.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 17:28:20 -0700
john stultz <johnstul@us.ibm.com> wrote:

> Hey Martin,
> 	So here's a really quick swipe at breaking apart the clocksource struct
> into a clocksource only portion and a timekeeping portion.
> 
> Caveats:
> 1) This doesn't completely build. The core bits do, but there's still a
> few left-over issues (see following caveats). Its just here to give you
> an idea of what I'm thinking about. I'd of course break it up into more
> manageable chunks before submitting it.
> 
> 2) Structure names aren't too great right now. Not sure timeclock is
> what I want to use, probably system_time or something. Will find/replace
> before the next revision is sent out.
> 
> 3) I still need to unify the clocksource and cyclecounter structures, as
> they're basically redundant now.
> 
> 4) I still need to fix the update_vsyscall code (shouldn't be hard, I
> didn't want to run through arch code yet).
> 
> 5) The TSC clocksource uses cycles_last to avoid very slight skew issues
> (that otherwise would not be noticed). Not sure how to fix that if we're
> pulling cycles_last (which is purely timekeeping state) out of the
> clocksource. Will have to think of something.
> 
> 
> Other cleanups still out there in the distant future:
> 1) Once all arches are converted to GENERIC_TIME, we can remove the
> ifdefs, and cleanup a lot of the more complicated xtime struct
> manipulation. It will cleanup update_wall_time() nicely.
> 
> 2) I have a logarithmic accumulation patch to update_wall_time that will
> remove the need for xtime_cache to be managed and updated. Just have to
> spend some additional time making sure its bugfree.
> 
> 3) Once all arches are converted to using read_persistent_clock(), then
> the arch specific time initialization can be dropped. Removing the
> majority of direct xtime structure accesses.
> 
> 4) Then once the remaining direct wall_to_monotonic and xtime accessors
> are moved to timekeeping.c we can make those both static and embed them
> into the core timekeeping structure.
> 
> 
> But let me know if this patch doesn't achieve most of the cleanup you
> wanted to see.

Cool, I'll have a look. What I can see right away is that a lot of the
changes I tried yesterday are contained in your patch as well.
But your patch is more radical, a lot more is (re-)moved from the
struct clocksource. That mult_orig goes aways is good :-)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

