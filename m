Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYLTVGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYLTVGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 16:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYLTVFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 16:05:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbYLTVFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 16:05:55 -0500
Date: Sat, 20 Dec 2008 22:04:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
Message-ID: <20081220210401.GA14447@redhat.com>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Thomas Gleixner wrote:
>
> +static int no_timer_create(struct k_itimer *new_timer)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  /*
>   * Return nonzero if we know a priori this clockid_t value is bogus.
>   */
> @@ -248,6 +253,7 @@ static __init int init_posix_timers(void)
>  		.clock_getres = hrtimer_get_res,
>  		.clock_get = posix_get_monotonic_raw,
>  		.clock_set = do_posix_clock_nosettime,
> +		.timer_create = no_timer_create,

Agreed, this patch is better than mine (and thanks for your
explanation about CLOCK_MONOTONIC_RAW).

I am not sure about -EOPNOTSUPP. To clarify, I do not claim this
is wrong, I just do not know.

But please note that sys_timer_create() does:

	if (invalid_clockid(which_clock))
		return -EINVAL;

And ltp's timer_create04.c expects timer_create(MAX_CLOCKS == 4)
returns -EINVAL.

Oleg.

