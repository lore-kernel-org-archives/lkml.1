Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZE2NPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZE2NPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZE2NOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:14:53 -0400
Received: from www.tglx.de ([62.245.132.106]:59363 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZE2NOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:14:53 -0400
Date: Fri, 29 May 2009 15:14:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 2/2] keep on ticking if oprofile is active
In-Reply-To: <20090529145734.6872f1f6@skybase>
Message-ID: <alpine.LFD.2.00.0905291514130.3397@localhost.localdomain>
References: <20090528150447.152019714@de.ibm.com> <20090528150502.305840931@de.ibm.com> <alpine.LFD.2.00.0905282220400.3397@localhost.localdomain> <20090529145734.6872f1f6@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Martin Schwidefsky wrote:
> On Thu, 28 May 2009 22:29:38 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 28 May 2009, Martin Schwidefsky wrote:
> > > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > 
> > > On a NOHZ system with oprofile enabled the timer tick should not be
> > > stopped when a cpu goes idle. Oprofile needs the pt_regs structure
> > > of the interrupt and allocates memory in the ring buffer for each
> > > sample. Current a maximum of 1 tick is accounted with oprofile if a
> > > cpu sleeps for a longer period of time. This does bad things to the
> > > percentages in the oprofile output. To postpone the oprofile tick to
> > > tick_nohz_restart_sched_tick analog to the in kernel profiler is not
> > > possible as there is no pt_regs structure in the context the
> > > tick_nohz_restart_sched_tick function is called and it is not a good
> > > idea to create hundreds of samples at once.
> > 
> >   Sigh. That's stupid.
> 
> What is stupid, the bug or the fix?

  The bug :)
  
> >   OTOH, thinking more about the patch itself it might be even useful
> >   for things aside oprofile. Runtime switching from and to nohz mode
> >   for debugging or evaluation purposes comes to my mind. That would
> >   need some sysfs interface, but that's not too hard to do.
> 
> That should be no problem. We used to have the hz_timer system control
> with the old no-tick solution on s390. 
> 
> >   So yeah, I think we should satisfy oprofile needs and utilize it further.
> 
> Ok, so you are in principle fine with the patch?

Yup.

	tglx
