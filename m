Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZGFOP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZGFOP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZGFOPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:15:49 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:62715 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZGFOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:15:48 -0400
Date: Mon, 6 Jul 2009 16:15:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
Message-ID: <20090706161535.4a36b4cb@skybase>
In-Reply-To: <4A52051A.60407@gmail.com>
References: <20090706154933.5a1f8990@skybase>
	<4A52051A.60407@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jul 2009 16:07:22 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > diff -urpN linux-2.5/kernel/time/timekeeping.c linux-2.5-patched/kernel/time/timekeeping.c
> > --- linux-2.5/kernel/time/timekeeping.c	2009-07-03 10:46:07.000000000 +0200
> > +++ linux-2.5-patched/kernel/time/timekeeping.c	2009-07-03 10:46:23.000000000 +0200
> > @@ -118,6 +118,69 @@ void getnstimeofday(struct timespec *ts)
> >  
> >  EXPORT_SYMBOL(getnstimeofday);
> >  
> > +ktime_t ktime_get(void)
> > +{
> > +	cycle_t cycle_now, cycle_delta;
> > +	struct timespec time;
> > +	unsigned long seq;
> > +	s64 nsecs;
> > +
> > +	do {
> > +		seq = read_seqbegin(&xtime_lock);  
> 
> minor nit : read_seqbegin() returns an "unsigned int", not an "unsigned long"
 
Hmm, just cut-copy-pasted the seq-loop. Seems like a job for the janitor ..
But I will update my patch.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

