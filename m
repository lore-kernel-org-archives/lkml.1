Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZKFICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZKFICS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZKFICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:02:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:47777 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752037AbZKFICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:02:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19uRlBLEHVutvuPNHkeJXJAhkPvVE+X38BlowUlMQ
	EFPr69FaxCPtPA
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257493130.16282.109.camel@ymzhang>
References: <1257493130.16282.109.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 09:02:19 +0100
Message-Id: <1257494539.20688.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-11-06 at 15:38 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.31, specjbb2005 and aim7 have some regressions with
> 2.6.32-rc kernels on core2 machines.
> 
> 1) On 4*4 core tigerton: specjbb2005 has about 5% regression.
> 2) On 2*4 stoakley: aim7 has about 5% regression.
> 
> On Nehalem, specjbb2005 has about 2%~8%  improvement instead of regression.
> 
> aim7 has much dependency on schedule patameters, such like sched_latency_ns,
> sched_min_granularity_ns, and sched_wakeup_granularity_ns. 2.6.32-rc kernel
> decreases these parameter values. I restore them and retest aim7 on stoakley.
> aim7 regression becomes about 2% and specjbb2005 regression also becomes
> 2%. But on Nehalem, the improvement shrinks.

Yeah, the price of lower latency.  We may want to tweak big machine
setup a little.

Be advised that there's a locking problem which appears to be falsifying
benchmark results somewhat.  I've got a tentative fix, but I don't think
it's quite enough.  (I haven't looked yet at what protects cpus_allowed,
so aren't sure yet.)  Just wanted to let you know lest your testing time
investment may be producing somewhat skewed results, so you may want to
hold off a little bit.  (your testing time is much appreciated, don't
want to waste a single drop;)

	-Mike

