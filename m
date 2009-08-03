Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZHCICR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZHCICR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZHCICP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:02:15 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48051 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZHCICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:02:14 -0400
Date: Mon, 3 Aug 2009 10:02:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC][patch 10/12] move NTP adjusted clock multiplier to struct
 timekeeper
Message-ID: <20090803100209.29431638@skybase>
In-Reply-To: <1249083178.9941.8.camel@work-vm>
References: <20090729134125.313191633@de.ibm.com>
	<20090729134231.515027738@de.ibm.com>
	<1248991488.3374.14.camel@localhost>
	<20090731095254.3ed0cb7d@skybase>
	<1249027979.3333.8.camel@work-vm>
	<20090731110003.44cc16a9@skybase>
	<1249083178.9941.8.camel@work-vm>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 16:32:58 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Fri, 2009-07-31 at 11:00 +0200, Martin Schwidefsky wrote:
> > How about this definition for struct timekeeper?
> > 
> > /* Structure holding internal timekeeping values. */
> > struct timekeeper {
> >         /* Current clocksource used for timekeeping. */
> >         struct clocksource *clock;
> >         /* The shift value of the current clocksource. */
> >         int     shift;
> > 
> >         /* Number of clock cycles in one NTP interval. */
> >         cycle_t cycle_interval;
> >         /* Number of clock shifted nano seconds in one NTP interval. */
> >         u64     xtime_interval;
> >         /* Raw nano seconds accumulated per NTP interval. */
> 
> I might just use the term "accumulation interval"  instead of NTP
> interval. This isn't something that's strictly connected to NTP, other
> then they both just need to have some chunk of time that we use as an
> comparative interval.

Acuumulation interval is more generic but it IS the NTP interval, no?
Do we plan to ever use something different than the NTP interval? 

> >         u32     raw_interval;
> > 
> >         /* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
> >         u64     xtime_nsec;
> >         /* Difference between accumulated time and NTP time in ntp
> >          * shifted nano seconds. */
> >         s64     ntp_error;
> >         /* Shift conversion between clock shifted nano seconds and
> >          * ntp shifted nano seconds. */
> >         int     ntp_error_shift;
> >         /* NTP adjusted clock multiplier */
> >         u32     mult;
> > };
> 
> Other then that it looks good to me!

Ok, I'll update the patches.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

