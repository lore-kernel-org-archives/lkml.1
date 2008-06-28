Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYF1Mgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYF1Mgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYF1MgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:36:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56725 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYF1MgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:36:10 -0400
Date: Sat, 28 Jun 2008 16:38:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sched: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080628123825.GA1682@tv-sign.ru>
References: <20080608172041.GA10383@tv-sign.ru> <20080627204954.4CC04154226@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627204954.4CC04154226@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09, Roland McGrath wrote:
>
   ^^^^^
Oops, something is wrong! I received this message today, 06/28.

> > Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
> > This is needed to preserve the current behaviour (ptrace_notify). I hope
> > this check will be removed soon, but this (afaics good) change needs the
> > separate discussion.
> 
> Agreed.  I think it might actually already be safe to drop it, but we can
> get to that after this settles.

Great! I'll re-send the patch which drops it in a minute.

Could you also look at other patches?

	[PATCH 2/3] ptrace: never sleep in TASK_TRACED if SIGKILL'ed
	http://marc.info/?l=linux-kernel&m=121362601402886

	[PATCH 3/3] ptrace: kill may_ptrace_stop()
	http://marc.info/?l=linux-kernel&m=121362601702897

I think ptrace_stop() really needs changes. But I don't know what is
the supposed behaviour of PT_TRACE_EXIT. Should we sleep even if the
task was killed? Should we sleep if the thread was killed because another
one does exit_group() or exec() ?

We can use "SIGNAL_GROUP_EXIT && (group_exit_code & 0x7f)" instead
of signal_group_exit() to be sure that task was killed by the fatal
signal.

Oleg.

