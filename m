Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXELNH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXELNH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 09:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXELNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 09:07:22 -0400
Received: from www.osadl.org ([213.239.205.134]:38968 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756628AbXELNHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 09:07:21 -0400
Subject: Re: [PATCH] Fix UCB1x00 driver to use sched_setscheduler
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Jordi Colomer <jco@ict.es>
In-Reply-To: <87ps57ejah.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87ps57ejah.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 12 May 2007 15:10:27 +0200
Message-Id: <1178975427.22481.153.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 19:39 +0900, Satoru Takeuchi wrote:
> Fix Touchscreen driver for UCB1x00-based touchscreens to use
> sched_setscheduler() instead of setting the fields of task_struct directly.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
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

Can we please remove the unused code completely instead of replacing it
by more commented out code ?

	tglx




