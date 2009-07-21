Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZGUVzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZGUVzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZGUVzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:55:44 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:33573 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbZGUVzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:55:43 -0400
Date: Tue, 21 Jul 2009 23:55:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
Message-ID: <20090721235538.14929e8e@skybase>
In-Reply-To: <1248205851.14209.777.camel@desktop>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192057.177653956@de.ibm.com>
	<1248205851.14209.777.camel@desktop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 12:50:51 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (clocksource-move.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Move clock source related code from timekeeping.c to clocksource.c
> > where they belong. The selected clocks source "clock" is now defined
> > in clocksource.c and clocksource_init is added to set up the initial
> > clock.
> 
> The problem is most (if not all) the code your moving is actually time
> keeping code .. The reason it seems like clocksource code is cause John
> wasn't very choosy about which structure he added variables too .. So
> really this clean up needs to be in reverse, remove all the timekeeping
> code from the clocksource code.

You are refering to the following variables, aren't you?

        cycle_t cycle_interval;
        u64     xtime_interval;
        u32     raw_interval;
        u64 xtime_nsec;
        s64 error;
        struct timespec raw_time;

There is a dependency between these values and the clocksource. But they
are only needed for the current active clock, so we could move them out
of the clocksource data structure and make them static variables in
timekeeping.c. I guess it would improve the code separation for
update_wall_time as well. Hmm, worth a try.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

