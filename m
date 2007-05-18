Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbXERU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbXERU2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXERU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:28:05 -0400
Received: from mail.screens.ru ([213.234.233.54]:45135 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXERU2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:28:04 -0400
Date: Sat, 19 May 2007 00:28:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Zilvinas Valinskas <zilvinas@wilibox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 + CFS v12)
Message-ID: <20070518202805.GA298@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com> <20070516121538.7b108c10.akpm@linux-foundation.org> <20070516225543.GA337@tv-sign.ru> <1179390065.4760.5.camel@zv.wilibox.com> <20070517184556.GA81@tv-sign.ru> <1179485230.3800.20.camel@zv.wilibox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179485230.3800.20.camel@zv.wilibox.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Zilvinas Valinskas wrote:
>
> On Thu, 2007-05-17 at 22:45 +0400, Oleg Nesterov wrote:
> >
> > However, I can't understand why cleanup_workqueue_thread() hangs anyway.
> > It shouldn't. Looks like rpciod/1 was preempted, and can't get CPU. According
> > to kernel-nfs-freeze.log it is TASK_RUNNING. Strange.
> >
> > It is very sad, because this code was supposed to be cleanuped anyway,
> > but if it is really buggy, it would be great to know why.
>
> Can this be related to :
>
> CONFIG_PREEMPT=y

Yes, but this preemption should be very unlikely, but it happens every time
for you, strange. lockd in turn spins with preemption enabled, but somehow
rpciod/1 can't make progress. system_state == SYSTEM_HALT, but this shouldn't
affect preempt_schedule_irq(). So I think there is something else.

> workqueue.objdump - without any patch.

So it hangs waiting for cwq->thread == NULL, as expected.

OK. I still can't see how this code could be wrong, but it is bad anyway and
should be changed. The 2nd patch was done more than a month ago, but was
delayed for some stupid reasons. I'll send it today.

Still, it is not clear to me what happens, and you have other crashes with
nfs stop/start

	http://marc.info/?l=linux-kernel&m=117939027602591
	http://marc.info/?l=linux-kernel&m=117939257630947

which probaly need some attention.

Thanks!

Oleg.

