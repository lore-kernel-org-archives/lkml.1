Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbXHFOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbXHFOnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763531AbXHFOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:43:15 -0400
Received: from mail.screens.ru ([213.234.233.54]:45325 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242AbXHFOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:43:14 -0400
Date: Mon, 6 Aug 2007 18:45:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Daniel Walker <dwalker@mvista.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to workqueue infrastructure
Message-ID: <20070806144536.GA232@tv-sign.ru>
References: <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru> <20070806114954.GC1903@elte.hu> <20070806131814.GC91@tv-sign.ru> <1186406963.7182.13.camel@twins> <1186407173.7182.16.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186407173.7182.16.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Peter Zijlstra wrote:
>
> On Mon, 2007-08-06 at 15:29 +0200, Peter Zijlstra wrote:
> > On Mon, 2007-08-06 at 17:18 +0400, Oleg Nesterov wrote:
> > 
> > > Yes, I still disagree with the whole idea because I hope we can make
> > > something more simpler to solve the problem, but I must admit I don't
> > > quite understand what the problem is.
> > > 
> > > So, please consider a noise from my side as my attempt to help. And
> > > in fact, I am very curious about -rt tree, just I never had a time
> > > to study it :)
> > 
> > 
> > Well, the thing is, suppose we have 2 drivers both using keventd say a
> > NIC and some USB thingy.
> > 
> > Now the NIC is deemed important hand gets irq thread prio 90, and the
> > USB could not be cared less about and gets 10 (note that on -rt irq
> > handlers are threaded and run SCHED_FIFO).
> > 
> > So now you can get priority inversion in keventd. Say the USB thingy
> > schedules a work item which will be executed. Then during the execution
> > of this work the NIC will also schedule a work item. Now the NIC (fifo
> > 90) will have to wait for the USB work (fifo 10) to complete.
> 
> /me hits himself.
> 
> of course today everything will run on whatever prio keventd ends up,
> regardless of the prio of the submitter.
> 
> still this does not change the fundamental issue of a high prio piece of
> work waiting on a lower prio task.
       ^^^^^^^
waiting. This is a "key" word, and this was my (perhaps wrong) point.

> > I suspect most of the barrier/flush semantics could be replaced with
> > completions from specific work items.

Hm. But this is exactly how it works?

Oleg.

