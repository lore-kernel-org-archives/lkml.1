Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbZCZUqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbZCZUqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZCZUq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:46:28 -0400
Received: from hq2.tensilica.com ([65.205.227.30]:44133 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754190AbZCZUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:46:27 -0400
Message-ID: <49CBE945.3060304@tensilica.com>
Date: Thu, 26 Mar 2009 13:44:53 -0700
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Johannes Weiner <jw@emlix.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH} - There appears  to be a minor race condition in	sched.c
References: <49CAFA83.1000005@tensilica.com> <20090326075101.GE24227@balbir.in.ibm.com>
In-Reply-To: <20090326075101.GE24227@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Piet Delaney <piet.delaney@tensilica.com> [2009-03-25 20:46:11]:
> 
>> Ingo, Peter:
>>
>> There appears to be a minor race condition in sched.c where
>> you can get a division by zero. I suspect that it only shows
>> up when the kernel is compiled without optimization and the code
>> loads rq->nr_running from memory twice.
>>
>> It's part of our SMP stabilization changes that I just posted to:
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/piet/xtensa-2.6.27-smp.git
>>
>> I mentioned it to Johannes the other day and he suggested passing it on to you ASAP.
>>
> 
> The latest version uses ACCESS_ONCE to get rq->nr_running and then
> uses that value. I am not sure what version you are talking about, if
> it is older, you should consider backporting from the current version.

Hi Balbir:

It appears that Steven Rostedt changed cpu_ave_load_per_task() to use a local
variable nr_running, just as I suggested, apparently back in 2.6.28-rc5
last Nov; well after the 2.6.27 that I mentioned above.

A few days later Ingo added the ACCESS_ONCE() after Linus pointed out
that nothing prevented the compiler from reloading rg->rn_running.
Linus was right, adding the volatile is necessary to prevent gcc
from doing forward substitution.

I'll check Linus's current repo next time before suggesting bug fixes.

-piet
