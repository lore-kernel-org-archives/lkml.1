Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYGRQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYGRQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760513AbYGRQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:30:26 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:23090 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504AbYGRQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:30:24 -0400
Date: Fri, 18 Jul 2008 18:29:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eric miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Message-ID: <20080718162905.GA4781@osiris.boeblingen.de.ibm.com>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu> <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de> <f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com> <alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 05:27:28PM +0200, Thomas Gleixner wrote:
> On Fri, 18 Jul 2008, eric miao wrote:
> > On Fri, Jul 18, 2008 at 9:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> Thomas, Peter, Dmitry, do you concur with the analysis? (commit below)
> > >
> > > Yes. I did not understand the issue when Jack pointed it out to me,
> > > but with Erics explanation it's really clear. Thanks for tracking that
> > > down.
> > 
> > Actually, Jack did most of the analysis and came up with this quick
> > fix.
> > 
> > >
> > >> It looks a bit ugly to me in the middle of schedule() - is there no wait
> > >> to solve this within kernel/time/*.c ?
> > >
> > > Hmm, yes. I think the proper fix is to enable the tick stop mechanism
> > > in the idle loop and disable it before we go to schedule. That takes
> > > an additional parameter to tick_nohz_stop_sched_tick(), but we then
> > > gain a very clear section where the nohz mimic can be active.
> > >
> > > I'll whip up a patch.
> > 
> > Sounds great, thanks.
> 
> Hey, thanks for tracking that down. I was banging my head against the
> wall when I understood the problem.
> 
> I tried to pinpoint the occasional softlockup bug reports, but I
> probably stared too long into that code so I just saw what I expected
> to see.
> 
> Can you give the patch below a try please ?

If this patch works, could you also add the s390 hunk before submitting?
Thanks! ;)
