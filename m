Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbXCES5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbXCES5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbXCES5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:57:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41674 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbXCES5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:57:21 -0500
Subject: Re: [PATCH] fix vsyscall settimeofday
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070305165648.518964015@mvista.com>
References: <20070305165648.518964015@mvista.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 10:57:18 -0800
Message-Id: <1173121038.31232.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 08:56 -0800, Daniel Walker wrote:
> I've only seen this on x86_64 .
> 
> The vsyscall state only gets updated when a timer interrupts comes in . So
> if the time is set long before the next timer, there will be a period when
> a gettimeofday() won't reflect the correct time.
> 
> I added an explicit update_vsyscall() during the settimeofday(), that way
> the vsyscall state doesn't get stale.
> 
> Any thought John?

Oh! Yes, very good catch, Daniel!

Thanks so much!
-john


> Signed-Off-By: Daniel Walker <dwalker@mvista.com>

Acked-by: John Stultz <johnstul@us.ibm.com>


> ---
>  kernel/timer.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.20/kernel/timer.c
> ===================================================================
> --- linux-2.6.20.orig/kernel/timer.c
> +++ linux-2.6.20/kernel/timer.c
> @@ -861,6 +861,8 @@ int do_settimeofday(struct timespec *tv)
>  	clock->error = 0;
>  	ntp_clear();
> 
> +	update_vsyscall(&xtime, clock);
> +
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
> 
>  	/* signal hrtimers about time change */

