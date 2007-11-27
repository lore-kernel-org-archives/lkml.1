Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXK0M7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXK0M7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXK0M7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:59:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:34294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXK0M7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:59:14 -0500
From: Andreas Schwab <schwab@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] timer_list should use signed numbers for relative times
References: <20071127124405.GA3943@elf.ucw.cz>
X-Yow: I'd like some JUNK FOOD...  and then I want to be ALONE --
Date: Tue, 27 Nov 2007 13:59:12 +0100
In-Reply-To: <20071127124405.GA3943@elf.ucw.cz> (Pavel Machek's message of
	"Tue\, 27 Nov 2007 13\:44\:05 +0100")
Message-ID: <jeaboz4zfj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Relative times are signed by nature, and timers can (briefly) have
> expires in past. Print them as negative numbers.
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index 12c5f4c..7f6eaa9 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -65,7 +65,7 @@ #ifdef CONFIG_TIMER_STATS
>  	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
>  #endif
>  	SEQ_printf(m, "\n");
> -	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
> +	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
>  		(unsigned long long)ktime_to_ns(timer->expires),
>  		(unsigned long long)(ktime_to_ns(timer->expires) - now));

Perhaps change the cast as well.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
