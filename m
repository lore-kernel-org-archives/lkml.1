Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYDKI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYDKI47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbYDKI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:56:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:10155 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYDKI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o4KbgAEzjYaBJSOfDDM1tlxVHnwNnCaqkSkp3vCocEuG5PYPBdeuxW1fqJwlOmOARjnJTiQMScM7dA3b9pfH9MA1KfrYbnKrCmKElY7gPrWtA3IlRHBo9pCoVPXHLlUC2t1vE2duwf3Vu2toY4nvlA2gqdot8C/jg4zZmkpf8vw=
Message-ID: <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>
Date: Fri, 11 Apr 2008 10:56:49 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Eugene Teo" <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1204212100.12120.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 5:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> > Peter,
> >
> > Could you please provide some text describing RLIMIT_RTTIMEfor the
> > getrlimit.2 man page.
>
> The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> This time is measured between sleeps, so a schedule in RR or a
> preemption in either is not a sleep - the task needs to be dequeued and
> enqueued for the timer to reset.
>
> Upon reaching the cur limit we start giving SIGXCPU every second, upon
> reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.
>
> Time is measured in tick granularity (for now).

So I have another question: why is the granularity of this rlimit
microseconds?  On the one hand, specifying limits down at the
microsecond level seems (to my naive eye) unlikely to be useful.  (But
perhaps I have missed a thread where this was explained.)  On the
other hand, it means that on 32-bit the largest time limit we can set
is ~4000 seconds, and I wonder if there are scenarios where it might
be useful to have larger limits than that.

Why not, for example, have a granularity of milliseconds?

Cheers,

Michael


> > On Fri, Feb 8, 2008 at 4:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
> > > > RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
> > > > real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
> > > > /proc/<pid>/limits with the new rlimit.
> > >
> > > Ah, didn't know about that file, thanks!
> > >
> > > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> > >
> > > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >
> > >
> > > > ---
> > > >  fs/proc/base.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > > index c59852b..dcf7be8 100644
> > > > --- a/fs/proc/base.c
> > > > +++ b/fs/proc/base.c
> > > > @@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
> > > >       [RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> > > >       [RLIMIT_NICE] = {"Max nice priority", NULL},
> > > >       [RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> > > > +     [RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> > > >  };
> > > >
> > > >  /* Display limits for a process */
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> >
> >
> >
>
>



-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
