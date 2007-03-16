Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXCPHi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXCPHi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXCPHi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:38:57 -0400
Received: from www.osadl.org ([213.239.205.134]:35072 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752966AbXCPHi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:38:56 -0400
Subject: Re: [patch 6/13] signal/timer/event fds v6 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.9367.1174004538.6>
References: <send-serie.davidel@xmailserver.org.9367.1174004538.6>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 08:45:44 +0100
Message-Id: <1174031144.13341.249.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 17:22 -0700, Davide Libenzi wrote:
> +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> +			  const struct itimerspec *ktmr)
> +{
> +	enum hrtimer_mode htmode;
> +
> +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> +
> +	ctx->ticks = 0;
> +	ctx->texp = timespec_to_ktime(ktmr->it_value);

I know, I'm racking your nerves. texp is only used for setup. No need to
carry it in the ctx data structure. :)

> +	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> +	hrtimer_init(&ctx->tmr, clockid, htmode);
> +	ctx->tmr.expires = ctx->texp;
> +	ctx->tmr.function = timerfd_tmrproc;
> +	if (ctx->texp.tv64 != 0)
> +		hrtimer_start(&ctx->tmr, ctx->texp, htmode);
> +}

Thanks,

	tglx


