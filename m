Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXKBQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXKBQ2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXKBQ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:28:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60121 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXKBQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:28:30 -0400
Message-ID: <472B501E.9000307@linux.vnet.ibm.com>
Date: Fri, 02 Nov 2007 21:58:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: delayacct regression in 2.6.24 git
References: <472B2908.7020507@linux.vnet.ibm.com> <20071102152529.GB20134@elte.hu>
In-Reply-To: <20071102152529.GB20134@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Hi, Ingo,
>>
>> I missed commit 75d4ef16a6aa84f708188bada182315f80aab6fa
>> "sched: fix delay accounting performance regression"
>>
>> Without these changes, I find that delay accounting does
>> not work as expected, I see zeros in the field for virtual,delay
>> and count(s).
>>
>> CPU             count     real total  virtual total    delay total
>>                     0      535861848              0              0
>>
>>
>> This breaks existing delay accounting behaviour.
>>
>> Am I missing something?
> 
> delay accounting was causing context-switch slowdown because it called 
> sched_clock() explicitly - but indeed my fix to that is wrong ...
> 
> how about reverting the change but also using rq->clock instead of 
> sched_clock()?

Hmm... I think that might work, I find that schedule() calls
__update_rq_clock() which in turn calls sched_clock(), so it
might be a worthwhile optimization.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
