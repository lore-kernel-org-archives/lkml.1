Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZKIGTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZKIGTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 01:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZKIGTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 01:19:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:20400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZKIGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 01:19:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,706,1249282800"; 
   d="scan'208";a="465541727"
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20091106080418.GB28227@elte.hu>
References: <1257493130.16282.109.camel@ymzhang>
	 <20091106080418.GB28227@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2009 14:19:57 +0800
Message-Id: <1257747597.16282.120.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 09:04 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.31, specjbb2005 and aim7 have some regressions with 
> > 2.6.32-rc kernels on core2 machines.
> > 
> > 1) On 4*4 core tigerton: specjbb2005 has about 5% regression.
> > 2) On 2*4 stoakley: aim7 has about 5% regression.
> > 
> > On Nehalem, specjbb2005 has about 2%~8% improvement instead of 
> > regression.
> > 
> > aim7 has much dependency on schedule patameters, such like 
> > sched_latency_ns, sched_min_granularity_ns, and 
> > sched_wakeup_granularity_ns. 2.6.32-rc kernel decreases these 
> > parameter values. I restore them and retest aim7 on stoakley. aim7 
> > regression becomes about 2% and specjbb2005 regression also becomes 
> > 2%. But on Nehalem, the improvement shrinks.
> 
> Which precise 2.6.32-rc commit have you tested?
> 
> Since v2.6.32-rc6 Linus's tree has this one too:
> 
>   f685cea: sched: Strengthen buddies and mitigate buddy induced latencies
> 
> Which should improve things a bit. For 2.6.33 we have queued up these 
> two in -tip:
> 
>   a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()
>   1b9508f: sched: Rate-limit newidle
> 
> If any of them fixes a performance regression we could still merge them 
> into 2.6.32 as well.
﻿1b9508f definitely fixes netperf UDP loopback regression.

Yanmin


