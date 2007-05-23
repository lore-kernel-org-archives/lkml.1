Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbXEWKdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbXEWKdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXEWKdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:33:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54113 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbXEWKdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:33:24 -0400
Date: Wed, 23 May 2007 12:33:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] lock contention tracking -v2
Message-ID: <20070523103311.GA13482@elte.hu>
References: <20070523072618.129001605@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523072618.129001605@chello.nl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Use the lockdep infrastructure to track lock contention and other lock 
> statistics.
> 
> It tracks lock contention events, and the first four unique call-sites 
> that encountered contention.
> 
> It also measures lock wait-time and hold-time in nanoseconds. The 
> minimum and maximum times are tracked, as well as a total (which 
> together with the number of event can give the avg).
> 
> All statistics are done per lock class, per write (exclusive state) 
> and per read (shared state).
> 
> The statistics are collected per-cpu, so that the collection overhead 
> is minimized via having no global cachemisses.
> 
> This new lock statistics feature is independent of the lock dependency 
> checking traditionally done by lockdep; it just shares the lock 
> tracking code. It is also possible to enable both and runtime disabled 
> either component - thereby avoiding the O(n^2) lock chain walks for 
> instance.

really nice changes! The wait-time and hold-time changes should make it 
as capable as lockmeter and more: lockmeter only measured spinlocks, 
while your approach covers all lock types (spinlocks, rwlocks and 
mutexes).

The performance enhancements in -v2 should make it much more scalable 
than your first version was. (in fact i think it should be completely 
scalable as the statistics counters are all per-cpu, so there should be 
no cacheline bouncing at all from this)

Also, you've detached it from CONFIG_PROVE_LOCKING so the 
lock-dependency overhead should be gone too.

Looks really good to me!

 Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
