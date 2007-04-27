Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXD0HX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXD0HX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXD0HX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:23:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:58365 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbXD0HX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:23:56 -0400
Date: Fri, 27 Apr 2007 11:23:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070427072349.GA106@tv-sign.ru>
References: <20070424215034.GA5985@tv-sign.ru> <20070425130246.GA4086@ff.dom.local> <20070425125214.GB94@tv-sign.ru> <20070426142921.GE3145@ff.dom.local> <20070426152953.GA1824@tv-sign.ru> <20070427061506.GC997@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427061506.GC997@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Jarek Poplawski wrote:
>
> According to workqueue.h:
> > /*
> >  * Kill off a pending schedule_delayed_work().  Note that the work callback
> >  * function may still be running on return from cancel_delayed_work().  Run
> >  * flush_workqueue() or cancel_work_sync() to wait on it.
> >  */
> > static inline int cancel_delayed_work(struct delayed_work *work)
> 
> So, we can do something like this:
> 
> cancel_delayed_work(dwork);
> flush_workqueue(wq);
> kfree(some_obj_used_by_dwork_func);
> 
> And this is enough to work with not rearming work.
> 
> But no more after this patch...

Yes, you are right, and so this patch is wrong.

This is even documented in the changelog, with this change cancel_delayed_work()
may return while the queueing is in progress. However, in that case we can not
rely on flush_workqueue/cancel_work_sync.

Thanks a lot!

Oleg.

