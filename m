Return-Path: <linux-kernel-owner+w=401wt.eu-S1030706AbXHMMuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706AbXHMMuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763249AbXHMHfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:35:44 -0400
Received: from www.osadl.org ([213.239.205.134]:49059 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764954AbXHMHfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:35:42 -0400
Subject: Re: [PATCH 2/4] posix-timers: fix creation race
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20070812194455.GA113@tv-sign.ru>
References: <20070812170522.GA4299@tv-sign.ru>
	 <1186945555.12828.89.camel@chaos>  <20070812194455.GA113@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 09:35:22 +0200
Message-Id: <1186990522.12828.94.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 23:44 +0400, Oleg Nesterov wrote:
> > > --- t/kernel/posix-timers.c~2_CREATE	2007-08-12 17:59:17.000000000 +0400
> > > +++ t/kernel/posix-timers.c	2007-08-12 18:11:33.000000000 +0400
> > > @@ -547,13 +547,12 @@ sys_timer_create(const clockid_t which_c
> > >  				new_timer->it_process = process;
> > >  				list_add(&new_timer->list,
> > >  					 &process->signal->posix_timers);
> > > -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
> > >  				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
> > >  					get_task_struct(process);
> > >  			} else {
> > > -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
> > >  				process = NULL;
> > >  			}
> > > +			spin_unlock_irqrestore(&process->sighand->siglock, flags);
> 
> i'll resend this patch tomorrow. We can't do spin_unlock_irqrestore(&process->...)
> if we set process = NULL above.

Doh, half of my brain seems to be still on vacation.

	tglx


