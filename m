Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXJ3Ihw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXJ3Ihw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXJ3Ihn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:37:43 -0400
Received: from mga05.intel.com ([192.55.52.89]:42855 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751992AbXJ3Ihm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:37:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,346,1188802800"; 
   d="scan'208";a="363253644"
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20071030072658.GB20372@elte.hu>
References: <1193391787.3019.174.camel@ymzhang>
	 <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang>
	 <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>
	 <20071030072658.GB20372@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Oct 2007 16:36:30 +0800
Message-Id: <1193733390.3019.210.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 08:26 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > sub-bisecting captured patch 
> > 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings) 
> > caused 20% regression of aim7.
> > 
> > The last 10% should be also related to sched parameters, such like 
> > sysctl_sched_min_granularity.
> 
> ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you 
> please try to figure out what the best value for 
> /proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and 
> /proc/sys/kernel_sched_min_granularity is?
> 
> there's a tuning constraint for kernel_sched_nr_latency: 
> 
> - kernel_sched_nr_latency should always be set to 
>   kernel_sched_latency/kernel_sched_min_granularity. (it's not a free 
>   tunable)
> 
> i suspect a good approach would be to double the value of 
> kernel_sched_latency and kernel_sched_nr_latency in each tuning 
> iteration, while keeping kernel_sched_min_granularity unchanged. That 
> will excercise the tuning values of the 2.6.23 kernel as well.
I followed your idea to test 2.6.24-rc1. The improvement is slow.
When sched_nr_latency=2560 and sched_latency_ns=640000000, the performance
is still about 15% less than 2.6.23.

-yanmin
