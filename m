Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYCUHaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYCUHaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYCUH3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:29:53 -0400
Received: from mga05.intel.com ([192.55.52.89]:63658 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753755AbYCUH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:29:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,535,1199692800"; 
   d="scan'208";a="537515521"
Subject: Re: VolanoMark performance improvements (was: Re: volanoMark 12%
	regression with 2.6.25-rc6)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <1206083694.14496.114.camel@ymzhang>
References: <1205831650.3215.569.camel@ymzhang>
	 <20080318195807.GA26887@elte.hu> <1205892420.3215.594.camel@ymzhang>
	 <20080319021555.GA15825@elte.hu> <1205896722.3215.624.camel@ymzhang>
	 <20080319032854.GA20793@elte.hu> <1205901807.3215.659.camel@ymzhang>
	 <20080319134813.GA25197@elte.hu>  <1205976946.14496.9.camel@ymzhang>
	 <1206083694.14496.114.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Mar 2008 15:18:23 +0800
Message-Id: <1206083903.14496.117.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 15:14 +0800, Zhang, Yanmin wrote:
> On Thu, 2008-03-20 at 09:35 +0800, Zhang, Yanmin wrote:
> > On Wed, 2008-03-19 at 14:48 +0100, Ingo Molnar wrote:
> > > i just tried a handful of kernels with VolanoMark on an Intel quad-core 
> > > testbox,
> > How many physical processors does it have?
> > > these numbers are totally reproducible when running them over a long 
> > > time, i only included 6 runs for brevity. (A sidenote: the 
> > > /proc/sys/kernel/compat_sched_yield switch of 0 or 1 has no effect on 
> > > the .25-rc7 results, and it degraded the .24 results by about 35% so i 
> > > kept it off there.)
> I used java-openjdk to test it with 2.6.25-rc5 by switching compat_sched_yield
> to 0/1. The result difference is about 30%.
> 
> vmstat data when compat_sched_yield=0:
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 85  0      0 7584984  17128  79264    0    0     0     0    2 716494 37 60  3  0  0
> 94  0      0 7585168  17136  79256    0    0     0    64    7 723299 39 57  4  0  0
> 
> 
> vmstat data when compat_sched_yield=0:
Sorry. below data is when compat_sched_yield=1:

> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 369  0      0 7580656  14364  75852    0    0     0     0    4 1013260 42 57  1  0  0
> 335  0      0 7580836  14364  75852    0    0     0     0    1 971081 41 58  1  0  0
> 414  0      0 7580932  14372  75852    0    0     0    64    7 955333 40 58  1  0  0


