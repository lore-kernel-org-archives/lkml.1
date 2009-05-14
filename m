Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZENLWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZENLWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZENLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:22:34 -0400
Received: from www.tglx.de ([62.245.132.106]:36725 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbZENLWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:22:34 -0400
Message-Id: <20090514105915.973318588@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 14 May 2009 11:21:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/2] sched,
	timers: simplify calc_load and avoid cpu iteration loop
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich pointed out that calc_load iterates over all online
CPUs under xtime lock which can cause long latencies on large SMP
systems.

The following patch series removes the iteration loop and lets
scheduler_tick() on each CPU update the number of active tasks. The
calc_load() function just uses this variable and updates avenrun from
do_timer().

Dimitri, can you please test run this on one of your large machines ?

Thanks,

	tglx


