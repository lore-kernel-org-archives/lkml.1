Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYHDLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYHDLUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYHDLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:20:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51839 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYHDLUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:20:06 -0400
Date: Mon, 4 Aug 2008 15:23:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] posix-timers: don't switch to ->group_leader if ->it_process dies
Message-ID: <20080804112346.GA76@tv-sign.ru>
References: <20080803174910.GA4913@tv-sign.ru> <20080804025633.A4620154217@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804025633.A4620154217@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Roland McGrath wrote:
>
> The key thing that the old code does it to drop the ref to the old task as
> soon as it notices.

I thought about this too. But, again, this doesn't actually work. And it is
very easy to pin the dead task_struct. The user can just create the
SIGEV_THREAD_ID timer and kill the sub-thread (->it_process). Without
calling timer_settime() the timer can't notice the death.

(just in case, please note that the next patch doesn't make things worse,
 when ->group_leader dies the timer should be destroyed soon).

> It may be worthwhile to do that in the case where
> send_sigqueue fails.

I think it is better to convert the posix timers to use "struct pid*" instead
of "struct task_struct*". This change looks more or less straightforward, and
it should fix the problem.

Oleg.

