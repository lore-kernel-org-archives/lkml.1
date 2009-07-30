Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZG3Qdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZG3Qdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZG3Qdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:33:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49561 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZG3Qdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:33:50 -0400
Date: Thu, 30 Jul 2009 18:30:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com, utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] introduce tracehook_finish_jctl() helper
Message-ID: <20090730163035.GA3617@redhat.com>
References: <20090729020139.GA7381@redhat.com> <20090729155007.f4f5a793.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729155007.f4f5a793.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Andrew Morton wrote:
>
> On Wed, 29 Jul 2009 04:01:40 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +static inline void tracehook_finish_jctl(void)
> > +{
> > +}
> > +
> >  #define DEATH_REAP			-1
> >  #define DEATH_DELAYED_GROUP_LEADER	-2
> >
> > --- __UTRACE/kernel/signal.c~2_FINISH_JCTL	2009-07-29 03:17:49.000000000 +0200
> > +++ __UTRACE/kernel/signal.c	2009-07-29 03:57:07.000000000 +0200
> > @@ -1735,12 +1735,12 @@ static int do_signal_stop(int signr)
> >  		read_unlock(&tasklist_lock);
> >  	}
> >
> > +	/* Now we don't run again until woken by SIGCONT or SIGKILL */
> >  	do {
> >  		schedule();
> >  	} while (try_to_freeze());
> > -	/*
> > -	 * Now we don't run again until continued.
> > -	 */
> > +
> > +	tracehook_finish_jctl();
> >  	current->exit_code = 0;
> >
>
> Confused.  This patch has no effect.

Yes, currently tracehook_finish_jctl() does nothing. This patch is
needed to add the functional changes later, without touching the code
outside of tracehook/etc. It is like tracehook_notify_resume() which
does nothing until we add the real tracing.

Oleg.

