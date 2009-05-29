Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbZE2M6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbZE2M6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZE2M6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:58:43 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:42576 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbZE2M6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:58:43 -0400
Date: Fri, 29 May 2009 14:57:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 2/2] keep on ticking if oprofile is active
Message-ID: <20090529145734.6872f1f6@skybase>
In-Reply-To: <alpine.LFD.2.00.0905282220400.3397@localhost.localdomain>
References: <20090528150447.152019714@de.ibm.com>
	<20090528150502.305840931@de.ibm.com>
	<alpine.LFD.2.00.0905282220400.3397@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 22:29:38 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 28 May 2009, Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > On a NOHZ system with oprofile enabled the timer tick should not be
> > stopped when a cpu goes idle. Oprofile needs the pt_regs structure
> > of the interrupt and allocates memory in the ring buffer for each
> > sample. Current a maximum of 1 tick is accounted with oprofile if a
> > cpu sleeps for a longer period of time. This does bad things to the
> > percentages in the oprofile output. To postpone the oprofile tick to
> > tick_nohz_restart_sched_tick analog to the in kernel profiler is not
> > possible as there is no pt_regs structure in the context the
> > tick_nohz_restart_sched_tick function is called and it is not a good
> > idea to create hundreds of samples at once.
> 
>   Sigh. That's stupid.

What is stupid, the bug or the fix?
 
>   OTOH, thinking more about the patch itself it might be even useful
>   for things aside oprofile. Runtime switching from and to nohz mode
>   for debugging or evaluation purposes comes to my mind. That would
>   need some sysfs interface, but that's not too hard to do.

That should be no problem. We used to have the hz_timer system control
with the old no-tick solution on s390. 

>   So yeah, I think we should satisfy oprofile needs and utilize it further.

Ok, so you are in principle fine with the patch?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

