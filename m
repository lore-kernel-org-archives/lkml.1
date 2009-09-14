Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZINHXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZINHXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZINHXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:23:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZINHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:23:09 -0400
Message-ID: <4AADEF2F.5080504@cn.fujitsu.com>
Date: Mon, 14 Sep 2009 15:22:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com> <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:

>> CPU A call smp_call_function_many(wait=0) that want CPU B to call
>> a specific function, after smp_call_function_many() return, we let
>> CPU A offline immediately. Unfortunately, if CPU B receives this
>> IPI interrupt after CPU A down, it will crash like above description.
> 
> How can cpu B receive the IPI interrupt after cpu A is down?
> 
> As part of the cpu A going down, we first do the stop machine. i.e.,
> schedule the stop machine worker threads on each cpu. So, by the time
> all the worker threads on all the cpu's get scheduled and synchronized,
> ipi on B should get delivered.
> 

Actually, those two examples have the same reason, that is how long
the destination CPU will receive the IPI interruption?

If the stop machine threads can schedule in CPU B during the IPI
interruption delivering, It will occur those issue.

I understand what you say but let me confuse is how we ensure it? The IPI
interruption is delivered over the APIC bus, It need several CPU instruction
cycle I guess, I also have read the spec of Intel 64 and IA-32, but not find
the answer, could you point out for me?

Thanks,
Xiao
