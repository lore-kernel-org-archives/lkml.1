Return-Path: <linux-kernel-owner+w=401wt.eu-S2992768AbXDRV0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992768AbXDRV0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXDRV0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:26:36 -0400
Received: from holomorphy.com ([66.93.40.71]:54706 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992768AbXDRV0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:26:35 -0400
Date: Wed, 18 Apr 2007 14:26:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070418212645.GU2986@holomorphy.com>
References: <20070418175017.GA5250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418175017.GA5250@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:50:17PM +0200, Ingo Molnar wrote:
> this is the third release of the CFS patchset (against v2.6.21-rc7), and 
> can be downloaded from:
>    http://redhat.com/~mingo/cfs-scheduler/
> this is a pure "fix reported regressions" release so there's much less 
> churn:
>    5 files changed, 71 insertions(+), 29 deletions(-)
> (the added lines are mostly debug related, not genuine increase in the 
> scheduler's size)

It appears to me that the following can be taken in for mainline
(or rejected for mainline) independently of the rest of the cfs patch.


-- wli

Mark the runqueues ____cacheline_aligned_in_smp to avoid false sharing.

Index: sched/kernel/sched.c
===================================================================
--- sched.orig/kernel/sched.c	2007-04-18 14:10:03.593207728 -0700
+++ sched/kernel/sched.c	2007-04-18 14:11:39.270660075 -0700
@@ -278,7 +278,7 @@
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues);
+static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
 
 static inline int cpu_of(struct rq *rq)
 {
