Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbXD0I5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbXD0I5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXD0I5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:57:47 -0400
Received: from mx10.go2.pl ([193.17.41.74]:60502 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755483AbXD0I5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:57:46 -0400
Date: Fri, 27 Apr 2007 11:03:39 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070427090338.GA2454@ff.dom.local>
References: <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070425144759.GA201@tv-sign.ru> <20070426125918.GC3145@ff.dom.local> <20070426163406.GA1933@tv-sign.ru> <20070427052618.GA997@ff.dom.local> <20070427075247.GB106@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427075247.GB106@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:52:47AM +0400, Oleg Nesterov wrote:
> On 04/27, Jarek Poplawski wrote:
...
> > > Sorry, can't understand. done == 0 means that the queueing in progress,
> > > this work should be placed on cwq->worklist very soon, most probably
> > > right after we drop cwq->lock.
> > 
> > I think, theoretically, probably, maybe, there is possible some strange
> > case, this function gets spin_lock only when: list_empty(&work->entry) == 1
> > && _PENDING == 1 && del_timer(&dwork->timer) == 0.
> 
> Yes, but this is not so strange, this means the queueing in progress. Most
> probably the "owner" of WORK_STRUCT_PENDING bit spins waiting for cwq->lock.
> We will retry in this case. Of course, if we have a workqueue with the single
> work which just re-arms itself via queue_work() (without delay) and does nothing
> more, we may need a lot of looping.

I've forgot most of the math already, but there is (probably)
some Parkinson's Law about it. So, by this strange case I
mean really lot of looping (something around infinity - quite
precisely).

> 
> > PS: probably unusable, but for my own satisfaction:
> > 
> > Acked-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> It is useable, at least for me. I hope you will re-ack when I actually send

This is even more strange...
BTW, I take a week of vacation (people here deserve to rest
from me), so let's say it's both acked and re-acked by me.

> the patch. Note that the "else" branch above doesn't need cwq->lock, and we
> should start with del_timer(), because the pending timer is the most common
> case.

I see, you've thought about it probably more than you said
so, I trust you 100% here (but will check later, anyway...).

Cheers,
Jarek P. 
