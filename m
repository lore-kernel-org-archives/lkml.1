Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYBRLCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYBRLCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbYBRLB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:01:58 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55448 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756667AbYBRLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:01:57 -0500
Date: Mon, 18 Feb 2008 16:31:22 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>, efault@gmx.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched-devel latencies
Message-ID: <20080218110121.GB18817@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080218104933.GA18817@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218104933.GA18817@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:19:33PM +0530, Dhaval Giani wrote:
> Hi Ingo,
> 
> I am running the sched-devel tree (at HEAD
> 44e770a8750abc7e876076cda718b413bad9e654) and it is not looking good.
> 
> I am running two "make -j"s for the kernel in two different cgroups and
> interactivity is going for a toss. I can see noticable lags in
> keypresses.
> 
> Will get down to debugging it further a bit later on.
> 

Some more numbers, with exact scenario

1. Mount the cgroup
2. Make 3 groups
3. Start kernbench in each group
4. Start chew.

This is the chew output from the root cgroup 

[root@llm11 dhaval]# ./chew2 
pid 29345 preempted 544115 us after 1560 us
pid 29345 preempted 588109 us after 3935 us
pid 29345 preempted 632122 us after 3941 us
pid 29345 preempted 794259 us after 3954 us
pid 29345 preempted 972163 us after 3963 us
pid 29345 preempted 1024219 us after 3942 us

>From within one of the groups
[root@llm11 dhaval]# ./chew2 
pid 27961 preempted 4028 us after 1708 us
pid 27961 preempted 28090 us after 5466 us
pid 27961 preempted 52021 us after 6505 us
pid 27961 preempted 56100 us after 7183 us
pid 27961 preempted 61850 us after 7505 us
pid 27961 preempted 131892 us after 59 us
pid 27961 preempted 332112 us after 7607 us

-- 
regards,
Dhaval
