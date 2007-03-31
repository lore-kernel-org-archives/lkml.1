Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXCaKLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXCaKLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXCaKLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:11:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbXCaKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:11:48 -0400
Date: Sat, 31 Mar 2007 12:11:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] sched: improve fairness, v3
Message-ID: <20070331101143.GA14533@elte.hu>
References: <1175322706.6030.20.camel@Homer.simpson.net> <20070331092857.12651.qmail@web26704.mail.ukl.yahoo.com> <20070331094323.GA5550@elte.hu> <20070331094848.GA7829@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331094848.GA7829@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > also, could you possibly try these workloads you described with 
> > Mike's latest patch too? Thanks,
> 
> i.e. the one below.

plus the small patch below too.

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3491,7 +3491,7 @@ static inline int expired_starving(struc
 		return 1;
 	if (!STARVATION_LIMIT)
 		return 0;
-	if (jiffies - rq->switch_timestamp > STARVATION_LIMIT * rq->nr_running)
+	if (jiffies - rq->switch_timestamp > STARVATION_LIMIT)
 		return 1;
 	return 0;
 }
