Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXDMX06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXDMX06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161020AbXDMX06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:26:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26459 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029AbXDMX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:26:57 -0400
Date: Fri, 13 Apr 2007 17:26:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
In-reply-to: <fa.Aj3PE3FoH/kmJ6APQFg2oZN1OFc@ifi.uio.no>
To: Zhao Forrest <forrest.zhao@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-id: <462011B3.5030800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.jxja7Ze2HZEPZZ5vd0w5eLsKf88@ifi.uio.no>
 <fa.RbU8KKG9LmOiypCl0DuBe43HL5c@ifi.uio.no>
 <fa.7mgz+w23+bQoEmP17EX7CoXvAKk@ifi.uio.no>
 <fa.Iwu0x59X2e1XgdDQWyXObWrcbFY@ifi.uio.no>
 <fa.Aj3PE3FoH/kmJ6APQFg2oZN1OFc@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao Forrest wrote:
> These 2 kernel options are turned on by default in my kernel. Here's
> snip from .config
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_BKL=y
> CONFIG_NUMA=y
> CONFIG_K8_NUMA=y
> 
>>
>> Does this fix it?
>>
>> --- fs/buffer.c~        2007-02-01 12:00:34.000000000 +0100
>> +++ fs/buffer.c 2007-04-11 12:35:48.000000000 +0200
>> @@ -3029,6 +3029,8 @@ out:
>>                         struct buffer_head *next = bh->b_this_page;
>>                         free_buffer_head(bh);
>>                         bh = next;
>> +
>> +                       cond_resched();
>>                 } while (bh != buffers_to_free);
>>         }
>>         return ret;
>>
> So far I have run the test with patched kernel for 6 rounds, and
> didn't see the soft lockup. I think this patch should fix the problem.
> But what still confused me is that why do we need to invoke
> cond_resched() voluntarily since CONFIG_PREEMPT_VOLUNTARY and
> CONFIG_PREEMPT_BKL are both turned on? From my understanding these 2
> options should make schedule happen even if CPU is under heavy
> load......

No, only CONFIG_PREEMPT will do that.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

