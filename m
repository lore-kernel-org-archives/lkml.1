Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXDQGrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXDQGrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXDQGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:47:11 -0400
Received: from omta03ps.mx.bigpond.com ([144.140.82.155]:64863 "EHLO
	omta03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXDQGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:47:11 -0400
Message-ID: <46246D61.8010300@bigpond.net.au>
Date: Tue, 17 Apr 2007 16:46:57 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu>
In-Reply-To: <20070416220715.GA4071@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 06:47:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> this is the second release of the CFS (Completely Fair Scheduler) 
> patchset, against v2.6.21-rc7:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
> 
> i'd like to thank everyone for the tremendous amount of feedback and 
> testing the v1 patch got - i could hardly keep up with just reading the 
> mails! Some of the stuff people addressed i couldnt implement yet, i 
> mostly concentrated on bugs, regressions and debuggability.

Have you considered using rq->raw_weighted_load instead of 
rq->nr_running in calculating fair_clock?  This would take the nice 
value (or RT priority) of the other tasks into account when determining 
what's fair.

Peter
PS You'd have to change the migration thread's load_weight from 0 to 1 
in order to prevent divide by zero without having to explicitly check 
for it every time.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
