Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYFJQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYFJQ6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYFJQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:58:10 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39499 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbYFJQ6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:58:09 -0400
Date: Tue, 10 Jun 2008 21:00:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing	cpus_allowed
Message-ID: <20080610170005.GA6038@tv-sign.ru>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins> <484E9FE8.9040504@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E9FE8.9040504@qualcomm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Max Krasnyansky wrote:
> 
> Peter Zijlstra wrote:
> >
> > Per cpu workqueues should stay on their cpu.
> >
> > What you're really looking for is a more fine grained alternative to
> > flush_workqueue().
> Actually I had a discussion on that with Oleg Nesterov. If you remember my
> original solution (ie centralized cpu_isolate_map) was to completely redirect
> work onto other cpus. Then you pointed out that it's the flush_() that really
> makes the box stuck. So I started thinking about redoing the flush. While
> looking at the code I realized that if I only change the flush_() then queued
> work can get stale so to speak. ie Machine does not get stuck but some work
> submitted on the isolated cpus will sit there for a long time. Oleg pointed
> out exact same thing. So the simplest solution that does not require any
> surgery to the workqueue is to just move the threads to other cpus.

Cough... I'd like to mention that I _personally agree with Peter, cwq->thread's
should stay on their cpu.

I just meant that from the workqueue.c pov it is (afaics) OK to move cwq->thread
to other CPUs, in a sense that this shouldn't add races or hotplug problems, etc.
But still this doesn't look right to me.

Oleg.

