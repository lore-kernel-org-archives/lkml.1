Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbXBSKuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbXBSKuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXBSKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:50:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58905 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbXBSKua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:50:30 -0500
Date: Mon, 19 Feb 2007 11:50:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix refrigerator() vs thaw_process() race
Message-ID: <20070219105008.GA19184@elf.ucw.cz>
References: <20070218221737.GA4880@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218221737.GA4880@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
> ordering.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- WQ/kernel/power/process.c~WAKE	2007-02-18 22:56:49.000000000 +0300
> +++ WQ/kernel/power/process.c	2007-02-19 01:04:26.000000000 +0300
> @@ -46,8 +46,10 @@ void refrigerator(void)
>  	recalc_sigpending(); /* We sent fake signal, clean it up */
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -		current->state = TASK_UNINTERRUPTIBLE;
> +		set_current_state(TASK_UNINTERRUPTIBLE);


Looks okay to me... but this one liner would be exactly as effective,
right?

								Pavel

>  		schedule();
>  	}
>  	pr_debug("%s left refrigerator\n", current->comm);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
