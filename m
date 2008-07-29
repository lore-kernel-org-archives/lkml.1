Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYG2Uwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYG2Uwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbYG2UwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:52:15 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:64852 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbYG2UwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:52:13 -0400
Subject: Re: scheduling hrtimers while holding rq->lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Rosenthal <danielrosenthal@acm.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <4b6fba110807291223g16ca0bf1o54c270efac409d45@mail.gmail.com>
References: <4b6fba110807291223g16ca0bf1o54c270efac409d45@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 22:52:10 +0200
Message-Id: <1217364730.9348.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 15:23 -0400, Daniel Rosenthal wrote:
> What's the best way for scheduling code to start an hrtimer while
> holding the rq->lock?  I am trying to implement SCHED_SPORADIC
> (sporadic server) in the realtime scheduling class (rt_sched_class),
> and it needs to schedule aperiodic, asynchronous replenishment
> operations which are independent of timeslice expiration.  This is to
> implement the functionality that when a SCHED_SPORADIC task blocks or
> uses up its timeslice, one of these asynchronous events is scheduled
> to happen at some time offset in the future that doesn't necessarily
> correspond to any timeslice expiration.
> 
> Is there some way to schedule this event without duplicating the code
> that the generic scheduler currently uses for its hrtick_timer?  As
> in, is there a way to do this without adding a thread flag similar in
> function to TIF_HRTICK_RESCHED and calling an rt_sched_class function
> from do_notify_resume if the flag is set?
> 
> The code snippet below is what I am trying to do.
> 
> Please CC me explicitly in any replies.

Look at .27-rc1 ;-)

