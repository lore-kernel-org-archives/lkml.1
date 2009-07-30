Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbZG3IMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbZG3IMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZG3IMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:12:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZG3IMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:12:12 -0400
Message-ID: <4A7155C7.90400@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 16:11:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       jens.axboe@oracle.com, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 -mm] generic-ipi: fix the race between generic_smp_call_function_*()
 and hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com>	 <4A6FFFE9.5070204@cn.fujitsu.com> <4A7000FF.6040402@cn.fujitsu.com>	 <20090729163120.2e27be41.akpm@linux-foundation.org> <1248936657.6987.3095.camel@twins>
In-Reply-To: <1248936657.6987.3095.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:

> It introduces this run_callbacks thing to two functions, but nothing
> actually uses that... makes me suspicious there's something missing.
> 

Hi Peter,

Thanks for your point out.
I'm sorry for making a mistake when I make this patch, I'll send the new
patch soon

Hi Andrew,

I can't apply "kernel/smp.c: relocate some code" because this patch are
base on my other patch: "generic-ipi: make struct call_function_data lockless",
which can be found at:
	http://lkml.org/lkml/2009/7/24/63

I'll rewrite your patch base on it

Thanks,
Xiao

> 
>> case CPU_DEAD_FROZEN:
>> +               local_irq_save(flags);
>> +               __generic_smp_call_function_interrupt(cpu, 0);
>> +               __generic_smp_call_function_single_interrupt(cpu, 0);
>> +               local_irq_restore(flags);
> 
> Doing the callbacks from a different cpu than they were queued on seems
> like a fine way to mess things up.
> 
> 
