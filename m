Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbYB1Po0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbYB1Po0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbYB1PoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:44:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:50842 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbYB1PoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XTGK/aYp9EHaTYP/zN2uGkxEAfkBWlHf8q0BQzzbIuCg9MO0Hq+gI3bA4+bX573C/qTrvJRpIoY/p3APfDG+VS9YuE5uGfJRXcuSxELVMnQi05BQnzCwvH5HtJ0ioCuZ+IAwvG1PERe/YDSD+u/2Ueris4v5tD1o8fRPUs9e05c=
Message-ID: <cfd18e0f0802280744q18ccad3at3c88bac166806118@mail.gmail.com>
Date: Thu, 28 Feb 2008 16:44:16 +0100
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

Peter,

Thanks for the text.

On Thu, Feb 28, 2008 at 4:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
>  > Peter,
>  >
>  > Could you please provide some text describing RLIMIT_RTTIMEfor the
>  > getrlimit.2 man page.
>
>  The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
>  This time is measured between sleeps, so a schedule in RR or a
>  preemption in either is not a sleep - the task needs to be dequeued and
>  enqueued for the timer to reset.

Just to clarify: sleep here means a call to some blocking syscall
(e.g., nanosleep(), read(), select(), etc.), right?  Is there anything
else that falls under the category of "sleep"?  What about a call to
sched_yield() where the process explicitly lets go of the CPU?

Also, is this limit per-thread or per-process?  I assume the latter --
but can you confirm please.

Cheers,

Michael

>  Upon reaching the cur limit we start giving SIGXCPU every second, upon
>  reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.
>
>  Time is measured in tick granularity (for now).
>
>
>
>  > Cheers,
>  >
>  > Michael
>  >
>  > On Fri, Feb 8, 2008 at 4:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  > >
>  > > On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
>  > > > RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
>  > > > real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
>  > > > /proc/<pid>/limits with the new rlimit.
>  > >
>  > > Ah, didn't know about that file, thanks!
>  > >
>  > > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
>  > >
>  > > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  > >
>  > >
>  > > > ---
>  > > >  fs/proc/base.c |    1 +
>  > > >  1 files changed, 1 insertions(+), 0 deletions(-)
>  > > >
>  > > > diff --git a/fs/proc/base.c b/fs/proc/base.c
>  > > > index c59852b..dcf7be8 100644
>  > > > --- a/fs/proc/base.c
>  > > > +++ b/fs/proc/base.c
>  > > > @@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
>  > > >       [RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
>  > > >       [RLIMIT_NICE] = {"Max nice priority", NULL},
>  > > >       [RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
>  > > > +     [RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
>  > > >  };
>  > > >
>  > > >  /* Display limits for a process */
>  > >
>  > > --
>  > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > > the body of a message to majordomo@vger.kernel.org
>  > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > > Please read the FAQ at  http://www.tux.org/lkml/
>  > >
>  >
>  >
>  >
>
>



-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
