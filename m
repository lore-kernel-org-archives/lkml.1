Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXDMNkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXDMNkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXDMNkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:40:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:48925 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbXDMNko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:40:44 -0400
Date: Fri, 13 Apr 2007 17:40:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] worker_thread: don't play with SIGCHLD
Message-ID: <20070413134046.GA180@tv-sign.ru>
References: <20070413072910.GA1522@tv-sign.ru> <m1irc0pfyq.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irc0pfyq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > depends on Eric's
> >
> > 	kthread-dont-depend-on-work-queues-take-2.patch
> >
> > worker_thread() inherits ignored SIGCHLD from its parent, kthreadd.
> > We can remove unneeded do_sigaction().
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Looks good.
> 
> We could delete all of:
> 
> > 	set_user_nice(current, -5);
> > 
> > 	/* Block and flush all signals */
> > 	sigfillset(&blocked);
> > 	sigprocmask(SIG_BLOCK, &blocked, NULL);
> > 	flush_signals(current);

this one is already deleted in -mm...

> > 	/*
> > 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
> > 	 * Set MPOL_DEFAULT to insure node local allocations.
> > 	 */
> > 	numa_default_policy();

Yes, I forgot about this!

> If we wanted to, as that all comes by default from kthreadd.

Thanks, will send an update.

Oleg.

