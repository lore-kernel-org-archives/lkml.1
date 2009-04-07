Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZDGGm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZDGGm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbZDGGmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:42:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56845 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZDGGmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:42:16 -0400
Message-ID: <49DAF54A.10909@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 14:40:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49D45DAC.2060508@cn.fujitsu.com> <20090402140037.GC12851@redhat.com> <49DAAF25.8010702@cn.fujitsu.com>
In-Reply-To: <49DAAF25.8010702@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng wrote:
> Vivek Goyal wrote:
>> On Thu, Apr 02, 2009 at 02:39:40PM +0800, Gui Jianfeng wrote:
>>> Vivek Goyal wrote:
>>>> Hi All,
>>>>
>>>> Here is another posting for IO controller patches. Last time I had posted
>>>> RFC patches for an IO controller which did bio control per cgroup.
>>>>
>>>> http://lkml.org/lkml/2008/11/6/227
>>>>
>>>> One of the takeaway from the discussion in this thread was that let us
>>>> implement a common layer which contains the proportional weight scheduling
>>>> code which can be shared by all the IO schedulers.
>>>>
>>>   
>>>   Hi Vivek,
>>>
>>>   I did some tests on my *old* i386 box(with two concurrent dd running), and notice 
>>>   that IO Controller doesn't work fine in such situation. But it can work perfectly 
>>>   in my *new* x86 box. I dig into this problem, and i guess the major reason is that
>>>   my *old* i386 box is too slow, it can't ensure two running ioqs are always backlogged.
>> Hi Gui,
>>
>> Have you run top to see what's the percentage cpu usage. I suspect that
>> cpu is not keeping up pace disk to enqueue enough requests. I think
>> process might be blocked somewhere else so that it could not issue
>> requests. 
>>
>>>   If that is the case, I happens to have a thought. when an ioq uses up it time slice, 
>>>   we don't expire it immediately. May be we can give a piece of bonus time for idling 
>>>   to wait new requests if this ioq's finish time and its ancestor's finish time are all 
>>>   much smaller than other entities in each corresponding service tree.
>> Have you tried it with "fairness" enabled? With "fairness" enabled, for
>> sync queues I am waiting for one extra idle time slice "8ms" for queue
>> to get backlogged again before I move to the next queue?
>>
>> Otherwise try to increase the idle time length to higher value say "12ms"
>> just to see if that has any impact.
>>
>> Can you please also send me output of blkparse. It might give some idea
>> how IO schedulers see IO pattern.
> 
>   Hi Vivek,
> 
>   Sorry for the late reply, I tried the "fairness" patch, it seems not working.
>   I'v also tried to extend the idle value, not working either.
>   The blktrace output is attached. It seems that the high priority ioq is deleting
>   from busy tree too often due to lacking of requests. My box is single CPU and CPU
>   speed is a little slow. May be two concurrent dd is contending CPU to submit
>   requests, that's the reason for not always backlogged for ioqs.

  Hi Vivek,

  Sorry for bothering, there were some configure errors when i tested, and got the improper
  result.
  The "fairness" patch seems to work fine now! It makes the high priority ioq *always* backlogged :)

> 
>> Thanks
>> Vivek
>>
>>
>>
> 

-- 
Regards
Gui Jianfeng

