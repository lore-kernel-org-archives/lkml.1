Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXEKLc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXEKLc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXEKLcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:32:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39915 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756499AbXEKLcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:32:52 -0400
Date: Fri, 11 May 2007 13:32:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Jordi Colomer <jco@ict.es>
Subject: Re: [PATCH] Fix UCB1x00 driver to use sched_setscheduler
Message-ID: <20070511113245.GA27358@elf.ucw.cz>
References: <87ps57ejah.wl%takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ps57ejah.wl%takeuchi_satoru@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Fix Touchscreen driver for UCB1x00-based touchscreens to use
> sched_setscheduler() instead of setting the fields of task_struct directly.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Looks ok to me.
								Pavel

> Index: linux-2.6.21-fix-ucb-drivers/drivers/mfd/ucb1x00-ts.c
> ===================================================================
> --- linux-2.6.21-fix-ucb-drivers.orig/drivers/mfd/ucb1x00-ts.c	2007-05-11 18:53:36.000000000 +0900
> +++ linux-2.6.21-fix-ucb-drivers/drivers/mfd/ucb1x00-ts.c	2007-05-11 19:33:20.000000000 +0900
> @@ -214,8 +214,9 @@ static int ucb1x00_thread(void *_ts)
>  	 * We could run as a real-time thread.  However, thus far
>  	 * this doesn't seem to be necessary.
>  	 */
> -//	tsk->policy = SCHED_FIFO;
> -//	tsk->rt_priority = 1;
> +//	struct sched_param param = { .sched_priority = 1 };
> +//
> +//	sched_setscheduler(tsk, SCHED_FIFO, &param);
>  
>  	valid = 0;
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
