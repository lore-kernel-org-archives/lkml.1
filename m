Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYHFHPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYHFHPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYHFHKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:10:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYHFHKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:10:17 -0400
Message-ID: <48994DDA.70205@cn.fujitsu.com>
Date: Wed, 06 Aug 2008 15:08:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for	callbacks-processing(v2)
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com> <20080801211053.GZ14851@linux.vnet.ibm.com> <489565BC.3000408@cn.fujitsu.com> <20080804225438.GA18866@linux.vnet.ibm.com>
In-Reply-To: <20080804225438.GA18866@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
[...]
> 
> Tell me more about percpu_ptr().

Sorry about this. percpu_ptr is used for dynamic allocation percpu pointer.

It seems that we cannot get a pointer from a static declare percpu data
which can be used as a dynamic allocation percpu data's pointer. 

> 
[...]
> 
> I have a somewhat different goal here.  I want to simplify the memory
> ordering design without giving up too much performance -- the current
> state in mainline is much too fragile, in my opinion, especially given
> that the grace-period code paths are not fastpaths.
> 
> Next step -- hierarchical grace-period detection to handle the 4096-CPU
> machines that I was being buttonholed about at OLS...
> 
> Would you be interested in applying your multi-tailed list change to
> preemptable RCU?
> 
It's not necessary. Actually I like one tail per list which is good for
readability. 

But in my patch, the most work is combining lists, not
moving a list to next list, so i use multi-tailed simplify this works
and others(etc: "if (rdp->nxtlist)" will be changed to be a more
complex and less readability statement if i use one-tail-per-list)

These not means multi-tailed is good thing.

