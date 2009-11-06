Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZKFIE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZKFIE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZKFIEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:04:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZKFIEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:04:25 -0500
Date: Fri, 6 Nov 2009 09:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
Message-ID: <20091106080418.GB28227@elte.hu>
References: <1257493130.16282.109.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257493130.16282.109.camel@ymzhang>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Comparing with 2.6.31, specjbb2005 and aim7 have some regressions with 
> 2.6.32-rc kernels on core2 machines.
> 
> 1) On 4*4 core tigerton: specjbb2005 has about 5% regression.
> 2) On 2*4 stoakley: aim7 has about 5% regression.
> 
> On Nehalem, specjbb2005 has about 2%~8% improvement instead of 
> regression.
> 
> aim7 has much dependency on schedule patameters, such like 
> sched_latency_ns, sched_min_granularity_ns, and 
> sched_wakeup_granularity_ns. 2.6.32-rc kernel decreases these 
> parameter values. I restore them and retest aim7 on stoakley. aim7 
> regression becomes about 2% and specjbb2005 regression also becomes 
> 2%. But on Nehalem, the improvement shrinks.

Which precise 2.6.32-rc commit have you tested?

Since v2.6.32-rc6 Linus's tree has this one too:

  f685cea: sched: Strengthen buddies and mitigate buddy induced latencies

Which should improve things a bit. For 2.6.33 we have queued up these 
two in -tip:

  a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()
  1b9508f: sched: Rate-limit newidle

If any of them fixes a performance regression we could still merge them 
into 2.6.32 as well.

	Ingo
