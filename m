Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYFYPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYFYPfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYFYPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:35:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44005 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657AbYFYPfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:35:34 -0400
Date: Wed, 25 Jun 2008 19:38:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
Message-ID: <20080625153806.GA499@tv-sign.ru>
References: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Michael Kerrisk wrote:
>
> --- /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c.orig	2008-06-24
> 16:20:39.000000000 +0200
> +++ /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c	2008-06-24
> 16:22:17.000000000 +0200
> @@ -1379,10 +1379,9 @@
> 
>  	info.si_uid = tsk->uid;
> 
> -	/* FIXME: find out whether or not this is supposed to be c*time. */
> -	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
> +	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
>  						       tsk->signal->utime));
> -	info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
> +	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
>  						       tsk->signal->stime));
> 
>  	info.si_status = tsk->exit_code & 0x7f;
> @@ -1450,9 +1449,8 @@
> 
>  	info.si_uid = tsk->uid;
> 
> -	/* FIXME: find out whether or not this is supposed to be c*time. */
> -	info.si_utime = cputime_to_jiffies(tsk->utime);
> -	info.si_stime = cputime_to_jiffies(tsk->stime);
> +	info.si_utime = cputime_to_clock_t(tsk->utime);
> +	info.si_stime = cputime_to_clock_t(tsk->stime);
> 
>   	info.si_code = why;
>   	switch (why) {

This looks like the obviously good fix to me.

The patch also deletes the comment about signal_struct->cXtime,
this also looks right: why should we use cutime/cstime ?

Oleg.

