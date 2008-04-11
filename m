Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYDKRhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYDKRhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbYDKRhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:37:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbYDKRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:37:04 -0400
Subject: Re: CFS rq lock question
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Upton <upton.dan.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <ba7d8f720804111021v25cc4688mf6e36f571fd2b388@mail.gmail.com>
References: <ba7d8f720804111021v25cc4688mf6e36f571fd2b388@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 19:37:01 +0200
Message-Id: <1207935421.7524.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 13:21 -0400, Dan Upton wrote:
> I'm poking around with some scheduler stuff, and there's something I'm
> not clear on for the CFS runqueue locks.  The comments before
> __load_balance_iterator(...) in sched_fair.c suggests things can be
> dequeued even though the runqueue lock is held.  Can things also be
> added to the queue while the lock is held?  (Also, either way, what's
> the rationale that dequeueing is a safe procedure when somebody else
> holds a lock?)

/*
 * Load-balancing iterator. Note: while the runqueue stays locked
 * during the whole iteration, the current task might be
 * dequeued so the iterator has to be dequeue-safe. Here we
 * achieve that by always pre-iterating before returning
 * the current task:
 */

I don't think this comment is correct, but if it were, it would only
apply to rq->curr, not for any enqueue/dequeue.



