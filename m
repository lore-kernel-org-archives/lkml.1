Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYDHIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYDHIna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYDHInX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:43:23 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:59644 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYDHInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:43:22 -0400
Subject: Re: Regression in gdm-2.18 since 2.6.24
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, skumar@linux.vnet.ibm.com
In-Reply-To: <20080408085027.GB13042@linux.vnet.ibm.com>
References: <20080403191916.GA30864@deepthought>
	 <20080404143701.GA13042@linux.vnet.ibm.com>
	 <20080404153232.GC21753@deepthought>
	 <20080405144042.GB24075@linux.vnet.ibm.com>
	 <20080405210347.GA19097@deepthought> <20080406234833.GA12131@deepthought>
	 <20080408085027.GB13042@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 10:42:49 +0200
Message-Id: <1207644169.15579.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 14:20 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Apr 07, 2008 at 12:48:33AM +0100, Ken Moffat wrote:
> >  Well, I found your analysis convincing.  Unfortunately, my hardware
> > disagreed.  Testing -rc8 with CONFIG_GROUP_SCHED disabled (a test is
> > a mixture of 5 attempts to restart and 5 to shutdown):
> > 
> > 1. the base version success is 4/10
> > 
> > 2. increasing the granularity by a factor of 10 as you requested,
> > success is 8/10
> 
> This makes me think that we are just exposing a timing related problem
> in gdm here.
> 
> How abt a larger factor?
> 
> 	# echo 200000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> 
> Does that make it 10/10 ?!
> 
> Anyway, it would be interesting to analyze the failure scenario more
> (with help from gdm developers). Can you get some more debug data in this 
> regard?
> 
> Before you shutdown,
> 
> 	# strace -p <gdm-binary-pid1> 2>/tmp/gdmlog1 &
> 	# strace -p <gdm-binary-pid2> 2>/tmp/gdmlog2 &
> 
> Now shutdown and wait few minutes to confirm its not working. Send me
> the strace log files ..Hopefully this will give a hint on what they are
> deadlocked on (in the last log you sent, i can see both gdm-binaries in
> sleep state ..whether that was a momentary state or whether they are 
> actually deadlocked, will be confirmed by strace logs above).
> 
> >  If I was confused earlier, I guess I must be dazed and confused
> > now!
> 
> me too!
> 
> Ingo/Peter, Any other suggestions you have?

Sounds like a race condition to me; non of these changes affect
correctness in a strict manner of speaking.



