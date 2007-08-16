Return-Path: <linux-kernel-owner+w=401wt.eu-S1765137AbXHPQA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765137AbXHPQA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXHPQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:00:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41208 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779AbXHPQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:00:45 -0400
Date: Thu, 16 Aug 2007 20:03:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty_io.c: don't use flush_scheduled_work()
Message-ID: <20070816160309.GB213@tv-sign.ru>
References: <20070701153749.GA111@tv-sign.ru> <20070816115349.GA26908@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816115349.GA26908@localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Dan Aloni wrote:
>
> On Sun, Jul 01, 2007 at 07:37:49PM +0400, Oleg Nesterov wrote:
> > I don't know how to test this patch, the ack/nack from maintainer is wanted.
> > 
> > flush_scheduled_work() is evil and should be avoided. Change tty_set_ldisc()
> > and release_dev() to use cancel_delayed_work_sync/cancel_work_sync.
> > 
> > I am not sure we really need to call do_tty_hangup() when cancel_work_sync()
> > returns true, but this matches the current behaviour.
> 
> I also noticed this problem recently with 2.6.22, on a 2-CPU box where there 
> was one SCHED_RR userspace process stuck in a busy loop. The box was completely 
> responsive but had this annoyance where all tty closings were stuck in 
> flush_scheduled_work(). It's especially noticable when you ssh to the machine
> and then try to log out.

cancel_work_sync(work) can hang too if some SCHED_RR userspace process does not
relinquish CPU, but the probability is much lower (it should preempt work->func
of that work_struct).

see also http://marc.info/?l=linux-kernel&m=118115098120503.

Oleg.

