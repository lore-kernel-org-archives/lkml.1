Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZJ1J2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZJ1J2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZJ1J2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:28:09 -0400
Received: from mga10.intel.com ([192.55.52.92]:63486 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830AbZJ1J2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:28:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,638,1249282800"; 
   d="scan'208";a="508365261"
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256654547.17752.13.camel@marge.simson.net>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2009 17:29:01 +0800
Message-Id: <1256722141.16282.20.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:42 +0100, Mike Galbraith wrote:
> On Tue, 2009-10-27 at 16:03 +0800, Zhang, Yanmin wrote:
> > On Fri, 2009-10-16 at 13:06 +0200, Mike Galbraith wrote:
> > > On Tue, 2009-10-13 at 11:12 +0800, Zhang, Yanmin wrote:
> > > 
> > > > NEXT_BUDDY has no help on volanoMark and tbench.
> > > 
> > > Can you try the patch below please?  It does tries to preserve buddy
> > > affinity where possible, and mitigates over-preemption by strengthening
> > > buddies a bit.  It improves vmark here by ~7%.
> > I ran some benchmarks against 2.6.32-rc1+Peter_2_patches+below_patch.
> > Below result is against 2.6.32-rc1.
> > hackbench result has about 10% improvement on stoakley (2*4 cores) and
> > tigerton (4*4 cores).
> > tbench still has about 5% regression on ﻿stoakley and tigerton.
> > VolanoMark has 33% regression on tigerton, but has 2% improvement on stoakley.
> > 
> > I also ran the benchmarks against the latest tips/master and got the similiar
> > results like above testing.
> > ﻿
> > The testing against tips on Nehalem machine didn't show much improvement/regression.
> 
> Thanks for the testing.  Your results suggest that I should revive the
> mark buddies whether you use them or not idea.
> 
> 	-Mike
I'm investigating 5% tbench regression on Nehalem machine. perf_counter shows
select_task_rq_fair consumes about 5% cpu time with 2.6.32-rc1 while it consumes
less than 0.5% with 2.6.31.

Patch c88d5910890 has comments to explain it, but I still can't understand why
to add complicated balance logic when selecting task rq.

I will check which section in function ﻿select_task_rq_fair consumes so much time.

Yanmin


