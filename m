Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYB1PVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYB1PVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYB1PVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:21:45 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:63823 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYB1PVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:21:44 -0500
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
References: <20080208145950.GA3910@kernel.sg>
	 <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:21:40 +0100
Message-Id: <1204212100.12120.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> Peter,
> 
> Could you please provide some text describing RLIMIT_RTTIMEfor the
> getrlimit.2 man page.

The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
This time is measured between sleeps, so a schedule in RR or a
preemption in either is not a sleep - the task needs to be dequeued and
enqueued for the timer to reset.

Upon reaching the cur limit we start giving SIGXCPU every second, upon
reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.

Time is measured in tick granularity (for now).

> Cheers,
> 
> Michael
> 
> On Fri, Feb 8, 2008 at 4:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
> > > RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
> > > real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
> > > /proc/<pid>/limits with the new rlimit.
> >
> > Ah, didn't know about that file, thanks!
> >
> > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> >
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> >
> > > ---
> > >  fs/proc/base.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index c59852b..dcf7be8 100644
> > > --- a/fs/proc/base.c
> > > +++ b/fs/proc/base.c
> > > @@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
> > >       [RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> > >       [RLIMIT_NICE] = {"Max nice priority", NULL},
> > >       [RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> > > +     [RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> > >  };
> > >
> > >  /* Display limits for a process */
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 

