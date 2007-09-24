Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbXIXU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbXIXU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXIXU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:28:09 -0400
Received: from www.osadl.org ([213.239.205.134]:60523 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757726AbXIXU2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:28:07 -0400
Subject: Re: [patch 1/4] new timerfd API v2 - introduce a new
	hrtimer_forward_now() function
From: Thomas Gleixner <tglx@linutronix.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.3854.1190665357.1>
References: <send-serie.davidel@xmailserver.org.3854.1190665357.1>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 22:28:05 +0200
Message-Id: <1190665685.4035.249.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 13:22 -0700, Davide Libenzi wrote:
> I think that advancing the timer against the timer's current "now" can
> be a pretty common usage, so, w/out exposing hrtimer's internals, we add
> a new hrtimer_forward_now() function.
> 
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

Reviewed-and-Acked-by: Thomas Gleixner <tglx@linutronix.de>

> 
> - Davide
> 
> 
> ---
>  include/linux/hrtimer.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6.mod/include/linux/hrtimer.h
> ===================================================================
> --- linux-2.6.mod.orig/include/linux/hrtimer.h	2007-09-24 12:27:20.000000000 -0700
> +++ linux-2.6.mod/include/linux/hrtimer.h	2007-09-24 12:29:39.000000000 -0700
> @@ -298,6 +298,13 @@
>  extern unsigned long
>  hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
>  
> +/* Forward a hrtimer so it expires after the hrtimer's current now */
> +static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
> +						ktime_t interval)
> +{
> +	return hrtimer_forward(timer, timer->base->get_time(), interval);
> +}
> +
>  /* Precise sleep: */
>  extern long hrtimer_nanosleep(struct timespec *rqtp,
>  			      struct timespec __user *rmtp,
> 

