Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXHFPwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXHFPwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933048AbXHFPv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:51:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34587 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbXHFPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:51:57 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806153655.GA245@tv-sign.ru>
References: <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru>
	 <1186400154.21381.40.camel@ghaskins-t60p.haskins.net>
	 <20070806142616.GA210@tv-sign.ru>
	 <1186412235.21381.82.camel@ghaskins-t60p.haskins.net>
	 <20070806153655.GA245@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 11:50:03 -0400
Message-Id: <1186415403.21381.100.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 19:36 +0400, Oleg Nesterov wrote:

> > Well, the "trylock+requeue" avoids the obvious recursive deadlock, but
> > it introduces a more subtle error: the reschedule effectively bypasses
> > the flush.
> 
> this is OK, flush_workqueue() should only care about work_struct's that are
> already queued.

Agreed.

> 
> > E.g. whatever work was being flushed was allowed to escape
> > out from behind the barrier.  If you don't care about the flush working,
> > why do it at all?
> 
> The caller of flush_workueue() doesn't necessary know we have such a work
> on list. It just wants to flush its own works.

I was assuming that the work being flushed was submitted by the same
context, but I think I see what you are saying now.  Essentially if that
queued work was unrelated to the thread that was doing the flush, it
doesn't care if it gets rescheduled.

Do you agree that if the context was the same there is a bug?  Or did I
miss something else?

-Greg



