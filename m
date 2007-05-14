Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXENJVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXENJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXENJVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:21:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46340 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755617AbXENJVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:21:13 -0400
Date: Mon, 14 May 2007 11:21:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: tglx@linutronix.de, Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Fix UCB1x00 driver to use sched_setscheduler
Message-ID: <20070514092109.GJ11735@elf.ucw.cz>
References: <87ps57ejah.wl%takeuchi_satoru@jp.fujitsu.com> <1178975427.22481.153.camel@localhost.localdomain> <87mz08e0qx.wl%takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mz08e0qx.wl%takeuchi_satoru@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Index: linux-2.6.21-fix-ucb-drivers/drivers/mfd/ucb1x00-ts.c
> > > ===================================================================
> > > --- linux-2.6.21-fix-ucb-drivers.orig/drivers/mfd/ucb1x00-ts.c	2007-05-11 18:53:36.000000000 +0900
> > > +++ linux-2.6.21-fix-ucb-drivers/drivers/mfd/ucb1x00-ts.c	2007-05-11 19:33:20.000000000 +0900
> > > @@ -214,8 +214,9 @@ static int ucb1x00_thread(void *_ts)
> > >  	 * We could run as a real-time thread.  However, thus far
> > >  	 * this doesn't seem to be necessary.
> > >  	 */
> > > -//	tsk->policy = SCHED_FIFO;
> > > -//	tsk->rt_priority = 1;
> > > +//	struct sched_param param = { .sched_priority = 1 };
> > > +//
> > > +//	sched_setscheduler(tsk, SCHED_FIFO, &param);
> > 
> > Can we please remove the unused code completely instead of replacing it
> > by more commented out code ?
> 
> It's OK to me, but I'm not the driver writer and doesn't know how important
> are those comments. If removing them is better for driver writers too, here
> is the patch.

I doubt anyone cares either way. Feel free to add my ACK to either
"remove" or "fix" version.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
