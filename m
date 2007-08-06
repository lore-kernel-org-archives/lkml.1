Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbXHFQsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbXHFQsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXHFQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:48:09 -0400
Received: from mail.screens.ru ([213.234.233.54]:59864 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXHFQsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:48:08 -0400
Date: Mon, 6 Aug 2007 20:50:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806165007.GB4021@tv-sign.ru>
References: <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <1186400154.21381.40.camel@ghaskins-t60p.haskins.net> <20070806142616.GA210@tv-sign.ru> <1186412235.21381.82.camel@ghaskins-t60p.haskins.net> <20070806153655.GA245@tv-sign.ru> <1186415403.21381.100.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186415403.21381.100.camel@ghaskins-t60p.haskins.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Gregory Haskins wrote:
>
> On Mon, 2007-08-06 at 19:36 +0400, Oleg Nesterov wrote:
> 
> > > E.g. whatever work was being flushed was allowed to escape
> > > out from behind the barrier.  If you don't care about the flush working,
> > > why do it at all?
> > 
> > The caller of flush_workueue() doesn't necessary know we have such a work
> > on list. It just wants to flush its own works.
> 
> I was assuming that the work being flushed was submitted by the same
> context, but I think I see what you are saying now.  Essentially if that
> queued work was unrelated to the thread that was doing the flush, it
> doesn't care if it gets rescheduled.

Yes.

> Do you agree that if the context was the same there is a bug?  Or did I
> miss something else?

Yes sure. We can't expect we can "flush" work_struct with flush_workqueue()
unless we know it doesn't re-schedule itself.

OTOH, it is not the bug to call flush_workqueue() even if that work was
queued by us, it should complete.

Oleg.

