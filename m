Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbZAUMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbZAUMsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZAUMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:48:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55611 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419AbZAUMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:48:10 -0500
Date: Wed, 21 Jan 2009 13:45:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: not allow recursion run_workqueue
Message-ID: <20090121124514.GA13404@redhat.com>
References: <4976EE11.7010007@cn.fujitsu.com> <1232536373.4847.115.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232536373.4847.115.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Peter Zijlstra wrote:
>
> On Wed, 2009-01-21 at 17:42 +0800, Lai Jiangshan wrote:
> > 1) lockdep will complain when recursion run_workqueue
> > 2) works is not run orderly when recursion run_workqueue
> >
> > 3) BUG!
> >    We use recursion run_workqueue to hidden deadlock when
> >    keventd trying to flush its own queue.
> >
> >    It's bug. When flush_workqueue()(nested in a work callback)returns,
> >    the workqueue is not really flushed, the sequence statement of
> >    this work callback will do some thing bad.
> >
> >    So we should not allow workqueue trying to flush its own queue.
>
> The patch looks good, but I'm utterly failing to comprehend this
> changelog. What exactly can go wrong (other than the obvious too deep
> nest and the fact that lockdep will complain)?

I am confused too.


But the change itself looks good to me, I am only worried if we still
have the callers of flush() from within work->func().

> +	WARN_ON(cwq->thread == current);

probably BUG_ON() is better, we are going to deadlock in this case.

Oleg.

