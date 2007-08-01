Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXHAUvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXHAUvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXHAUvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:51:00 -0400
Received: from mail.screens.ru ([213.234.233.54]:41296 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXHAUu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:50:59 -0400
Date: Thu, 2 Aug 2007 00:50:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070801205053.GA263@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net> <1185940340.2636.97.camel@imap.mvista.com> <1185987663.12034.99.camel@twins> <20070801181253.GA90@tv-sign.ru> <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186000468.2636.168.camel@imap.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Daniel Walker wrote:
>
> On Thu, 2007-08-02 at 00:18 +0400, Oleg Nesterov wrote:
> > On 08/01, Daniel Walker wrote:
> > >
> > > On Wed, 2007-08-01 at 22:12 +0400, Oleg Nesterov wrote:
> > > 
> > > > And I personally think it is not very useful, even if it was correct.
> > > > You can create your own workqueue and change the priority of cwq->thread.
> > > 
> > > This change is more dynamic than than just setting a single priority ..
> > > There was some other work going on around this, so it's not totally
> > > clear what the benefits are ..
> > 
> > Yes, I see. But still I think the whole idea is broken, not just the
> > implementation.
> 
> It's translating priorities through the work queues, which doesn't seem
> to happen with the current implementation. A high priority, say
> SCHED_FIFO priority 99, task may have to wait for a nice -5 work queue
> to finish..

Why should that task wait?

> > What about delayed_work? insert_work() will use ->normal_prio of
> > the random interrupted process, while queue_work() uses current.
> 
> Actually it would be the priority of the timer softirq .. I think what
> is desired here would be saving the priority of the task calling
> delayed_work then using that..

But mainline calls  __do_softirq() from interrupt (irq_exit).

Oleg.

