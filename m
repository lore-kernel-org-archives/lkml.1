Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYDHIki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYDHIki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYDHIk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:40:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57247 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYDHIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:40:28 -0400
Date: Tue, 8 Apr 2008 14:20:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, skumar@linux.vnet.ibm.com
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080408085027.GB13042@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080403191916.GA30864@deepthought> <20080404143701.GA13042@linux.vnet.ibm.com> <20080404153232.GC21753@deepthought> <20080405144042.GB24075@linux.vnet.ibm.com> <20080405210347.GA19097@deepthought> <20080406234833.GA12131@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080406234833.GA12131@deepthought>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 12:48:33AM +0100, Ken Moffat wrote:
>  Well, I found your analysis convincing.  Unfortunately, my hardware
> disagreed.  Testing -rc8 with CONFIG_GROUP_SCHED disabled (a test is
> a mixture of 5 attempts to restart and 5 to shutdown):
> 
> 1. the base version success is 4/10
> 
> 2. increasing the granularity by a factor of 10 as you requested,
> success is 8/10

This makes me think that we are just exposing a timing related problem
in gdm here.

How abt a larger factor?

	# echo 200000000 > /proc/sys/kernel/sched_wakeup_granularity_ns

Does that make it 10/10 ?!

Anyway, it would be interesting to analyze the failure scenario more
(with help from gdm developers). Can you get some more debug data in this 
regard?

Before you shutdown,

	# strace -p <gdm-binary-pid1> 2>/tmp/gdmlog1 &
	# strace -p <gdm-binary-pid2> 2>/tmp/gdmlog2 &

Now shutdown and wait few minutes to confirm its not working. Send me
the strace log files ..Hopefully this will give a hint on what they are
deadlocked on (in the last log you sent, i can see both gdm-binaries in
sleep state ..whether that was a momentary state or whether they are 
actually deadlocked, will be confirmed by strace logs above).

>  If I was confused earlier, I guess I must be dazed and confused
> now!

me too!

Ingo/Peter, Any other suggestions you have?


-- 
Regards,
vatsa
