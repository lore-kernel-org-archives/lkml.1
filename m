Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbXHFOwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbXHFOwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbXHFOw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:52:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41476 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbXHFOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:52:28 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Daniel Walker <dwalker@mvista.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806144536.GA232@tv-sign.ru>
References: <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru> <20070806114954.GC1903@elte.hu>
	 <20070806131814.GC91@tv-sign.ru> <1186406963.7182.13.camel@twins>
	 <1186407173.7182.16.camel@twins>  <20070806144536.GA232@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 16:52:01 +0200
Message-Id: <1186411921.7182.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 18:45 +0400, Oleg Nesterov wrote:
> On 08/06, Peter Zijlstra wrote:

> > still this does not change the fundamental issue of a high prio piece of
> > work waiting on a lower prio task.
>        ^^^^^^^
> waiting. This is a "key" word, and this was my (perhaps wrong) point.

Yeah, its having a higher prio item processed at a lower prio that is
the problem. It might be delayed by less important issues.

But I'm feeling a question wanting to jump out of your statement, I just
fail to find it.

> > > I suspect most of the barrier/flush semantics could be replaced with
> > > completions from specific work items.
> 
> Hm. But this is exactly how it works?

Ah, I fail to be clear :-/

Yes, barriers work by enqueueing work and waiting for that one work item
to fall out, thereby knowing that all previous work has been completed.

My point was that most flushes are there to wait for a previously
enqueued work item, and might as well wait for that one.

Let me try to illustrate: a regular pattern is, we enqueue work A and
then flush the whole queue to ensure A is processed. So instead of
enqueueing A, then B in the barrier code, and wait for B to pop out, we
might as well wait for A to begin with.



